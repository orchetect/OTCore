//
//  Integers Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-07.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import OTCore

class Extensions_Integers_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testTypeConversions_IntsToInts() {
		
		// Int
		
		_ = 1.int
		_ = 1.uint
		_ = 1.int8
		_ = 1.uint8
		_ = 1.int16
		_ = 1.uint16
		_ = 1.int32
		_ = 1.uint32
		_ = 1.int64
		_ = 1.uint64
		
		_ = 1.double
		_ = 1.float
		_ = 1.float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = 1.float80
		#endif
		_ = 1.cgFloat
		_ = 1.decimal
		
		// UInt
		
		_ = UInt(1).int
		_ = UInt(1).uint
		_ = UInt(1).int8
		_ = UInt(1).uint8
		_ = UInt(1).int16
		_ = UInt(1).uint16
		_ = UInt(1).int32
		_ = UInt(1).uint32
		_ = UInt(1).int64
		_ = UInt(1).uint64
		
		_ = UInt(1).double
		_ = UInt(1).float
		_ = UInt(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = UInt(1).float80
		#endif
		_ = UInt(1).cgFloat
		_ = UInt(1).decimal
		
		// Int8
		
		_ = Int8(1).int
		_ = Int8(1).uint
		_ = Int8(1).int8
		_ = Int8(1).uint8
		_ = Int8(1).int16
		_ = Int8(1).uint16
		_ = Int8(1).int32
		_ = Int8(1).uint32
		_ = Int8(1).int64
		_ = Int8(1).uint64
		
		_ = Int8(1).double
		_ = Int8(1).float
		_ = Int8(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = Int8(1).float80
		#endif
		_ = Int8(1).cgFloat
		_ = Int8(1).decimal
		
		// UInt8
		
		_ = UInt8(1).int
		_ = UInt8(1).uint
		_ = UInt8(1).int8
		_ = UInt8(1).uint8
		_ = UInt8(1).int16
		_ = UInt8(1).uint16
		_ = UInt8(1).int32
		_ = UInt8(1).uint32
		_ = UInt8(1).int64
		_ = UInt8(1).uint64
		
		_ = UInt8(1).double
		_ = UInt8(1).float
		_ = UInt8(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = UInt8(1).float80
		#endif
		_ = UInt8(1).cgFloat
		_ = UInt8(1).decimal
		
		// Int16
		
		_ = Int16(1).int
		_ = Int16(1).uint
		_ = Int16(1).int8
		_ = Int16(1).uint8
		_ = Int16(1).int16
		_ = Int16(1).uint16
		_ = Int16(1).int32
		_ = Int16(1).uint32
		_ = Int16(1).int64
		_ = Int16(1).uint64
		
		_ = Int16(1).double
		_ = Int16(1).float
		_ = Int16(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = Int16(1).float80
		#endif
		_ = Int16(1).cgFloat
		_ = Int16(1).decimal
		
		// UInt16
		
		_ = UInt16(1).int
		_ = UInt16(1).uint
		_ = UInt16(1).int8
		_ = UInt16(1).uint8
		_ = UInt16(1).int16
		_ = UInt16(1).uint16
		_ = UInt16(1).int32
		_ = UInt16(1).uint32
		_ = UInt16(1).int64
		_ = UInt16(1).uint64
		
		_ = UInt16(1).double
		_ = UInt16(1).float
		_ = UInt16(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = UInt16(1).float80
		#endif
		_ = UInt16(1).cgFloat
		_ = UInt16(1).decimal
		
		// Int32
		
		_ = Int32(1).int
		_ = Int32(1).uint
		_ = Int32(1).int8
		_ = Int32(1).uint8
		_ = Int32(1).int16
		_ = Int32(1).uint16
		_ = Int32(1).int32
		_ = Int32(1).uint32
		_ = Int32(1).int64
		_ = Int32(1).uint64
		
		_ = Int32(1).double
		_ = Int32(1).float
		_ = Int32(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = Int32(1).float80
		#endif
		_ = Int32(1).cgFloat
		_ = Int32(1).decimal
		
		// UInt32
		
		_ = UInt32(1).int
		_ = UInt32(1).uint
		_ = UInt32(1).int8
		_ = UInt32(1).uint8
		_ = UInt32(1).int16
		_ = UInt32(1).uint16
		_ = UInt32(1).int32
		_ = UInt32(1).uint32
		_ = UInt32(1).int64
		_ = UInt32(1).uint64
		
		_ = UInt32(1).double
		_ = UInt32(1).float
		_ = UInt32(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = UInt32(1).float80
		#endif
		_ = UInt32(1).cgFloat
		_ = UInt32(1).decimal
		
		// Int64
		
		_ = Int64(1).int
		_ = Int64(1).uint
		_ = Int64(1).int8
		_ = Int64(1).uint8
		_ = Int64(1).int16
		_ = Int64(1).uint16
		_ = Int64(1).int32
		_ = Int64(1).uint32
		_ = Int64(1).int64
		_ = Int64(1).uint64
		
		_ = Int64(1).double
		_ = Int64(1).float
		_ = Int64(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = Int64(1).float80
		#endif
		_ = Int64(1).cgFloat
		_ = Int64(1).decimal
		
		// UInt64
		
		_ = UInt64(1).int
		_ = UInt64(1).uint
		_ = UInt64(1).int8
		_ = UInt64(1).uint8
		_ = UInt64(1).int16
		_ = UInt64(1).uint16
		_ = UInt64(1).int32
		_ = UInt64(1).uint32
		_ = UInt64(1).int64
		_ = UInt64(1).uint64
		
		_ = UInt64(1).double
		_ = UInt64(1).float
		_ = UInt64(1).float32
		#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
		_ = UInt64(1).float80
		#endif
		_ = UInt64(1).cgFloat
		_ = UInt64(1).decimal
		
	}
	
	func testTypeConversions_StringToInts() {
		
		XCTAssertEqual("1".int		,		   1 )
		XCTAssertEqual("1".uint		,	  UInt(1))
		XCTAssertEqual("1".int8		,	  Int8(1))
		XCTAssertEqual("1".uint8	,	 UInt8(1))
		XCTAssertEqual("1".int16	,	 Int16(1))
		XCTAssertEqual("1".uint16	,	UInt16(1))
		XCTAssertEqual("1".int32	,	 Int32(1))
		XCTAssertEqual("1".uint32	,	UInt32(1))
		XCTAssertEqual("1".int64	,	 Int64(1))
		XCTAssertEqual("1".uint64	,	UInt64(1))
		
	}
	
	func testTypeConversions_IntsToString() {
		
		XCTAssertEqual(       1 .string, "1")
		XCTAssertEqual(  UInt(1).string, "1")
		XCTAssertEqual(  Int8(1).string, "1")
		XCTAssertEqual( UInt8(1).string, "1")
		XCTAssertEqual( Int16(1).string, "1")
		XCTAssertEqual(UInt16(1).string, "1")
		XCTAssertEqual( Int32(1).string, "1")
		XCTAssertEqual(UInt32(1).string, "1")
		XCTAssertEqual( Int64(1).string, "1")
		XCTAssertEqual(UInt64(1).string, "1")
		
	}
	
	func testStringPaddedTo() {
		
		// basic validation checks
		
		XCTAssertEqual(  1.string(paddedTo:  1)	, "1")
		XCTAssertEqual(  1.string(paddedTo:  2)	, "01")
		
		XCTAssertEqual(123.string(paddedTo:  1)	, "123")
		
		XCTAssertEqual(  1.string(paddedTo: -1)	, "1")
		
		// BinaryInteger cases
		
		XCTAssertEqual(       1 .string(paddedTo: 1)	, "1")
		XCTAssertEqual(  UInt(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual(  Int8(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual( UInt8(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual( Int16(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual(UInt16(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual( Int32(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual(UInt32(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual( Int64(1).string(paddedTo: 1)	, "1")
		XCTAssertEqual(UInt64(1).string(paddedTo: 1)	, "1")
		
	}
	
	func testRounding() {
		
		XCTAssertEqual((-5).roundedAwayFromZero(toMultiplesOf: 4),	-8)
		XCTAssertEqual((-1).roundedAwayFromZero(toMultiplesOf: 4),	-4)
		XCTAssertEqual(   1.roundedAwayFromZero(toMultiplesOf: 1),	 1)
		XCTAssertEqual(   1.roundedAwayFromZero(toMultiplesOf: 4),	 4)
		XCTAssertEqual(   4.roundedAwayFromZero(toMultiplesOf: 4),	 4)
		XCTAssertEqual(   5.roundedAwayFromZero(toMultiplesOf: 4),	 8)
		
		XCTAssertEqual((-5).roundedUp(toMultiplesOf: 4),	-4)
		XCTAssertEqual((-1).roundedUp(toMultiplesOf: 4),	 0)
		XCTAssertEqual(   1.roundedUp(toMultiplesOf: 1),	 1)
		XCTAssertEqual(   1.roundedUp(toMultiplesOf: 4),	 4)
		XCTAssertEqual(   4.roundedUp(toMultiplesOf: 4),	 4)
		XCTAssertEqual(   5.roundedUp(toMultiplesOf: 4),	 8)
		
		XCTAssertEqual((-5).roundedDown(toMultiplesOf: 4),	-8)
		XCTAssertEqual((-1).roundedDown(toMultiplesOf: 4),	-4)
		XCTAssertEqual(   1.roundedDown(toMultiplesOf: 1),	 1)
		XCTAssertEqual(   1.roundedDown(toMultiplesOf: 4),	 0)
		XCTAssertEqual(   4.roundedDown(toMultiplesOf: 4),	 4)
		XCTAssertEqual(   5.roundedDown(toMultiplesOf: 4),	 4)
		
	}
	
	func testBitwise() {
		
		XCTAssertEqual(0b100.uint8.bit(0),	0)
		XCTAssertEqual(0b100.uint8.bit(1),	0)
		XCTAssertEqual(0b100.uint8.bit(2),	1)
		
		XCTAssertEqual(Int8(-0b0100_0000).twosComplement, 0b1100_0000)
		
	}
	
	func testRandomNumbers() {
		
		// typical types
		
		_ = [Int]   (randomValuesBetween:    0...255, count: 4)
		_ = [UInt]  (randomValuesBetween:    0...255, count: 4)
		_ = [Int8]  (randomValuesBetween: -128...127, count: 4)
		_ = [UInt8] (randomValuesBetween:    0...255, count: 4)
		_ = [Int16] (randomValuesBetween:    0...255, count: 4)
		_ = [UInt16](randomValuesBetween:    0...255, count: 4)
		_ = [Int32] (randomValuesBetween:    0...255, count: 4)
		_ = [UInt32](randomValuesBetween:    0...255, count: 4)
		_ = [Int64] (randomValuesBetween:    0...255, count: 4)
		_ = [UInt64](randomValuesBetween:    0...255, count: 4)
		
		// spot check
		
		let range = UInt8(0)...UInt8(255)
		
		let arr = [UInt8](randomValuesBetween: range, count: 4)
		
		// check expected count
		XCTAssertEqual(arr.count, 4)
		
		// ensure each value is within range
		arr.forEach {
			XCTAssert(range.contains($0))
		}
	}
	
	func testWrappingNumbers() {
		
		// ClosedRange
		
		// single value ranges
		
		XCTAssertEqual(    1.wrapped(around: 0...0)		,  0)
		XCTAssertEqual(    1.wrapped(around: -1...(-1))	, -1)
		
		// basic ranges
		
		XCTAssertEqual((-11).wrapped(around: 0...4)		,  4)
		XCTAssertEqual((-10).wrapped(around: 0...4)		,  0)
		XCTAssertEqual( (-9).wrapped(around: 0...4)		,  1)
		XCTAssertEqual( (-8).wrapped(around: 0...4)		,  2)
		XCTAssertEqual( (-7).wrapped(around: 0...4)		,  3)
		XCTAssertEqual( (-6).wrapped(around: 0...4)		,  4)
		XCTAssertEqual( (-5).wrapped(around: 0...4)		,  0)
		XCTAssertEqual( (-4).wrapped(around: 0...4)		,  1)
		XCTAssertEqual( (-3).wrapped(around: 0...4)		,  2)
		XCTAssertEqual( (-2).wrapped(around: 0...4)		,  3)
		XCTAssertEqual( (-1).wrapped(around: 0...4)		,  4)
		XCTAssertEqual(    0.wrapped(around: 0...4)		,  0)
		XCTAssertEqual(    1.wrapped(around: 0...4)		,  1)
		XCTAssertEqual(    2.wrapped(around: 0...4)		,  2)
		XCTAssertEqual(    3.wrapped(around: 0...4)		,  3)
		XCTAssertEqual(    4.wrapped(around: 0...4)		,  4)
		XCTAssertEqual(    5.wrapped(around: 0...4)		,  0)
		XCTAssertEqual(    6.wrapped(around: 0...4)		,  1)
		XCTAssertEqual(    7.wrapped(around: 0...4)		,  2)
		XCTAssertEqual(    8.wrapped(around: 0...4)		,  3)
		XCTAssertEqual(    9.wrapped(around: 0...4)		,  4)
		XCTAssertEqual(   10.wrapped(around: 0...4)		,  0)
		XCTAssertEqual(   11.wrapped(around: 0...4)		,  1)
		
		XCTAssertEqual((-11).wrapped(around: 1...5)		,  4)
		XCTAssertEqual((-10).wrapped(around: 1...5)		,  5)
		XCTAssertEqual( (-9).wrapped(around: 1...5)		,  1)
		XCTAssertEqual( (-8).wrapped(around: 1...5)		,  2)
		XCTAssertEqual( (-7).wrapped(around: 1...5)		,  3)
		XCTAssertEqual( (-6).wrapped(around: 1...5)		,  4)
		XCTAssertEqual( (-5).wrapped(around: 1...5)		,  5)
		XCTAssertEqual( (-4).wrapped(around: 1...5)		,  1)
		XCTAssertEqual( (-3).wrapped(around: 1...5)		,  2)
		XCTAssertEqual( (-2).wrapped(around: 1...5)		,  3)
		XCTAssertEqual( (-1).wrapped(around: 1...5)		,  4)
		XCTAssertEqual(    0.wrapped(around: 1...5)		,  5)
		XCTAssertEqual(    1.wrapped(around: 1...5)		,  1)
		XCTAssertEqual(    2.wrapped(around: 1...5)		,  2)
		XCTAssertEqual(    3.wrapped(around: 1...5)		,  3)
		XCTAssertEqual(    4.wrapped(around: 1...5)		,  4)
		XCTAssertEqual(    5.wrapped(around: 1...5)		,  5)
		XCTAssertEqual(    6.wrapped(around: 1...5)		,  1)
		XCTAssertEqual(    7.wrapped(around: 1...5)		,  2)
		XCTAssertEqual(    8.wrapped(around: 1...5)		,  3)
		XCTAssertEqual(    9.wrapped(around: 1...5)		,  4)
		XCTAssertEqual(   10.wrapped(around: 1...5)		,  5)
		XCTAssertEqual(   11.wrapped(around: 1...5)		,  1)
		
		XCTAssertEqual((-11).wrapped(around: -1...3)	, -1)
		XCTAssertEqual((-10).wrapped(around: -1...3)	,  0)
		XCTAssertEqual( (-9).wrapped(around: -1...3)	,  1)
		XCTAssertEqual( (-8).wrapped(around: -1...3)	,  2)
		XCTAssertEqual( (-7).wrapped(around: -1...3)	,  3)
		XCTAssertEqual( (-6).wrapped(around: -1...3)	, -1)
		XCTAssertEqual( (-5).wrapped(around: -1...3)	,  0)
		XCTAssertEqual( (-4).wrapped(around: -1...3)	,  1)
		XCTAssertEqual( (-3).wrapped(around: -1...3)	,  2)
		XCTAssertEqual( (-2).wrapped(around: -1...3)	,  3)
		XCTAssertEqual( (-1).wrapped(around: -1...3)	, -1)
		XCTAssertEqual(    0.wrapped(around: -1...3)	,  0)
		XCTAssertEqual(    1.wrapped(around: -1...3)	,  1)
		XCTAssertEqual(    2.wrapped(around: -1...3)	,  2)
		XCTAssertEqual(    3.wrapped(around: -1...3)	,  3)
		XCTAssertEqual(    4.wrapped(around: -1...3)	, -1)
		XCTAssertEqual(    5.wrapped(around: -1...3)	,  0)
		XCTAssertEqual(    6.wrapped(around: -1...3)	,  1)
		XCTAssertEqual(    7.wrapped(around: -1...3)	,  2)
		XCTAssertEqual(    8.wrapped(around: -1...3)	,  3)
		XCTAssertEqual(    9.wrapped(around: -1...3)	, -1)
		XCTAssertEqual(   10.wrapped(around: -1...3)	,  0)
		XCTAssertEqual(   11.wrapped(around: -1...3)	,  1)
		
		// Range
		
		// single value ranges
		
		XCTAssertEqual(    1.wrapped(around: 0..<0)		,  0)
		XCTAssertEqual(    1.wrapped(around: -1..<(-1))	, -1)
		
		// basic ranges
		
		XCTAssertEqual((-11).wrapped(around: 0..<4)		,  1)
		XCTAssertEqual((-10).wrapped(around: 0..<4)		,  2)
		XCTAssertEqual( (-9).wrapped(around: 0..<4)		,  3)
		XCTAssertEqual( (-8).wrapped(around: 0..<4)		,  0)
		XCTAssertEqual( (-7).wrapped(around: 0..<4)		,  1)
		XCTAssertEqual( (-6).wrapped(around: 0..<4)		,  2)
		XCTAssertEqual( (-5).wrapped(around: 0..<4)		,  3)
		XCTAssertEqual( (-4).wrapped(around: 0..<4)		,  0)
		XCTAssertEqual( (-3).wrapped(around: 0..<4)		,  1)
		XCTAssertEqual( (-2).wrapped(around: 0..<4)		,  2)
		XCTAssertEqual( (-1).wrapped(around: 0..<4)		,  3)
		XCTAssertEqual(    0.wrapped(around: 0..<4)		,  0)
		XCTAssertEqual(    1.wrapped(around: 0..<4)		,  1)
		XCTAssertEqual(    2.wrapped(around: 0..<4)		,  2)
		XCTAssertEqual(    3.wrapped(around: 0..<4)		,  3)
		XCTAssertEqual(    4.wrapped(around: 0..<4)		,  0)
		XCTAssertEqual(    5.wrapped(around: 0..<4)		,  1)
		XCTAssertEqual(    6.wrapped(around: 0..<4)		,  2)
		XCTAssertEqual(    7.wrapped(around: 0..<4)		,  3)
		XCTAssertEqual(    8.wrapped(around: 0..<4)		,  0)
		XCTAssertEqual(    9.wrapped(around: 0..<4)		,  1)
		XCTAssertEqual(   10.wrapped(around: 0..<4)		,  2)
		XCTAssertEqual(   11.wrapped(around: 0..<4)		,  3)
		
	}
	
	func testNumberofDigits() {
		
		XCTAssertEqual(     0.numberOfDigits,	1)
		XCTAssertEqual(     1.numberOfDigits,	1)
		XCTAssertEqual(    10.numberOfDigits,	2)
		XCTAssertEqual(    15.numberOfDigits,	2)
		XCTAssertEqual(   205.numberOfDigits,	3)
		
		XCTAssertEqual(  (-0).numberOfDigits,	1)
		XCTAssertEqual(  (-1).numberOfDigits,	1)
		XCTAssertEqual( (-10).numberOfDigits,	2)
		XCTAssertEqual( (-15).numberOfDigits,	2)
		XCTAssertEqual((-205).numberOfDigits,	3)
		
	}
	
}
