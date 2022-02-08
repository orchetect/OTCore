//
//  CancellableAsyncClosureOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An asynchronous `Operation` subclass that provides essential boilerplate and supplies a closure as a convenience when further subclassing is not necessary.
///
/// This operation is asynchronous. If the operation is run without being inserted into an `OperationQueue`, when you call the `start()` method the operation executes immediately in the current thread and may return control before the operation is complete.
///
/// **Usage**
///
/// There is no need to guard `mainStartOperation()` at the start of the block, as the initial check is done for you internally.
///
/// It is still best practise to periodically guard `mainShouldAbort()` if the operation may take more than a few seconds.
///
/// Finally, you must call `completeOperation()` within the closure block once the async operation is fully finished its execution.
///
///     let op = CancellableAsyncClosureOperation { operation in
///         // ... do some work ...
///
///         // optionally: if the operation takes more
///         // than a few seconds on average,
///         // it's good practise to periodically
///         // check if operation is cancelled and return
///         if operation.mainShouldAbort() { return }
///
///         // ... do some work ...
///
///         // finally call complete
///         operation.completeOperation()
///     }
///
///     // force the operation to execute on a dispatch queue,
///     // which may be desirable especially when running
///     // the operation without adding it to an OperationQueue
///     // and the closure body does not contain any asynchronous code
///     let op = CancellableAsyncClosureOperation(on: .global()) { operation in
///         // ... do some work ...
///
///         // finally call complete
///         operation.completeOperation()
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
/// - note: Inherits from both `BasicAsyncOperation` and `BasicOperation`.
public final class CancellableAsyncClosureOperation: BasicAsyncOperation {
    
    public final let queue: DispatchQueue?
    public final let mainBlock: (_ operation: CancellableAsyncClosureOperation) -> Void
    
    public init(
        on queue: DispatchQueue? = nil,
        _ mainBlock: @escaping (_ operation: CancellableAsyncClosureOperation) -> Void
    ) {
        
        self.queue = queue
        self.mainBlock = mainBlock
        
    }
    
    override public final func main() {
        
        guard mainStartOperation() else { return }
        
        if let queue = queue {
            queue.async { [weak self] in
                guard let self = self else { return }
                self.mainBlock(self)
            }
        } else {
            mainBlock(self)
        }
        
        // completeOperation() must be called manually in the block since the block runs async
        
    }
    
}

#endif
