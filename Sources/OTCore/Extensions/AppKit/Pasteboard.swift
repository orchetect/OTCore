//
//  Pasteboard.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit

extension NSPasteboard.PasteboardType {
    /// **OTCore:**
    /// Can use in place of `.fileURL` when building for platforms earlier than macOS 10.13.
    @_disfavoredOverload
    public static var fileURLBackCompat: Self {
        if #available(macOS 10.13, *) {
            return .fileURL
            
        } else {
            // Fallback on earlier versions
            return .init(kUTTypeFileURL as String)
        }
    }
}

#endif
