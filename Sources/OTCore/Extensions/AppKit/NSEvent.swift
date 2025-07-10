//
//  NSEvent.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit

extension NSEvent {
    /// **OTCore:**
    /// Returns an `NSEvent`'s mouse location in relation to a view's coordinate space.
    /// For non-mouse events the return value of this method is undefined.
    @_disfavoredOverload
    @MainActor
    public func location(in view: NSView) -> NSPoint {
        // Apple docs:
        // "With NSMouseMoved and possibly other events, the event can have a nil window (that is, the window property contains nil).
        // In this case, locationInWindow returns the event location in screen coordinates."
        
        view.convert(locationInWindow, from: nil)
    }
}

#endif
