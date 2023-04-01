//
//  Integers and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_IntegersAndFoundation_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testStringPaddedTo() {
        // basic validation checks
        
        XCTAssertEqual(1.string(paddedTo:  1), "1")
        XCTAssertEqual(1.string(paddedTo:  2), "01")
        
        XCTAssertEqual(123.string(paddedTo:  1), "123")
        
        XCTAssertEqual(1.string(paddedTo: -1), "1")
        
        // BinaryInteger cases
        
        XCTAssertEqual(1.string(paddedTo: 1), "1")
        XCTAssertEqual(UInt(1).string(paddedTo: 1), "1")
        XCTAssertEqual(Int8(1).string(paddedTo: 1), "1")
        XCTAssertEqual(UInt8(1).string(paddedTo: 1), "1")
        XCTAssertEqual(Int16(1).string(paddedTo: 1), "1")
        XCTAssertEqual(UInt16(1).string(paddedTo: 1), "1")
        XCTAssertEqual(Int32(1).string(paddedTo: 1), "1")
        XCTAssertEqual(UInt32(1).string(paddedTo: 1), "1")
        XCTAssertEqual(Int64(1).string(paddedTo: 1), "1")
        XCTAssertEqual(UInt64(1).string(paddedTo: 1), "1")
    }
}

#endif
