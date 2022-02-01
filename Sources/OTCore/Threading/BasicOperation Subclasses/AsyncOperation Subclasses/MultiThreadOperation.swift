//
//  MultiThreadOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An `Operation` subclass that adds structure to build an operation that a) contains an internal `OperationQueue` which can be serial or concurrent and b) in which operation blocks can operate upon a shared mutable variable passed into the blocks.
///
/// **Setup**
///
/// 1. Instantiate `MultiThreadOperation` with queue type and initial mutable value. This value can be of any concrete type. If a shared mutable value is not required, an arbitrary value can be passed as the initial value such as 0.
///
///        let op = MultiThreadOperation(.serialFIFO, initialMutableValue: 0)
///
/// 2. Add operation blocks. The passed-in variable is thread-safe to mutate.
///
///        .addOperation { sharedVar in
///            sharedVar += 1
///        }
///
/// 3. Any initial setup necessary can be done in the first operation block. Do not override `main()` or `start()`.
/// 4. Add a completion handler that handles the final mutated variable. Use `.setCompletionBlock { }` and do not set `.completionBlock` directly.
///
///        .setCompletionBlock { sharedVar in
///            print(sharedVar)
///        }
///
/// 5. Add the operation to an `OperationQueue` using `.addOperation()` or start the operation by calling `.start()` if it is not being inserted into an `OperationQueue`.
///
/// **When Subclassing**
///
/// For most use cases, subclassing is not necessary. In the event that subclassing is needed:
///
/// 1. At the start of either your `main()` override or `start()` override, you call `startOperation()` and return early if it returns `false`.
///
///        guard mainStartOperation() else { return }
///
/// 2. If it is an operation that can take multiple seconds or minutes, ensure that you call `shouldAbort()` periodically and return early if it returns `true`.
///
///        if mainShouldAbort() { return }
///
/// 3. Finally, at the end of the operation you must call `completeOperation()`.
///
/// - note: `MultiThreadOperation` inherits from both `AsyncOperation` and`BasicOperation`.
open class MultiThreadOperation<T>: AsyncOperation {
    private let queueType: QueueType
    private let operationQueue: OperationQueue
    private weak var lastAddedOperation: Operation?
    
    /// The thread-safe shared mutable value that all operation blocks operate upon.
    @Atomic public final var sharedMutableValue: T
    
    // MARK: - Init
    
    public init(_ queueType: MultiThreadOperation.QueueType,
                initialMutableValue: T) {
        // assign properties
        self.queueType = queueType
        self.operationQueue = OperationQueue()
        self.sharedMutableValue = initialMutableValue
        
        // super
        super.init()
        
        // set up queue
        operationQueue.isSuspended = true
        
        operationQueue.qualityOfService = qualityOfService
        
        switch queueType {
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
    
    public final override func start() {
        guard mainStartOperation() else { return }
        operationQueue.isSuspended = false
    }
    
    // MARK: - KVO Observers
    
    /// Retain property observers. They will auto-release on deinit.
    private var observers: [NSKeyValueObservation] = []
    private func addObservers() {
        let isCancelledRetain = observe(\.isCancelled,
                                         options: [.new]) { [weak self] _, _ in
            guard let self = self else { return }
            if self.isCancelled {
                self.operationQueue.cancelAllOperations()
                self.completeOperation()
            }
        }
        observers.append(isCancelledRetain)
        
        let qosRetain = observe(\.qualityOfService,
                                 options: [.new]) { [weak self] _, _ in
            guard let self = self else { return }
            // propagate to operation queue
            self.operationQueue.qualityOfService = self.qualityOfService
        }
        observers.append(qosRetain)
        
        // can't use operationQueue.progress as it's macOS 10.15+ only
        let opCtRetain = operationQueue.observe(\.operationCount,
                                                 options: [.new]) { [weak self] _, _ in
            guard let self = self else { return }
            if self.operationQueue.operationCount == 0 {
                self.completeOperation()
            }
        }
        observers.append(opCtRetain)
    }
}

// MARK: - Wrapper methods

extension MultiThreadOperation {
    /// Add an operation block operating on the shared mutable value.
    public final func addOperation(
        _ block: @escaping (_ sharedMutableValue: inout T) -> Void
    ) {
        switch queueType {
        case .serialFIFO:
            // wrap in an Operation so we can track it
            let op = BasicClosureOperation { [weak self] in
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
    }
    
    public final func addOperation(_ op: Operation) {
        switch queueType {
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
    }
    
    public final func addOperations(_ ops: [Operation]) {
        switch queueType {
        case .serialFIFO:
            // feed into our custom addOperation since we need to add operation dependency information
            ops.forEach { addOperation($0) }
            
        case .concurrentAutomatic,
             .concurrent:
            // just use the native API since we don't care about serial dependencies with concurrency
            operationQueue.addOperations(ops, waitUntilFinished: false)
        }
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
    public final func addBarrierBlock(
        _ barrier: @escaping (_ sharedMutableValue: T) -> Void
    ) {
        operationQueue.addBarrierBlock { [weak self] in
            guard let self = self else { return }
            barrier(self.sharedMutableValue)
        }
    }
    
    public final func setCompletionBlock(
        _ block: @escaping (_ sharedMutableValue: T) -> Void
    ) {
        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            block(self.sharedMutableValue)
        }
    }
}

// MARK: - QueueType

extension MultiThreadOperation {
    public enum QueueType {
        /// Serial (one operation at a time), first-in-first-out.
        case serialFIFO
        
        /// Concurrent operations.
        /// Max number of concurrent operations will be automatically determined by the system.
        case concurrentAutomatic
        
        /// Concurrent operations.
        /// Specifies the number of max concurrent operations.
        case concurrent(maxConcurrentOperations: Int)
    }
}

#endif
