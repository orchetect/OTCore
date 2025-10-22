//
//  FilePath and URL.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation) && canImport(System)

import Foundation
import System

// MARK: - FilePath & URL Interop

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FilePath {
    /// **OTCore:**
    /// Returns the file path as a new file `URL` instance.
    @_disfavoredOverload
    public func asURL() -> URL {
        URL(fileURLWithPath: string)
    }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension FilePath {
    /// **OTCore:**
    /// Returns the file path as a new file `URL` instance.
    public func asURL(directoryHint: URL.DirectoryHint = .inferFromPath) -> URL {
        URL(filePath: self, directoryHint: directoryHint)
            // alternative method to avoid returning an Optional:
            ?? URL(fileURLWithPath: string)
    }
}

#endif
