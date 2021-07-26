//
//  TimeInterval.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension TimeInterval {
    
    /// **OTCore:**
    /// Convenience constructor from `timespec`
    @inlinable public init(_ time: timespec) {
        
        self = time.doubleValue
        
    }
    
}

#endif
