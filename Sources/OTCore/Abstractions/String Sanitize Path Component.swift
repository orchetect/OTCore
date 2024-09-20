//
//  String Sanitize Path Component.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2024 Steffan Andrews • Licensed under MIT License
//

// MARK: - Sanitize Path Component

/// **OTCore:**
/// File system cases.
public enum FileSystemFormat: Equatable, Hashable, CaseIterable {
    /// HFS+ (Apple)
    case hfsPlus
    
    /// APFS (Apple)
    case apfs
    
    // case ext
    // case ntfs
    // case fat32
}

extension FileSystemFormat: Identifiable {
    public var id: Self { self }
}

extension String {
    /// **OTCore:**
    /// Sanitizes illegal characters in a path component based on the specified file system(s).
    /// This method takes an over-cautious approach by replacing certain characters that may be
    /// supported on modern systems but may still present backwards-compatibility issues.
    ///
    /// - Parameters:
    ///   - formats: Target file system(s). Passing `nil` sanitizes the string for all supported
    ///     file systems.
    ///   - replacement: Replacement character to substitute for illegal characters.
    /// - Returns: Sanitized string.
    @_disfavoredOverload
    public mutating func sanitizePathComponent(
        for formats: [FileSystemFormat]? = nil,
        replacement: Character = "-"
    ) {
        let fileSystems = formats ?? FileSystemFormat.allCases
        
        for fileSystem in fileSystems {
            _sanitizePathComponent(for: fileSystem, replacement: replacement)
        }
    }
    
    private mutating func _sanitizePathComponent(
        for format: FileSystemFormat,
        replacement: Character
    ) {
        switch format {
        case .hfsPlus, .apfs:
            // legacy Apple file systems did not support the colon character (`:`).
            
            // HFS+:
            // Supports all Unicode characters.
            
            // APFS:
            // Supports all valid UTF-8 strings.
            
            // Even though HFS+ and APFS file systems both support all Unicode characters, most APIs
            // provided
            // by OS X/macOS allow you create/open files with a slash `/` or NUL `\0` in them.
            
            let illegalChars: [Character] = ["/", "\0", ":"]
            
            replace(elementsIn: illegalChars, with: replacement)
        }
    }
    
    /// **OTCore:**
    /// Returns the path component string by sanitizing illegal characters based on the specified
    /// file system(s). This method takes an over-cautious approach by replacing certain characters
    /// that may be supported on modern systems but may still present backwards-compatibility
    /// issues.
    ///
    /// - Parameters:
    ///   - formats: Target file system(s). Passing `nil` sanitizes the string for all supported
    ///     file systems.
    ///   - replacement: Replacement character to substitute for illegal characters.
    /// - Returns: Sanitized string.
    @_disfavoredOverload
    public func sanitizingPathComponent(
        for formats: [FileSystemFormat]? = nil,
        replacement: Character = "-"
    ) -> String {
        var mutable = self
        mutable.sanitizePathComponent(for: formats, replacement: replacement)
        return mutable
    }
}

#if canImport(Foundation)

import Foundation

extension URL {
    /// **OTCore:**
    /// Returns the URL by sanitizing illegal characters in the last path component based on the
    /// specified file system(s). This method takes an over-cautious approach by replacing certain
    /// characters that may be supported on modern systems but may still present
    /// backwards-compatibility issues.
    ///
    /// - Parameters:
    ///   - formats: Target file system(s). Passing `nil` sanitizes the string for all supported
    ///     file systems.
    ///   - replacement: Replacement character to substitute for illegal characters.
    @_disfavoredOverload
    public mutating func sanitizeLastPathComponent(
        for formats: [FileSystemFormat]? = nil,
        replacement: Character = "-"
    ) {
        let lpc = lastPathComponent
            .sanitizingPathComponent(for: formats, replacement: replacement)
        
        deleteLastPathComponent()
        
        appendPathComponent(lpc)
    }
    
    /// **OTCore:**
    /// Sanitizes illegal characters in the last path component based on the
    /// specified file system(s). This method takes an over-cautious approach by replacing certain
    /// characters that may be supported on modern systems but may still present
    /// backwards-compatibility issues.
    ///
    /// - Parameters:
    ///   - formats: Target file system(s). Passing `nil` sanitizes the string for all supported
    ///     file systems.
    ///   - replacement: Replacement character to substitute for illegal characters.
    @_disfavoredOverload
    public func sanitizingLastPathComponent(
        for formats: [FileSystemFormat]? = nil,
        replacement: Character = "-"
    ) -> URL {
        var mutable = self
        mutable.sanitizeLastPathComponent(for: formats, replacement: replacement)
        return mutable
    }
}

#endif
