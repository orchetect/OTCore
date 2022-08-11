//
//  NSPoint.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(AppKit)

import Foundation // imports Core Graphics

extension NSPoint {
    /// **OTCore:**
    /// Returns the `NSPoint` as a `CGPoint` (toll-free bridged).
    @_disfavoredOverload
    public var cgPoint: CGPoint {
        self as CGPoint
    }
}

#endif
