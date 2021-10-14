//
//  NSControl.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)

import AppKit

extension Bool {
    
    /// **OTCore:**
    /// Returns `NSControl.StateValue` instance of `.on` (true) or `.off` (false).
    public var stateValue: NSControl.StateValue {
        
        self ? .on : .off
        
    }
    
}

extension NSControl.StateValue {
    
    /// **OTCore:**
    /// Returns the inverted (toggled) state.
    /// If `.off`, will return `.on`.
    /// If `.on` or `.mixed`, will return `.off`.
    public static prefix func !(stateValue: Self) -> Self {
        
        stateValue.toggled()
        
    }
    
    /// **OTCore:**
    /// Returns the inverted (toggled) state.
    /// If `.off`, will return `.on`.
    /// If `.on` or `.mixed`, will return `.off`.
    public func toggled() -> Self {
        
        self == .off ? .on : .off
        
    }
    
    /// **OTCore:**
    /// Inverts (toggles) the state.
    /// If `.off`, will return `.on`.
    /// If `.on` or `.mixed`, will return `.off`.
    public mutating func toggle() {
        
        self = toggled()
        
    }
    
}

#endif
