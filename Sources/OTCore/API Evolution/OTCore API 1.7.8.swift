//
//  OTCore API 1.7.8.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

#if canImport(AppKit)

import Foundation // imports Core Graphics

extension NSPoint {
    /// **OTCore:**
    /// Returns the `NSPoint` as a `CGPoint` (toll-free bridged).
    @available(
        *,
        deprecated,
        message: "This property will be removed in future. NSPoint is toll-free bridged to CGPoint; use it as-is."
    )
    @_disfavoredOverload
    public var cgPoint: CGPoint {
        self as CGPoint
    }
}

extension CGPoint {
    /// **OTCore:**
    /// Returns the `CGPoint` as a `NSPoint` (toll-free bridged).
    @available(
        *,
        deprecated,
        message: "This property will be removed in future. CGPoint is toll-free bridged to NSPoint; use it as-is."
    )
    @inline(__always) @_disfavoredOverload
    public var nsPoint: NSPoint {
        self as NSPoint
    }
}

#endif

// MARK: - String and CharacterSet.swift

extension StringProtocol {
    @available(*, deprecated, renamed: "only(charactersIn:)")
    @_disfavoredOverload
    public func only(characters: String) -> String {
        only(charactersIn: characters)
    }
    
    @available(*, deprecated, renamed: "isOnly(charactersIn:)")
    @_disfavoredOverload
    public func isOnly(characters: String) -> Bool {
        isOnly(charactersIn: characters)
    }
    
    @available(*, deprecated, renamed: "contains(anyCharactersIn:)")
    @_disfavoredOverload
    public func contains(anyCharacters characters: String) -> Bool {
        contains(anyCharactersIn: characters)
    }
}

#endif
