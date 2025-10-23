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
    /// - Throws: Error if the URL is not a file URL.
    public func asFilePath() throws -> FilePath {
        guard isFileURL else { throw CocoaError(.fileNoSuchFile) }
        
        if let path = FilePath(self) { return path }
        
        // alternative method:
        // FilePath throws an exception if we supply it with components that include the root
        let components = pathComponents.drop { $0 == "/" }
        return FilePath(root: "/", components.map(FilePath.Component.init))
    }
    
    /// **OTCore:**
    /// Internal. Returns the file URL as a new `FilePath` instance.
    /// Implements a workaround to prevent throwing or returning an Optional in scenarios where you
    /// can guarantee the URL is a file URL.
    internal func asGuaranteedFilePath() -> FilePath {
        assert(isFileURL)
        
        if let path = FilePath(self) { return path }
        
        // alternative method:
        // FilePath throws an exception if we supply it with components that include the root
        let components = pathComponents.drop { $0 == "/" }
        return FilePath(root: "/", components.map(FilePath.Component.init))
    }
}

// MARK: - Path Manipulation

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath {
    /// **OTCore:**
    /// Return a new path by mutating the file name (last path component).
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public func mutatingLastPathComponent(
        _ transform: (_ component: FilePath.Component) -> String
    ) -> Self {
        guard let oldFileName = lastComponent else { return self }
        let newFileName = transform(oldFileName)
        
        return removingLastComponent()
            .appending(newFileName)
    }
    
    /// **OTCore:**
    /// Return a new path by mutating the file name (last path component) excluding extension.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public func mutatingLastPathComponentExcludingExtension(
        _ transform: (_ fileName: String) -> String
    ) -> Self {
        guard let oldFileName = lastComponent else { return self }
        var newFileName = transform(oldFileName.stem)
        if let ext = oldFileName.extension {
            newFileName += "." + ext
        }
        
        return removingLastComponent()
            .appending(newFileName)
    }
    
    /// **OTCore:**
    /// Return a new path by appending a string to the file name (last path component) before the
    /// extension.
    ///
    /// ie:
    ///
    /// ```
    /// let path = FilePath("/Users/user/file.txt")
    /// let path2 = path.appendingToLastPathComponentBeforeExtension("-2")
    /// path2.string // "/Users/user/file-2.txt"
    /// ```
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public func appendingToLastPathComponentBeforeExtension(
        _ string: String
    ) -> Self {
        guard let oldFileName = lastComponent else { return self }
        var newFileName = "\(oldFileName.stem)\(string)"
        if let ext = oldFileName.extension {
            newFileName += "." + ext
        }
        
        return removingLastComponent()
            .appending(newFileName)
    }
}

// MARK: - File / Folder Metadata

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath {
    /// **OTCore:**
    /// Returns whether the file/folder exists.
    /// Convenience proxy for Foundation `FileManager` `fileExists` method.
    ///
    /// - Will return `false` if used on a symlink and the symlink's original file does not exist.
    /// - Will still return `true` if used on an alias and the alias' original file does not exist.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public var fileExists: Bool {
        FileManager.default.fileExists(atPath: string)
    }
    
    /// **OTCore:**
    /// Returns whether the file path is a directory by querying the local file system.
    ///
    /// - Returns: `true` if the path exists and is a folder.
    ///   `false` if the path is not a folder or the path does not exist.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        let isExists = FileManager.default.fileExists(atPath: string, isDirectory: &isDirectory)
        guard isExists else { return false }
        return isDirectory.boolValue
    }
    
    /// **OTCore:**
    /// Updates the path with its canonical file system path on disk.
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
    /// - Throws: Error if there was a problem reading the file system.
    @available(macOS 12.0, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public mutating func canonicalize(partial: Bool = false) throws {
        self = try canonicalized(partial: partial)
    }
    
    /// **OTCore:**
    /// Returns the path by returning its canonical file system path on disk.
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
    /// - Throws: Error if there was a problem reading the file system.
    @available(macOS 12.0, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public func canonicalized(partial: Bool = false) throws -> FilePath {
        let url = try asURL().canonicalizingFileURL(partial: partial)
        return FilePath(url.path)
    }
    
    /// **OTCore:**
    /// Updates the path with its canonical file system path on disk.
    ///
    /// If the path does not exist, the path will remain unmodified.
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
    /// - Throws: Error if there was a problem reading the file system.
    @available(macOS 12.0, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public mutating func canonicalizeIfPossible(partial: Bool = false) {
        self = canonicalizedIfPossible(partial: partial)
    }
    
    /// **OTCore:**
    /// Returns the path by returning its canonical file system path on disk.
    ///
    /// If the path does not exist, the path will be returned unmodified.
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
    /// - Throws: Error if there was a problem reading the file system.
    @available(macOS 12.0, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public func canonicalizedIfPossible(partial: Bool = false) -> FilePath {
        (try? canonicalized(partial: partial)) ?? self
    }
    
    /// **OTCore:**
    /// Returns `true` if the path points to the same file system node as another path.
    /// This is more reliable than comparing simple equality of two `FilePath` instances, as this method
    /// will account for mismatched case and will resolve the paths as needed in order to perform
    /// the comparison.
    ///
    /// > Note:
    /// > This method is only available on macOS as the API required is not available on other
    /// > platforms.
    ///
    /// - Throws: Error if there was a problem reading the file system.
    @available(macOS 12.0, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @_disfavoredOverload
    public func isEqualFileNode(as otherFilePath: FilePath) throws -> Bool {
        try asURL().isEqualFileNode(as: otherFilePath.asURL())
    }
}

// MARK: - File Operations

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath {
    /// **OTCore:**
    /// Attempts to first move a file to the Trash if possible, otherwise attempts to delete the
    /// file.
    ///
    /// If the file was moved to the trash, the new resulting path is returned.
    ///
    /// If the file was deleted, `nil` is returned.
    ///
    /// If both operations were unsuccessful, an error is thrown.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @discardableResult @_disfavoredOverload
    public func trashOrDelete() throws -> FilePath? {
        let url = try asURL().trashOrDelete()
        return try url?.asFilePath()
    }
    
    /// **OTCore:**
    /// If the file path is a file or folder that exists on disk, the file name (last path component
    /// prior to extension) is uniqued by appending the first number in `2...` that results in a file
    /// name that does not exist on disk.
    ///
    /// - Parameter suffix: Formatting of the suffix. The incrementing counter number is passed in
    ///   and must be used in the body of the closure. The closure must not return a static value.
    ///
    ///   For example, given a file named "MyFile.txt" that exists on disk:
    ///
    ///   - `" \($0)"` produces "MyFile 2.txt", "MyFile 3.txt", etc.
    ///   - `"-\($0)"` produces "MyFile-2.txt", "MyFile-3.txt", etc.
    ///   - `" (\($0))"` produces "MyFile (2).txt", "MyFile (3).txt", etc.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public mutating func unique(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) {
        self = uniqued(suffix: suffix)
    }
    
    /// **OTCore:**
    /// If the file path is a file or folder that exists on disk, the file name (last path component
    /// prior to extension) is uniqued by appending the first number in `2...` that results in a file
    /// name that does not exist on disk.
    ///
    /// - Parameter suffix: Formatting of the suffix. The incrementing counter number is passed in
    ///   and must be used in the body of the closure. The closure must not return a static value.
    ///
    ///   For example, given a file named "MyFile.txt" that exists on disk:
    ///
    ///   - `" \($0)"` produces "MyFile 2.txt", "MyFile 3.txt", etc.
    ///   - `"-\($0)"` produces "MyFile-2.txt", "MyFile-3.txt", etc.
    ///   - `" (\($0))"` produces "MyFile (2).txt", "MyFile (3).txt", etc.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public func uniqued(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) -> FilePath {
        var suffix = suffix
        
        // sanity check - ensure the closure produces unique values to prevent an infinite loop
        if suffix(2) == suffix(3) {
            assertionFailure("Suffix closure does not produce unique return values. Reverting to default suffix format.")
            suffix = { " \($0)" }
        }
        
        let ext = lastComponent?.extension
        let baseName = lastComponent?.stem ?? ""
        let basePath = removingLastComponent()
        
        var proposedPath = self
        var counter: Int = 2
        let maxCount = 1000
        
        func generatePath(addingSuffix: String) -> FilePath {
            var newFilename = baseName + addingSuffix
            if let ext { newFilename.append("." + ext) }
            let newPath = basePath.appending(newFilename)
            return newPath
        }
        
        while proposedPath.fileExists,
              counter < maxCount // prevent infinite loop
        {
            let newPath = generatePath(addingSuffix: suffix(counter))
            assert(proposedPath != newPath) // catch malformed suffix
            proposedPath = newPath
            counter += 1
        }
        
        // failsafe - if we exhaust the counter, use a UUID suffix instead to guarantee a unique file
        if counter >= maxCount {
            proposedPath = generatePath(addingSuffix: "-\(UUID().uuidString)")
        }
        
        return proposedPath
    }
}

// MARK: - Finder Aliases

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath {
    /// **OTCore:**
    /// Convenience method to test if a file path is a Finder alias.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @_disfavoredOverload
    public var isFinderAlias: Bool {
        asURL().isFinderAlias
    }
    
    /// **OTCore:**
    /// Creates an alias of the base file or folder `at` the supplied target location. Will
    /// overwrite existing target path if it exists.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @_disfavoredOverload
    public func createFinderAlias(at path: FilePath) throws {
        try asURL().createFinderAlias(at: path.asURL())
    }
    
    /// **OTCore:**
    /// If the path is a Finder alias, its resolved path is returned regardless whether it exists or not.
    ///
    /// `nil` will be returned if any of the following is true for `self`:
    /// - is not a Finder alias or does not exist, or
    /// - is a symbolic link or a hard link and not a Finder alias, or
    /// - does not exist.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @_disfavoredOverload
    public var resolvedFinderAlias: URL? {
        asURL().resolvedFinderAlias
    }
}

// MARK: - SymLinks

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath {
    /// **OTCore:**
    /// Convenience method to test if a path is a symbolic link pointing to another file/folder,
    /// and not an actual file/folder itself.
    ///
    /// - Throws: Error if there was a problem querying the path's file system attributes.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public var isSymLink: Bool {
        get throws {
            let getAttr = try FileManager.default
                .attributesOfItem(atPath: string)
            
            guard let rawFileType = getAttr[.type] as? String
            else { throw CocoaError(.fileReadUnknown) }
            
            let fileType = FileAttributeType(rawValue: rawFileType)
            return fileType == .typeSymbolicLink // "NSFileTypeSymbolicLink"
        }
    }
    
    /// **OTCore:**
    /// Convenience method to test if a file path is a symbolic link pointing to `file`.
    ///
    /// - Returns: `true` even if original file does not exist. This is possible because a symbolic link
    ///   is its own file system node that points to another, regardless if the original exists or not.
    /// - Throws: `nil` if the path is not a properly formatted or there was a problem querying the file system.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public func isSymLink(of path: FilePath) throws -> Bool {
        try asURL().isSymLink(of: path.asURL())
    }
    
    /// **OTCore:**
    /// Creates a symbolic link (symlink) of the base path file or folder `at` the supplied target
    /// location.
    ///
    /// - Returns `true` if new symlink gets created.
    /// - Returns `false` if destination already exists or if the symlink already exists.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @_disfavoredOverload
    public func createSymLink(at path: FilePath) throws {
        try FileManager.default
            .createSymbolicLink(at: path.asURL(), withDestinationURL: asURL())
    }
}

// MARK: - Static

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath {
    // Some fun bedtime reading about the wonkiness of the underlying API:
    // https://wadetregaskis.com/bad-api-example-filemanagers-urlforinappropriateforcreate/
    
    /// **OTCore:**
    /// The working directory of the current process.
    /// Calling this property will issue a `getcwd` syscall.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static func currentDirectory() -> FilePath { URL.currentDirectory().asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// The home directory for the current user (~/).
    /// Complexity: O(1)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var homeDirectory: FilePath { URL.homeDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Returns the home directory for the specified user.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static func homeDirectory(forUser user: String) -> FilePath? {
        URL.homeDirectory(forUser: user)?.asGuaranteedFilePath()
    }
    
    /// **OTCore:**
    /// The temporary directory for the current user.
    /// Complexity: O(1)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var temporaryDirectory: FilePath { URL.temporaryDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Discardable cache files directory for the
    /// current user. (~/Library/Caches).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var cachesDirectory: FilePath { URL.cachesDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Supported applications (/Applications).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var applicationDirectory: FilePath { URL.applicationDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Various user-visible documentation, support, and configuration
    /// files for the current user (~/Library).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var libraryDirectory: FilePath { URL.libraryDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// User home directories (/Users).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var userDirectory: FilePath { URL.userDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Documents directory for the current user (~/Documents)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var documentsDirectory: FilePath { URL.documentsDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Desktop directory for the current user (~/Desktop)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var desktopDirectory: FilePath { URL.desktopDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Application support files for the current
    /// user (~/Library/Application Support)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var applicationSupportDirectory: FilePath { URL.applicationSupportDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Downloads directory for the current user (~/Downloads)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var downloadsDirectory: FilePath { URL.downloadsDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Movies directory for the current user (~/Movies)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var moviesDirectory: FilePath { URL.moviesDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Music directory for the current user (~/Music)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var musicDirectory: FilePath { URL.musicDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Pictures directory for the current user (~/Pictures)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var picturesDirectory: FilePath { URL.picturesDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// The user’s Public sharing directory (~/Public)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var sharedPublicDirectory: FilePath { URL.sharedPublicDirectory.asGuaranteedFilePath() }
    
    /// **OTCore:**
    /// Trash directory for the current user (~/.Trash)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var trashDirectory: FilePath { URL.trashDirectory.asGuaranteedFilePath() }
}

#endif
