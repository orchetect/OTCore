//
//  String Wrapped Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Abstractions_StringWrapped_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testWrapped() {
        // .wrapped
        
        XCTAssertEqual("string".wrapped(with: "-"),             "-string-")
        
        XCTAssertEqual("string".wrapped(with: .parentheses),    "(string)")
        XCTAssertEqual("string".wrapped(with: .brackets),       "[string]")
        XCTAssertEqual("string".wrapped(with: .braces),         "{string}")
        XCTAssertEqual("string".wrapped(with: .angleBrackets),  "<string>")
        XCTAssertEqual("string".wrapped(with: .singleQuotes),   "'string'")
        XCTAssertEqual("string".wrapped(with: .quotes),         #""string""#)
    }
    
    func testCategoryMethods() {
        XCTAssertEqual("string".parenthesized, "(string)")
        
        XCTAssertEqual("string".singleQuoted, "'string'")
        
        XCTAssertEqual("string".quoted, #""string""#)
    }
}

#endif
