//
//  Decimal Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_Decimal_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testTypeConversions_IntsToInts() {
		
		_ = 1.decimal
		_ = UInt(1).decimal
		
		_ = Int8(1).decimal
		_ = UInt8(1).decimal
		
		_ = Int16(1).decimal
		_ = UInt16(1).decimal
		
		_ = Int32(1).decimal
		_ = UInt32(1).decimal
		
		_ = Int64(1).decimal
		_ = UInt64(1).decimal
		
	}
	
	func testBoolValue() {
		
		_ = Decimal(1).boolValue
		
	}
	
	func testPower() {
		
		XCTAssertEqual(Decimal(2.0).power(3) , 8.0)
		
	}
	
	func testString() {
		
		XCTAssertEqual(Decimal(1).string, "1")
		
	}
	
	func testFromString() {
		
		// String
		
		let str = "1.0"
		
		XCTAssertEqual(str.decimal, 1.0)
		XCTAssertEqual(str.decimal(locale: .init(identifier: "en_US")), 1.0)
		
		// Substring
		
		let subStr = str.prefix(3)
		
		XCTAssertEqual(subStr.decimal, 1.0)
		XCTAssertEqual(subStr.decimal(locale: .init(identifier: "en_US")), 1.0)
		
	}
	
}

#endif
