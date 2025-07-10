//
//  String Sanitize Path Component Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OTCore

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
class Abstractions_StringSanitizePathComponent_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSanitizingFilename_all() {
        check(fileSystem: nil)
    }
    
    func testSanitizingFilename_hfsPlus() {
        check(fileSystem: .hfsPlus)
    }
    
    func testSanitizingFilename_apfs() {
        check(fileSystem: .apfs)
    }
    
    private func check(fileSystem: FileSystemFormat?) {
        let fs: [FileSystemFormat]? = fileSystem != nil ? [fileSystem!] : nil
        
        // path component string
        XCTAssertEqual("".sanitizingPathComponent(for: fs, replacement: "-"), "")
        XCTAssertEqual("Test/File.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test-File.txt")
        XCTAssertEqual("Test//File.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test--File.txt")
        XCTAssertEqual("TestFile\0.txt".sanitizingPathComponent(for: fs, replacement: "-"), "TestFile-.txt")
        XCTAssertEqual("Test/File\0.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test-File-.txt")
        XCTAssertEqual("Test:File.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test-File.txt")
        
        // url last path component
        XCTAssertEqual(
            URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("")
                .sanitizingLastPathComponent(for: fs, replacement: "-")
                .path,
            "/Folder"
        )
        XCTAssertEqual(
            URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("Test/File.txt") // URL interprets `/` as a path delimiter
                .sanitizingLastPathComponent(for: fs, replacement: "-")
                .path,
            "/Folder/Test/File.txt"
        )
        
        do {
            let url = URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("Test//File.txt") // URL interprets `//` as a single path delimiter
            XCTAssertEqual(url.pathComponents, ["/", "Folder", "Test", "File.txt"])
            XCTAssertEqual(url.lastPathComponent, "File.txt")
            let sanitizedURL = url.sanitizingLastPathComponent(for: fs, replacement: "-")
            XCTAssertEqual(sanitizedURL.pathComponents, ["/", "Folder", "Test", "File.txt"])
            XCTAssertEqual(sanitizedURL.lastPathComponent, "File.txt")
            if URL.preservesSequentialSeparators {
                XCTAssertEqual(sanitizedURL.path, "/Folder/Test//File.txt")
            } else {
                XCTAssertEqual(sanitizedURL.path, "/Folder/Test/File.txt")
            }
        }
        
        do {
            let url = URL(fileURLWithPath: "/Folder/Test//File.txt") // URL interprets `//` as a single path delimiter
            XCTAssertEqual(url.pathComponents, ["/", "Folder", "Test", "File.txt"])
            XCTAssertEqual(url.lastPathComponent, "File.txt")
            let sanitizedURL = url.sanitizingLastPathComponent(for: fs, replacement: "-")
            XCTAssertEqual(sanitizedURL.pathComponents, ["/", "Folder", "Test", "File.txt"])
            XCTAssertEqual(sanitizedURL.lastPathComponent, "File.txt")
            if URL.preservesSequentialSeparators {
                XCTAssertEqual(sanitizedURL.path, "/Folder/Test//File.txt")
            } else {
                XCTAssertEqual(sanitizedURL.path, "/Folder/Test/File.txt")
            }
        }
        
        // Note: appending a null character to URL will cause a crash
        // XCTAssertEqual(
        //     URL(fileURLWithPath: "/Folder")
        //         .appendingPathComponent("TestFile\0.txt")
        //         .sanitizingLastPathComponent(for: fs, replacement: "-")
        //         .path,
        //     "/Folder/TestFile-.txt"
        // )
        // XCTAssertEqual(
        //     URL(fileURLWithPath: "/Folder")
        //         .appendingPathComponent("Test/File\0.txt")
        //         .sanitizingLastPathComponent(for: fs, replacement: "-")
        //         .path,
        //     "/Folder/Test-File-.txt"
        // )
        
        XCTAssertEqual(
            URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("Test:File.txt")
                .sanitizingLastPathComponent(for: fs, replacement: "-")
                .path,
            "/Folder/Test-File.txt"
        )
    }
}

extension URL {
    // URL has slightly different sequential path separator behavior depending on platform and version
    fileprivate static let preservesSequentialSeparators: Bool = {
        #if os(macOS)
        true
        #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 26, tvOS 26, watchOS 26, visionOS 26, *) {
            false
        } else {
            true
        }
        #endif
    }()
}
