//
//  URL and AppKit.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit

// MARK: - Images

extension URL {
    /// **OTCore:**
    /// Returns the icon that represents the given file, folder, application, etc.
    /// Returns nil if URL is not a file URL or if file does not exist.
    /// Thread-safe.
    @_disfavoredOverload
    public var fileIcon: NSImage? {
        guard isFileURL, fileExists else { return nil }
        
        return NSWorkspace.shared.icon(forFile: path)
    }
}

#endif
