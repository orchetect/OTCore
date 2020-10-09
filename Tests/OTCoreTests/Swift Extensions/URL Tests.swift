//
//  URL Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-16.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import OTCore

class Extensions_URL_URL_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testFileExists() {
		
		// guaranteed to exist
		let folder = URL(fileURLWithPath: NSHomeDirectory())
		
		XCTAssertTrue(folder.fileExists)
		
	}
	
	func testIsAlias() {
		
		// boilerplate
		
		let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
		
		// determine temporary URLs
		
		let randomFolderName = "temp-\(UUID().uuidString)"
		
		let url1 = temporaryDirectoryURL
			.appendingPathComponent(randomFolderName)
		
		// ensure path does not exist
		guard !url1.fileExists else {
			XCTFail("\(url1) exists unexpectedly. Can't continue test.")
			return
		}
		
		print("Source URL:     ", url1)
		
		let url2 = temporaryDirectoryURL
			.appendingPathComponent(randomFolderName + " alias")
		
		// ensure path does not exist
		guard !url2.fileExists else {
			XCTFail("\(url2) exists unexpectedly. Can't continue test.")
			return
		}
		
		print("Destination URL:", url2)
		
		// ensure paths aren't equal
		guard url1 != url2 else {
			XCTFail("Random URLs generated are equal. Can't continue test.")
			return
		}
		
		// neither exist, so this will fail
		
		XCTAssertFalse(url1.isFinderAlias)
		XCTAssertFalse(url2.isFinderAlias)
		
		// create source folder
		
		print("Creating source directory...")
		
		guard (try? FileManager.default.createDirectory(at: url1, withIntermediateDirectories: false, attributes: nil)) != nil else {
			XCTFail("Failed to create source folder \"\(url1)\". Can't continue test.")
			return
		}
		
		// create temporary alias
		
		print("Forming alias...")
		
		guard (try? url1.createFinderAlias(at: url2)) != nil else {
			XCTFail("Failed to create temporary alias \"\(url2)\" on disk from source \"\(url1)\". Can't continue with test.")
			return
		}
		
		// test
		
		XCTAssertFalse(url1.isFinderAlias)
		XCTAssertTrue(url2.isFinderAlias)
		
		// clean up
		
		// .trashItem not available on all platforms
		
		print("Cleaning up source directory...")
		XCTAssertTrue(trashOrDelete(url: url1))
		
		print("Cleaning up destination alias...")
		XCTAssertTrue(trashOrDelete(url: url2))
		
	}
	
	func testSymlink() {
		
		// boilerplate
		
		let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
		
		// determine temporary URLs
		
		let randomFolderName = "temp-\(UUID().uuidString)"
		
		let url1 = temporaryDirectoryURL
			.appendingPathComponent(randomFolderName)
		
		// ensure path does not exist
		guard !url1.fileExists else {
			XCTFail("\(url1) exists unexpectedly. Can't continue test.")
			return
		}
		
		print("Source URL:     ", url1)
		
		let url2 = temporaryDirectoryURL
			.appendingPathComponent(randomFolderName + "-alias")
		
		// ensure path does not exist
		guard !url2.fileExists else {
			XCTFail("\(url2) exists unexpectedly. Can't continue test.")
			return
		}
		
		// ensure paths aren't equal
		guard url1 != url2 else {
			XCTFail("Random URLs generated are equal. Can't continue test.")
			return
		}
		
		print("Destination URL:", url2)
		
		// neither exist, so this will fail
		
		XCTAssertNil(url1.isSymLink)
		XCTAssertNil(url2.isSymLink)
		
		// create source folder
		
		print("Creating source directory...")
		
		guard (try? FileManager.default.createDirectory(at: url1, withIntermediateDirectories: false, attributes: nil)) != nil else {
			XCTFail("Failed to create source folder \"\(url1)\". Can't continue test.")
			return
		}
		
		// create temporary symlink
		
		print("Forming symlink...")
		
		if (try? url1.createSymLink(at: url2)) == nil {
			XCTFail("Failed to create symlink, or symlink already exists. Can't continue with test.")
			return
		}
		
		// test
		
		if let checkSymlink = url1.isSymLink {
			XCTAssertFalse(checkSymlink)
		} else { XCTFail("isSymLink should not be nil here") ; return }
		if let checkSymlink = url2.isSymLink {
			XCTAssertTrue(checkSymlink)
		} else { XCTFail("isSymLink should not be nil here") ; return }
		
		if let checkSymlink = url1.isSymLinkOf(file: url2) {
			XCTAssertFalse(checkSymlink)
		} else { XCTFail("isSymLink should not be nil here") ; return }
		if let checkSymlink = url2.isSymLinkOf(file: url1) {
			XCTAssertTrue(checkSymlink)
		} else { XCTFail("isSymLink should not be nil here") ; return }
		
		// clean up
		
		print("Cleaning up source directory...")
		XCTAssertTrue(trashOrDelete(url: url1))
		
		print("Cleaning up destination symlink...")
		XCTAssertTrue(trashOrDelete(url: url2))
		
	}

	func testFolders() {
		
		#if os(macOS)
		
		// FileManager
		
		_ = FileManager.homeDirectoryForCurrentUserCompat
		_ = FileManager.temporaryDirectoryCompat
		
		#endif
		
	}
	
}


// MARK: - Helpers

/// Attemptes to move a file to the Trash if possible, otherwise attemptes to delete the file.
@discardableResult
fileprivate func trashOrDelete(url: URL) -> Bool {
	
	// funcs
	
	func __delFile(url: URL) -> Bool {
		(try? FileManager.default.removeItem(at: url)) != nil
	}
		
	// logic
	
	#if os(tvOS)
	
	return __delFile(url: url)
	
	#else
	
	if #available(macOS 10.8, iOS 11.0, *) {
		
		func __trashFile(url: URL) -> Bool {
			if (try? FileManager.default.trashItem(at: url, resultingItemURL: nil)) == nil {
				#if os(macOS) // .trashItem has permissions issues on iOS; ignore
				return false
				#endif
			}
			return true
		}
		
		// move file to trash
		
		return __trashFile(url: url)
		
	} else {
		
		// delete file
		
		return __delFile(url: url)
		
	}
	
	#endif
	
}
