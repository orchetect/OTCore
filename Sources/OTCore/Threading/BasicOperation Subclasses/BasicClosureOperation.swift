//
//  BasicClosureOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An `Operation` subclass that adds basic boilerplate for building an operation by supplying a closure as a convenience when further subclassing is not necessary.
///
/// No special method calls are required in the closure.
///
/// `BasicClosureOperation` is not intended to be subclassed. Rather, it is a simple convenience wrapper when a closure is needed to be wrapped in an `Operation` for when you require a reference to the operation which would not otherwise be available if `.addOperation { }` was called directly on an `OperationQueue`.
///
/// - note: `BasicClosureOperation` inherits from `BasicOperation`.
public final class BasicClosureOperation: BasicOperation {
    
    public final override var isAsynchronous: Bool { false }
    
    public final var closure: () -> Void
    
    public required init(_ closure: @escaping () -> Void) {
        
        self.closure = closure
        
    }
    
    override public func main() {
        
        guard mainStartOperation() else { return }
        closure()
        completeOperation()
        
    }
    
}

#endif
