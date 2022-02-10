//
//  AtomicOperationQueue.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An `OperationQueue` subclass that passes shared thread-safe variable into operation closures.
/// Concurrency type can be specified.
/// 
/// - note: Inherits from `BasicOperationQueue`.
open class AtomicOperationQueue<T>: BasicOperationQueue {
    
    /// The thread-safe shared mutable value that all operation blocks operate upon.
    @Atomic public final var sharedMutableValue: T
    
    // MARK: - Init
    
    public init(
        type operationQueueType: OperationQueueType = .concurrentAutomatic,
        initialMutableValue: T,
        resetProgressWhenFinished: Bool = false,
        statusHandler: BasicOperationQueue.StatusHandler? = nil
    ) {
        
        self.sharedMutableValue = initialMutableValue
        
        super.init(type: operationQueueType,
                   resetProgressWhenFinished: resetProgressWhenFinished,
                   statusHandler: statusHandler)
        
    }
    
    // MARK: - Shared Mutable Value Methods
    /// **OTCore:**
    /// Add an operation block operating on the shared mutable value.
    ///
    /// - returns: The new operation.
    @discardableResult
    public final func addOperation(
        dependencies: [Operation] = [],
        _ block: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> ClosureOperation {
        
        let op = createOperation(block)
        dependencies.forEach { op.addDependency($0) }
        addOperation(op)
        return op
            
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
        
        let op = createInteractiveOperation(block)
        dependencies.forEach { op.addDependency($0) }
        addOperation(op)
        return op
        
    }
    
    /// **OTCore:**
    /// Add a barrier block operation to the operation queue.
    ///
    /// Invoked after all currently enqueued operations have finished. Operations you add after the barrier block don’t start until the block has completed.
    @available(macOS 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
    public final func addBarrierBlock(
        _ barrier: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) {
        
        addBarrierBlock { [weak self] in
            guard let self = self else { return }
            let varAccess = AtomicVariableAccess(operationQueue: self)
            barrier(varAccess)
        }
        
    }
    
    // MARK: - Factory Methods
    
    /// **OTCore:**
    /// Internal for debugging:
    /// Create an operation block operating on the shared mutable value.
    internal final func createOperation(
        _ block: @escaping (_ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> ClosureOperation {
        
        ClosureOperation { [weak self] in
            guard let self = self else { return }
            let varAccess = AtomicVariableAccess(operationQueue: self)
            block(varAccess)
        }
        
    }
    
    /// **OTCore:**
    /// Internal for debugging:
    /// Create an operation block operating on the shared mutable value.
    /// `operation.mainShouldAbort()` can be periodically called and then early return if the operation may take more than a few seconds.
    internal final func createInteractiveOperation(
        _ block: @escaping (_ operation: InteractiveClosureOperation,
                            _ atomicValue: AtomicVariableAccess<T>) -> Void
    ) -> InteractiveClosureOperation {
        
        InteractiveClosureOperation { [weak self] operation in
            guard let self = self else { return }
            let varAccess = AtomicVariableAccess(operationQueue: self)
            block(operation, varAccess)
        }
        
    }
    
    /// **OTCore:**
    /// Mutate the shared atomic variable in a closure.
    public func mutateValue(_ block: (inout T) -> Void) {
        
        block(&sharedMutableValue)
        
    }
    
}

#endif
