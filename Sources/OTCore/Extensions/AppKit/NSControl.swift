//
//  NSControl.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit

extension Bool {
    /// **OTCore:**
    /// Returns `NSControl.StateValue` instance of `on` (true) or `off` (false).
    @inline(__always) @_disfavoredOverload
    public var stateValue: NSControl.StateValue {
        self ? .on : .off
    }
}

extension NSControl.StateValue {
    /// **OTCore:**
    /// Returns the inverted (toggled) state.
    /// If `off`, will return `on`.
    /// If `on` or `mixed`, will return `off`.
    @inline(__always) @_disfavoredOverload
    public static prefix func ! (stateValue: Self) -> Self {
        stateValue.toggled()
    }
    
    /// **OTCore:**
    /// Returns the inverted (toggled) state.
    /// If `off`, will return `on`.
    /// If `on` or `mixed`, will return `off`.
    @inline(__always) @_disfavoredOverload
    public func toggled() -> Self {
        self == .off ? .on : .off
    }
    
    /// **OTCore:**
    /// Inverts (toggles) the state.
    /// If `off`, will return `on`.
    /// If `on` or `mixed`, will return `off`.
    @inline(__always) @_disfavoredOverload
    public mutating func toggle() {
        self = toggled()
    }
}

#endif
