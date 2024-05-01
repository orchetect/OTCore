//
//  String Sanitize Path Component Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

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
            URL(fileURLWithPath: "/Folder").appending(component: "").sanitizingLastPathComponent(for: fs, replacement: "-").path,
            "/Folder"
        )
        XCTAssertEqual(
            URL(fileURLWithPath: "/Folder").appending(component: "Test/File.txt").sanitizingLastPathComponent(for: fs, replacement: "-").path,
            "/Folder/Test/File.txt" // URL interprets `/` as a path delimiter
        )
        XCTAssertEqual(
            URL(fileURLWithPath: "/Folder").appending(component: "Test//File.txt").sanitizingLastPathComponent(for: fs, replacement: "-").path,
            "/Folder/Test//File.txt" // URL interprets `/` as a path delimiter
        )
        
        // Note: appending a null character to URL will cause a crash
        // XCTAssertEqual(
        //     URL(fileURLWithPath: "/Folder").appending(component: "TestFile\0.txt").sanitizingLastPathComponent(for: fs, replacement: "-").path,
        //     "/Folder/TestFile-.txt"
        // )
        // XCTAssertEqual(
        //     URL(fileURLWithPath: "/Folder").appending(component: "Test/File\0.txt").sanitizingLastPathComponent(for: fs, replacement: "-").path,
        //     "/Folder/Test-File-.txt"
        // )
        
        XCTAssertEqual(
            URL(fileURLWithPath: "/Folder").appending(component: "Test:File.txt").sanitizingLastPathComponent(for: fs, replacement: "-").path,
            "/Folder/Test-File.txt"
        )
    }
}

#endif
