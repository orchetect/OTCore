//
//  OperationQueue Extensions.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension OperationQueue {
    
    /// **OTCore:**
    /// Blocks the current thread until all the receiver’s queued and executing operations finish executing. Same as calling `waitUntilAllOperationsAreFinished()` but offers a timeout duration.
    @discardableResult
    public func waitUntilAllOperationsAreFinished(
        timeout: DispatchTimeInterval
    ) -> DispatchTimeoutResult {
        
        DispatchGroup.sync(asyncOn: .global(),
                           timeout: timeout) { g in
            
            self.waitUntilAllOperationsAreFinished()
            g.leave()
            
        }
        
    }
    
}

#endif
