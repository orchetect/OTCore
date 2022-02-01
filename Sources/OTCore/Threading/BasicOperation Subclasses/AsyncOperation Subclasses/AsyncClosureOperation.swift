//
//  AsyncClosureOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An `Operation` subclass that adds basic boilerplate for building an async operation by supplying a closure as a convenience when further subclassing is not necessary.
///
/// You must call `completeOperation()` within the closure block once the async operation is fully finished its execution.
///
///     let op = AsyncClosureOperation { operation in
///         DispatchQueue.global().async {
///             /// do some work ...
///
///             /// optionally: if the operation takes more
///             /// than a few seconds on average,
///             /// it's good practise to periodically
///             /// check if operation is cancelled and return
///             if operation.mainShouldAbort() { return }
///
///             /// finally call complete
///             operation.completeOperation()
///         }
///     }
///
/// - note: `AsyncClosureOperation` is not intended to be subclassed. Rather, it is a simple convenience wrapper when a closure is needed to be wrapped in an `Operation` for when you require a reference to the operation which would not otherwise be available if `.addOperation { }` was called directly on an `OperationQueue`.
///
/// - note: `AsyncClosureOperation` inherits from both `AsyncOperation` and `BasicOperation`.
public final class AsyncClosureOperation: AsyncOperation {
    
    public final var mainBlock: (_ operation: AsyncOperation) -> Void
    
    public init(
        _ mainBlock: @escaping (_ operation: AsyncOperation) -> Void
    ) {
        
        self.mainBlock = mainBlock
        
    }
    
    override public final func main() {
        
        guard mainStartOperation() else { return }
        mainBlock(self)
        // completeOperation() must be
    }
    
}

#endif
