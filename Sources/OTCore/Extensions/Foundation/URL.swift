//
//  URL.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - URL Manipulation

extension URL {
    /// **OTCore:**
    /// Returns true if the URL begins with the given base URL exactly.
    ///
    /// ie:
    ///
    ///     // url: "file:///temp1/temp2/file.txt"
    ///
    ///     let url2 = URL(string: "file:///temp1/temp2/")!
    ///     url.hasPrefix(url: url2) // == true
    ///
    ///     let url2 = URL(string: "file:///wrong/")!
    ///     url.hasPrefix(url: url2) // == false
    ///
    @_disfavoredOverload
    public func hasPrefix(url base: URL) -> Bool {
        absoluteString.starts(with: base.absoluteString)
    }
    
    /// **OTCore:**
    /// Returns true if the URL path components begin with the specified components.
    ///
    /// ie:
    ///
    ///     // url: "file:///temp1/temp2/file.txt"
    ///
    ///     url.hasPathComponents(prefix: ["/", "temp1"])
    ///     // == true
    ///
    ///     url.hasPathComponents(prefix: ["/", "wrong"])
    ///     // == false
    ///
    @_disfavoredOverload
    public func hasPathComponents(prefix base: [String]) -> Bool {
        pathComponents.starts(with: base)
    }
    
    /// **OTCore:**
    /// If the URL has the given base URL exactly, the path components will be returned removing the base URL's path components.
    ///
    /// ie:
    ///
    ///     // url: "file:///temp1/temp2/file.txt"
    ///
    ///     url.pathComponents(removingBase: "file:///temp1/")
    ///     // == ["temp2", "file.txt"]
    ///
    ///     url.pathComponents(removingBase: "file:///wrong/")
    ///     // == nil
    ///
    @_disfavoredOverload
    public func pathComponents(removingBase base: URL) -> [String]? {
        guard !base.pathComponents.isEmpty else { return [] }
        guard hasPrefix(url: base) else { return nil }
        
        return pathComponents.dropFirst(base.pathComponents.count).array
    }
    
    /// **OTCore:**
    /// If the URL path components begin with those of the given base URL, the path components will be returned removing the base URL's path components.
    ///
    /// ie:
    ///
    ///     // url: "file:///temp1/temp2/file.txt"
    ///
    ///     url.pathComponents(removingBase: ["/", "temp1"])
    ///     // == ["temp2", "file.txt"]
    ///
    ///     url.pathComponents(removingBase: ["/", "wrong"])
    ///     // == nil
    ///
    @_disfavoredOverload
    public func pathComponents(removingPrefix base: [String]) -> [String]? {
        guard !base.isEmpty else { return [] }
        guard hasPathComponents(prefix: base) else { return nil }
        
        return pathComponents.dropFirst(base.count).array
    }
    
    /// **OTCore:**
    /// Returns the URL with a relative base URL applied.
    /// If the URL is not prefixed by the passed `base` URL, the URL is simply returned unchanged.
    ///
    /// ie:
    ///
    ///     let url = URL(string: "file:///temp1/temp2/file.txt")
    ///     let base = URL(string: "file:///temp1/")
    ///
    ///     let rel = url.relative(to: base)
    ///     rel.absoluteString // == "file:///temp1/temp2/file.txt"
    ///     rel.baseURL?.absoluteString // == "file:///temp1/"
    ///     rel.relativeString // == "temp2/file.txt"
    ///
    @_disfavoredOverload
    public func relative(to base: URL) -> Self {
        guard let relPath = pathComponents(removingBase: base)?.joined(separator: "/"),
              !relPath.isEmpty
        else { return self }
        let encodedRelPath = URL(fileURLWithPath: relPath).relativeString
        return URL(string: encodedRelPath, relativeTo: base) ?? self
    }
    
    /// **OTCore:**
    /// Return a new URL by mutating the file name (last path component) including extension.
    @_disfavoredOverload
    public func mutatingLastPathComponent(
        _ transform: (_ fileName: String) -> String
    ) -> Self {
        let oldFileName = lastPathComponent
        let newFileName = transform(oldFileName)
        let newURL: URL = self
            .deletingLastPathComponent()
            .appendingPathComponent(newFileName)
        return newURL
    }
    
    /// **OTCore:**
    /// Return a new URL by mutating the file name (last path component) excluding extension.
    @_disfavoredOverload
    public func mutatingLastPathComponentExcludingExtension(
        _ transform: (_ fileName: String) -> String
    ) -> Self {
        let oldFileName = deletingPathExtension().lastPathComponent
        let newFileName = transform(oldFileName)
        let newURL: URL = self
            .deletingLastPathComponent()
            .appendingPathComponent(newFileName)
            .appendingPathExtension(pathExtension)
        return newURL
    }
    
    /// **OTCore:**
    /// Return a new URL by appending a string to the file name (last path component) before the extension.
    ///
    /// ie:
    ///
    /// ```
    /// let url = URL(string: "file:///Users/user/file.txt")!
    /// let url2 = url.appendingToLastPathComponentBeforeExtension("-2")
    /// url2.absoluteString // "file:///Users/user/file-2.txt"
    /// ```
    @_disfavoredOverload
    public func appendingToLastPathComponentBeforeExtension(
        _ string: String
    ) -> Self {
        let oldFileName = deletingPathExtension().lastPathComponent
        let newFileName = "\(oldFileName)\(string)"
        let newURL: URL = self
            .deletingLastPathComponent()
            .appendingPathComponent(newFileName)
            .appendingPathExtension(pathExtension)
        return newURL
    }
}

// MARK: - File / folder

extension URL {
    /// **OTCore:**
    /// Returns whether the file/folder exists.
    /// Convenience proxy for Foundation `.fileExists` method.
    ///
    /// - Will return `false` if used on a symlink and the symlink's original file does not exist.
    /// - Will still return `true` if used on an alias and the alias' original file does not exist.
    @_disfavoredOverload
    public var fileExists: Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    /// **OTCore:**
    /// Returns whether the file URL path is a folder.
    ///
    /// - Will return `nil` if the URL is not a properly formatted file URL, or there was a problem querying the URL's file system attributes.
    @_disfavoredOverload
    public var isFolder: Bool? {
        try? resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
            .isDirectory
    }
    
    /// **OTCore:**
    /// Returns the URL by returning its file system path on disk, restoring character case in the process.
    ///
    /// For example, if a file named `File.txt` exists on the desktop of a user named `John Doe`, the input URL:
    ///
    /// `file:///users/johndoe/desktop/file.txt`
    ///
    /// Would be returned as:
    ///
    /// `file:///Users/JohnDoe/Desktop/File.txt`
    ///
    /// If the file does not exist or the URL is not a file URL, the URL will be returned unmodified.
    @_disfavoredOverload
    public func restoringFileURLCase() -> URL {
        guard isFileURL else { return self }
        
        let folder = deletingLastPathComponent()
        guard folder.isFolder == true else { return self }
        
        // TODO: there is probably a more efficient way to achieve this other than enumerating folder contents, but this works
        guard let enumerator = FileManager.default
            .enumerator(at: folder, includingPropertiesForKeys: [.nameKey, .pathKey])
        else { return self }
        
        while let fileURL = enumerator.nextObject() as? URL {
            enumerator.skipDescendants()
            // crude, but it works in English locales
            if fileURL.path.lowercased() == path.lowercased() {
                return fileURL
            }
        }
        return self
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
    @discardableResult @_disfavoredOverload
    public func trashOrDelete() throws -> URL? {
        // funcs
        
        func __delFile(url: URL) throws {
            try FileManager.default.removeItem(at: url)
        }
        
        // platform-specific logic
        
        #if os(macOS) || targetEnvironment(macCatalyst) || os(iOS) || os(visionOS)
        
        if #available(macOS 10.8, iOS 11.0, *) {
            // move file to trash
            
            var resultingURL: NSURL?
            
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
    @_disfavoredOverload
    public var isFinderAlias: Bool {
        guard isFileURL else { return false }
        
        return (try? URL.bookmarkData(withContentsOf: self)) != nil
    }
    
    /// **OTCore:**
    /// Creates an alias of the base URL file or folder `at` the supplied target location. Will override existing path if it exists.
    @_disfavoredOverload
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
    @_disfavoredOverload
    public var resolvedFinderAlias: URL? {
        guard isFileURL else { return nil }
        
        guard let data = try? URL.bookmarkData(withContentsOf: self)
        else { return nil }
        
        let rv = URL.resourceValues(
            forKeys: [.pathKey],
            fromBookmarkData: data
        )
        
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
    /// - Returns `nil` if the URL is not a properly formatted file URL, or there was a problem
    ///   querying the URL's file system attributes.
    @_disfavoredOverload
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
    @_disfavoredOverload
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
    @_disfavoredOverload
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
    /// - Returns `true` if new symlink gets created.
    /// - Returns `false` if destination already exists or if the symlink already exists.
    @_disfavoredOverload
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
    @_disfavoredOverload
    public var homeDirectoryForCurrentUserCompat: URL {
        if #available(OSX 10.12, *) {
            // only available on macOS
            return homeDirectoryForCurrentUser
        } else {
            // available on all Apple platforms
            return URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        }
    }
    
    #endif
    
    /// **OTCore:**
    /// Backwards compatible method for retrieving a temporary folder from the system.
    @_disfavoredOverload
    public var temporaryDirectoryCompat: URL {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            return temporaryDirectory
        } else {
            return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
    }
}

#endif
