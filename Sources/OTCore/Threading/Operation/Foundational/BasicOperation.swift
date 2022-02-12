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
///             guard mainShouldStart() else { return }
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
open class BasicOperation: Operation, ProgressReporting {
    
    // MARK: - Progress
    
    /// **OTCore:**
    /// Progress object representing progress of the operation.
    public private(set) var progress: Progress = .init(totalUnitCount: 1)
    
    // MARK: - KVO
    
    // adding KVO compliance
    @objc dynamic
    public final override var isExecuting: Bool { _isExecuting }
    @Atomic private var _isExecuting = false {
        willSet { willChangeValue(for: \.isExecuting) }
        didSet { didChangeValue(for: \.isExecuting) }
    }
    
    // adding KVO compliance
    @objc dynamic
    public final override var isFinished: Bool { _isFinished }
    @Atomic private var _isFinished = false {
        willSet { willChangeValue(for: \.isFinished) }
        didSet { didChangeValue(for: \.isFinished) }
    }
    
    // adding KVO compliance
    @objc dynamic
    public final override var qualityOfService: QualityOfService {
        get { _qualityOfService }
        set { _qualityOfService = newValue }
    }
    private var _qualityOfService: QualityOfService = .default {
        willSet { willChangeValue(for: \.qualityOfService) }
        didSet { didChangeValue(for: \.qualityOfService) }
    }
    
    // MARK: - Method Overrides
    
    public final override func start() {
        if isCancelled { completeOperation(dueToCancellation: true) }
        super.start()
    }
    
    public final override func cancel() {
        super.cancel()
        progress.cancel()
    }
    
    // MARK: - Methods
    
    /// **OTCore:**
    /// Returns true if operation should begin.
    public final func mainShouldStart() -> Bool {
        
        guard !isCancelled else {
            completeOperation(dueToCancellation: true)
            return false
        }
        
        guard !isExecuting else { return false }
        _isExecuting = true
        return true
        
    }
    
    /// **OTCore:**
    /// Call this once all execution is complete in the operation.
    /// If returning early from the operation due to `isCancelled` being true, call this with the `dueToCancellation` flag set to `true` to update this operation's progress as cancelled.
    public final func completeOperation(dueToCancellation: Bool = false) {
        
        if isCancelled || dueToCancellation {
            progress.cancel()
        } else {
            progress.completedUnitCount = progress.totalUnitCount
        }
        
        _isExecuting = false
        _isFinished = true
        
    }
    
    /// **OTCore:**
    /// Checks if `isCancelled` is true, and calls `completedOperation()` if so.
    /// Returns `isCancelled`.
    public final func mainShouldAbort() -> Bool {
        
        if isCancelled {
            completeOperation(dueToCancellation: true)
        }
        return isCancelled
        
    }
    
}

#endif
