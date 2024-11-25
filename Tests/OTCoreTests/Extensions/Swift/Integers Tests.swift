//
//  Integers Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OTCore

class Extensions_Swift_Integers_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testTypeConversions_IntsToIntsAndFloats() {
        // Int
        
        _ = 1.int
        _ = 1.uInt
        _ = 1.int8
        _ = 1.uInt8
        _ = 1.int16
        _ = 1.uInt16
        _ = 1.int32
        _ = 1.uInt32
        _ = 1.int64
        _ = 1.uInt64
        
        _ = 1.intExactly?.bitWidth
        _ = 1.uIntExactly?.bitWidth
        _ = 1.int8Exactly?.bitWidth
        _ = 1.uInt8Exactly?.bitWidth
        _ = 1.int16Exactly?.bitWidth
        _ = 1.uInt16Exactly?.bitWidth
        _ = 1.int32Exactly?.bitWidth
        _ = 1.uInt32Exactly?.bitWidth
        _ = 1.int64Exactly?.bitWidth
        _ = 1.uInt64Exactly?.bitWidth
        
        _ = 1.double
        _ = 1.doubleExactly?.bitPattern
        
        _ = 1.float
        _ = 1.floatExactly?.bitPattern
        
        _ = 1.float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = 1.float80
        #endif
        
        // UInt
        
        _ = UInt(1).int
        _ = UInt(1).uInt
        _ = UInt(1).int8
        _ = UInt(1).uInt8
        _ = UInt(1).int16
        _ = UInt(1).uInt16
        _ = UInt(1).int32
        _ = UInt(1).uInt32
        _ = UInt(1).int64
        _ = UInt(1).uInt64
        
        _ = UInt(1).intExactly?.bitWidth
        _ = UInt(1).uIntExactly?.bitWidth
        _ = UInt(1).int8Exactly?.bitWidth
        _ = UInt(1).uInt8Exactly?.bitWidth
        _ = UInt(1).int16Exactly?.bitWidth
        _ = UInt(1).uInt16Exactly?.bitWidth
        _ = UInt(1).int32Exactly?.bitWidth
        _ = UInt(1).uInt32Exactly?.bitWidth
        _ = UInt(1).int64Exactly?.bitWidth
        _ = UInt(1).uInt64Exactly?.bitWidth
        
        _ = UInt(1).double
        _ = UInt(1).doubleExactly?.bitPattern
        
        _ = UInt(1).float
        _ = UInt(1).floatExactly?.bitPattern
        
        _ = UInt(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = UInt(1).float80
        #endif
        
        // Int8
        
        _ = Int8(1).int
        _ = Int8(1).uInt
        _ = Int8(1).int8
        _ = Int8(1).uInt8
        _ = Int8(1).int16
        _ = Int8(1).uInt16
        _ = Int8(1).int32
        _ = Int8(1).uInt32
        _ = Int8(1).int64
        _ = Int8(1).uInt64
        
        _ = Int8(1).intExactly?.bitWidth
        _ = Int8(1).uIntExactly?.bitWidth
        _ = Int8(1).int8Exactly?.bitWidth
        _ = Int8(1).uInt8Exactly?.bitWidth
        _ = Int8(1).int16Exactly?.bitWidth
        _ = Int8(1).uInt16Exactly?.bitWidth
        _ = Int8(1).int32Exactly?.bitWidth
        _ = Int8(1).uInt32Exactly?.bitWidth
        _ = Int8(1).int64Exactly?.bitWidth
        _ = Int8(1).uInt64Exactly?.bitWidth
        
        _ = Int8(1).double
        _ = Int8(1).doubleExactly?.bitPattern
        
        _ = Int8(1).float
        _ = Int8(1).floatExactly?.bitPattern
        
        _ = Int8(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = Int8(1).float80
        #endif
        
        // UInt8
        
        _ = UInt8(1).int
        _ = UInt8(1).uInt
        _ = UInt8(1).int8
        _ = UInt8(1).uInt8
        _ = UInt8(1).int16
        _ = UInt8(1).uInt16
        _ = UInt8(1).int32
        _ = UInt8(1).uInt32
        _ = UInt8(1).int64
        _ = UInt8(1).uInt64
        
        _ = UInt8(1).int.intExactly?.bitWidth
        _ = UInt8(1).uInt.intExactly?.bitWidth
        _ = UInt8(1).int8.intExactly?.bitWidth
        _ = UInt8(1).uInt8.intExactly?.bitWidth
        _ = UInt8(1).int16.intExactly?.bitWidth
        _ = UInt8(1).uInt16.intExactly?.bitWidth
        _ = UInt8(1).int32.intExactly?.bitWidth
        _ = UInt8(1).uInt32.intExactly?.bitWidth
        _ = UInt8(1).int64.intExactly?.bitWidth
        _ = UInt8(1).uInt64.intExactly?.bitWidth
        
        _ = UInt8(1).double
        _ = UInt8(1).doubleExactly?.bitPattern
        
        _ = UInt8(1).float
        _ = UInt8(1).floatExactly?.bitPattern
        
        _ = UInt8(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = UInt8(1).float80
        #endif
        
        // Int16
        
        _ = Int16(1).int
        _ = Int16(1).uInt
        _ = Int16(1).int8
        _ = Int16(1).uInt8
        _ = Int16(1).int16
        _ = Int16(1).uInt16
        _ = Int16(1).int32
        _ = Int16(1).uInt32
        _ = Int16(1).int64
        _ = Int16(1).uInt64
        
        _ = Int16(1).int.intExactly?.bitWidth
        _ = Int16(1).uInt.intExactly?.bitWidth
        _ = Int16(1).int8.intExactly?.bitWidth
        _ = Int16(1).uInt8.intExactly?.bitWidth
        _ = Int16(1).int16.intExactly?.bitWidth
        _ = Int16(1).uInt16.intExactly?.bitWidth
        _ = Int16(1).int32.intExactly?.bitWidth
        _ = Int16(1).uInt32.intExactly?.bitWidth
        _ = Int16(1).int64.intExactly?.bitWidth
        _ = Int16(1).uInt64.intExactly?.bitWidth
        
        _ = Int16(1).double
        _ = Int16(1).doubleExactly?.bitPattern
        
        _ = Int16(1).float
        _ = Int16(1).floatExactly?.bitPattern
        
        _ = Int16(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = Int16(1).float80
        #endif
        
        // UInt16
        
        _ = UInt16(1).int
        _ = UInt16(1).uInt
        _ = UInt16(1).int8
        _ = UInt16(1).uInt8
        _ = UInt16(1).int16
        _ = UInt16(1).uInt16
        _ = UInt16(1).int32
        _ = UInt16(1).uInt32
        _ = UInt16(1).int64
        _ = UInt16(1).uInt64
        
        _ = UInt16(1).int.intExactly?.bitWidth
        _ = UInt16(1).uInt.intExactly?.bitWidth
        _ = UInt16(1).int8.intExactly?.bitWidth
        _ = UInt16(1).uInt8.intExactly?.bitWidth
        _ = UInt16(1).int16.intExactly?.bitWidth
        _ = UInt16(1).uInt16.intExactly?.bitWidth
        _ = UInt16(1).int32.intExactly?.bitWidth
        _ = UInt16(1).uInt32.intExactly?.bitWidth
        _ = UInt16(1).int64.intExactly?.bitWidth
        _ = UInt16(1).uInt64.intExactly?.bitWidth
        
        _ = UInt16(1).double
        _ = UInt16(1).doubleExactly?.bitPattern
        
        _ = UInt16(1).float
        _ = UInt16(1).floatExactly?.bitPattern
        
        _ = UInt16(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = UInt16(1).float80
        #endif
        
        // Int32
        
        _ = Int32(1).int
        _ = Int32(1).uInt
        _ = Int32(1).int8
        _ = Int32(1).uInt8
        _ = Int32(1).int16
        _ = Int32(1).uInt16
        _ = Int32(1).int32
        _ = Int32(1).uInt32
        _ = Int32(1).int64
        _ = Int32(1).uInt64
        
        _ = Int32(1).int.intExactly?.bitWidth
        _ = Int32(1).uInt.intExactly?.bitWidth
        _ = Int32(1).int8.intExactly?.bitWidth
        _ = Int32(1).uInt8.intExactly?.bitWidth
        _ = Int32(1).int16.intExactly?.bitWidth
        _ = Int32(1).uInt16.intExactly?.bitWidth
        _ = Int32(1).int32.intExactly?.bitWidth
        _ = Int32(1).uInt32.intExactly?.bitWidth
        _ = Int32(1).int64.intExactly?.bitWidth
        _ = Int32(1).uInt64.intExactly?.bitWidth
        
        _ = Int32(1).double
        _ = Int32(1).doubleExactly?.bitPattern
        
        _ = Int32(1).float
        _ = Int32(1).floatExactly?.bitPattern
        
        _ = Int32(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = Int32(1).float80
        #endif
        
        // UInt32
        
        _ = UInt32(1).int
        _ = UInt32(1).uInt
        _ = UInt32(1).int8
        _ = UInt32(1).uInt8
        _ = UInt32(1).int16
        _ = UInt32(1).uInt16
        _ = UInt32(1).int32
        _ = UInt32(1).uInt32
        _ = UInt32(1).int64
        _ = UInt32(1).uInt64
        
        _ = UInt32(1).int.intExactly?.bitWidth
        _ = UInt32(1).uInt.intExactly?.bitWidth
        _ = UInt32(1).int8.intExactly?.bitWidth
        _ = UInt32(1).uInt8.intExactly?.bitWidth
        _ = UInt32(1).int16.intExactly?.bitWidth
        _ = UInt32(1).uInt16.intExactly?.bitWidth
        _ = UInt32(1).int32.intExactly?.bitWidth
        _ = UInt32(1).uInt32.intExactly?.bitWidth
        _ = UInt32(1).int64.intExactly?.bitWidth
        _ = UInt32(1).uInt64.intExactly?.bitWidth
        
        _ = UInt32(1).double
        _ = UInt32(1).doubleExactly?.bitPattern
        
        _ = UInt32(1).float
        _ = UInt32(1).floatExactly?.bitPattern
        
        _ = UInt32(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = UInt32(1).float80
        #endif
        
        // Int64
        
        _ = Int64(1).int
        _ = Int64(1).uInt
        _ = Int64(1).int8
        _ = Int64(1).uInt8
        _ = Int64(1).int16
        _ = Int64(1).uInt16
        _ = Int64(1).int32
        _ = Int64(1).uInt32
        _ = Int64(1).int64
        _ = Int64(1).uInt64
        
        _ = Int64(1).int.intExactly?.bitWidth
        _ = Int64(1).uInt.intExactly?.bitWidth
        _ = Int64(1).int8.intExactly?.bitWidth
        _ = Int64(1).uInt8.intExactly?.bitWidth
        _ = Int64(1).int16.intExactly?.bitWidth
        _ = Int64(1).uInt16.intExactly?.bitWidth
        _ = Int64(1).int32.intExactly?.bitWidth
        _ = Int64(1).uInt32.intExactly?.bitWidth
        _ = Int64(1).int64.intExactly?.bitWidth
        _ = Int64(1).uInt64.intExactly?.bitWidth
        
        _ = Int64(1).double
        _ = Int64(1).doubleExactly?.bitPattern
        
        _ = Int64(1).float
        _ = Int64(1).floatExactly?.bitPattern
        
        _ = Int64(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = Int64(1).float80
        #endif
        
        // UInt64
        
        _ = UInt64(1).int
        _ = UInt64(1).uInt
        _ = UInt64(1).int8
        _ = UInt64(1).uInt8
        _ = UInt64(1).int16
        _ = UInt64(1).uInt16
        _ = UInt64(1).int32
        _ = UInt64(1).uInt32
        _ = UInt64(1).int64
        _ = UInt64(1).uInt64
        
        _ = UInt64(1).int.intExactly?.bitWidth
        _ = UInt64(1).uInt.intExactly?.bitWidth
        _ = UInt64(1).int8.intExactly?.bitWidth
        _ = UInt64(1).uInt8.intExactly?.bitWidth
        _ = UInt64(1).int16.intExactly?.bitWidth
        _ = UInt64(1).uInt16.intExactly?.bitWidth
        _ = UInt64(1).int32.intExactly?.bitWidth
        _ = UInt64(1).uInt32.intExactly?.bitWidth
        _ = UInt64(1).int64.intExactly?.bitWidth
        _ = UInt64(1).uInt64.intExactly?.bitWidth
        
        _ = UInt64(1).double
        _ = UInt64(1).doubleExactly?.bitPattern
        
        _ = UInt64(1).float
        _ = UInt64(1).floatExactly?.bitPattern
        
        _ = UInt64(1).float32
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = UInt64(1).float80
        #endif
    }
    
    func testTypeConversions_StringToInts() {
        XCTAssertEqual("1".int, 1)
        XCTAssertEqual("1".uInt, UInt(1))
        XCTAssertEqual("1".int8, Int8(1))
        XCTAssertEqual("1".uInt8, UInt8(1))
        XCTAssertEqual("1".int16, Int16(1))
        XCTAssertEqual("1".uInt16, UInt16(1))
        XCTAssertEqual("1".int32, Int32(1))
        XCTAssertEqual("1".uInt32, UInt32(1))
        XCTAssertEqual("1".int64, Int64(1))
        XCTAssertEqual("1".uInt64, UInt64(1))
    }
    
    func testTypeConversions_IntsToString() {
        XCTAssertEqual(1.string, "1")
        XCTAssertEqual(UInt(1).string, "1")
        XCTAssertEqual(Int8(1).string, "1")
        XCTAssertEqual(UInt8(1).string, "1")
        XCTAssertEqual(Int16(1).string, "1")
        XCTAssertEqual(UInt16(1).string, "1")
        XCTAssertEqual(Int32(1).string, "1")
        XCTAssertEqual(UInt32(1).string, "1")
        XCTAssertEqual(Int64(1).string, "1")
        XCTAssertEqual(UInt64(1).string, "1")
    }
    
    func testRounding() {
        XCTAssertEqual((-5).roundedAwayFromZero(toMultiplesOf: 4), -8)
        XCTAssertEqual((-1).roundedAwayFromZero(toMultiplesOf: 4), -4)
        XCTAssertEqual(1.roundedAwayFromZero(toMultiplesOf: 1), 1)
        XCTAssertEqual(1.roundedAwayFromZero(toMultiplesOf: 4), 4)
        XCTAssertEqual(4.roundedAwayFromZero(toMultiplesOf: 4), 4)
        XCTAssertEqual(5.roundedAwayFromZero(toMultiplesOf: 4), 8)
        
        XCTAssertEqual((-5).roundedUp(toMultiplesOf: 4), -4)
        XCTAssertEqual((-1).roundedUp(toMultiplesOf: 4),  0)
        XCTAssertEqual(1.roundedUp(toMultiplesOf: 1), 1)
        XCTAssertEqual(1.roundedUp(toMultiplesOf: 4), 4)
        XCTAssertEqual(4.roundedUp(toMultiplesOf: 4), 4)
        XCTAssertEqual(5.roundedUp(toMultiplesOf: 4), 8)
        
        XCTAssertEqual((-5).roundedDown(toMultiplesOf: 4),  -8)
        XCTAssertEqual((-1).roundedDown(toMultiplesOf: 4),  -4)
        XCTAssertEqual(1.roundedDown(toMultiplesOf: 1), 1)
        XCTAssertEqual(1.roundedDown(toMultiplesOf: 4), 0)
        XCTAssertEqual(4.roundedDown(toMultiplesOf: 4), 4)
        XCTAssertEqual(5.roundedDown(toMultiplesOf: 4), 4)
    }
    
    func testBit() {
        XCTAssertEqual(0b100.uInt8.bit(0), 0)
        XCTAssertEqual(0b100.uInt8.bit(1), 0)
        XCTAssertEqual(0b100.uInt8.bit(2), 1)
    }
    
    func testInt8twosComplement() {
        XCTAssertEqual(Int8(-0b01000000).twosComplement, 0b11000000)
    }
    
    func testCollectionRandomNumbers() {
        // typical types
        
        _ = [Int](randomValuesBetween: 0 ... 255, count: 4)
        _ = [UInt](randomValuesBetween: 0 ... 255, count: 4)
        _ = [Int8](randomValuesBetween: -128 ... 127, count: 4)
        _ = [UInt8](randomValuesBetween: 0 ... 255, count: 4)
        _ = [Int16](randomValuesBetween: 0 ... 255, count: 4)
        _ = [UInt16](randomValuesBetween: 0 ... 255, count: 4)
        _ = [Int32](randomValuesBetween: 0 ... 255, count: 4)
        _ = [UInt32](randomValuesBetween: 0 ... 255, count: 4)
        _ = [Int64](randomValuesBetween: 0 ... 255, count: 4)
        _ = [UInt64](randomValuesBetween: 0 ... 255, count: 4)
        
        // spot check
        
        let range = UInt8(0) ... UInt8(255)
        
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
        
        XCTAssertEqual(1.wrapped(around: 0 ... 0), 0)
        XCTAssertEqual(1.wrapped(around: -1 ... (-1)), -1)
        
        // basic ranges
        
        XCTAssertEqual((-11).wrapped(around: 0 ... 4), 4)
        XCTAssertEqual((-10).wrapped(around: 0 ... 4), 0)
        XCTAssertEqual((-9).wrapped(around: 0 ... 4), 1)
        XCTAssertEqual((-8).wrapped(around: 0 ... 4), 2)
        XCTAssertEqual((-7).wrapped(around: 0 ... 4), 3)
        XCTAssertEqual((-6).wrapped(around: 0 ... 4), 4)
        XCTAssertEqual((-5).wrapped(around: 0 ... 4), 0)
        XCTAssertEqual((-4).wrapped(around: 0 ... 4), 1)
        XCTAssertEqual((-3).wrapped(around: 0 ... 4), 2)
        XCTAssertEqual((-2).wrapped(around: 0 ... 4), 3)
        XCTAssertEqual((-1).wrapped(around: 0 ... 4), 4)
        XCTAssertEqual(0.wrapped(around: 0 ... 4), 0)
        XCTAssertEqual(1.wrapped(around: 0 ... 4), 1)
        XCTAssertEqual(2.wrapped(around: 0 ... 4), 2)
        XCTAssertEqual(3.wrapped(around: 0 ... 4), 3)
        XCTAssertEqual(4.wrapped(around: 0 ... 4), 4)
        XCTAssertEqual(5.wrapped(around: 0 ... 4), 0)
        XCTAssertEqual(6.wrapped(around: 0 ... 4), 1)
        XCTAssertEqual(7.wrapped(around: 0 ... 4), 2)
        XCTAssertEqual(8.wrapped(around: 0 ... 4), 3)
        XCTAssertEqual(9.wrapped(around: 0 ... 4), 4)
        XCTAssertEqual(10.wrapped(around: 0 ... 4), 0)
        XCTAssertEqual(11.wrapped(around: 0 ... 4), 1)
        
        XCTAssertEqual((-11).wrapped(around: 1 ... 5), 4)
        XCTAssertEqual((-10).wrapped(around: 1 ... 5), 5)
        XCTAssertEqual((-9).wrapped(around: 1 ... 5), 1)
        XCTAssertEqual((-8).wrapped(around: 1 ... 5), 2)
        XCTAssertEqual((-7).wrapped(around: 1 ... 5), 3)
        XCTAssertEqual((-6).wrapped(around: 1 ... 5), 4)
        XCTAssertEqual((-5).wrapped(around: 1 ... 5), 5)
        XCTAssertEqual((-4).wrapped(around: 1 ... 5), 1)
        XCTAssertEqual((-3).wrapped(around: 1 ... 5), 2)
        XCTAssertEqual((-2).wrapped(around: 1 ... 5), 3)
        XCTAssertEqual((-1).wrapped(around: 1 ... 5), 4)
        XCTAssertEqual(0.wrapped(around: 1 ... 5), 5)
        XCTAssertEqual(1.wrapped(around: 1 ... 5), 1)
        XCTAssertEqual(2.wrapped(around: 1 ... 5), 2)
        XCTAssertEqual(3.wrapped(around: 1 ... 5), 3)
        XCTAssertEqual(4.wrapped(around: 1 ... 5), 4)
        XCTAssertEqual(5.wrapped(around: 1 ... 5), 5)
        XCTAssertEqual(6.wrapped(around: 1 ... 5), 1)
        XCTAssertEqual(7.wrapped(around: 1 ... 5), 2)
        XCTAssertEqual(8.wrapped(around: 1 ... 5), 3)
        XCTAssertEqual(9.wrapped(around: 1 ... 5), 4)
        XCTAssertEqual(10.wrapped(around: 1 ... 5), 5)
        XCTAssertEqual(11.wrapped(around: 1 ... 5), 1)
        
        XCTAssertEqual((-11).wrapped(around: -1 ... 3), -1)
        XCTAssertEqual((-10).wrapped(around: -1 ... 3),  0)
        XCTAssertEqual((-9).wrapped(around: -1 ... 3),  1)
        XCTAssertEqual((-8).wrapped(around: -1 ... 3),  2)
        XCTAssertEqual((-7).wrapped(around: -1 ... 3),  3)
        XCTAssertEqual((-6).wrapped(around: -1 ... 3), -1)
        XCTAssertEqual((-5).wrapped(around: -1 ... 3),  0)
        XCTAssertEqual((-4).wrapped(around: -1 ... 3),  1)
        XCTAssertEqual((-3).wrapped(around: -1 ... 3),  2)
        XCTAssertEqual((-2).wrapped(around: -1 ... 3),  3)
        XCTAssertEqual((-1).wrapped(around: -1 ... 3), -1)
        XCTAssertEqual(0.wrapped(around: -1 ... 3),  0)
        XCTAssertEqual(1.wrapped(around: -1 ... 3),  1)
        XCTAssertEqual(2.wrapped(around: -1 ... 3),  2)
        XCTAssertEqual(3.wrapped(around: -1 ... 3),  3)
        XCTAssertEqual(4.wrapped(around: -1 ... 3), -1)
        XCTAssertEqual(5.wrapped(around: -1 ... 3),  0)
        XCTAssertEqual(6.wrapped(around: -1 ... 3),  1)
        XCTAssertEqual(7.wrapped(around: -1 ... 3),  2)
        XCTAssertEqual(8.wrapped(around: -1 ... 3),  3)
        XCTAssertEqual(9.wrapped(around: -1 ... 3), -1)
        XCTAssertEqual(10.wrapped(around: -1 ... 3),  0)
        XCTAssertEqual(11.wrapped(around: -1 ... 3),  1)
        
        // Range
        
        // single value ranges
        
        XCTAssertEqual(1.wrapped(around: 0 ..< 0),  0)
        XCTAssertEqual(1.wrapped(around: -1 ..< (-1)), -1)
        
        // basic ranges
        
        XCTAssertEqual((-11).wrapped(around: 0 ..< 4), 1)
        XCTAssertEqual((-10).wrapped(around: 0 ..< 4), 2)
        XCTAssertEqual((-9).wrapped(around: 0 ..< 4), 3)
        XCTAssertEqual((-8).wrapped(around: 0 ..< 4), 0)
        XCTAssertEqual((-7).wrapped(around: 0 ..< 4), 1)
        XCTAssertEqual((-6).wrapped(around: 0 ..< 4), 2)
        XCTAssertEqual((-5).wrapped(around: 0 ..< 4), 3)
        XCTAssertEqual((-4).wrapped(around: 0 ..< 4), 0)
        XCTAssertEqual((-3).wrapped(around: 0 ..< 4), 1)
        XCTAssertEqual((-2).wrapped(around: 0 ..< 4), 2)
        XCTAssertEqual((-1).wrapped(around: 0 ..< 4), 3)
        XCTAssertEqual(0.wrapped(around: 0 ..< 4), 0)
        XCTAssertEqual(1.wrapped(around: 0 ..< 4), 1)
        XCTAssertEqual(2.wrapped(around: 0 ..< 4), 2)
        XCTAssertEqual(3.wrapped(around: 0 ..< 4), 3)
        XCTAssertEqual(4.wrapped(around: 0 ..< 4), 0)
        XCTAssertEqual(5.wrapped(around: 0 ..< 4), 1)
        XCTAssertEqual(6.wrapped(around: 0 ..< 4), 2)
        XCTAssertEqual(7.wrapped(around: 0 ..< 4), 3)
        XCTAssertEqual(8.wrapped(around: 0 ..< 4), 0)
        XCTAssertEqual(9.wrapped(around: 0 ..< 4), 1)
        XCTAssertEqual(10.wrapped(around: 0 ..< 4), 2)
        XCTAssertEqual(11.wrapped(around: 0 ..< 4), 3)
    }
    
    func testNumberOfDigits() {
        XCTAssertEqual(0.numberOfDigits, 1)
        XCTAssertEqual(1.numberOfDigits, 1)
        XCTAssertEqual(10.numberOfDigits, 2)
        XCTAssertEqual(15.numberOfDigits, 2)
        XCTAssertEqual(205.numberOfDigits, 3)
        
        XCTAssertEqual((-0).numberOfDigits, 1)
        XCTAssertEqual((-1).numberOfDigits, 1)
        XCTAssertEqual((-10).numberOfDigits, 2)
        XCTAssertEqual((-15).numberOfDigits, 2)
        XCTAssertEqual((-205).numberOfDigits, 3)
    }
}
