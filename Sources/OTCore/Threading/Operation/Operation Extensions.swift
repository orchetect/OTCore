//
//  Operation Extensions.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension Operation {
    
    /// **OTCore:**
    /// Convenience static constructor for `ClosureOperation`.
    public static func basic(
        _ mainBlock: @escaping () -> Void
    ) -> ClosureOperation {
        
        .init(mainBlock)
        
    }
    
    /// **OTCore:**
    /// Convenience static constructor for `CancellableClosureOperation`.
    public static func cancellable(
        _ mainBlock: @escaping (_ operation: CancellableClosureOperation) -> Void
    ) -> CancellableClosureOperation {
        
        .init(mainBlock)
        
    }
    
    /// **OTCore:**
    /// Convenience static constructor for `CancellableAsyncClosureOperation`.
    public static func cancellableAsync(
        on queue: DispatchQueue? = nil,
        _ mainBlock: @escaping (_ operation: CancellableAsyncClosureOperation) -> Void
    ) -> CancellableAsyncClosureOperation {
        
        .init(on: queue, mainBlock)
        
    }
    
    /// **OTCore:**
    /// Convenience static constructor for `AtomicBlockOperation`.
    /// Builder pattern can be used to add operations inline.
    public static func atomicBlock<T>(
        _ operationQueueType: OperationQueueType,
        initialMutableValue: T
    ) -> AtomicBlockOperation<T> {
        
        .init(type: operationQueueType,
              initialMutableValue: initialMutableValue)
        
    }
    
}

#endif
