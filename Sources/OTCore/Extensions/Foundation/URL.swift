//
//  URL.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - URL Manipulation

extension URL {
    /// **OTCore:**
    /// Returns `true` if the URL begins with the given base URL exactly.
    ///
    /// ie:
    ///
    /// ```swift
    /// // url: "file:///temp1/temp2/file.txt"
    ///
    /// let url2 = URL(string: "file:///temp1/temp2/")!
    /// url.hasPrefix(url: url2) // == true
    ///
    /// let url2 = URL(string: "file:///wrong/")!
    /// url.hasPrefix(url: url2) // == false
    /// ```
    @_disfavoredOverload
    public func hasPrefix(url base: URL) -> Bool {
        absoluteString.starts(with: base.absoluteString)
    }
    
    /// **OTCore:**
    /// Returns `true` if the URL path components begin with the specified components.
    ///
    /// ie:
    ///
    /// ```swift
    /// // url: "file:///temp1/temp2/file.txt"
    ///
    /// url.hasPathComponents(prefix: ["/", "temp1"])
    /// // == true
    ///
    /// url.hasPathComponents(prefix: ["/", "wrong"])
    /// // == false
    /// ```
    @_disfavoredOverload
    public func hasPathComponents(prefix base: [String]) -> Bool {
        pathComponents.starts(with: base)
    }
    
    /// **OTCore:**
    /// If the URL has the given base URL exactly, the path components will be returned removing the
    /// base URL's path components.
    ///
    /// ie:
    ///
    /// ```swift
    /// // url: "file:///temp1/temp2/file.txt"
    ///
    /// url.pathComponents(removingBase: "file:///temp1/")
    /// // == ["temp2", "file.txt"]
    ///
    /// url.pathComponents(removingBase: "file:///wrong/")
    /// // == nil
    /// ```
    @_disfavoredOverload
    public func pathComponents(removingBase base: URL) -> [String]? {
        guard !base.pathComponents.isEmpty else { return [] }
        guard hasPrefix(url: base) else { return nil }
        
        return pathComponents.dropFirst(base.pathComponents.count).array
    }
    
    /// **OTCore:**
    /// If the URL path components begin with those of the given base URL, the path components will
    /// be returned removing the base URL's path components.
    ///
    /// ie:
    ///
    /// ```swift
    /// // url: "file:///temp1/temp2/file.txt"
    ///
    /// url.pathComponents(removingBase: ["/", "temp1"])
    /// // == ["temp2", "file.txt"]
    ///
    /// url.pathComponents(removingBase: ["/", "wrong"])
    /// // == nil
    /// ```
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
    /// ```swift
    /// let url = URL(string: "file:///temp1/temp2/file.txt")
    /// let base = URL(string: "file:///temp1/")
    ///
    /// let rel = url.relative(to: base)
    /// rel.absoluteString // == "file:///temp1/temp2/file.txt"
    /// rel.baseURL?.absoluteString // == "file:///temp1/"
    /// rel.relativeString // == "temp2/file.txt"
    /// ```
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
        let newURL: URL = deletingLastPathComponent()
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
        let newURL: URL = deletingLastPathComponent()
            .appendingPathComponent(newFileName)
            .appendingPathExtension(pathExtension)
        return newURL
    }
    
    /// **OTCore:**
    /// Return a new URL by appending a string to the file name (last path component) before the
    /// extension.
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
        let newURL: URL = deletingLastPathComponent()
            .appendingPathComponent(newFileName)
            .appendingPathExtension(pathExtension)
        return newURL
    }
}

// MARK: - File / Folder Metadata

extension URL {
    /// **OTCore:**
    /// Returns whether the file/folder exists.
    /// Convenience proxy for Foundation `FileManager` `fileExists` method.
    ///
    /// - Will return `false` if used on a symlink and the symlink's original file does not exist.
    /// - Will still return `true` if used on an alias and the alias' original file does not exist.
    @_disfavoredOverload
    public var fileExists: Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    /// **OTCore:**
    /// Returns whether the file URL path is a directory by querying the local file system.
    ///
    /// - Returns: `true` if the path exists and is a folder.
    ///   `false` if the path is not a folder or the path does not exist.
    @_disfavoredOverload
    public var isDirectory: Bool {
        guard let bool = try? resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
            .isDirectory
        else { return false }
        
        return bool
    }
    
    /// **OTCore:**
    /// Updates the URL with its canonical file system path on disk.
    ///
    /// If the file does not exist or the URL is not a file URL, the URL will remain unmodified.
    ///
    /// > Note:
    /// > This method is only available on macOS as the API required is not available on other
    /// > platforms.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    ///
    /// - Throws: Error if the URL is not a file URL, or there was a problem reading the file
    ///   system.
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @_disfavoredOverload
    public mutating func canonicalizeFileURL(partial: Bool = false) throws {
        self = try canonicalizingFileURL(partial: partial)
    }
    
    /// **OTCore:**
    /// Returns the URL by returning its canonical file system path on disk.
    ///
    /// If the file does not exist or the URL is not a file URL, the URL will be returned
    /// unmodified.
    ///
    /// > Note:
    /// > This method is only available on macOS as the API required is not available on other
    /// > platforms.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    ///
    /// - Throws: Error if the URL is not a file URL, or there was a problem reading the file
    ///   system.
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @_disfavoredOverload
    public func canonicalizingFileURL(partial: Bool = false) throws -> URL {
        // see https://stackoverflow.com/a/66968423/2805570 for in-depth explainer
        
        guard isFileURL else { throw CocoaError(.fileNoSuchFile) }
        
        if partial {
            // iterate through each path component, canonicalizing each time
            var newURL = URL(fileURLWithPath: "/").deletingLastPathComponent()
            for component in pathComponents {
                newURL.appendPathComponent(component)
                try? newURL.canonicalizeFileURL(partial: false)
            }
            return newURL
        } else {
            guard fileExists else {
                return self
            }
            
            guard let newPath = try resourceValues(forKeys: [.canonicalPathKey]).canonicalPath else {
                throw CocoaError(.fileReadUnknown)
            }
            let newURL = URL(fileURLWithPath: newPath)
            return newURL
        }
    }
    
    /// **OTCore:**
    /// Returns `true` if the URL points to the same file system node as another URL.
    /// This is more reliable than comparing simple equality of two `URL` instances, as this method
    /// will account for mismatched case and will resolve the URLs as needed in order to perform
    /// the comparison.
    ///
    /// > Note:
    /// > This method is only available on macOS as the API required is not available on other
    /// > platforms.
    ///
    /// - Throws: Error if one or both URLs are not file URLs, or there was a problem reading the
    ///   file system.
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @_disfavoredOverload
    public func isEqualFileNode(as otherFileURL: URL) throws -> Bool {
        // see https://stackoverflow.com/a/66968423/2805570 for in-depth explainer
        
        guard isFileURL, otherFileURL.isFileURL else { throw CocoaError(.fileNoSuchFile) }
        
        guard let lhs = try resourceValues(forKeys: [.fileResourceIdentifierKey])
            .fileResourceIdentifier,
            let rhs = try otherFileURL.resourceValues(forKeys: [.fileResourceIdentifierKey])
                .fileResourceIdentifier
        else { throw CocoaError(.fileReadUnknown) }
        
        return lhs.isEqual(rhs)
    }
}

// MARK: - File Operations

extension URL {
    /// **OTCore:**
    /// Attempts to first move a file to the Trash if possible, otherwise attempts to delete the
    /// file.
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
    
    /// **OTCore:**
    /// If the file URL is a file or folder that exists on disk, the file name (last path component
    /// prior to extension) is uniqued by appending the first number in `2...` that results in a file
    /// name that does not exist on disk.
    ///
    /// If the URL is not a file URL, the URL is returned unmodified.
    ///
    /// - Parameter suffix: Formatting of the suffix. The incrementing counter number is passed in
    ///   and must be used in the body of the closure. The closure must not return a static value.
    ///
    ///   For example, given a file named "MyFile.txt" that exists on disk:
    ///
    ///   - `" \($0)"` produces "MyFile 2.txt", "MyFile 3.txt", etc.
    ///   - `"-\($0)"` produces "MyFile-2.txt", "MyFile-3.txt", etc.
    ///   - `" (\($0))"` produces "MyFile (2).txt", "MyFile (3).txt", etc.
    @_disfavoredOverload
    public mutating func uniqueFileURL(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) {
        self = uniquedFileURL(suffix: suffix)
    }
    
    /// **OTCore:**
    /// If the file URL is a file or folder that exists on disk, the file name (last path component
    /// prior to extension) is uniqued by appending the first number in `2...` that results in a file
    /// name that does not exist on disk.
    ///
    /// If the URL is not a file URL, the URL is returned unmodified.
    ///
    /// - Parameter suffix: Formatting of the suffix. The incrementing counter number is passed in
    ///   and must be used in the body of the closure. The closure must not return a static value.
    ///
    ///   For example, given a file named "MyFile.txt" that exists on disk:
    ///
    ///   - `" \($0)"` produces "MyFile 2.txt", "MyFile 3.txt", etc.
    ///   - `"-\($0)"` produces "MyFile-2.txt", "MyFile-3.txt", etc.
    ///   - `" (\($0))"` produces "MyFile (2).txt", "MyFile (3).txt", etc.
    @_disfavoredOverload
    public func uniquedFileURL(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) -> URL {
        guard isFileURL else {
            assertionFailure("URL is not a file URL and cannot be uniqued. Returning URL unmodified.")
            return self
        }
        
        var suffix = suffix
        
        // sanity check - ensure the closure produces unique values to prevent an infinite loop
        if suffix(2) == suffix(3) {
            assertionFailure("Suffix closure does not produce unique return values. Reverting to default suffix format.")
            suffix = { " \($0)" }
        }
                
        let ext = pathExtension
        let baseName = deletingPathExtension().lastPathComponent
        let basePath = deletingLastPathComponent()
        
        var proposedURL = self
        var counter: Int = 2
        let maxCount = 1000
        
        func generateURL(addingSuffix: String) -> URL {
            var newURL = basePath
                .appendingPathComponent(baseName + addingSuffix)
            if !ext.isEmpty {
                newURL.appendPathExtension(ext)
            }
            return newURL
        }
        
        while proposedURL.fileExists,
              counter < maxCount // prevent infinite loop
        {
            let newURL = generateURL(addingSuffix: suffix(counter))
            assert(proposedURL != newURL) // catch malformed suffix
            proposedURL = newURL
            counter += 1
        }
        
        // failsafe - if we exhaust the counter, use a UUID suffix instead to guarantee a unique file
        if counter >= maxCount {
            proposedURL = generateURL(addingSuffix: "-\(UUID().uuidString)")
        }
        
        return proposedURL
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
    /// Creates an alias of the base URL file or folder `at` the supplied target location. Will
    /// overwrite existing target path if it exists.
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
    /// If the file URL is a Finder alias, its resolved URL is returned regardless whether it exists or not.
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
    /// Convenience method to test if a file URL is a symbolic link pointing to another file/folder,
    /// and not an actual file/folder itself.
    ///
    /// - Throws: Error if the URL is not a properly formatted file URL, or there was a problem
    ///   querying the URL's file system attributes.
    @_disfavoredOverload
    public var isSymLink: Bool {
        get throws {
            guard isFileURL
            else { throw CocoaError(.fileNoSuchFile) }
            
            let getAttr = try FileManager.default
                .attributesOfItem(atPath: path)
            
            guard let rawFileType = getAttr[.type] as? String
            else { throw CocoaError(.fileReadUnknown) }
            
            let fileType = FileAttributeType(rawValue: rawFileType)
            return fileType == .typeSymbolicLink // "NSFileTypeSymbolicLink"
        }
    }
    
    /// **OTCore:**
    /// Convenience method to test if a file URL is a symbolic link pointing to `file`.
    ///
    /// - Returns: `true` even if original file does not exist. This is possible because a symbolic link
    ///   is its own file system node that points to another, regardless if the original exists or not.
    /// - Throws: `nil` if the URL is not a properly formatted file URL or there was a problem querying
    ///   the file system.
    @_disfavoredOverload
    public func isSymLink(of file: URL) throws -> Bool {
        try isSymLink(of: file.path)
    }
    
    /// **OTCore:**
    /// Convenience method to test if a file URL is a symbolic link pointing to `file`.
    ///
    /// - Returns: `true` even if original file does not exist. This is possible because a symbolic link
    ///   is its own file system node that points to another, regardless if the original exists or not.
    /// - Throws: `nil` if the URL is not a properly formatted file URL or there was a problem querying
    ///   the file system.
    @_disfavoredOverload
    public func isSymLink(of file: String) throws -> Bool {
        guard isFileURL
        else { throw CocoaError(.fileNoSuchFile) }
        
        do {
            // returns path of original file, even if original file no longer exists
            let dest = try FileManager.default
                .destinationOfSymbolicLink(atPath: path)
            
            return file == dest
        } catch let error as CocoaError {
            switch error.code {
            case .fileReadUnknown:
                // one scenario where this error is thrown is when a file/folder exists, but it's not a symlink.
                // to suppress spurious errors, we'll catch it and just return false.
                return false
            default:
                throw error
            }
        } catch {
            throw error
        }
    }
    
    /// **OTCore:**
    /// Creates a symbolic link (symlink) of the base URL file or folder `at` the supplied target
    /// location.
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
    /// Backwards compatible method for retrieving the current user's home directory, using the most
    /// recent API where possible.
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
