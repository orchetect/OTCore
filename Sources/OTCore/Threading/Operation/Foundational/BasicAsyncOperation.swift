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
/// **Important Information from Apple Docs**
///
/// If you always plan to use queues to execute your operations, it is simpler to define them as synchronous (by subclassing OTCore's `BasicOperation` instead). If you execute operations manually, though, you might want to define your operation objects as asynchronous. Defining an asynchronous operation requires more work, because you have to monitor the ongoing state of your task and report changes in that state using KVO notifications. But defining asynchronous operations is useful in cases where you want to ensure that a manually executed operation does not block the calling thread.
///
/// When you call the `start()` method of an asynchronous operation, that method may return before the corresponding task is completed. An asynchronous operation object is responsible for scheduling its task on a separate thread. The operation could do that by starting a new thread directly, by calling an asynchronous method, or by submitting a block to a dispatch queue for execution. It does not actually matter if the operation is ongoing when control returns to the caller, only that it could be ongoing.
///
/// When you add an operation to an operation queue, the queue ignores the value of the `isAsynchronous` property and always calls the `start()` method from a separate thread. Therefore, if you always run operations by adding them to an operation queue, there is no reason to make them asynchronous.
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
/// - note: This object is designed to be subclassed. See the Foundation documentation for `Operation` regarding overriding `start()` and be sure to follow the guidelines in these inline docs regarding `BasicAsyncOperation` specifically.
///
/// - note: Inherits from `BasicOperation`.
open class BasicAsyncOperation: BasicOperation {
    
    final public override var isAsynchronous: Bool { true }
    
}

#endif
