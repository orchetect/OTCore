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
	
	func testBoolValue() {
		
		// .boolValue
		
		_ = 0.0.boolValue
		
		_ = Float(1).boolValue
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		_ = Float80(1).boolValue
		#endif
		
		_ = CGFloat(1).boolValue
		
		XCTAssertEqual((-1.0).boolValue	, false)
		XCTAssertEqual(0.0.boolValue	, false)
		XCTAssertEqual(1.0.boolValue	, true)
		XCTAssertEqual(123.0.boolValue	, true)
		
	}
	
	func testRounded() {
		
		// Double .rounded(decimalPlaces:)
		
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
		
		// Double .round(decimalPlaces:)
		
		var dbl = 0.1264
		dbl.round(decimalPlaces: 2)
		XCTAssertEqual(dbl, 0.13)
		
		dbl = 0.1264
		dbl.round(.up, decimalPlaces: 1)
		XCTAssertEqual(dbl, 0.2)
		
	}
	
	func testWrappingNumbers() {
		
		// ClosedRange
		
		// single value ranges
		
		XCTAssertEqual(    1.0.wrapped(around: 0...0)		,  0)
		XCTAssertEqual(    1.0.wrapped(around: -1...(-1))	, -1)
		
		// basic ranges
		
		XCTAssertEqual((-11.0).wrapped(around: 0...4)		,  4)
		XCTAssertEqual((-10.0).wrapped(around: 0...4)		,  0)
		XCTAssertEqual( (-9.0).wrapped(around: 0...4)		,  1)
		XCTAssertEqual( (-8.0).wrapped(around: 0...4)		,  2)
		XCTAssertEqual( (-7.0).wrapped(around: 0...4)		,  3)
		XCTAssertEqual( (-6.0).wrapped(around: 0...4)		,  4)
		XCTAssertEqual( (-5.0).wrapped(around: 0...4)		,  0)
		XCTAssertEqual( (-4.0).wrapped(around: 0...4)		,  1)
		XCTAssertEqual( (-3.0).wrapped(around: 0...4)		,  2)
		XCTAssertEqual( (-2.0).wrapped(around: 0...4)		,  3)
		XCTAssertEqual( (-1.0).wrapped(around: 0...4)		,  4)
		XCTAssertEqual(    0.0.wrapped(around: 0...4)		,  0)
		XCTAssertEqual(    1.0.wrapped(around: 0...4)		,  1)
		XCTAssertEqual(    2.0.wrapped(around: 0...4)		,  2)
		XCTAssertEqual(    3.0.wrapped(around: 0...4)		,  3)
		XCTAssertEqual(    4.0.wrapped(around: 0...4)		,  4)
		XCTAssertEqual(    5.0.wrapped(around: 0...4)		,  0)
		XCTAssertEqual(    6.0.wrapped(around: 0...4)		,  1)
		XCTAssertEqual(    7.0.wrapped(around: 0...4)		,  2)
		XCTAssertEqual(    8.0.wrapped(around: 0...4)		,  3)
		XCTAssertEqual(    9.0.wrapped(around: 0...4)		,  4)
		XCTAssertEqual(   10.0.wrapped(around: 0...4)		,  0)
		XCTAssertEqual(   11.0.wrapped(around: 0...4)		,  1)
		
		XCTAssertEqual((-11.0).wrapped(around: 1...5)		,  4)
		XCTAssertEqual((-10.0).wrapped(around: 1...5)		,  5)
		XCTAssertEqual( (-9.0).wrapped(around: 1...5)		,  1)
		XCTAssertEqual( (-8.0).wrapped(around: 1...5)		,  2)
		XCTAssertEqual( (-7.0).wrapped(around: 1...5)		,  3)
		XCTAssertEqual( (-6.0).wrapped(around: 1...5)		,  4)
		XCTAssertEqual( (-5.0).wrapped(around: 1...5)		,  5)
		XCTAssertEqual( (-4.0).wrapped(around: 1...5)		,  1)
		XCTAssertEqual( (-3.0).wrapped(around: 1...5)		,  2)
		XCTAssertEqual( (-2.0).wrapped(around: 1...5)		,  3)
		XCTAssertEqual( (-1.0).wrapped(around: 1...5)		,  4)
		XCTAssertEqual(    0.0.wrapped(around: 1...5)		,  5)
		XCTAssertEqual(    1.0.wrapped(around: 1...5)		,  1)
		XCTAssertEqual(    2.0.wrapped(around: 1...5)		,  2)
		XCTAssertEqual(    3.0.wrapped(around: 1...5)		,  3)
		XCTAssertEqual(    4.0.wrapped(around: 1...5)		,  4)
		XCTAssertEqual(    5.0.wrapped(around: 1...5)		,  5)
		XCTAssertEqual(    6.0.wrapped(around: 1...5)		,  1)
		XCTAssertEqual(    7.0.wrapped(around: 1...5)		,  2)
		XCTAssertEqual(    8.0.wrapped(around: 1...5)		,  3)
		XCTAssertEqual(    9.0.wrapped(around: 1...5)		,  4)
		XCTAssertEqual(   10.0.wrapped(around: 1...5)		,  5)
		XCTAssertEqual(   11.0.wrapped(around: 1...5)		,  1)
		
		XCTAssertEqual((-11.0).wrapped(around: -1...3)	, -1)
		XCTAssertEqual((-10.0).wrapped(around: -1...3)	,  0)
		XCTAssertEqual( (-9.0).wrapped(around: -1...3)	,  1)
		XCTAssertEqual( (-8.0).wrapped(around: -1...3)	,  2)
		XCTAssertEqual( (-7.0).wrapped(around: -1...3)	,  3)
		XCTAssertEqual( (-6.0).wrapped(around: -1...3)	, -1)
		XCTAssertEqual( (-5.0).wrapped(around: -1...3)	,  0)
		XCTAssertEqual( (-4.0).wrapped(around: -1...3)	,  1)
		XCTAssertEqual( (-3.0).wrapped(around: -1...3)	,  2)
		XCTAssertEqual( (-2.0).wrapped(around: -1...3)	,  3)
		XCTAssertEqual( (-1.0).wrapped(around: -1...3)	, -1)
		XCTAssertEqual(    0.0.wrapped(around: -1...3)	,  0)
		XCTAssertEqual(    1.0.wrapped(around: -1...3)	,  1)
		XCTAssertEqual(    2.0.wrapped(around: -1...3)	,  2)
		XCTAssertEqual(    3.0.wrapped(around: -1...3)	,  3)
		XCTAssertEqual(    4.0.wrapped(around: -1...3)	, -1)
		XCTAssertEqual(    5.0.wrapped(around: -1...3)	,  0)
		XCTAssertEqual(    6.0.wrapped(around: -1...3)	,  1)
		XCTAssertEqual(    7.0.wrapped(around: -1...3)	,  2)
		XCTAssertEqual(    8.0.wrapped(around: -1...3)	,  3)
		XCTAssertEqual(    9.0.wrapped(around: -1...3)	, -1)
		XCTAssertEqual(   10.0.wrapped(around: -1...3)	,  0)
		XCTAssertEqual(   11.0.wrapped(around: -1...3)	,  1)
		
		// Range
		
		// single value ranges
		
		XCTAssertEqual(    1.0.wrapped(around: 0..<0)		,  0)
		XCTAssertEqual(    1.0.wrapped(around: -1..<(-1))	, -1)
		
		// basic ranges
		
		XCTAssertEqual((-11.0).wrapped(around: 0..<4)		,  1)
		XCTAssertEqual((-10.0).wrapped(around: 0..<4)		,  2)
		XCTAssertEqual( (-9.0).wrapped(around: 0..<4)		,  3)
		XCTAssertEqual( (-8.0).wrapped(around: 0..<4)		,  0)
		XCTAssertEqual( (-7.0).wrapped(around: 0..<4)		,  1)
		XCTAssertEqual( (-6.0).wrapped(around: 0..<4)		,  2)
		XCTAssertEqual( (-5.0).wrapped(around: 0..<4)		,  3)
		XCTAssertEqual( (-4.0).wrapped(around: 0..<4)		,  0)
		XCTAssertEqual( (-3.0).wrapped(around: 0..<4)		,  1)
		XCTAssertEqual( (-2.0).wrapped(around: 0..<4)		,  2)
		XCTAssertEqual( (-1.0).wrapped(around: 0..<4)		,  3)
		XCTAssertEqual(    0.0.wrapped(around: 0..<4)		,  0)
		XCTAssertEqual(    1.0.wrapped(around: 0..<4)		,  1)
		XCTAssertEqual(    2.0.wrapped(around: 0..<4)		,  2)
		XCTAssertEqual(    3.0.wrapped(around: 0..<4)		,  3)
		XCTAssertEqual(    4.0.wrapped(around: 0..<4)		,  0)
		XCTAssertEqual(    5.0.wrapped(around: 0..<4)		,  1)
		XCTAssertEqual(    6.0.wrapped(around: 0..<4)		,  2)
		XCTAssertEqual(    7.0.wrapped(around: 0..<4)		,  3)
		XCTAssertEqual(    8.0.wrapped(around: 0..<4)		,  0)
		XCTAssertEqual(    9.0.wrapped(around: 0..<4)		,  1)
		XCTAssertEqual(   10.0.wrapped(around: 0..<4)		,  2)
		XCTAssertEqual(   11.0.wrapped(around: 0..<4)		,  3)
		
	}
	
	func testDegreesToRadians() {
		
		// Double
		XCTAssertEqual(360.0.degreesToRadians, 6.28318530717958647693)
		XCTAssertEqual(6.28318530717958647693.radiansToDegrees, 360.0)
		
		// Float
		XCTAssertEqual(Float(360.0).degreesToRadians, 6.283185)
		XCTAssertEqual(Float(6.283185).radiansToDegrees, 360.0)
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		// Float80
		XCTAssertEqual(Float80(360.0).degreesToRadians, 6.28318530717958647693)
		XCTAssertEqual(Float80(6.28318530717958647693).radiansToDegrees, 360.0)
		#endif
		
		// CGFloat
		XCTAssertEqual(CGFloat(360.0).degreesToRadians, 6.28318530717958647693)
		XCTAssertEqual(CGFloat(6.28318530717958647693).radiansToDegrees, 360.0)
		
	}
	
	func testTypeConversions_FloatsToString() {
		
		XCTAssertEqual((1.0).string, "1.0")
		
		XCTAssertEqual(Float(1).string, "1.0")
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		XCTAssertEqual(Float80(1).string, "1.0")
		#endif
		
		XCTAssertEqual(CGFloat(1).string, "1.0")
		
	}
	
	func testTypeConversions_StringToFloats() {
		
		// String
		
		let str = "1.0"
		
		XCTAssertEqual(str.double,		1.0)
		
		XCTAssertEqual(str.float,		1.0)
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		XCTAssertEqual(str.float80,		1.0)
		#endif
		
		XCTAssertEqual(str.cgFloat,		1.0)
		
		// Substring
		
		let subStr = str.prefix(3)
		
		XCTAssertEqual(subStr.double,	1.0)
		
		XCTAssertEqual(subStr.float,	1.0)
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		XCTAssertEqual(subStr.float80,	1.0)
		#endif
		
		XCTAssertEqual(subStr.cgFloat,	1.0)
		
	}
}

#endif
