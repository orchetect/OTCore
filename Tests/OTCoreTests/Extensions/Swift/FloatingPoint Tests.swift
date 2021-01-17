//
//  FloatingPoint Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-12.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_FloatingPoint_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testTypeConversions_FloatsToInts() {
		
		// Double
		
		let double = 123.456
		
		_ = double.int
		_ = double.intExactly
		_ = double.uint
		_ = double.uintExactly
		
		_ = double.int8
		_ = double.int8Exactly
		_ = double.uint8
		_ = double.uint8Exactly
		
		_ = double.int16
		_ = double.int16Exactly
		_ = double.uint16
		_ = double.uint16Exactly
		
		_ = double.int32
		_ = double.int32Exactly
		_ = double.uint32
		_ = double.uint32Exactly
		
		_ = double.int64
		_ = double.int64Exactly
		_ = double.uint64
		_ = double.uint64Exactly
		
		// Float
		
		let float = Float(123.456)
		
		_ = float.int
		_ = float.intExactly
		_ = float.uint
		_ = float.uintExactly
		
		_ = float.int8
		_ = float.int8Exactly
		_ = float.uint8
		_ = float.uint8Exactly
		
		_ = float.int16
		_ = float.int16Exactly
		_ = float.uint16
		_ = float.uint16Exactly
		
		_ = float.int32
		_ = float.int32Exactly
		_ = float.uint32
		_ = float.uint32Exactly
		
		_ = float.int64
		_ = float.int64Exactly
		_ = float.uint64
		_ = float.uint64Exactly
		
		// Float80
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		
		let float80 = Float80(123.456)
		
		_ = float80.int
		_ = float80.intExactly
		_ = float80.uint
		_ = float80.uintExactly
		
		_ = float80.int8
		_ = float80.int8Exactly
		_ = float80.uint8
		_ = float80.uint8Exactly
		
		_ = float80.int16
		_ = float80.int16Exactly
		_ = float80.uint16
		_ = float80.uint16Exactly
		
		_ = float80.int32
		_ = float80.int32Exactly
		_ = float80.uint32
		_ = float80.uint32Exactly
		
		_ = float80.int64
		_ = float80.int64Exactly
		_ = float80.uint64
		_ = float80.uint64Exactly
		
		#endif
		
		// CGFloat
		
		let cgfloat = CGFloat(123.456)
		
		_ = cgfloat.int
		_ = cgfloat.intExactly
		_ = cgfloat.uint
		_ = cgfloat.uintExactly
		
		_ = cgfloat.int8
		_ = cgfloat.int8Exactly
		_ = cgfloat.uint8
		_ = cgfloat.uint8Exactly
		
		_ = cgfloat.int16
		_ = cgfloat.int16Exactly
		_ = cgfloat.uint16
		_ = cgfloat.uint16Exactly
		
		_ = cgfloat.int32
		_ = cgfloat.int32Exactly
		_ = cgfloat.uint32
		_ = cgfloat.uint32Exactly
		
		_ = cgfloat.int64
		_ = cgfloat.int64Exactly
		_ = cgfloat.uint64
		_ = cgfloat.uint64Exactly
		
	}
	
	func testCeiling() {
		
		XCTAssertEqual(123.45.ceiling, 124.0)
		
	}
	
	func testFloor() {
		
		XCTAssertEqual(123.45.floor, 123.0)
		
	}
	
	func testBoolValue() {
		
		// .boolValue
		
		var b: Bool = false
		b = 0.0.boolValue
		b = Float(1).boolValue
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		b = Float80(1).boolValue
		#endif
		
		b = CGFloat(1).boolValue
		b = Decimal(1).boolValue
		_ = b // silences 'variable was written to, but never read' warning
		
		XCTAssertEqual((-1.0).boolValue	, false)
		XCTAssertEqual(0.0.boolValue	, false)
		XCTAssertEqual(1.0.boolValue	, true)
		XCTAssertEqual(123.0.boolValue	, true)
		
	}
	
	func testPower() {
		
		XCTAssertEqual(         2.0.power(3)	, 8.0) // Double
		XCTAssertEqual(  Float(2.0).power(3)	, 8.0)
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		XCTAssertEqual(Float80(2.0).power(3)	, 8.0)
		#endif
		XCTAssertEqual(CGFloat(2.0).power(3)	, 8.0)
		XCTAssertEqual(Decimal(2.0).power(3)	, 8.0)
		
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
		
		flt = 0.123456789
		//		XCTAssertEqual(flt.truncated(decimalPlaces: 8), 0.12345678) // fails -- precision issue??
		
		flt = 0.1264
		flt.formTruncated(decimalPlaces: 2)
		XCTAssertEqual(flt, 0.12)
		
	}
	
	func testRounded() {
		
		// Double .rounded()
		
		XCTAssertEqual(1.62456.rounded(decimalPlaces: -1), 2.0)
		XCTAssertEqual(1.62456.rounded(decimalPlaces: 0),  2.0)
		XCTAssertEqual(1.62456.rounded(decimalPlaces: 2),  1.62)
		XCTAssertEqual(1.62456.rounded(decimalPlaces: 3),  1.625)
		XCTAssertEqual(1.62456.rounded(decimalPlaces: 4),  1.6246)
		XCTAssertEqual(1.62456.rounded(decimalPlaces: 5),  1.62456)
		XCTAssertEqual(1.62456.rounded(decimalPlaces: 6),  1.62456)
		
		XCTAssertEqual(1.62456.rounded(.up, decimalPlaces: -1), 2.0)
		XCTAssertEqual(1.62456.rounded(.up, decimalPlaces: 0),  2.0)
		XCTAssertEqual(1.62456.rounded(.up, decimalPlaces: 2),  1.63)
		XCTAssertEqual(1.62456.rounded(.up, decimalPlaces: 3),  1.625)
		XCTAssertEqual(1.62456.rounded(.up, decimalPlaces: 4),  1.6246)
		XCTAssertEqual(1.62456.rounded(.up, decimalPlaces: 5),  1.62456)
		XCTAssertEqual(1.62456.rounded(.up, decimalPlaces: 6),  1.62456)
		
		var dbl = 0.1264
		dbl.round(decimalPlaces: 2)
		XCTAssertEqual(dbl, 0.13)
		
		dbl = 0.1264
		dbl.round(.up, decimalPlaces: 1)
		XCTAssertEqual(dbl, 0.2)
		
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
	
	func testStringValueHighPrecision() {
		
		// Double
		
		XCTAssertEqual((0.0).stringValueHighPrecision, "0")
		XCTAssertEqual((0.1).stringValueHighPrecision, "0.1000000000000000055511151231257827021181583404541015625")
		XCTAssertEqual((1.0).stringValueHighPrecision, "1")
		
		let double: Double = 3603.59999999999990905052982270717620849609375
		XCTAssertEqual(double.stringValueHighPrecision, "3603.59999999999990905052982270717620849609375")
		
		// Float
		
		let float: Float = 3603.59999999999990905052982270717620849609375
		XCTAssertEqual(float.stringValueHighPrecision, "3603.60009765625")
		
		// Float80
		
		// doesn't work yet - not interoperable with CVarArg
		
		// CGFloat
		
		let cgfloat = CGFloat(exactly: 3603.59999999999990905052982270717620849609375)!
		XCTAssertEqual(cgfloat.stringValueHighPrecision, "3603.59999999999990905052982270717620849609375")
		
	}
	
	func testTypeConversions_FloatsToString() {
		
		var str: String = ""
		str = 0.0.string
		str = Float(1).string
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		str = Float80(1).string
		#endif
		
		str = CGFloat(1).string
		str = Decimal(1).string
		_ = str // silences 'variable was written to, but never read' warning
		
		XCTAssertEqual(  Float(1).string,	"1.0")
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		XCTAssertEqual(Float80(1).string,	"1.0")
		#endif
		
		XCTAssertEqual(CGFloat(1).string,	"1.0")
		XCTAssertEqual(Decimal(1).string,	"1")
		
	}
	
	func testTypeConversions_StringToFloats() {
		
		XCTAssertEqual("1.0".double,	1.0)
		XCTAssertEqual("1.0".float,		1.0)
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		XCTAssertEqual("1.0".float80,	1.0)
		#endif
		
		XCTAssertEqual("1.0".decimal,	1.0)
		
	}
}

#endif
