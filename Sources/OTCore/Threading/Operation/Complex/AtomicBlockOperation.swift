//
//  AtomicBlockOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// A synchronous `Operation` subclass that is similar to `BlockOperation` but whose internal queue can be serial or concurrent and where sub-operations can reduce upon a shared thread-safe variable passed into the operation closures.
///
/// **Setup**
///
/// Instantiate `AtomicBlockOperation` with queue type and initial mutable value. This value can be of any concrete type. If a shared mutable value is not required, an arbitrary value can be passed as the initial value such as 0.
///
/// Any initial setup necessary can be done using `setSetupBlock{}`. Do not override `main()` or `start()`.
///
/// For completion, use `.setCompletionBlock{}`. Do not modify the underlying `.completionBlock` directly.
///
///     let op = AtomicBlockOperation(.serialFIFO,
///                                   initialMutableValue: 2)
///     op.setSetupBlock { operation, atomicValue in
///         // do some setup
///     }
///     op.addOperation { atomicValue in
///         atomicValue.mutate { $0 += 1 }
///     }
///     op.addOperation { atomicValue in
///         atomicValue.mutate { $0 += 1 }
///     }
///     op.addInteractiveOperation { operation, atomicValue in
///         atomicValue.mutate { $0 += 1 }
///         if operation.mainShouldAbort() { return }
///         atomicValue.mutate { $0 += 1 }
///     }
///     op.setCompletionBlock { atomicValue in
///         print(atomicValue) // "6"
///     }
///
/// Add the operation to an `OperationQueue` or start it manually if not being inserted into an OperationQueue.
///
///     // if inserting into an OperationQueue:
///     let opQueue = OperationQueue()
///     opQueue.addOperation(op)
///
///     // if not inserting into an OperationQueue:
///     op.start()
///
/// - important: In most use cases, this object does not need to be subclassed.
///
/// - note: Inherits from both `BasicAsyncOperation` and `BasicOperation`.
open class AtomicBlockOperation<T>: BasicOperation {
    
    private var operationQueueType: OperationQueueType {
        operationQueue.operationQueueType
    }
    
    private let operationQueue: AtomicOperationQueue<T>!
    
    /// **OTCore:**
    /// Stores a weak reference to the last `Operation` added to the internal operation queue. If the operation is complete and the queue is empty, this may return `nil`.
    public weak var lastAddedOperation: Operation? {
        operationQueue.lastAddedOperation
    }
    
    /// **OTCore:**
    /// The thread-safe shared mutable value that all operation blocks operate upon.
    public final var value: T {
        operationQueue.sharedMutableValue
    }
    
    /// **OTCore:**
    /// Mutate the shared atomic variable in a closure.
    public func mutateValue(_ block: (inout T) -> Void) {
        
        block(&operationQueue.sharedMutableValue)
        
    }
    
    /// **OTCore:**
    /// Handler called any time the `status` property changes.
    public final var statusHandler: BasicOperationQueue.StatusHandler? {
        get {
            operationQueue.statusHandler
        }
        set {
            operationQueue.statusHandler = newValue
        }
    }
    
    private var setupBlock: ((_ operation: AtomicBlockOperation,
                              _ atomicValue: AtomicVariableAccess<T>) -> Void)?
    
    // MARK: - Init
    
    public init(type operationQueueType: OperationQueueType,
                initialMutableValue: T,
                qualityOfService: QualityOfService? = nil,
                resetProgressWhenFinished: Bool = false,
                statusHandler: BasicOperationQueue.StatusHandler? = nil) {
        
        // assign properties
        operationQueue = AtomicOperationQueue(
            type: operationQueueType,
            qualityOfService: qualityOfService,
            initiallySuspended: true,
            resetProgressWhenFinished: resetProgressWhenFinished,
            initialMutableValue: initialMutableValue,
            statusHandler: statusHandler
        )
        
        // super
        super.init()
        
        if let qualityOfService = qualityOfService {
            self.qualityOfService = qualityOfService
            self.operationQueue.qualityOfService = qualityOfService
        }
        
        // set up observers
        addObservers()
        
    }
    
    // MARK: - Overrides
    
    public final override func main() {
        
        guard mainShouldStart() else { return }
        let varAccess = AtomicVariableAccess(operationQueue: self.operationQueue)
        setupBlock?(self, varAccess)
        
        guard operationQueue.operationCount > 0 else {
            completeOperation()
            return
        }
        
        operationQueue.isSuspended = false
        
        // this ensures that the operation runs synchronously
        // which mirrors the behavior of BlockOperation
        while !isFinished {
            sleep(0.010) // 10ms
            
            //Thread.sleep(forTimeInterval: 0.010)
            
            //RunLoop.current.run(until: Date().addingTimeInterval(0.010))
        }
        
    }
    
    // MARK: - KVO Observers
    
    /// **OTCore:**
    /// Retain property observers. For safety, this array must be emptied on class deinit.
    private var observers: [NSKeyValueObservation] = []
    private func addObservers() {
        
        // self.isCancelled
        
        observers.append(
            observe(\.isCancelled, options: [.new])
            { [self, operationQueue] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                if isCancelled {
                    operationQueue?.cancelAllOperations()
                    completeOperation(dueToCancellation: true)
                }
            }
        )
        
        // self.qualityOfService
        
        observers.append(
            observe(\.qualityOfService, options: [.new])
            { [self, operationQueue] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                // for some reason, change.newValue is nil here. so just read from the property directly.
                // guard let newValue = change.newValue else { return }
                
                // propagate to operation queue
                operationQueue?.qualityOfService = qualityOfService
            }
        )
        
        // self.operationQueue.operationCount
        
        observers.append(
            operationQueue.observe(\.operationCount, options: [.new])
            { [self, operationQueue] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                if operationQueue?.operationCount == 0 {
                    completeOperation()
                }
            }
        )
        
        // self.operationQueue.progress.isFinished
        // (NSProgress docs state that isFinished is KVO-observable)
        
        observers.append(
            operationQueue.progress.observe(\.isFinished, options: [.new])
            { [self, operationQueue] _, _ in
                // !!! DO NOT USE [weak self] HERE. MUST BE STRONG SELF !!!
                
                if operationQueue?.progress.isFinished == true {
                    completeOperation()
                }
            }
        )
        
    }
    
    private func removeObservers() {
        
        observers.forEach { $0.invalidate() } // for extra safety, invalidate them first
        observers.removeAll()
    }
    
    deinit {
        
        setupBlock = nil
        
        // this is very important or it may result in random crashes if the KVO observers aren't nuked at the appropriate time
        removeObservers()
        
    }
    
}

// MARK: - Proxy methods

extension AtomicBlockOperation {
    
    /// **OTCore:**
    /// Add an operation block operating on the shared mutable value.
    ///
    /// - returns: The new operation.
    @discardableResult
    public final func addOperation(
        dependencies: [Operation] = [],
        _ block: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> ClosureOperation {
        
        operationQueue.addOperation(dependencies: dependencies, block)
        
    }
    
    /// **OTCore:**
    /// Add an operation block operating on the shared mutable value.
    /// `operation.mainShouldAbort()` can be periodically called and then early return if the operation may take more than a few seconds.
    ///
    /// - returns: The new operation.
    @discardableResult
    public final func addInteractiveOperation(
        dependencies: [Operation] = [],
        _ block: @escaping (_ operation: InteractiveClosureOperation,
                            _ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> InteractiveClosureOperation {
        
        operationQueue.addInteractiveOperation(dependencies: dependencies, block)
        
    }
    
    /// **OTCore:**
    /// Add an operation to the operation queue.
    public final func addOperation(_ op: Operation){
        
        operationQueue.addOperation(op)
        
    }
    
    /// **OTCore:**
    /// Add operations to the operation queue.
    public final func addOperations(_ ops: [Operation],
                                    waitUntilFinished: Bool) {
        
        operationQueue.addOperations(ops,
                                     waitUntilFinished: waitUntilFinished)
        
    }
    
    /// **OTCore:**
    /// Add a barrier block operation to the operation queue.
    ///
    /// Invoked after all currently enqueued operations have finished. Operations you add after the barrier block don’t start until the block has completed.
    @available(macOS 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
    public final func addBarrierBlock(
        _ barrier: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) {
        
        operationQueue.addBarrierBlock(barrier)
        
    }
    
    /// **OTCore:**
    /// Blocks the current thread until all the receiver’s queued and executing operations finish executing.
    public func waitUntilAllOperationsAreFinished(timeout: DispatchTimeInterval? = nil) {
        
        if let timeout = timeout {
            operationQueue.waitUntilAllOperationsAreFinished(timeout: timeout)
        } else {
            operationQueue.waitUntilAllOperationsAreFinished()
        }
        
    }
    
}

// MARK: - Blocks

extension AtomicBlockOperation {
    
    /// **OTCore:**
    /// Add a setup block that runs when the `AtomicBlockOperation` starts.
    public final func setSetupBlock(
        _ block: @escaping (_ operation: AtomicBlockOperation<T>,
                            _ atomicValue: AtomicVariableAccess<T>) -> Void
    ) {
        
        setupBlock = block
        
    }
    
    /// **OTCore:**
    /// Add a completion block that runs when the `AtomicBlockOperation` completes all its operations.
    public final func setCompletionBlock(
        _ block: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) {
        
        completionBlock = { [weak self] in
            guard let self = self else { return }
            let varAccess = AtomicVariableAccess(operationQueue: self.operationQueue)
            block(varAccess)
        }
        
    }
    
}

#endif
