//
//  URL.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-03.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation

#if os(macOS)
import Cocoa
#endif

// MARK: - File / folder

extension URL {
	
	/// OTCore:
	/// Convenience proxy for Foundation fileExists method. Returns whether the file/folder exists.
	///
	/// - Will return `false` if used on a symlink and the symlink's original file does not exist.
	/// - Will still return `true` if used on an alias and the alias' original file does not exist.
	public var fileExists: Bool {
		FileManager.default.fileExists(atPath: self.path)
	}
	
	/// OTCore:
	/// Convenience method to test if a file URL is a symbolic link and not an actual file/folder.
	///
	/// - Will return `nil` if the URL is not a properly formatted file URL, or there was a problem querying the URL's file system attributes.
	public var isFolder: Bool? {
		try? self.resourceValues(forKeys: Set([URLResourceKey.isDirectoryKey]))
			.isDirectory
	}
	
}


// MARK: - Images

#if os(macOS)

extension URL {
	
	/// OTCore:
	/// Returns the icon that represents the given file, folder, application, etc. Returns nil if URL is not a file URL or if file does not exist. Thread-safe.
	public var icon: NSImage? {
		guard isFileURL else { return nil }
		guard fileExists else { return nil }
		
		return NSWorkspace.shared.icon(forFile: self.path)
	}
	
}

#endif


// MARK: - Finder Aliases

extension URL {
	
	/// OTCore:
	/// Convenience method to test if a file URL is a Finder alias.
	public var isFinderAlias: Bool {
		
		guard self.isFileURL else { return false } // fail if it's not a file URL
		
		return (try? URL.bookmarkData(withContentsOf: self)) != nil
		
	}
	
	/// OTCore:
	/// Creates an alias of the base URL file or folder `at` the supplied target location. Will override existing path if it exists.
	public func createFinderAlias(at url: URL) throws {
		let data = try self.bookmarkData(
			options: .suitableForBookmarkFile,
			includingResourceValuesForKeys: nil,
			relativeTo: nil)
		
		try URL.writeBookmarkData(data, to: url)
	}
	
	/// OTCore:
	/// If self is a Finder alias, its resolved URL is returned whether it exists or not.
	/// Nil will be returned if self:
	///   A) is not a Finder alias or does not exist, or
	///   B) is a symbolic link or a hard link and not a Finder alias, or
	///   C) does not exist.
	public var resolvedFinderAlias: URL? {
		
		guard self.isFileURL else { return nil } // fail if it's not a file URL
		
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
	
	/// OTCore:
	/// Convenience method to test if a file URL is a symbolic link and not an actual file/folder.
	///
	/// - Will return `nil` if the URL is not a properly formatted file URL, or there was a problem querying the URL's file system attributes.
	public var isSymLink: Bool? {
		
		guard self.isFileURL
			else { return nil }
		
		guard let getAttr = try? FileManager.default
			.attributesOfItem(atPath: self.path)
			else { return nil }
		
		guard let getFileType = getAttr[.type]
			else { return nil }
		
		return getFileType as? String == "NSFileTypeSymbolicLink"
		
	}
	
	/// OTCore:
	/// Convenience method to test if a file URL is a symbolic link pointing to `file`.
	///
	/// - Will return `true` even if original file does not exist.
	/// - Will return `nil` if the URL is not a properly formatted file URL.
	public func isSymLinkOf(file: URL) -> Bool? {
		
		guard file.isFileURL
			else { return nil }
		
		return self.isSymLinkOf(file: file.path)
		
	}
	
	/// OTCore:
	/// Convenience method to test if a file URL is a symbolic link pointing to `file`.
	///
	/// - Will return `true` even if original file does not exist.
	/// - Will return `nil` if the URL is not a properly formatted file URL.
	public func isSymLinkOf(file: String) -> Bool? {
		
		guard self.isFileURL
			else { return nil }
		
		// returns path of original file, even if original file no longer exists
		guard let dest = try? FileManager.default
			.destinationOfSymbolicLink(atPath: self.path)
			else { return false }
		
		return file == dest
		
	}
	
	/// OTCore:
	/// Creates a symbolic link (symlink) of the base URL file or folder `at` the supplied target location. Will return `true` if new symlink gets created. Will return `false` if destination already exists or if the symlink already exists.
	public func createSymLink(at url: URL) throws {
		try FileManager.default
			.createSymbolicLink(at: url, withDestinationURL: self)
	}
	
}


// MARK: - Folders

extension FileManager {
	
	#if os(macOS)
	
	/// OTCore:
	/// Backwards compatible method for retrieving the current user's home directory, using the most recent API where possible.
	public static var homeDirectoryForCurrentUserCompat: URL {
		
		if #available(OSX 10.12, *) {
			return FileManager.default.homeDirectoryForCurrentUser
		} else {
			return URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
		}
		
	}
	
	#endif
	
	/// OTCore:
	/// Backwards compatible method for retrieving a temporary folder from the system.
	public static var temporaryDirectoryCompat: URL {
		
		if #available(OSX 10.12, iOS 10.0, *) {
			return FileManager.default.temporaryDirectory
		} else {
			return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
		}
		
	}
	
}


