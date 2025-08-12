//
//  OTCore API 1.5.4.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - URL.swift

#if canImport(Foundation)
import Foundation

extension FileManager {
    #if os(macOS)
    
    /// **OTCore:**
    /// Backwards compatible method for retrieving the current user's home directory, using the most
    /// recent API where possible.
    @available(*, deprecated, renamed: "default.homeDirectoryForCurrentUserCompat")
    @_disfavoredOverload
    public static var homeDirectoryForCurrentUserCompat: URL {
        Self.default.homeDirectoryForCurrentUserCompat
    }
    
    #endif
    
    /// **OTCore:**
    /// Backwards compatible method for retrieving a temporary folder from the system.
    @available(*, deprecated, renamed: "default.temporaryDirectoryCompat")
    @_disfavoredOverload
    public static var temporaryDirectoryCompat: URL {
        Self.default.temporaryDirectoryCompat
    }
}
#endif
