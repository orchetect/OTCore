//
//  FloatingPoint and Darwin Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Darwin_FloatingPointAndDarwin_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testCeiling() {
		
		XCTAssertEqual(123.45.ceiling, 124.0)
		
	}
	
	func testFloor() {
		
		XCTAssertEqual(123.45.floor, 123.0)
		
	}
	
	func testPower() {
		
		// Double
		XCTAssertEqual(         2.0.power(3)	, 8.0)
		
		// Float
		XCTAssertEqual(  Float(2.0).power(3)	, 8.0)
		
		// Float80 is now removed for ARM
		#if !(arch(arm64) || arch(arm) || os(watchOS))
		XCTAssertEqual(Float80(2.0).power(3)	, 8.0)
		#endif
		
	}
	
	func testTruncated() {
		
		// Double .truncated()
		
		XCTAssertEqual(1.1234.truncated(decimalPlaces: -1), 1.0)
		XCTAssertEqual(1.1234.truncated(decimalPlaces: 0),  1.0)
		XCTAssertEqual(1.1234.truncated(decimalPlaces: 2),  1.12)
		XCTAssertEqual(1.1234.truncated(decimalPlaces: 3),  1.123)
		XCTAssertEqual(1.1234.truncated(decimalPlaces: 4),  1.1234)
		XCTAssertEqual(1.1234.truncated(decimalPlaces: 5),  1.1234)
		
		XCTAssertEqual(0.123456789.truncated(decimalPlaces: 8), 0.12345678)
		
		var dbl = 0.1264
		dbl.formTruncated(decimalPlaces: 2)
		XCTAssertEqual(dbl, 0.12)
		
		// Float .truncated()
		
		var flt: Float = 1.1234
		
		XCTAssertEqual(flt.truncated(decimalPlaces: -1), 1.0)
		XCTAssertEqual(flt.truncated(decimalPlaces: 0),  1.0)
		XCTAssertEqual(flt.truncated(decimalPlaces: 2),  1.12)
		XCTAssertEqual(flt.truncated(decimalPlaces: 3),  1.123)
		XCTAssertEqual(flt.truncated(decimalPlaces: 4),  1.1234)
		XCTAssertEqual(flt.truncated(decimalPlaces: 5),  1.1234)
		
		//flt = 0.123456789
		//XCTAssertEqual(flt.truncated(decimalPlaces: 8), 0.12345678) // fails -- precision issue??
		
		// Double .formTruncated()
		
		flt = 0.1264
		flt.formTruncated(decimalPlaces: 2)
		XCTAssertEqual(flt, 0.12)
		
	}
	
	func testQuotientAndRemainder() {
		
		let qr = 17.5.quotientAndRemainder(dividingBy: 5.0)
		
		XCTAssertEqual(qr.quotient, 3)
		XCTAssertEqual(qr.remainder, 2.5)
		
	}
	
	func testIntegralAndFraction() {
		
		let iaf = 17.5.integralAndFraction
		
		XCTAssertEqual(iaf.integral, 17)
		XCTAssertEqual(iaf.fraction, 0.5)
		
		XCTAssertEqual(17.5.integral, 17)
		
		XCTAssertEqual(17.5.fraction, 0.5)
		
	}
	
}

#endif
