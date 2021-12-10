//
//  NSPoint.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation // imports Core Graphics

extension NSPoint {
    
    /// **OTCore:**
    /// Returns the `NSPoint` as a `CGPoint` (toll-free bridged).
    public var cgPoint: CGPoint {
        
        self as CGPoint
        
    }
    
}

#endif
