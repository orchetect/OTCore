//
//  Bool Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-12.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import OTCore

class Extensions_Bool_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testBool() {
		
		// Bool
		
		XCTAssertEqual(true.intValue	, 1)
		XCTAssertEqual(true.int8Value	, 1)
		XCTAssertEqual(true.int16Value	, 1)
		XCTAssertEqual(true.int32Value	, 1)
		XCTAssertEqual(true.int64Value	, 1)
		XCTAssertEqual(true.uintValue	, 1)
		XCTAssertEqual(true.uint8Value	, 1)
		XCTAssertEqual(true.uint16Value	, 1)
		XCTAssertEqual(true.uint32Value	, 1)
		XCTAssertEqual(true.uint64Value	, 1)
		
		XCTAssertEqual(false.intValue	, 0)
		XCTAssertEqual(false.int8Value	, 0)
		XCTAssertEqual(false.int16Value	, 0)
		XCTAssertEqual(false.int32Value	, 0)
		XCTAssertEqual(false.int64Value	, 0)
		XCTAssertEqual(false.uintValue	, 0)
		XCTAssertEqual(false.uint8Value	, 0)
		XCTAssertEqual(false.uint16Value, 0)
		XCTAssertEqual(false.uint32Value, 0)
		XCTAssertEqual(false.uint64Value, 0)
		
		XCTAssertEqual(Bool(-1)					, false)
		XCTAssertEqual(Bool(integerLiteral: 0)	, false)	// same as b: Bool = 0
		XCTAssertEqual(Bool(0)					, false)
		XCTAssertEqual(Bool(integerLiteral: 1)	, true)		// same as b: Bool = 1
		XCTAssertEqual(Bool(1)					, true)
		XCTAssertEqual(Bool(integerLiteral: 123), true)		// same as b: Bool = 123
		XCTAssertEqual(Bool(123)				, true)
		
		//   ExpressibleByIntegerLiteral - these should all be possible
		
		var b: Bool = false
		b = -1
		b = 0
		b = 1
		b = 123
		b = Bool(1)
		b = Bool(UInt8(1))
		b = 0.boolValue
		b = UInt8(1).boolValue
		_ = b // silences 'variable was written to, but never read' warning
		
		XCTAssertEqual((-1).boolValue	, false)
		XCTAssertEqual(0.boolValue		, false)
		XCTAssertEqual(1.boolValue		, true)
		XCTAssertEqual(123.boolValue	, true)
	}
	
}
