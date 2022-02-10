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
    /// Convenience static constructor for `InteractiveClosureOperation`.
    public static func interactive(
        _ mainBlock: @escaping (_ operation: InteractiveClosureOperation) -> Void
    ) -> InteractiveClosureOperation {
        
        .init(mainBlock)
        
    }
    
    /// **OTCore:**
    /// Convenience static constructor for `InteractiveAsyncClosureOperation`.
    public static func interactiveAsync(
        on queue: DispatchQueue? = nil,
        _ mainBlock: @escaping (_ operation: InteractiveAsyncClosureOperation) -> Void
    ) -> InteractiveAsyncClosureOperation {
        
        .init(on: queue,
              mainBlock)
        
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
