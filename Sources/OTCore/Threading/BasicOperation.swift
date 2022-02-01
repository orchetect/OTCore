//
//  BasicOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An `Operation` subclass that adds basic boilerplate. `BasicOperation` is designed to be subclassed.
///
/// **When Subclassing**
///
/// 1. At the start of either your `main()` override or `start()` override, you call `mainStartOperation()` and return early if it returns `false`.
///
///        guard mainStartOperation() else { return }
///
/// 2. If it is an operation that can take multiple seconds or minutes, ensure that you call `mainShouldAbort()` periodically and return early if it returns `true`.
///
///        if mainShouldAbort() { return }
///
/// 3. Finally, at the end of the operation you must call `completeOperation()`.
open class BasicOperation: Operation {
    
    // adding KVO compliance
    public final override var isExecuting: Bool { _isExecuting }
    private var _isExecuting = false {
        willSet { willChangeValue(for: \.isExecuting) }
        didSet { didChangeValue(for: \.isExecuting) }
    }
    
    // adding KVO compliance
    public final override var isFinished: Bool { _isFinished }
    private var _isFinished = false {
        willSet { willChangeValue(for: \.isFinished) }
        didSet { didChangeValue(for: \.isFinished) }
    }
    
    // adding KVO compliance
    @objc dynamic
    public final override var qualityOfService: QualityOfService {
        willSet { willChangeValue(for: \.qualityOfService) }
        didSet { didChangeValue(for: \.qualityOfService) }
    }
    
    /// Returns true if operation should begin.
    public final func mainStartOperation() -> Bool {
        
        let shouldStart = isExecuting == false
        _isExecuting = true
        return shouldStart
        
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
