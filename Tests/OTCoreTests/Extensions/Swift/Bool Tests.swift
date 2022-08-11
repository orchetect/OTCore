//
//  Bool Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Extensions_Swift_Bool_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testToInt() {
        // Bool
        
        XCTAssertEqual(true.intValue, 1)
        XCTAssertEqual(true.int8Value, 1)
        XCTAssertEqual(true.int16Value, 1)
        XCTAssertEqual(true.int32Value, 1)
        XCTAssertEqual(true.int64Value, 1)
        XCTAssertEqual(true.uIntValue, 1)
        XCTAssertEqual(true.uInt8Value, 1)
        XCTAssertEqual(true.uInt16Value, 1)
        XCTAssertEqual(true.uInt32Value, 1)
        XCTAssertEqual(true.uInt64Value, 1)
        
        XCTAssertEqual(false.intValue, 0)
        XCTAssertEqual(false.int8Value, 0)
        XCTAssertEqual(false.int16Value, 0)
        XCTAssertEqual(false.int32Value, 0)
        XCTAssertEqual(false.int64Value, 0)
        XCTAssertEqual(false.uIntValue, 0)
        XCTAssertEqual(false.uInt8Value, 0)
        XCTAssertEqual(false.uInt16Value, 0)
        XCTAssertEqual(false.uInt32Value, 0)
        XCTAssertEqual(false.uInt64Value, 0)
    }
    
    func testToggled() {
        XCTAssertEqual(true.toggled(), false)
        XCTAssertEqual(false.toggled(), true)
    }
    
    func testExpressibleByIntegerLiteral() {
        XCTAssertEqual(Bool(-1), false)
        XCTAssertEqual(Bool(integerLiteral: 0), false)    // same as b: Bool = 0
        XCTAssertEqual(Bool(0), false)
        XCTAssertEqual(Bool(integerLiteral: 1), true)     // same as b: Bool = 1
        XCTAssertEqual(Bool(1), true)
        XCTAssertEqual(Bool(integerLiteral: 123), true)     // same as b: Bool = 123
        XCTAssertEqual(Bool(123), true)
        
        // ExpressibleByIntegerLiteral - these should all be possible
        
        var b = false
        b = -1
        b = 0
        b = 1
        b = 123
        b = Bool(1)
        b = Bool(UInt8(1))
        b = 0.boolValue
        b = UInt8(1).boolValue
        _ = b // silences 'variable was written to, but never read' warning
    }
    
    func testBinaryIntegerBoolValue() {
        XCTAssertEqual((-1).boolValue, false)
        XCTAssertEqual(0.boolValue, false)
        XCTAssertEqual(1.boolValue, true)
        XCTAssertEqual(123.boolValue, true)
    }
}

#endif
