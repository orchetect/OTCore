//
//  ClosureOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// A synchronous `Operation` subclass that provides essential boilerplate for building an operation and supplies a closure as a convenience when further subclassing is not necessary.
///
/// This operation is synchronous. If the operation is run without being inserted into an `OperationQueue`, when you call the `start()` method the operation executes immediately in the current thread. By the time the `start()` method returns control, the operation is complete.
///
/// **Usage**
///
/// No special method calls are required in the main block.
///
/// This closure is not cancellable once it is started. If you want to allow cancellation (early return partway through operation execution) use `CancellableClosureOperation` instead.
///
///     let op = ClosureOperation {
///         // ... do some work ...
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
/// - important: This object is not intended to be subclassed. Rather, it is a simple convenience wrapper when a closure is needed to be wrapped in an `Operation` for when you require a reference to the operation which would not otherwise be available if `.addOperation{}` was called directly on an `OperationQueue`.
///
/// - note: Inherits from `BasicOperation`.
public final class ClosureOperation: BasicOperation {
    
    public final override var isAsynchronous: Bool { false }
    
    public final var mainBlock: () -> Void
    
    public init(_ mainBlock: @escaping () -> Void) {
        
        self.mainBlock = mainBlock
        
    }
    
    override public func main() {
        
        guard mainStartOperation() else { return }
        mainBlock()
        completeOperation()
        
    }
    
}

#endif
