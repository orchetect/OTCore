//
//  BasicOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// A synchronous or asynchronous `Operation` subclass that provides essential boilerplate.
/// `BasicOperation` is designed to be subclassed.
///
/// By default this operation is synchronous. If the operation is run without being inserted into an `OperationQueue`, when you call the `start()` method the operation executes immediately in the current thread. By the time the `start()` method returns control, the operation is complete.
///
/// If asynchronous behavior is required then use `BasicAsyncOperation` instead.
///
/// **Usage**
///
/// This object is designed to be subclassed.
///
/// Refer to the following example for calls that must be made within the main closure block:
///
///     class MyOperation: BasicOperation {
///         override func main() {
///             // At the start, call this and conditionally return:
///             guard mainStartOperation() else { return }
///
///             // ... do some work ...
///
///             // Optionally:
///             // If the operation may take more than a few seconds,
///             // periodically check and and return early:
///             if mainShouldAbort() { return }
///
///             // ... do some work ...
///
///             // Finally, at the end of the operation call:
///             completeOperation()
///         }
///     }
///
/// - important: This object is designed to be subclassed. See the Foundation documentation for `Operation` regarding overriding `start()` and be sure to follow the guidelines in these inline docs regarding `BasicOperation` specifically.
open class BasicOperation: Operation {
    
    // MARK: - KVO
    
    // adding KVO compliance
    public final override var isExecuting: Bool { _isExecuting }
    @Atomic private var _isExecuting = false {
        willSet { willChangeValue(for: \.isExecuting) }
        didSet { didChangeValue(for: \.isExecuting) }
    }
    
    // adding KVO compliance
    public final override var isFinished: Bool { _isFinished }
    @Atomic private var _isFinished = false {
        willSet { willChangeValue(for: \.isFinished) }
        didSet { didChangeValue(for: \.isFinished) }
    }
    
    // adding KVO compliance
    @objc dynamic
    public final override var qualityOfService: QualityOfService {
        willSet { willChangeValue(for: \.qualityOfService) }
        didSet { didChangeValue(for: \.qualityOfService) }
    }
    
    // MARK: - Method Overrides
    
    public final override func start() {
        if isCancelled { completeOperation() }
        super.start()
    }
    
    // MARK: - Methods
    
    /// Returns true if operation should begin.
    public final func mainStartOperation() -> Bool {
        
        guard !isCancelled else {
            completeOperation()
            return false
        }
        
        guard !isExecuting else { return false }
        _isExecuting = true
        return true
        
    }
    
    /// Call this once all execution is complete in the operation.
    public final func completeOperation() {
        
        _isExecuting = false
        _isFinished = true
        
    }
    
    /// Checks if `isCancelled` is true, and calls `completedOperation()` if so.
    /// Returns `isCancelled`.
    public final func mainShouldAbort() -> Bool {
        
        if isCancelled {
            completeOperation()
        }
        return isCancelled
        
    }
    
}

#endif
