//
//  AsyncOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An `Operation` subclass that adds basic boilerplate for building an async operation.
///
/// **When Subclassing**
///
/// 1. At the start of either your `main()` override or `start()` override, you call `startOperation()` and return early if it returns `false`.
///
///        guard mainStartOperation() else { return }
///
/// 2. If it is an operation that can take multiple seconds or minutes, ensure that you call `shouldAbort()` periodically and return early if it returns `true`.
///
///        if mainShouldAbort() { return }
///
/// 3. Finally, at the end of the operation you must call `completeOperation()`.
///
/// - note: `AsyncOperation` inherits from `BasicOperation`.
open class AsyncOperation: BasicOperation {
    
    final public override var isAsynchronous: Bool { true }
    
}

#endif
