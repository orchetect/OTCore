//
//  InteractiveClosureOperation.swift
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
/// No specific calls are required to be made within the main block, however it is best practise to periodically check if the operation is cancelled and return early if the operation may take more than a few seconds.
///
/// If progress information is available, set `operation.progress.totalUnitCount` and periodically update `operation.progress.completedUnitCount` through the operation. Cleanup will automatically finish the progress and set it to 100% once the block finishes.
///
///     let op = InteractiveClosureOperation { operation in
///         // optionally: set progress info
///         operation.progress.totalUnitCount = 100
///
///         // ... do some work ...
///
///         // optionally: update progress periodically
///         operation.progress.completedUnitCount = 50
///
///         // optionally: if the operation takes more
///         // than a few seconds on average,
///         // it's good practise to periodically
///         // check if operation is cancelled and return
///         if operation.mainShouldAbort() { return }
///
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
public final class InteractiveClosureOperation: BasicOperation {
    
    public final override var isAsynchronous: Bool { false }
    
    public final var mainBlock: (_ operation: InteractiveClosureOperation) -> Void
    
    public init(
        _ mainBlock: @escaping (_ operation: InteractiveClosureOperation) -> Void
    ) {
        
        self.mainBlock = mainBlock
        
    }
    
    override public func main() {
        
        guard mainShouldStart() else { return }
        mainBlock(self)
        completeOperation()
        
    }
    
}

#endif
