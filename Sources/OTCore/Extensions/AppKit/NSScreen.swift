//
//  NSScreen.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)

import AppKit

extension NSScreen {
    /// **OTCore:**
    /// Returns the screen that currently contains the user's mouse pointer.
    @_disfavoredOverload
    public static var screenWithMouseCursor: NSScreen {
        NSScreen.screens
            .first {
                NSMouseInRect(NSEvent.mouseLocation, $0.frame, false)
            }
            ?? NSScreen.screens[0] // index 0 is virtually guaranteed to exist
    }
    
    /// **OTCore:**
    /// Returns `true` if the screen currently contains the user's mouse pointer.
    @_disfavoredOverload
    public var containsMouseCursor: Bool {
        Self.screenWithMouseCursor == self
    }
}

#endif
