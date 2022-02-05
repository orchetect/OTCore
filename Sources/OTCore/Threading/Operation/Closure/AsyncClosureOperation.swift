//
//  AsyncClosureOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An asynchronous `Operation` subclass that provides essential boilerplate for building an operation and supplies a closure as a convenience when further subclassing is not necessary.
///
/// This operation is asynchronous. If the operation is run without being inserted into an `OperationQueue`, when you call the `start()` method the operation executes immediately in the current thread and may return control before the operation is complete.
///
/// **Usage**
///
/// No special method calls are required in the main block.
///
/// This closure is not cancellable once it is started. If you want to allow cancellation (early return partway through operation execution) use `CancellableAsyncClosureOperation` instead.
///
///     // if not specifying a dispatch queue, the operation will
///     // run on the current thread if started manually,
///     // or if this operation is added to an OperationQueue it
///     // will be automatically managed
///     let op = AsyncClosureOperation {
///         // ... do some work ...
///     }
///
///     // force the operation to execute on a dispatch queue,
///     // which may be desirable especially when running
///     // the operation without adding it to an OperationQueue
///     // and the closure body does not contain any asynchronous code
///     let op = AsyncClosureOperation(on: .global()) {
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
public final class AsyncClosureOperation: BasicOperation {
    
    public final override var isAsynchronous: Bool { true }
    
    public final let queue: DispatchQueue?
    public final let mainBlock: () -> Void
    
    public init(
        on queue: DispatchQueue? = nil,
        _ mainBlock: @escaping () -> Void
    ) {
        
        self.queue = queue
        self.mainBlock = mainBlock
        
    }
    
    override public final func main() {
        
        guard mainStartOperation() else { return }
        
        if let queue = queue {
            queue.async { [weak self] in
                guard let self = self else { return }
                self.mainBlock()
                self.completeOperation()
            }
        } else {
            mainBlock()
            completeOperation()
        }
        
    }
    
}

#endif
