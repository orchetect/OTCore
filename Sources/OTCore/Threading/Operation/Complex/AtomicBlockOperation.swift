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
/// The builder pattern can be used to add a setup block, one or more operations, and a completion block.
///
/// Any initial setup necessary can be done using `setSetupBlock{}`. Do not override `main()` or `start()`.
///
/// For completion, use `.setCompletionBlock{}`. Do not modify the underlying `.completionBlock` directly.
///
///     let op = AtomicBlockOperation(.serialFIFO,
///                                   initialMutableValue: 2)
///         .setSetupBlock { operation, atomicValue in
///             // do some setup
///         }
///         .addOperation { atomicValue in
///             atomicValue.mutate { $0 += 1 }
///         }
///         .addOperation { atomicValue in
///             atomicValue.mutate { $0 += 1 }
///         }
///         .addCancellableOperation { operation, atomicValue in
///             atomicValue.mutate { $0 += 1 }
///             if operation.mainShouldAbort() { return }
///             atomicValue.mutate { $0 += 1 }
///         }
///         .setCompletionBlock { atomicValue in
///             print(atomicValue) // "6"
///         }
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
    
    private let operationQueue: AtomicOperationQueue<T>
    
    private weak var lastAddedOperation: Operation? {
        operationQueue.lastAddedOperation
    }
    
    /// The thread-safe shared mutable value that all operation blocks operate upon.
    public final var value: T {
        operationQueue.sharedMutableValue
    }
    
    private var setupBlock: ((_ operation: AtomicBlockOperation,
                              _ atomicValue: AtomicVariableAccess<T>) -> Void)?
    
    // MARK: - Init
    
    public init(type operationQueueType: OperationQueueType,
                initialMutableValue: T) {
        
        // assign properties
        self.operationQueue = AtomicOperationQueue(
            type: operationQueueType,
            initialMutableValue: initialMutableValue
        )
        
        // super
        super.init()
        
        // set up queue
        operationQueue.isSuspended = true
        
        operationQueue.qualityOfService = qualityOfService
        
        switch operationQueueType {
        case .serialFIFO:
            operationQueue.maxConcurrentOperationCount = 1
            
        case .concurrentAutomatic:
            operationQueue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
            
        case .concurrent(let maxConcurrentOperations):
            operationQueue.maxConcurrentOperationCount = maxConcurrentOperations
        }
        
        // set up observers
        addObservers()
        
    }
    
    // MARK: - Overrides
    
    public final override func main() {
        
        guard mainStartOperation() else { return }
        let varAccess = AtomicVariableAccess(operationQueue: self.operationQueue)
        setupBlock?(self, varAccess)
        operationQueue.isSuspended = false
        
        // this ensures that the operation runs synchronously
        // which mirrors the behavior of BlockOperation
        while !isFinished {
            //usleep(10_000) // 10 milliseconds
            RunLoop.current.run(until: Date().addingTimeInterval(0.010))
        }
        
    }
    
    // MARK: - KVO Observers
    
    /// **OTCore:**
    /// Retain property observers. They will auto-release on deinit.
    private var observers: [NSKeyValueObservation] = []
    private func addObservers() {
        
        let isCancelledRetain = observe(\.isCancelled,
                                         options: [.new])
        { [weak self] _, _ in
            guard let self = self else { return }
            if self.isCancelled {
                self.operationQueue.cancelAllOperations()
                self.completeOperation()
            }
        }
        observers.append(isCancelledRetain)
        
        let qosRetain = observe(\.qualityOfService,
                                 options: [.new])
        { [weak self] _, _ in
            guard let self = self else { return }
            // propagate to operation queue
            self.operationQueue.qualityOfService = self.qualityOfService
        }
        observers.append(qosRetain)
        
        // can't use operationQueue.progress as it's macOS 10.15+ only
        let opCtRetain = operationQueue.observe(\.operationCount,
                                                 options: [.new])
        { [weak self] _, _ in
            guard let self = self else { return }
            if self.operationQueue.operationCount == 0 {
                self.completeOperation()
            }
        }
        observers.append(opCtRetain)
        
    }
    
}

// MARK: - Proxy methods

extension AtomicBlockOperation {
    
    /// **OTCore:**
    /// Add an operation block operating on the shared mutable value.
    @discardableResult
    public final func addOperation(
        _ block: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> Self {
        
        operationQueue.addOperation(block)
        
        return self
        
    }
    
    /// **OTCore:**
    /// Add an operation block operating on the shared mutable value.
    /// `operation.mainShouldAbort()` can be periodically called and then early return if the operation may take more than a few seconds.
    @discardableResult
    public final func addCancellableOperation(
        _ block: @escaping (_ operation: CancellableClosureOperation,
                            _ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> Self {
        
        operationQueue.addCancellableOperation(block)
        
        return self
        
    }
    
    /// **OTCore:**
    /// Add an operation to the operation queue.
    @discardableResult
    public final func addOperation(_ op: Operation) -> Self {
        
        operationQueue.addOperation(op)
        
        return self
        
    }
    
    /// **OTCore:**
    /// Add operations to the operation queue.
    @discardableResult
    public final func addOperations(_ ops: [Operation]) -> Self {
        
        operationQueue.addOperations(ops, waitUntilFinished: false)
        
        return self
        
    }
    
    /// **OTCore:**
    /// Add a barrier block operation to the operation queue.
    ///
    /// Invoked after all currently enqueued operations have finished. Operations you add after the barrier block don’t start until the block has completed.
    @available(macOS 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
    @discardableResult
    public final func addBarrierBlock(
        _ barrier: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> Self {
        
        operationQueue.addBarrierBlock(barrier)
        
        return self
        
    }
    
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
    @discardableResult
    public final func setSetupBlock(
        _ block: @escaping (_ operation: AtomicBlockOperation<T>,
                            _ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> Self {
        
        self.setupBlock = block
        
        return self
        
    }
    
    /// **OTCore:**
    /// Add a completion block that runs when the `AtomicBlockOperation` completes all its operations.
    @discardableResult
    public final func setCompletionBlock(
        _ block: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> Self {
        
        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            let varAccess = AtomicVariableAccess(operationQueue: self.operationQueue)
            block(varAccess)
        }
        
        return self
        
    }
    
}

#endif
