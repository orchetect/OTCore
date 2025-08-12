//
//  String Title Case Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import XCTest

class Abstractions_StringTitleCase_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testTitleCased() {
        XCTAssertEqual(
            "this".titleCased,
            "This"
        )
        
        XCTAssertEqual(
            "this thing".titleCased,
            "This Thing"
        )
        
        XCTAssertEqual(
            "this is a test".titleCased,
            "This is a Test"
        )
    }
}
