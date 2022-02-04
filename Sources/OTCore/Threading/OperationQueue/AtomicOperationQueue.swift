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
        initialMutableValue: T
    ) {
        
        self.sharedMutableValue = initialMutableValue
        
        super.init(type: operationQueueType)
        
    }
    
    // MARK: - Shared Mutable Value Methods
    
    /// **OTCore:**
    /// Add an operation block operating on the shared mutable value.
    public final func addOperation(
        _ block: @escaping (_ sharedMutableValue: inout T) -> Void
    ) {
        
        let op = ClosureOperation { [weak self] in
            guard let self = self else { return }
            block(&self.sharedMutableValue)
        }
        addOperation(op)
        
    }
    
    /// **OTCore:**
    /// Add an operation block operating on the shared mutable value.
    /// `operation.mainShouldAbort()` can be periodically called and then early return if the operation may take more than a few seconds.
    public final func addCancellableOperation(
        _ block: @escaping (_ operation: CancellableClosureOperation,
                            _ sharedMutableValue: inout T) -> Void
    ) {
        
        let op = CancellableClosureOperation { [weak self] operation in
            guard let self = self else { return }
            block(operation, &self.sharedMutableValue)
        }
        addOperation(op)
        
    }
    
    /// **OTCore:**
    /// Add a barrier block operation to the operation queue.
    ///
    /// Invoked after all currently enqueued operations have finished. Operations you add after the barrier block don’t start until the block has completed.
    @available(macOS 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
    public final func addBarrierBlock(
        _ barrier: @escaping (_ sharedMutableValue: T) -> Void
    ) {
        
        addBarrierBlock { [weak self] in
            guard let self = self else { return }
            barrier(self.sharedMutableValue)
        }
        
    }
    
    // MARK: - Factory Methods
    
    /// **OTCore:**
    /// Internal for debugging:
    /// Create an operation block operating on the shared mutable value.
    internal final func createOperation(
        _ block: @escaping (_ sharedMutableValue: inout T) -> Void
    ) -> ClosureOperation {
        
        ClosureOperation { [weak self] in
            guard let self = self else { return }
            block(&self.sharedMutableValue)
        }
        
    }
    
    /// **OTCore:**
    /// Internal for debugging:
    /// Create an operation block operating on the shared mutable value.
    /// `operation.mainShouldAbort()` can be periodically called and then early return if the operation may take more than a few seconds.
    internal final func createCancellableOperation(
        _ block: @escaping (_ operation: CancellableClosureOperation,
                            _ sharedMutableValue: inout T) -> Void
    ) -> CancellableClosureOperation{
        
        CancellableClosureOperation { [weak self] operation in
            guard let self = self else { return }
            block(operation, &self.sharedMutableValue)
        }
        
    }
    
}

#endif
