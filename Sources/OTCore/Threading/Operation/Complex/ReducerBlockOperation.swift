//
//  ReducerBlockOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// A synchronous `Operation` subclass that is similar to `BlockOperation` but whose internal queue can be serial or concurrent and where sub-operations can reduce upon a shared thread-safe variable passed into the operation closures.
///
/// **Setup**
///
/// Instantiate `ReducerBlockOperation` with queue type and initial mutable value. This value can be of any concrete type. If a shared mutable value is not required, an arbitrary value can be passed as the initial value such as 0.
///
/// The builder pattern can be used to add a setup block, one or more operations, and a completion block.
///
/// Any initial setup necessary can be done using `setSetupBlock{}`. Do not override `main()` or `start()`.
///
/// For completion, use `.setCompletionBlock{}`. Do not modify the underlying `.completionBlock` directly.
///
///     let op = ReducerBlockOperation(.serialFIFO,
///                                    initialMutableValue: 2)
///         .setSetupBlock { operation, sharedMutableValue in
///             // do some setup
///         }
///         .addOperation { sharedMutableValue in
///             sharedMutableValue += 1
///         }
///         .addOperation { sharedMutableValue in
///             sharedMutableValue += 1
///         }
///         .addCancellableOperation { operation, sharedMutableValue in
///             sharedMutableValue += 1
///             if operation.mainShouldAbort() { return }
///             sharedMutableValue += 1
///         }
///         .setCompletionBlock { sharedMutableValue in
///             print(sharedMutableValue) // "6"
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
/// - important: This object is not designed to be subclassed.
///
/// - note: Inherits from both `BasicAsyncOperation` and `BasicOperation`.
public final class ReducerBlockOperation<T>: BasicOperation {
    
    private let operationQueueType: OperationQueueType
    private let operationQueue: OperationQueue
    private weak var lastAddedOperation: Operation?
    
    /// The thread-safe shared mutable value that all operation blocks operate upon.
    @Atomic public final var sharedMutableValue: T
    
    private var setupBlock: ((_ operation: ReducerBlockOperation,
                              _ sharedMutableValue: inout T) -> Void)?
    
    // MARK: - Init
    
    public init(_ operationQueueType: OperationQueueType,
                initialMutableValue: T) {
        
        // assign properties
        self.operationQueueType = operationQueueType
        self.operationQueue = OperationQueue()
        self.sharedMutableValue = initialMutableValue
        
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
        setupBlock?(self, &sharedMutableValue)
        operationQueue.isSuspended = false
        
        // this ensures that the operation runs synchronously
        // which mirrors the behavior of BlockOperation
        while !isFinished {
            //usleep(10_000) // 10 milliseconds
            RunLoop.current.run(until: Date().addingTimeInterval(0.010))
        }
        
    }
    
    // MARK: - KVO Observers
    
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

// MARK: - Wrapper methods

extension ReducerBlockOperation {
    
    /// Add an operation block operating on the shared mutable value.
    @discardableResult
    public final func addOperation(
        _ block: @escaping (_ sharedMutableValue: inout T) -> Void
    ) -> Self {
        
        switch operationQueueType {
        case .serialFIFO:
            // wrap in an Operation so we can track it
            let op = ClosureOperation { [weak self] in
                guard let self = self else { return }
                block(&self.sharedMutableValue)
            }
            addOperation(op)
            
        case .concurrentAutomatic,
             .concurrent:
            // just add operation directly, don't bother tracking since we don't care about serial dependencies with concurrency
            operationQueue.addOperation { [weak self] in
                guard let self = self else { return }
                block(&self.sharedMutableValue)
            }
        }
        
        return self
        
    }
    
    /// Add an operation block operating on the shared mutable value.
    /// `operation.mainShouldAbort()` can be periodically called and then early return if the operation may take more than a few seconds.
    @discardableResult
    public final func addCancellableOperation(
        _ block: @escaping (_ operation: CancellableClosureOperation,
                            _ sharedMutableValue: inout T) -> Void
    ) -> Self {
        
        let op = CancellableClosureOperation { [weak self] operation in
            guard let self = self else { return }
            block(operation, &self.sharedMutableValue)
        }
        addOperation(op)
        
        return self
        
    }
    
    @discardableResult
    public final func addOperation(_ op: Operation) -> Self {
        
        switch operationQueueType {
        case .serialFIFO:
            // to enforce a serial queue, we add the previous operation as a dependency to the new one if it still exists
            if let lastOp = lastAddedOperation {
                op.addDependency(lastOp)
            }
            
            lastAddedOperation = op
            operationQueue.addOperation(op)
            
        case .concurrentAutomatic,
             .concurrent:
            // just add operation directly, don't bother tracking since we don't care about serial dependencies with concurrency
            operationQueue.addOperation(op)
        }
        
        return self
        
    }
    
    @discardableResult
    public final func addOperations(_ ops: [Operation]) -> Self {
        
        switch operationQueueType {
        case .serialFIFO:
            // feed into our custom addOperation since we need to add operation dependency information
            ops.forEach { addOperation($0) }
            
        case .concurrentAutomatic,
             .concurrent:
            // just use the native API since we don't care about serial dependencies with concurrency
            operationQueue.addOperations(ops, waitUntilFinished: false)
        }
        
        return self
        
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
    @discardableResult
    public final func addBarrierBlock(
        _ barrier: @escaping (_ sharedMutableValue: T) -> Void
    ) -> Self {
        
        operationQueue.addBarrierBlock { [weak self] in
            guard let self = self else { return }
            barrier(self.sharedMutableValue)
        }
        
        return self
        
    }
    
    @discardableResult
    public final func setSetupBlock(
        _ block: @escaping (_ operation: ReducerBlockOperation<T>,
                            _ sharedMutableValue: inout T) -> Void
    ) -> Self {
        
        self.setupBlock = block
        
        return self
        
    }
    
    @discardableResult
    public final func setCompletionBlock(
        _ block: @escaping (_ sharedMutableValue: T) -> Void
    ) -> Self {
        
        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            block(self.sharedMutableValue)
        }
        
        return self
        
    }
}

#endif
