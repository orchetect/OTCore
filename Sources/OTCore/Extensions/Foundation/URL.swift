//
//  URL.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

// MARK: - File / folder

extension URL {
    
    /// **OTCore:**
    /// Returns whether the file/folder exists.
    /// Convenience proxy for Foundation `.fileExists` method.
    ///
    /// - Will return `false` if used on a symlink and the symlink's original file does not exist.
    /// - Will still return `true` if used on an alias and the alias' original file does not exist.
    public var fileExists: Bool {
        
        FileManager.default.fileExists(atPath: path)
        
    }
    
    /// **OTCore:**
    /// Convenience method to test if a file URL is a symbolic link and not an actual file/folder.
    ///
    /// - Will return `nil` if the URL is not a properly formatted file URL, or there was a problem querying the URL's file system attributes.
    public var isFolder: Bool? {
        
        try? resourceValues(forKeys: Set([URLResourceKey.isDirectoryKey]))
            .isDirectory
        
    }
    
}


// MARK: - File operations

extension URL {
    
    /// **OTCore:**
    /// Attempts to first move a file to the Trash if possible, otherwise attempts to delete the file.
    ///
    /// If the file was moved to the trash, the new resulting `URL` is returned.
    ///
    /// If the file was deleted, `nil` is returned.
    ///
    /// If both operations were unsuccessful, an error is thrown.
    @discardableResult
    public func trashOrDelete() throws -> URL? {
        
        // funcs
        
        func __delFile(url: URL) throws {
            try FileManager.default.removeItem(at: url)
        }
        
        // platform-specific logic
        
        #if os(macOS) || targetEnvironment(macCatalyst) || os(iOS)
            
            if #available(macOS 10.8, iOS 11.0, *) {
                
                // move file to trash
                
                var resultingURL: NSURL? = nil
                
                do {
                    try FileManager.default.trashItem(at: self, resultingItemURL: &resultingURL)
                } catch {
                    #if os(macOS)
                        throw error
                    #else
                        // .trashItem has permissions issues on iOS; ignore and return without throwing
                        return nil
                    #endif
                }
                
                return resultingURL?.absoluteURL
                
            } else {
                
                // OS version requirements not met - delete file as a fallback
                
                try __delFile(url: self)
                return nil
                
            }
        
        #elseif os(tvOS)
        
            // tvOS has no Trash - just delete the file
            
            try __delFile(url: self)
            return nil
        
        #elseif os(watchOS)
        
            // watchOS has no Trash - just delete the file
            
            try __delFile(url: self)
            return nil
        
        #endif
        
    }
    
}

// MARK: - Finder Aliases

extension URL {
    
    /// **OTCore:**
    /// Convenience method to test if a file URL is a Finder alias.
    public var isFinderAlias: Bool {
        
        guard isFileURL else { return false }
        
        return (try? URL.bookmarkData(withContentsOf: self)) != nil
        
    }
    
    /// **OTCore:**
    /// Creates an alias of the base URL file or folder `at` the supplied target location. Will override existing path if it exists.
    public func createFinderAlias(at url: URL) throws {
        
        let data = try
            bookmarkData(
                options: .suitableForBookmarkFile,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
        
        try URL.writeBookmarkData(data, to: url)
        
    }
    
    /// **OTCore:**
    /// If self is a Finder alias, its resolved URL is returned regardless whether it exists or not.
    ///
    /// `nil` will be returned if any of the following is true for `self`:
    /// - is not a Finder alias or does not exist, or
    /// - is a symbolic link or a hard link and not a Finder alias, or
    /// - does not exist.
    public var resolvedFinderAlias: URL? {
        
        guard isFileURL else { return nil }
        
        guard let data = try? URL.bookmarkData(withContentsOf: self)
        else { return nil }
        
        let rv = URL.resourceValues(forKeys: [.pathKey],
                                    fromBookmarkData: data)
        
        guard let pathString = rv?.path
        else { return nil }
        
        return URL(fileURLWithPath: pathString)
        
    }
    
}


// MARK: - SymLinks

extension URL {
    
    /// **OTCore:**
    /// Convenience method to test if a file URL is a symbolic link and not an actual file/folder.
    ///
    /// - Returns `nil` if the URL is not a properly formatted file URL, or there was a problem querying the URL's file system attributes.
    public var isSymLink: Bool? {
        
        guard isFileURL
        else { return nil }
        
        guard let getAttr = try? FileManager.default
                .attributesOfItem(atPath: path)
        else { return nil }
        
        guard let getFileType = getAttr[.type]
        else { return nil }
        
        return getFileType as? String == "NSFileTypeSymbolicLink"
        
    }
    
    /// **OTCore:**
    /// Convenience method to test if a file URL is a symbolic link pointing to `file`.
    ///
    /// - Returns `true` even if original file does not exist.
    /// - Returns `nil` if the URL is not a properly formatted file URL.
    public func isSymLinkOf(file: URL) -> Bool? {
        
        guard file.isFileURL
        else { return nil }
        
        return isSymLinkOf(file: file.path)
        
    }
    
    /// **OTCore:**
    /// Convenience method to test if a file URL is a symbolic link pointing to `file`.
    ///
    /// - Returns `true` even if original file does not exist.
    /// - Returns `nil` if the URL is not a properly formatted file URL.
    public func isSymLinkOf(file: String) -> Bool? {
        
        guard isFileURL
        else { return nil }
        
        // returns path of original file, even if original file no longer exists
        guard let dest = try? FileManager.default
                .destinationOfSymbolicLink(atPath: path)
        else { return false }
        
        return file == dest
        
    }
    
    /// **OTCore:**
    /// Creates a symbolic link (symlink) of the base URL file or folder `at` the supplied target location.
    ///
    /// Returns `true` if new symlink gets created.
    /// Returns `false` if destination already exists or if the symlink already exists.
    public func createSymLink(at url: URL) throws {
        
        try FileManager.default
            .createSymbolicLink(at: url, withDestinationURL: self)
        
    }
    
}


// MARK: - Folders

extension FileManager {
    
    #if os(macOS)
    
    /// **OTCore:**
    /// Backwards compatible method for retrieving the current user's home directory, using the most recent API where possible.
    public static var homeDirectoryForCurrentUserCompat: URL {
        
        if #available(OSX 10.12, *) {
            // only available on macOS
            return FileManager.default.homeDirectoryForCurrentUser
        } else {
            // available on all Apple platforms
            return URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        }
        
    }
    
    #endif
    
    /// **OTCore:**
    /// Backwards compatible method for retrieving a temporary folder from the system.
    public static var temporaryDirectoryCompat: URL {
        
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            return FileManager.default.temporaryDirectory
        } else {
            return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
        
    }
    
}

#endif
