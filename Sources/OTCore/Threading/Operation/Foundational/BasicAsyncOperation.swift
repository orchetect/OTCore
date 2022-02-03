//
//  BasicAsyncOperation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// An asynchronous `Operation` subclass that provides essential boilerplate.
/// `BasicAsyncOperation` is designed to be subclassed.
///
/// This operation is asynchronous. If the operation is run without being inserted into an `OperationQueue`, when you call the `start()` method the operation executes immediately in the current thread and may return control before the operation is complete.
///
/// **Usage**
///
/// This object is designed to be subclassed.
///
/// Refer to the following example for calls that must be made within the main closure block:
/// 
///     class MyOperation: BasicAsyncOperation {
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
/// - note: This object is designed to be subclassed. See the Foundation documentation for `Operation` regarding overriding `start()` and be sure to follow the guidelines in these inline docs regarding `BasicAsyncOperation` specifically.
///
/// - note: Inherits from `BasicOperation`.
open class BasicAsyncOperation: BasicOperation {
    
    final public override var isAsynchronous: Bool { true }
    
}

#endif
