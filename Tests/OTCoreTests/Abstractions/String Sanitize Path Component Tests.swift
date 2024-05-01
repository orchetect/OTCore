//
//  String Sanitize Path Component Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

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
        
        XCTAssertEqual("".sanitizingPathComponent(for: fs, replacement: "-"), "")
        XCTAssertEqual("Test/File.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test-File.txt")
        XCTAssertEqual("Test//File.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test--File.txt")
        XCTAssertEqual("TestFile\0.txt".sanitizingPathComponent(for: fs, replacement: "-"), "TestFile-.txt")
        XCTAssertEqual("Test/File\0.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test-File-.txt")
        XCTAssertEqual("Test:File.txt".sanitizingPathComponent(for: fs, replacement: "-"), "Test-File.txt")
    }
}

#endif
