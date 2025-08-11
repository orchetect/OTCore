//
//  Pasteboard.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit

extension NSPasteboard.PasteboardType {
    // TODO: Remove in future OTCore release.
    /// **OTCore:**
    /// Can use in place of `fileURL` when building for platforms earlier than macOS 10.13.
    @available(
        *,
        deprecated,
        renamed: "fileURL",
        message: "Since OTCore now has a minimum target of macOS 10.15, this property is redundant and will be removed in a future release of OTCore."
    )
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
