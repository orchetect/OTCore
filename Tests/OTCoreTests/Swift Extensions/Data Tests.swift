//
//  Data Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-14.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Data_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	// MARK: - Ints
	
	func testInt() {
		
		// Int is 32-bit on 32-bit systems, 64-bit on 64-bit systems
		
		#if !(arch(arm) || arch(i386))
		
		// .toData
		
		XCTAssertEqual(0b1.int.toData(.littleEndian)	, Data([0b1,0,0,0,0,0,0,0]))
		XCTAssertEqual(0b1.int.toData(.bigEndian)		, Data([0,0,0,0,0,0,0,0b1]))
		
		// .toInt64
		
		XCTAssertEqual(Data([])					.toInt(), nil) // underflow
		XCTAssertEqual(Data([1])				.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2])				.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])			.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4])			.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5])		.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6])		.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7])	.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8,9]).toInt(), nil) // overflow
		
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toInt(from: .littleEndian),
					   0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toInt(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000)
		
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt()?                   .toData()				, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4,5,6,7,8]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt(from: .littleEndian)?.toData(.bigEndian)		, Data([8,7,6,5,4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt(from: .bigEndian)?   .toData(.littleEndian)	, Data([8,7,6,5,4,3,2,1]))
		
		#elseif (arch(arm) || arch(i386))
		
		// .toData
		
		XCTAssertEqual(0b1.int.toData(.littleEndian)	, Data([0b1,0,0,0]))
		XCTAssertEqual(0b1.int.toData(.bigEndian)		, Data([0,0,0,0b1]))
		
		// .toInt64
		
		XCTAssertEqual(Data([])			.toInt(), nil) // underflow
		XCTAssertEqual(Data([1])		.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2])		.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])	.toInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5]).toInt(), nil) // overflow
		
		
		XCTAssertEqual(Data([1,2,3,4])			.toInt(from: .littleEndian),
					   0b00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4])			.toInt(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100)
		
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4])	.toInt()?                   .toData()				, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])	.toInt(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4]))
		XCTAssertEqual(Data([1,2,3,4])	.toInt(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])	.toInt(from: .littleEndian)?.toData(.bigEndian)		, Data([4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4])	.toInt(from: .bigEndian)?   .toData(.littleEndian)	, Data([4,3,2,1]))
		
		#else
		
		XCTFail("Platform not supported yet.")
		
		#endif
		
	}
	
	func testInt8() {
		
		// .toData
		
		XCTAssertEqual(0b1.int8.toData()				, Data([0b1]))
		XCTAssertEqual((-128).int8.toData()				, Data([0b1000_0000]))
		
		// .toInt8
		
		XCTAssertEqual(Data([])         .toInt8()		, nil) // underflow
		XCTAssertEqual(Data([1])        .toInt8()		, 0b00000001)
		XCTAssertEqual(Data([1,2])      .toInt8()		, nil) // overflow
		
		// both ways
		
		XCTAssertEqual(1.int8     .toData().toInt8(),	1)
		XCTAssertEqual(127.int8   .toData().toInt8(),	127)
		XCTAssertEqual((-128).int8.toData().toInt8(),	-128)
		
	}
	
	func testInt16() {
		
		// .toData
		
		XCTAssertEqual(0b1.int16.toData(.littleEndian)	, Data([0b1,0]))
		XCTAssertEqual(0b1.int16.toData(.bigEndian)		, Data([0,0b1]))
		
		// .toInt16
		
		XCTAssertEqual(Data([])         .toInt16()		, nil) // underflow
		XCTAssertEqual(Data([1])        .toInt16()		, nil) // underflow
		XCTAssertEqual(Data([1,2,3])    .toInt16()		, nil) // overflow
		
		XCTAssertEqual(Data([1,2])      .toInt16(from: .littleEndian),
					   0b00000010_00000001)
		XCTAssertEqual(Data([1,2])      .toInt16(from: .bigEndian),
					   0b00000001_00000010)
		
		// both ways
		XCTAssertEqual(Data([1,2])  .toInt16()?                   .toData()					, Data([1,2]))
		
		XCTAssertEqual(Data([1,2])  .toInt16(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2]))
		XCTAssertEqual(Data([1,2])  .toInt16(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2]))
		
		XCTAssertEqual(Data([1,2])  .toInt16(from: .littleEndian)?.toData(.bigEndian)		, Data([2,1]))
		XCTAssertEqual(Data([1,2])  .toInt16(from: .bigEndian)?   .toData(.littleEndian)	, Data([2,1]))
		
	}
	
	func testInt32() {
		
		// .toData
		
		XCTAssertEqual(0b1.int32.toData(.littleEndian)	, Data([0b1,0,0,0]))
		XCTAssertEqual(0b1.int32.toData(.bigEndian)		, Data([0,0,0,0b1]))
		
		// .toInt32
		
		XCTAssertEqual(Data([])         .toInt32()		, nil) // underflow
		XCTAssertEqual(Data([1])        .toInt32()		, nil) // underflow
		XCTAssertEqual(Data([1,2])      .toInt32()		, nil) // underflow
		XCTAssertEqual(Data([1,2,3])    .toInt32()		, nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5]).toInt32()		, nil) // overflow
		
		XCTAssertEqual(Data([1,2,3,4])  .toInt32(from: .littleEndian),
					   0b00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4])  .toInt32(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100)
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4])  .toInt32()?                   .toData()					, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toInt32(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4]))
		XCTAssertEqual(Data([1,2,3,4])  .toInt32(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toInt32(from: .littleEndian)?.toData(.bigEndian)		, Data([4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4])  .toInt32(from: .bigEndian)?   .toData(.littleEndian)	, Data([4,3,2,1]))
		
	}
	
	func testInt64() {
		
		// .toData
		
		XCTAssertEqual(0b1.int64.toData(.littleEndian)	, Data([0b1,0,0,0,0,0,0,0]))
		XCTAssertEqual(0b1.int64.toData(.bigEndian)		, Data([0,0,0,0,0,0,0,0b1]))
		
		// .toInt64
		
		XCTAssertEqual(Data([])					.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1])				.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2])				.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])			.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4])			.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5])		.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6])		.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7])	.toInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8,9]).toInt64(), nil) // overflow
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toInt64(from: .littleEndian),
					   0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toInt64(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000)
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt64()?                   .toData()					, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt64(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4,5,6,7,8]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt64(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt64(from: .littleEndian)?.toData(.bigEndian)		, Data([8,7,6,5,4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toInt64(from: .bigEndian)?   .toData(.littleEndian)	, Data([8,7,6,5,4,3,2,1]))
		
	}
	
	
	// MARK: - UInts
	
	func testUInt() {
		
		// UInt is 32-bit on 32-bit systems, 64-bit on 64-bit systems
		
		#if !(arch(arm) || arch(i386))
		
		// .toData
		
		XCTAssertEqual(0b1.uint.toData(.littleEndian)	, Data([0b1,0,0,0,0,0,0,0]))
		XCTAssertEqual(0b1.uint.toData(.bigEndian)		, Data([0,0,0,0,0,0,0,0b1]))
		
		// .toUInt
		
		XCTAssertEqual(Data([])					.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1])				.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2])				.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])			.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4])			.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5])		.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6])		.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7])	.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8,9]).toUInt(), nil) // overflow
		
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toUInt(from: .littleEndian),
					   0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toUInt(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000)
		
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt()?                   .toData()				, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4,5,6,7,8]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt(from: .bigEndian)?   .toData(.bigEndian)	, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt(from: .littleEndian)?.toData(.bigEndian)	, Data([8,7,6,5,4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt(from: .bigEndian)?   .toData(.littleEndian)	, Data([8,7,6,5,4,3,2,1]))
		
		#elseif (arch(arm) || arch(i386))
		
		// .toData
		
		XCTAssertEqual(0b1.uint.toData(.littleEndian)	, Data([0b1,0,0,0]))
		XCTAssertEqual(0b1.uint.toData(.bigEndian)		, Data([0,0,0,0b1]))
		
		// .toUInt
		
		XCTAssertEqual(Data([])			.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1])		.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2])		.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])	.toUInt(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5]).toUInt(), nil) // overflow
		
		
		XCTAssertEqual(Data([1,2,3,4])			.toUInt(from: .littleEndian),
					   0b00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4])			.toUInt(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100)
		
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4])  .toUInt()?                   .toData()				, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toUInt(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4]))
		XCTAssertEqual(Data([1,2,3,4])  .toUInt(from: .bigEndian)?   .toData(.bigEndian)	, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toUInt(from: .littleEndian)?.toData(.bigEndian)	, Data([4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4])  .toUInt(from: .bigEndian)?   .toData(.littleEndian)	, Data([4,3,2,1]))
		
		#else
		
		XCTFail("Platform not supported yet.")
		
		#endif
		
	}
	
	func testUInt8() {
		
		// .toData
		
		XCTAssertEqual(0b1.uint8.toData()				, Data([0b1]))
		XCTAssertEqual(0b1111_1111.uint8.toData()		, Data([0b1111_1111]))
		
		// .toUInt8
		
		XCTAssertEqual(Data([])         .toUInt8()		, nil) // underflow
		XCTAssertEqual(Data([1])        .toUInt8()		, 0b00000001)
		XCTAssertEqual(Data([1,2])      .toUInt8()		, nil) // overflow
		
		// both ways
		
		XCTAssertEqual(1.uint8     .toData().toUInt8(),	1)
		XCTAssertEqual(255.uint8   .toData().toUInt8(),	255)
		
	}
	
	func testUInt16() {
		
		// .toData
		
		XCTAssertEqual(0b1.uint16.toData(.littleEndian)	, Data([0b1,0]))
		XCTAssertEqual(0b1.uint16.toData(.bigEndian)	, Data([0,0b1]))
		
		// .toUInt16
		
		XCTAssertEqual(Data([])         .toUInt16()		, nil) // underflow
		XCTAssertEqual(Data([1])        .toUInt16()		, nil) // underflow
		XCTAssertEqual(Data([1,2,3])    .toUInt16()		, nil) // overflow
		
		XCTAssertEqual(Data([1,2])      .toUInt16(from: .littleEndian),
					   0b00000010_00000001)
		XCTAssertEqual(Data([1,2])      .toUInt16(from: .bigEndian),
					   0b00000001_00000010)
		
		// both ways
		XCTAssertEqual(Data([1,2])  .toUInt16()?                   .toData()				, Data([1,2]))
		
		XCTAssertEqual(Data([1,2])  .toUInt16(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2]))
		XCTAssertEqual(Data([1,2])  .toUInt16(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2]))
		
		XCTAssertEqual(Data([1,2])  .toUInt16(from: .littleEndian)?.toData(.bigEndian)		, Data([2,1]))
		XCTAssertEqual(Data([1,2])  .toUInt16(from: .bigEndian)?   .toData(.littleEndian)	, Data([2,1]))
		
	}
	
	func testUInt32() {
		
		// .toData
		
		XCTAssertEqual(0b1.uint32.toData(.littleEndian)	, Data([0b1,0,0,0]))
		XCTAssertEqual(0b1.uint32.toData(.bigEndian)	, Data([0,0,0,0b1]))
		
		// .toUInt32
		
		XCTAssertEqual(Data([])         .toUInt32()		, nil) // underflow
		XCTAssertEqual(Data([1])        .toUInt32()		, nil) // underflow
		XCTAssertEqual(Data([1,2])      .toUInt32()		, nil) // underflow
		XCTAssertEqual(Data([1,2,3])    .toUInt32()		, nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5]).toUInt32()		, nil) // overflow
		
		XCTAssertEqual(Data([1,2,3,4])  .toUInt32(from: .littleEndian),
					   0b00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4])  .toUInt32(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100)
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4])  .toUInt32()?                   .toData()				, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toUInt32(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4]))
		XCTAssertEqual(Data([1,2,3,4])  .toUInt32(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toUInt32(from: .littleEndian)?.toData(.bigEndian)		, Data([4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4])  .toUInt32(from: .bigEndian)?   .toData(.littleEndian)	, Data([4,3,2,1]))
		
	}
	
	func testUInt64() {
		
		// .toData
		
		XCTAssertEqual(0b1.uint64.toData(.littleEndian)	, Data([0b1,0,0,0,0,0,0,0]))
		XCTAssertEqual(0b1.uint64.toData(.bigEndian)	, Data([0,0,0,0,0,0,0,0b1]))
		
		// .toUInt64
		
		XCTAssertEqual(Data([])					.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1])				.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2])				.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])			.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4])			.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5])		.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6])		.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7])	.toUInt64(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8,9]).toUInt64(), nil) // overflow
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toUInt64(from: .littleEndian),
					   0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001)
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toUInt64(from: .bigEndian),
					   0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000)
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt64()?                   .toData()				, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt64(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4,5,6,7,8]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt64(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt64(from: .littleEndian)?.toData(.bigEndian)		, Data([8,7,6,5,4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toUInt64(from: .bigEndian)?   .toData(.littleEndian)	, Data([8,7,6,5,4,3,2,1]))
		
	}
	
	
	// MARK: - Floats
	
	func testFloat32() {
		
		// .toData
		
		XCTAssertEqual(0b1.float32.toData(.littleEndian)	, Data([0x00, 0x00, 0x80, 0x3F]))
		XCTAssertEqual(0b1.float32.toData(.bigEndian)		, Data([0x3F, 0x80, 0x00, 0x00]))
		
		// .toFloat32
		
		XCTAssertEqual(Data([])         .toFloat32(), nil) // underflow
		XCTAssertEqual(Data([1])        .toFloat32(), nil) // underflow
		XCTAssertEqual(Data([1,2])      .toFloat32(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])    .toFloat32(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5]).toFloat32(), nil) // overflow
		
		XCTAssertEqual(Data([1,2,3,4])  .toFloat32(from: .littleEndian), 1.5399896e-36)
		XCTAssertEqual(Data([1,2,3,4])  .toFloat32(from: .bigEndian), 2.3879393e-38)
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4])  .toFloat32()?                   .toData()				, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toFloat32(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4]))
		XCTAssertEqual(Data([1,2,3,4])  .toFloat32(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4]))
		
		XCTAssertEqual(Data([1,2,3,4])  .toFloat32(from: .littleEndian)?.toData(.bigEndian)		, Data([4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4])  .toFloat32(from: .bigEndian)?   .toData(.littleEndian)	, Data([4,3,2,1]))
	}
	
	func testDouble() {
		
		// .toData
		
		XCTAssertEqual(0b1.double.toData(.littleEndian)		, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F]))
		XCTAssertEqual(0b1.double.toData(.bigEndian)		, Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
		
		// .toDouble
		
		XCTAssertEqual(Data([])					.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1])				.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1,2])				.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1,2,3])			.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4])			.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5])		.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6])		.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7])	.toDouble(), nil) // underflow
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8,9]).toDouble(), nil) // overflow
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toDouble(from: .littleEndian),	5.447603722011605e-270)
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])	.toDouble(from: .bigEndian),	8.20788039913184e-304)
		
		// both ways
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toDouble()?                   .toData()				, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toDouble(from: .littleEndian)?.toData(.littleEndian)	, Data([1,2,3,4,5,6,7,8]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toDouble(from: .bigEndian)?   .toData(.bigEndian)		, Data([1,2,3,4,5,6,7,8]))
		
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toDouble(from: .littleEndian)?.toData(.bigEndian)		, Data([8,7,6,5,4,3,2,1]))
		XCTAssertEqual(Data([1,2,3,4,5,6,7,8])  .toDouble(from: .bigEndian)?   .toData(.littleEndian)	, Data([8,7,6,5,4,3,2,1]))
		
	}
	
	
	// MARK: - String
	
	func testString() {
		
		// String -> Data
		
		let sourceString = "This is a test string"
		
		let expectedBytes: [UInt8] = [0x54, 0x68, 0x69, 0x73, 0x20, 0x69, 0x73, 0x20, 0x61, 0x20, 0x74, 0x65, 0x73, 0x74, 0x20, 0x73, 0x74, 0x72, 0x69, 0x6E, 0x67]
		
		XCTAssertEqual(sourceString.toData(using: .utf8)!, Data(expectedBytes))
		
		// Data -> String
		
		let convertedString = Data(expectedBytes).toString(using: .utf8)
		
		XCTAssertEqual(convertedString, sourceString)
		
	}
	
	// MARK: - Bytes
	
	func testDataBytes() {
		
		let sourceBytes: [UInt8] = [1,2,3]
		
		// Collection -> Data
		
		XCTAssertEqual(sourceBytes.data, Data([1,2,3]))
		
		// Data -> Collection
		
		XCTAssertEqual(Data(sourceBytes).bytes, [1,2,3])
		
	}
	
}

#endif
