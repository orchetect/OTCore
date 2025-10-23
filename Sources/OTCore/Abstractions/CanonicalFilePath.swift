//
//  CanonicalFilePath.swift
//  Dipper © 2023-2025 Existential Audio
//

#if canImport(Foundation) && canImport(System)

import Foundation
import System

/// **OTCore:**
/// Wraps a `FilePath` instance by performing file path canonicalization on it.
///
/// This type makes it clear that the file path has been canonicalized, which makes comparing two instances more reliable.
///
/// Because of that, methods to mutate the path are not available. If you want to mutate the path, extract the ``wrapped``
/// `FilePath` instance and mutate it as needed. To re-canonicalize the path, you can then construct a new
/// `CanonicalFilePath` instance from it once more.
///
/// > Note:
/// > This type is only available on macOS as the API required is not available on other platforms.
@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct CanonicalFilePath {
    /// If path canonicalization was successful at the time of initialization, this property will return `true`.
    public let isCanonical: Bool
    
    /// The underlying `FilePath` instance.
    public let wrapped: FilePath
    
    /// Internal initializer that should only be called when you can guarantee the file path is already canonical.
    init(verbatim: FilePath, isCanonical: Bool) {
        self.wrapped = verbatim
        self.isCanonical = isCanonical
    }
}

// MARK: - Inits

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath {
    // MARK: Path String
    
    /// Creates a file path from a string and performs path canonicalization.
    ///
    /// - Parameters:
    ///   - string: Path string.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public init(canonicalizing string: String, partial: Bool = false) throws {
        let filePath = FilePath(string)
        try self.init(canonicalizing: filePath, partial: partial)
    }
    
    /// Creates a file path from a string and performs path canonicalization.
    /// If canonicalization fails, the path will be used as-is and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - string: Path string.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public init(canonicalizingIfPossible string: String, partial: Bool = false) {
        let filePath = FilePath(string)
        self.init(canonicalizingIfPossible: filePath, partial: partial)
    }
    
    // MARK: URL
    
    /// Creates a file path from a URL and performs path canonicalization.
    ///
    /// - Parameters:
    ///   - fileURL: File URL.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizing fileURL: URL, partial: Bool = false) throws {
        guard fileURL.isFileURL else { throw CocoaError(.fileNoSuchFile) }
        guard let filePath = FilePath(fileURL) else { throw CocoaError(.fileNoSuchFile) }
        try self.init(canonicalizing: filePath, partial: partial)
    }
    
    /// Creates a file path from a URL and performs path canonicalization.
    /// If canonicalization fails, the path will be used as-is and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - fileURL: File URL.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizingIfPossible fileURL: URL, partial: Bool = false) {
        self.init(canonicalizingIfPossible: fileURL.path, partial: partial)
    }
    
    // MARK: FilePath
    
    /// Performs file path canonicalization.
    ///
    /// - Parameters:
    ///   - filePath: `FilePath` instance.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizing filePath: FilePath, partial: Bool = false) throws {
        self.wrapped = try filePath.canonicalized(partial: partial)
        isCanonical = true
    }
    
    /// Performs file path canonicalization.
    /// If canonicalization fails, the path will be used as-is and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - filePath: `FilePath` instance.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizingIfPossible filePath: FilePath, partial: Bool = false) {
        if let canonical = try? filePath.canonicalized(partial: partial) {
            wrapped = canonical
            isCanonical = true
        } else {
            wrapped = filePath
            isCanonical = false
        }
    }
}

// MARK: - Equatable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs.isEqual(to: rhs) {
        case .equal, .equalAfterRecanonicalization(partial: _): return true
        case .notEqual: return false
        }
    }
    
    public enum ComparisonResult: Equatable, Hashable, Sendable {
        /// Both instances evaluated as equal as-is.
        case equal
        
        /// Both instances did not evaluate as equal as-is, but evaluated as equal after re-canonicalizing one or both instances.
        ///
        /// - Parameters:
        ///   - partial: If `true`, partial recanonicalization was required to achieve an equal evaluation.
        case equalAfterRecanonicalization(partial: Bool)
        
        /// The instances are not equal, and remain not equal even after re-canonicalization.
        case notEqual
    }
    
    /// Returns a comparison result after evaluating both instances, re-canonicalizing if initial comparison evaluates as not equal.
    public func isEqual(to other: Self) -> ComparisonResult {
        // if both were successfully canonicalized, compare directly
        if self.isCanonical, other.isCanonical {
            return (wrapped == other.wrapped) ? .equal : .notEqual
        }
        
        // otherwise attempt to canonicalize (non-partial) any that were not successfully canonicalized
        let refreshedSelf = self.isCanonical ? self : CanonicalFilePath(canonicalizingIfPossible: self.wrapped, partial: false)
        let refreshedOther = other.isCanonical ? other : CanonicalFilePath(canonicalizingIfPossible: other.wrapped, partial: false)
        if refreshedSelf.wrapped == refreshedOther.wrapped {
            let isChanged = (self.isCanonical != refreshedSelf.isCanonical) || (other.isCanonical != refreshedOther.isCanonical)
            return isChanged ? .equalAfterRecanonicalization(partial: false) : .equal
        }
        
        // otherwise attempt to canonicalize (partial) any that were not successfully canonicalized
        let refreshedSelf2 = self.isCanonical ? self : CanonicalFilePath(canonicalizingIfPossible: self.wrapped, partial: true)
        let refreshedOther2 = other.isCanonical ? other : CanonicalFilePath(canonicalizingIfPossible: other.wrapped, partial: true)
        if refreshedSelf2.wrapped == refreshedOther2.wrapped {
            let isChanged = (self.isCanonical != refreshedSelf2.isCanonical) || (other.isCanonical != refreshedOther2.isCanonical)
            return isChanged ? .equalAfterRecanonicalization(partial: true) : .equal
        }
        
        return .notEqual
    }
}

// MARK: - Hashable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Hashable { }

// MARK: - Sendable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Sendable { }

// MARK: - Codable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Codable {
    public init(from decoder: any Decoder) throws {
        let decoded = try FilePath(from: decoder)
        
        // we're not encoding `isCanonical` flag, so safest course is to attempt to re-canonicalize it
        self.init(canonicalizingIfPossible: decoded)
    }
    
    public func encode(to encoder: any Encoder) throws {
        // act as a proxy, and don't encode `isCanonical` flag
        try wrapped.encode(to: encoder)
    }
}

// MARK: - CustomStringConvertible / CustomDebugStringConvertible

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: CustomStringConvertible {
    public var description: String {
        wrapped.description
    }
}

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: CustomDebugStringConvertible {
    public var debugDescription: String {
        wrapped.debugDescription
    }
}

// MARK: - FilePath Native Forwarded Methods & Properties

// Note that these methods are INTENTIONALLY READ-ONLY even though `FilePath` supports setters for some of them.
// See the `CanonicalFilePath` inline documentation for the reason for offering these forwarding methods as read-only.

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath {
    /// View the non-root components that make up this path.
    public var components: FilePath.ComponentView {
        wrapped.components
    }
    
    /// The extension of the file or directory last component.
    public var `extension`: String? {
        wrapped.extension
    }
    
    /// Returns `true` if this path uniquely identifies the location of a file without reference to
    /// an additional starting location.
    public var isAbsolute: Bool {
        wrapped.isAbsolute
    }
    
    /// Whether this path is empty.
    public var isEmpty: Bool {
        wrapped.isEmpty
    }
    
    /// Whether the path is in lexical-normal form, that is `.` and `..` components have been collapsed
    /// lexically (i.e. without following symlinks).
    public var isLexicallyNormal: Bool {
        wrapped.isLexicallyNormal
    }
    
    /// Returns `true` if this path is not absolute (see ``isAbsolute``).
    public var isRelative: Bool {
        wrapped.isRelative
    }
    
    /// Returns the final component of the path. Returns `nil` if the path is empty or only contains a root.
    public var lastComponent: FilePath.Component? {
        wrapped.lastComponent
    }
    
    /// Returns the root of a path if there is one, otherwise `nil`.
    public var root: FilePath.Root? {
        wrapped.root
    }
    
    /// The non-extension portion of the file or directory last component.
    public var stem: String? {
        wrapped.stem
    }
    
    /// Creates a string by interpreting the path’s content as UTF-8 on Unix and UTF-16 on Windows.
    public var string: String {
        wrapped.string
    }
    
    /// The length of the file path, excluding the null terminator.
    public var length: Int {
        wrapped.length
    }
    
    /// Returns whether other is a suffix of `self`, only considering whole path components.
    public func ends(with other: FilePath) -> Bool {
        wrapped.ends(with: other)
    }
    
    /// Returns whether other is a suffix of `self`, only considering whole path components.
    public func ends(with other: CanonicalFilePath) -> Bool {
        wrapped.ends(with: other.wrapped)
    }
    
    /// Returns whether other is a prefix of `self`, only considering whole path components.
    public func starts(with other: FilePath) -> Bool {
        wrapped.starts(with: other)
    }
    
    /// Returns whether other is a prefix of `self`, only considering whole path components.
    public func starts(with other: CanonicalFilePath) -> Bool {
        wrapped.starts(with: other.wrapped)
    }
}

// MARK: - FilePath OTCore-Defined Forwarded Methods & Properties

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath {
    // MARK: - FilePath & URL Interop
    
    /// Returns the file path as a new file `URL` instance.
    @available(macOS 12.0, *)
    @_disfavoredOverload
    public func asURL() -> URL {
        wrapped.asURL()
    }
    
    /// Returns the file path as a new file `URL` instance.
    @available(macOS 13.0, *)
    public func asURL(directoryHint: URL.DirectoryHint = .inferFromPath) -> URL {
        wrapped.asURL(directoryHint: directoryHint)
    }
    
    // MARK: - File / Folder Metadata
    
    /// Returns whether the file/folder exists.
    /// Convenience proxy for Foundation `FileManager` `fileExists` method.
    ///
    /// - Will return `false` if used on a symlink and the symlink's original file does not exist.
    /// - Will still return `true` if used on an alias and the alias' original file does not exist.
    @available(macOS 12.0, *)
    public var fileExists: Bool {
        wrapped.fileExists
    }
    
    /// Returns whether the file path is a directory by querying the local file system.
    ///
    /// - Returns: `true` if the path exists and is a folder.
    ///   `false` if the path is not a folder or the path does not exist.
    @available(macOS 12.0, *)
    public var isDirectory: Bool {
        wrapped.isDirectory
    }
    
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
    public func isEqualFileNode(as otherFilePath: FilePath) throws -> Bool {
        try wrapped.isEqualFileNode(as: otherFilePath)
    }
    
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
    public func isEqualFileNode(as otherFilePath: CanonicalFilePath) throws -> Bool {
        try wrapped.isEqualFileNode(as: otherFilePath.wrapped)
    }
    
    // MARK: - File Operations
    
    /// Attempts to first move a file to the Trash if possible, otherwise attempts to delete the
    /// file.
    ///
    /// If the file was moved to the trash, the new resulting path is returned.
    ///
    /// If the file was deleted, `nil` is returned.
    ///
    /// If both operations were unsuccessful, an error is thrown.
    @available(macOS 13.0, *)
    @discardableResult
    public func trashOrDelete() throws -> FilePath? {
        try wrapped.trashOrDelete()
    }
    
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
    @available(macOS 12.0, *)
    public mutating func unique(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) {
        self = uniqued(suffix: suffix)
    }
    
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
    @available(macOS 12.0, *)
    public func uniqued(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) -> CanonicalFilePath {
        let newPath = wrapped.uniqued(suffix: suffix)
        // since we are only changing the filename and not the path, we can skip re-canonicalizing the new path
        return CanonicalFilePath(verbatim: newPath, isCanonical: isCanonical)
    }
    
    // MARK: - Finder Aliases
    
    /// Convenience method to test if a file path is a Finder alias.
    @available(macOS 13.0, *)
    public var isFinderAlias: Bool {
        wrapped.isFinderAlias
    }
    
    /// Creates an alias of the base file or folder `at` the supplied target location. Will
    /// overwrite existing target path if it exists.
    @available(macOS 13.0, *)
    @_disfavoredOverload
    public func createFinderAlias(at path: FilePath) throws {
        try wrapped.createFinderAlias(at: path)
    }
    
    /// Creates an alias of the base file or folder `at` the supplied target location. Will
    /// overwrite existing target path if it exists.
    @available(macOS 13.0, *)
    public func createFinderAlias(at path: CanonicalFilePath) throws {
        try wrapped.createFinderAlias(at: path.wrapped)
    }
    
    /// If the path is a Finder alias, its resolved path is returned regardless whether it exists or not.
    ///
    /// `nil` will be returned if any of the following is true for `self`:
    /// - is not a Finder alias or does not exist, or
    /// - is a symbolic link or a hard link and not a Finder alias, or
    /// - does not exist.
    @available(macOS 13.0, *)
    public var resolvedFinderAlias: URL? {
        wrapped.resolvedFinderAlias
    }
    
    // MARK: - SymLinks
    
    /// Convenience method to test if a path is a symbolic link pointing to another file/folder,
    /// and not an actual file/folder itself.
    ///
    /// - Throws: Error if there was a problem querying the path's file system attributes.
    @available(macOS 12.0, *)
    public var isSymLink: Bool {
        get throws { try wrapped.isSymLink }
    }
    
    /// Convenience method to test if a file path is a symbolic link pointing to `file`.
    ///
    /// - Returns: `true` even if original file does not exist. This is possible because a symbolic link
    ///   is its own file system node that points to another, regardless if the original exists or not.
    /// - Throws: `nil` if the path is not a properly formatted or there was a problem querying the file system.
    @available(macOS 12.0, *)
    @_disfavoredOverload
    public func isSymLink(of path: FilePath) throws -> Bool {
        try wrapped.isSymLink(of: path)
    }
    
    /// Convenience method to test if a file path is a symbolic link pointing to `file`.
    ///
    /// - Returns: `true` even if original file does not exist. This is possible because a symbolic link
    ///   is its own file system node that points to another, regardless if the original exists or not.
    /// - Throws: `nil` if the path is not a properly formatted or there was a problem querying the file system.
    @available(macOS 12.0, *)
    public func isSymLink(of path: CanonicalFilePath) throws -> Bool {
        try wrapped.isSymLink(of: path.wrapped)
    }
    
    /// Creates a symbolic link (symlink) of the base path file or folder `at` the supplied target
    /// location.
    ///
    /// - Returns `true` if new symlink gets created.
    /// - Returns `false` if destination already exists or if the symlink already exists.
    @available(macOS 13.0, *)
    @_disfavoredOverload
    public func createSymLink(at path: FilePath) throws {
        try wrapped.createSymLink(at: path)
    }
    
    /// Creates a symbolic link (symlink) of the base path file or folder `at` the supplied target
    /// location.
    ///
    /// - Returns `true` if new symlink gets created.
    /// - Returns `false` if destination already exists or if the symlink already exists.
    @available(macOS 13.0, *)
    public func createSymLink(at path: CanonicalFilePath) throws {
        try wrapped.createSymLink(at: path.wrapped)
    }
    
    // MARK: - Static
    
    /// The working directory of the current process.
    /// Calling this property will issue a `getcwd` syscall.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static func currentDirectory() -> CanonicalFilePath { URL.currentDirectory().asGuaranteedCanonicalFilePath() }
    
    /// The home directory for the current user (~/).
    /// Complexity: O(1)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var homeDirectory: CanonicalFilePath { URL.homeDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Returns the home directory for the specified user.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static func homeDirectory(forUser user: String) -> CanonicalFilePath? {
        URL.homeDirectory(forUser: user)?.asGuaranteedCanonicalFilePath()
    }
    
    /// The temporary directory for the current user.
    /// Complexity: O(1)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var temporaryDirectory: CanonicalFilePath { URL.temporaryDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Discardable cache files directory for the
    /// current user. (~/Library/Caches).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var cachesDirectory: CanonicalFilePath { URL.cachesDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Supported applications (/Applications).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var applicationDirectory: CanonicalFilePath { URL.applicationDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Various user-visible documentation, support, and configuration
    /// files for the current user (~/Library).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var libraryDirectory: CanonicalFilePath { URL.libraryDirectory.asGuaranteedCanonicalFilePath() }
    
    /// User home directories (/Users).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var userDirectory: CanonicalFilePath { URL.userDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Documents directory for the current user (~/Documents)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var documentsDirectory: CanonicalFilePath { URL.documentsDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Desktop directory for the current user (~/Desktop)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var desktopDirectory: CanonicalFilePath { URL.desktopDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Application support files for the current
    /// user (~/Library/Application Support)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var applicationSupportDirectory: CanonicalFilePath { URL.applicationSupportDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Downloads directory for the current user (~/Downloads)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var downloadsDirectory: CanonicalFilePath { URL.downloadsDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Movies directory for the current user (~/Movies)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var moviesDirectory: CanonicalFilePath { URL.moviesDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Music directory for the current user (~/Music)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var musicDirectory: CanonicalFilePath { URL.musicDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Pictures directory for the current user (~/Pictures)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var picturesDirectory: CanonicalFilePath { URL.picturesDirectory.asGuaranteedCanonicalFilePath() }
    
    /// The user’s Public sharing directory (~/Public)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var sharedPublicDirectory: CanonicalFilePath { URL.sharedPublicDirectory.asGuaranteedCanonicalFilePath() }
    
    /// Trash directory for the current user (~/.Trash)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var trashDirectory: CanonicalFilePath { URL.trashDirectory.asGuaranteedCanonicalFilePath() }
}

// MARK: - FilePath Extension Methods

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension FilePath {
    /// **OTCore:**
    /// Returns the file path canonicalized as a new ``CanonicalFilePath`` instance.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public func asCanonicalFilePath(partial: Bool = false) throws -> CanonicalFilePath {
        try CanonicalFilePath(canonicalizing: self, partial: partial)
    }
    
    /// **OTCore:**
    /// Returns the file path canonicalized as a new ``CanonicalFilePath`` instance if possible.
    /// If canonicalization fails, the file path will be used as-is (unmodified) and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public func asCanonicalFilePathIfPossible(partial: Bool = false) -> CanonicalFilePath {
        CanonicalFilePath(canonicalizingIfPossible: self, partial: partial)
    }
}

// MARK: - URL Extension Methods

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension URL {
    /// **OTCore:**
    /// Returns the file URL as a new `CanonicalFilePath` instance.
    /// - Throws: Error if the URL is not a file URL.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public func asCanonicalFilePath(partial: Bool = false) throws -> CanonicalFilePath {
        // this init will validate URL as a file URL
        try CanonicalFilePath(canonicalizing: self, partial: partial)
    }
    
    /// **OTCore:**
    /// Returns the file URL canonicalized as a new ``CanonicalFilePath`` instance if possible.
    /// If canonicalization fails, the file path will be used as-is (unmodified) and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public func asCanonicalFilePathIfPossible(partial: Bool = false) -> CanonicalFilePath {
        CanonicalFilePath(canonicalizingIfPossible: self, partial: partial)
    }
    
    /// **OTCore:**
    /// Internal. Returns the file URL as a new `CanonicalFilePath` instance.
    /// Implements a workaround to prevent throwing or returning an Optional in scenarios where you
    /// can guarantee the URL is a file URL.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    internal func asGuaranteedCanonicalFilePath(partial: Bool = false) -> CanonicalFilePath {
        assert(isFileURL)
        
        return CanonicalFilePath(canonicalizingIfPossible: asGuaranteedFilePath(), partial: partial)
    }
}

#endif
