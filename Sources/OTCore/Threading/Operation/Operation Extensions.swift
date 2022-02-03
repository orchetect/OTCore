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
        _ mainBlock: @escaping (_ operation: CancellableAsyncClosureOperation) -> Void
    ) -> CancellableAsyncClosureOperation {
        
        .init(mainBlock)
        
    }
    
    /// **OTCore:**
    /// Convenience static constructor for `ReducerBlockOperation`.
    /// Builder pattern can be used to add operations inline.
    public static func reducerBlock<T>(
        _ operationQueueType: OperationQueueType,
        initialMutableValue: T
    ) -> ReducerBlockOperation<T> {
        
        .init(operationQueueType,
              initialMutableValue: initialMutableValue)
        
    }
    
}

#endif
