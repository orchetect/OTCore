//
//  NSFont.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)

import AppKit

extension NSFont {
    
    /// **OTCore:**
    /// Convert an `NSFont` instance to a new `CGFont` instance.
    @_disfavoredOverload
    public var cgFont: CGFont {
        
        CTFontCopyGraphicsFont(self, nil)
        
    }
    
}

#endif
