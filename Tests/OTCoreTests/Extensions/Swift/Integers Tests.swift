//
//  Integers Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Extensions_Swift_Integers_Tests {
    @Test
    func typeConversions_IntsToIntsAndFloats() {
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
    
    @Test
    func typeConversions_StringToInts() {
        #expect("1".int == 1)
        #expect("1".uInt == UInt(1))
        #expect("1".int8 == Int8(1))
        #expect("1".uInt8 == UInt8(1))
        #expect("1".int16 == Int16(1))
        #expect("1".uInt16 == UInt16(1))
        #expect("1".int32 == Int32(1))
        #expect("1".uInt32 == UInt32(1))
        #expect("1".int64 == Int64(1))
        #expect("1".uInt64 == UInt64(1))
    }
    
    @Test
    func typeConversions_IntsToString() {
        #expect(1.string == "1")
        #expect(UInt(1).string == "1")
        #expect(Int8(1).string == "1")
        #expect(UInt8(1).string == "1")
        #expect(Int16(1).string == "1")
        #expect(UInt16(1).string == "1")
        #expect(Int32(1).string == "1")
        #expect(UInt32(1).string == "1")
        #expect(Int64(1).string == "1")
        #expect(UInt64(1).string == "1")
    }
    
    @Test
    func rounding() {
        #expect((-5).roundedAwayFromZero(toMultiplesOf: 4) == -8)
        #expect((-1).roundedAwayFromZero(toMultiplesOf: 4) == -4)
        #expect(1.roundedAwayFromZero(toMultiplesOf: 1) == 1)
        #expect(1.roundedAwayFromZero(toMultiplesOf: 4) == 4)
        #expect(4.roundedAwayFromZero(toMultiplesOf: 4) == 4)
        #expect(5.roundedAwayFromZero(toMultiplesOf: 4) == 8)
        
        #expect((-5).roundedUp(toMultiplesOf: 4) == -4)
        #expect((-1).roundedUp(toMultiplesOf: 4) == 0)
        #expect(1.roundedUp(toMultiplesOf: 1) == 1)
        #expect(1.roundedUp(toMultiplesOf: 4) == 4)
        #expect(4.roundedUp(toMultiplesOf: 4) == 4)
        #expect(5.roundedUp(toMultiplesOf: 4) == 8)
        
        #expect((-5).roundedDown(toMultiplesOf: 4) == -8)
        #expect((-1).roundedDown(toMultiplesOf: 4) == -4)
        #expect(1.roundedDown(toMultiplesOf: 1) == 1)
        #expect(1.roundedDown(toMultiplesOf: 4) == 0)
        #expect(4.roundedDown(toMultiplesOf: 4) == 4)
        #expect(5.roundedDown(toMultiplesOf: 4) == 4)
    }
    
    @Test
    func uInt8_bit() {
        #expect(0b100.uInt8.bit(0) == 0)
        #expect(0b100.uInt8.bit(1) == 0)
        #expect(0b100.uInt8.bit(2) == 1)
    }
    
    @Test
    func int8twosComplement() {
        #expect(Int8(-0b01000000).twosComplement == 0b11000000)
    }
    
    @Test
    func collectionRandomNumbers() {
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
        #expect(arr.count == 4)
        
        // ensure each value is within range
        for item in arr {
            #expect(range.contains(item))
        }
    }
    
    @Test
    func wrappingNumbers() {
        // ClosedRange
        
        // single value ranges
        
        #expect(1.wrapped(around: 0 ... 0) == 0)
        #expect(1.wrapped(around: -1 ... (-1)) == -1)
        
        // basic ranges
        
        #expect((-11).wrapped(around: 0 ... 4) == 4)
        #expect((-10).wrapped(around: 0 ... 4) == 0)
        #expect((-9).wrapped(around: 0 ... 4) == 1)
        #expect((-8).wrapped(around: 0 ... 4) == 2)
        #expect((-7).wrapped(around: 0 ... 4) == 3)
        #expect((-6).wrapped(around: 0 ... 4) == 4)
        #expect((-5).wrapped(around: 0 ... 4) == 0)
        #expect((-4).wrapped(around: 0 ... 4) == 1)
        #expect((-3).wrapped(around: 0 ... 4) == 2)
        #expect((-2).wrapped(around: 0 ... 4) == 3)
        #expect((-1).wrapped(around: 0 ... 4) == 4)
        #expect(0.wrapped(around: 0 ... 4) == 0)
        #expect(1.wrapped(around: 0 ... 4) == 1)
        #expect(2.wrapped(around: 0 ... 4) == 2)
        #expect(3.wrapped(around: 0 ... 4) == 3)
        #expect(4.wrapped(around: 0 ... 4) == 4)
        #expect(5.wrapped(around: 0 ... 4) == 0)
        #expect(6.wrapped(around: 0 ... 4) == 1)
        #expect(7.wrapped(around: 0 ... 4) == 2)
        #expect(8.wrapped(around: 0 ... 4) == 3)
        #expect(9.wrapped(around: 0 ... 4) == 4)
        #expect(10.wrapped(around: 0 ... 4) == 0)
        #expect(11.wrapped(around: 0 ... 4) == 1)
        
        #expect((-11).wrapped(around: 1 ... 5) == 4)
        #expect((-10).wrapped(around: 1 ... 5) == 5)
        #expect((-9).wrapped(around: 1 ... 5) == 1)
        #expect((-8).wrapped(around: 1 ... 5) == 2)
        #expect((-7).wrapped(around: 1 ... 5) == 3)
        #expect((-6).wrapped(around: 1 ... 5) == 4)
        #expect((-5).wrapped(around: 1 ... 5) == 5)
        #expect((-4).wrapped(around: 1 ... 5) == 1)
        #expect((-3).wrapped(around: 1 ... 5) == 2)
        #expect((-2).wrapped(around: 1 ... 5) == 3)
        #expect((-1).wrapped(around: 1 ... 5) == 4)
        #expect(0.wrapped(around: 1 ... 5) == 5)
        #expect(1.wrapped(around: 1 ... 5) == 1)
        #expect(2.wrapped(around: 1 ... 5) == 2)
        #expect(3.wrapped(around: 1 ... 5) == 3)
        #expect(4.wrapped(around: 1 ... 5) == 4)
        #expect(5.wrapped(around: 1 ... 5) == 5)
        #expect(6.wrapped(around: 1 ... 5) == 1)
        #expect(7.wrapped(around: 1 ... 5) == 2)
        #expect(8.wrapped(around: 1 ... 5) == 3)
        #expect(9.wrapped(around: 1 ... 5) == 4)
        #expect(10.wrapped(around: 1 ... 5) == 5)
        #expect(11.wrapped(around: 1 ... 5) == 1)
        
        #expect((-11).wrapped(around: -1 ... 3) == -1)
        #expect((-10).wrapped(around: -1 ... 3) == 0)
        #expect((-9).wrapped(around: -1 ... 3) == 1)
        #expect((-8).wrapped(around: -1 ... 3) == 2)
        #expect((-7).wrapped(around: -1 ... 3) == 3)
        #expect((-6).wrapped(around: -1 ... 3) == -1)
        #expect((-5).wrapped(around: -1 ... 3) == 0)
        #expect((-4).wrapped(around: -1 ... 3) == 1)
        #expect((-3).wrapped(around: -1 ... 3) == 2)
        #expect((-2).wrapped(around: -1 ... 3) == 3)
        #expect((-1).wrapped(around: -1 ... 3) == -1)
        #expect(0.wrapped(around: -1 ... 3) == 0)
        #expect(1.wrapped(around: -1 ... 3) == 1)
        #expect(2.wrapped(around: -1 ... 3) == 2)
        #expect(3.wrapped(around: -1 ... 3) == 3)
        #expect(4.wrapped(around: -1 ... 3) == -1)
        #expect(5.wrapped(around: -1 ... 3) == 0)
        #expect(6.wrapped(around: -1 ... 3) == 1)
        #expect(7.wrapped(around: -1 ... 3) == 2)
        #expect(8.wrapped(around: -1 ... 3) == 3)
        #expect(9.wrapped(around: -1 ... 3) == -1)
        #expect(10.wrapped(around: -1 ... 3) == 0)
        #expect(11.wrapped(around: -1 ... 3) == 1)
        
        // Range
        
        // single value ranges
        
        #expect(1.wrapped(around: 0 ..< 0) == 0)
        #expect(1.wrapped(around: -1 ..< (-1)) == -1)
        
        // basic ranges
        
        #expect((-11).wrapped(around: 0 ..< 4) == 1)
        #expect((-10).wrapped(around: 0 ..< 4) == 2)
        #expect((-9).wrapped(around: 0 ..< 4) == 3)
        #expect((-8).wrapped(around: 0 ..< 4) == 0)
        #expect((-7).wrapped(around: 0 ..< 4) == 1)
        #expect((-6).wrapped(around: 0 ..< 4) == 2)
        #expect((-5).wrapped(around: 0 ..< 4) == 3)
        #expect((-4).wrapped(around: 0 ..< 4) == 0)
        #expect((-3).wrapped(around: 0 ..< 4) == 1)
        #expect((-2).wrapped(around: 0 ..< 4) == 2)
        #expect((-1).wrapped(around: 0 ..< 4) == 3)
        #expect(0.wrapped(around: 0 ..< 4) == 0)
        #expect(1.wrapped(around: 0 ..< 4) == 1)
        #expect(2.wrapped(around: 0 ..< 4) == 2)
        #expect(3.wrapped(around: 0 ..< 4) == 3)
        #expect(4.wrapped(around: 0 ..< 4) == 0)
        #expect(5.wrapped(around: 0 ..< 4) == 1)
        #expect(6.wrapped(around: 0 ..< 4) == 2)
        #expect(7.wrapped(around: 0 ..< 4) == 3)
        #expect(8.wrapped(around: 0 ..< 4) == 0)
        #expect(9.wrapped(around: 0 ..< 4) == 1)
        #expect(10.wrapped(around: 0 ..< 4) == 2)
        #expect(11.wrapped(around: 0 ..< 4) == 3)
    }
    
    @Test
    func numberOfDigits() {
        #expect(0.numberOfDigits == 1)
        #expect(1.numberOfDigits == 1)
        #expect(10.numberOfDigits == 2)
        #expect(15.numberOfDigits == 2)
        #expect(205.numberOfDigits == 3)
        
        #expect((-0).numberOfDigits == 1)
        #expect((-1).numberOfDigits == 1)
        #expect((-10).numberOfDigits == 2)
        #expect((-15).numberOfDigits == 2)
        #expect((-205).numberOfDigits == 3)
    }
}
