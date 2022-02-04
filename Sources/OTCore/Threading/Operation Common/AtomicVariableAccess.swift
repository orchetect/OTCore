//
//  AtomicVariableAccess.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// Proxy object providing mutation access to an atomic variable.
public class AtomicVariableAccess<T> {
    
    weak private var operationQueue: AtomicOperationQueue<T>?
    
    internal init(operationQueue: AtomicOperationQueue<T>) {
        self.operationQueue = operationQueue
    }
    
    /// Mutate the atomic variable in a closure.
    /// Warning: Perform as little logic as possible and only use this closure to get or set the variable. Failure to do so may result in deadlocks in complex multi-threaded applications.
    public func mutate(_ block: (_ value: inout T) -> Void) {
        guard let operationQueue = operationQueue else { return }
        block(&operationQueue.sharedMutableValue)
    }
    
}

#endif
