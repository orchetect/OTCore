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

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URL {
    /// **OTCore:**
    /// Returns the file URL as a new `FilePath` instance.
    /// Returns `nil` if the URL is not a file URL.
    public var asFilePath: FilePath? {
        guard isFileURL else { return nil }
        
        if let path = FilePath(self) { return path }
        
        // alternative method:
        // FilePath throws an exception if we supply it with components that include the root
        let components = pathComponents.drop { $0 == "/" }
        return FilePath(root: "/", components.map(FilePath.Component.init))
    }
}

#endif
