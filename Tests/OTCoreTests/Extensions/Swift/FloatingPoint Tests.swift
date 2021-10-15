//
//  FloatingPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
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
        
        _ = double.double
        _ = double.doubleExactly
        _ = double.float
        _ = double.floatExactly
        _ = double.float32
        _ = double.float32Exactly
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = double.float80
        #endif
        
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
        
        _ = float80.double
        _ = float80.doubleExactly
        _ = float80.float
        _ = float80.floatExactly
        _ = float80.float32
        _ = float80.float32Exactly
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = float80.float80
        #endif
        
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
        
        _ = cgfloat.double
        _ = cgfloat.doubleExactly
        _ = cgfloat.float
        _ = cgfloat.floatExactly
        _ = cgfloat.float32
        _ = cgfloat.float32Exactly
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        _ = cgfloat.float80
        #endif
        
    }
    
    func testBoolValue() {
        
        // double
        XCTAssertEqual(Double( -1.0)       .boolValue, false)
        XCTAssertEqual(Double(  0.0)       .boolValue, false)
        XCTAssertEqual(Double(  1.0)       .boolValue, true)
        XCTAssertEqual(Double(123.0)       .boolValue, true)
        XCTAssertEqual(Double.nan          .boolValue, false)
        XCTAssertEqual(Double.signalingNaN .boolValue, false)
        XCTAssertEqual(Double.infinity     .boolValue, true)
        
        // float
        XCTAssertEqual(Float( -1.0)        .boolValue, false)
        XCTAssertEqual(Float(  0.0)        .boolValue, false)
        XCTAssertEqual(Float(  1.0)        .boolValue, true)
        XCTAssertEqual(Float(123.0)        .boolValue, true)
        XCTAssertEqual(Float.nan           .boolValue, false)
        XCTAssertEqual(Float.signalingNaN  .boolValue, false)
        XCTAssertEqual(Float.infinity      .boolValue, true)
        
        // float80
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        XCTAssertEqual(Float80( -1.0)      .boolValue, false)
        XCTAssertEqual(Float80(  0.0)      .boolValue, false)
        XCTAssertEqual(Float80(  1.0)      .boolValue, true)
        XCTAssertEqual(Float80(123.0)      .boolValue, true)
        XCTAssertEqual(Float80.nan         .boolValue, false)
        XCTAssertEqual(Float80.signalingNaN.boolValue, false)
        XCTAssertEqual(Float80.infinity    .boolValue, true)
        #endif
        
        // cgfloat
        XCTAssertEqual(CGFloat( -1.0)      .boolValue, false)
        XCTAssertEqual(CGFloat(  0.0)      .boolValue, false)
        XCTAssertEqual(CGFloat(  1.0)      .boolValue, true)
        XCTAssertEqual(CGFloat(123.0)      .boolValue, true)
        XCTAssertEqual(CGFloat.nan         .boolValue, false)
        XCTAssertEqual(CGFloat.signalingNaN.boolValue, false)
        XCTAssertEqual(CGFloat.infinity    .boolValue, true)
        
    }
    
    func testRounded() {
        
        // Double .rounded(decimalPlaces:)
        
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces: -1), 2.0)
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces:  0), 2.0)
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces:  1), 1.6)
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces:  2), 1.62)
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces:  3), 1.625)
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces:  4), 1.6246)
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces:  5), 1.62456)
        XCTAssertEqual(Double(1.62456).rounded(decimalPlaces:  6), 1.62456)
        
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces: -1), 2.0)
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces:  0), 2.0)
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces:  1), 1.7)
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces:  2), 1.63)
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces:  3), 1.625)
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces:  4), 1.6246)
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces:  5), 1.62456)
        XCTAssertEqual(Double(1.62456).rounded(.up, decimalPlaces:  6), 1.62456)
        
        // negative values
        
        XCTAssertEqual(Double(-1.62456).rounded(decimalPlaces: 2), -1.62)
        XCTAssertEqual(Double(-1.62456).rounded(.up, decimalPlaces: 1), -1.6)
        XCTAssertEqual(Double(-1.62456).rounded(.up, decimalPlaces: 2), -1.62)
        XCTAssertEqual(Double(-1.62456).rounded(.down, decimalPlaces: 1), -1.7)
        XCTAssertEqual(Double(-1.62456).rounded(.down, decimalPlaces: 2), -1.63)
        
        // edge cases
        
        XCTAssert(Double.nan.rounded(decimalPlaces: 2).isNaN)
        XCTAssert(Double.signalingNaN.rounded(decimalPlaces: 2).isNaN)
        XCTAssertEqual(Double.infinity.rounded(decimalPlaces: 2), .infinity)
        
        XCTAssert(Float.nan.rounded(decimalPlaces: 2).isNaN)
        XCTAssert(Float.signalingNaN.rounded(decimalPlaces: 2).isNaN)
        XCTAssertEqual(Float.infinity.rounded(decimalPlaces: 2), .infinity)
        
        XCTAssert(CGFloat.nan.rounded(decimalPlaces: 2).isNaN)
        XCTAssert(CGFloat.signalingNaN.rounded(decimalPlaces: 2).isNaN)
        XCTAssertEqual(CGFloat.infinity.rounded(decimalPlaces: 2), .infinity)
        
    }
    
    func testRound() {
        
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
        
        XCTAssertEqual(    1.0.wrapped(around: 0...0)    ,  0)
        XCTAssertEqual(    1.0.wrapped(around: -1...(-1)), -1)
        
        // basic ranges
        
        XCTAssertEqual((-11.0).wrapped(around: 0...4)    ,  4)
        XCTAssertEqual((-10.0).wrapped(around: 0...4)    ,  0)
        XCTAssertEqual( (-9.0).wrapped(around: 0...4)    ,  1)
        XCTAssertEqual( (-8.0).wrapped(around: 0...4)    ,  2)
        XCTAssertEqual( (-7.0).wrapped(around: 0...4)    ,  3)
        XCTAssertEqual( (-6.0).wrapped(around: 0...4)    ,  4)
        XCTAssertEqual( (-5.0).wrapped(around: 0...4)    ,  0)
        XCTAssertEqual( (-4.0).wrapped(around: 0...4)    ,  1)
        XCTAssertEqual( (-3.0).wrapped(around: 0...4)    ,  2)
        XCTAssertEqual( (-2.0).wrapped(around: 0...4)    ,  3)
        XCTAssertEqual( (-1.0).wrapped(around: 0...4)    ,  4)
        XCTAssertEqual(    0.0.wrapped(around: 0...4)    ,  0)
        XCTAssertEqual(    1.0.wrapped(around: 0...4)    ,  1)
        XCTAssertEqual(    2.0.wrapped(around: 0...4)    ,  2)
        XCTAssertEqual(    3.0.wrapped(around: 0...4)    ,  3)
        XCTAssertEqual(    4.0.wrapped(around: 0...4)    ,  4)
        XCTAssertEqual(    5.0.wrapped(around: 0...4)    ,  0)
        XCTAssertEqual(    6.0.wrapped(around: 0...4)    ,  1)
        XCTAssertEqual(    7.0.wrapped(around: 0...4)    ,  2)
        XCTAssertEqual(    8.0.wrapped(around: 0...4)    ,  3)
        XCTAssertEqual(    9.0.wrapped(around: 0...4)    ,  4)
        XCTAssertEqual(   10.0.wrapped(around: 0...4)    ,  0)
        XCTAssertEqual(   11.0.wrapped(around: 0...4)    ,  1)
        
        XCTAssertEqual((-11.0).wrapped(around: 1...5)    ,  4)
        XCTAssertEqual((-10.0).wrapped(around: 1...5)    ,  5)
        XCTAssertEqual( (-9.0).wrapped(around: 1...5)    ,  1)
        XCTAssertEqual( (-8.0).wrapped(around: 1...5)    ,  2)
        XCTAssertEqual( (-7.0).wrapped(around: 1...5)    ,  3)
        XCTAssertEqual( (-6.0).wrapped(around: 1...5)    ,  4)
        XCTAssertEqual( (-5.0).wrapped(around: 1...5)    ,  5)
        XCTAssertEqual( (-4.0).wrapped(around: 1...5)    ,  1)
        XCTAssertEqual( (-3.0).wrapped(around: 1...5)    ,  2)
        XCTAssertEqual( (-2.0).wrapped(around: 1...5)    ,  3)
        XCTAssertEqual( (-1.0).wrapped(around: 1...5)    ,  4)
        XCTAssertEqual(    0.0.wrapped(around: 1...5)    ,  5)
        XCTAssertEqual(    1.0.wrapped(around: 1...5)    ,  1)
        XCTAssertEqual(    2.0.wrapped(around: 1...5)    ,  2)
        XCTAssertEqual(    3.0.wrapped(around: 1...5)    ,  3)
        XCTAssertEqual(    4.0.wrapped(around: 1...5)    ,  4)
        XCTAssertEqual(    5.0.wrapped(around: 1...5)    ,  5)
        XCTAssertEqual(    6.0.wrapped(around: 1...5)    ,  1)
        XCTAssertEqual(    7.0.wrapped(around: 1...5)    ,  2)
        XCTAssertEqual(    8.0.wrapped(around: 1...5)    ,  3)
        XCTAssertEqual(    9.0.wrapped(around: 1...5)    ,  4)
        XCTAssertEqual(   10.0.wrapped(around: 1...5)    ,  5)
        XCTAssertEqual(   11.0.wrapped(around: 1...5)    ,  1)
        
        XCTAssertEqual((-11.0).wrapped(around: -1...3)   , -1)
        XCTAssertEqual((-10.0).wrapped(around: -1...3)   ,  0)
        XCTAssertEqual( (-9.0).wrapped(around: -1...3)   ,  1)
        XCTAssertEqual( (-8.0).wrapped(around: -1...3)   ,  2)
        XCTAssertEqual( (-7.0).wrapped(around: -1...3)   ,  3)
        XCTAssertEqual( (-6.0).wrapped(around: -1...3)   , -1)
        XCTAssertEqual( (-5.0).wrapped(around: -1...3)   ,  0)
        XCTAssertEqual( (-4.0).wrapped(around: -1...3)   ,  1)
        XCTAssertEqual( (-3.0).wrapped(around: -1...3)   ,  2)
        XCTAssertEqual( (-2.0).wrapped(around: -1...3)   ,  3)
        XCTAssertEqual( (-1.0).wrapped(around: -1...3)   , -1)
        XCTAssertEqual(    0.0.wrapped(around: -1...3)   ,  0)
        XCTAssertEqual(    1.0.wrapped(around: -1...3)   ,  1)
        XCTAssertEqual(    2.0.wrapped(around: -1...3)   ,  2)
        XCTAssertEqual(    3.0.wrapped(around: -1...3)   ,  3)
        XCTAssertEqual(    4.0.wrapped(around: -1...3)   , -1)
        XCTAssertEqual(    5.0.wrapped(around: -1...3)   ,  0)
        XCTAssertEqual(    6.0.wrapped(around: -1...3)   ,  1)
        XCTAssertEqual(    7.0.wrapped(around: -1...3)   ,  2)
        XCTAssertEqual(    8.0.wrapped(around: -1...3)   ,  3)
        XCTAssertEqual(    9.0.wrapped(around: -1...3)   , -1)
        XCTAssertEqual(   10.0.wrapped(around: -1...3)   ,  0)
        XCTAssertEqual(   11.0.wrapped(around: -1...3)   ,  1)
        
        // Range
        
        // single value ranges
        
        XCTAssertEqual(    1.0.wrapped(around: 0..<0)    ,  0)
        XCTAssertEqual(    1.0.wrapped(around: -1..<(-1)), -1)
        
        // basic ranges
        
        XCTAssertEqual((-11.0).wrapped(around: 0..<4)    ,  1)
        XCTAssertEqual((-10.0).wrapped(around: 0..<4)    ,  2)
        XCTAssertEqual( (-9.0).wrapped(around: 0..<4)    ,  3)
        XCTAssertEqual( (-8.0).wrapped(around: 0..<4)    ,  0)
        XCTAssertEqual( (-7.0).wrapped(around: 0..<4)    ,  1)
        XCTAssertEqual( (-6.0).wrapped(around: 0..<4)    ,  2)
        XCTAssertEqual( (-5.0).wrapped(around: 0..<4)    ,  3)
        XCTAssertEqual( (-4.0).wrapped(around: 0..<4)    ,  0)
        XCTAssertEqual( (-3.0).wrapped(around: 0..<4)    ,  1)
        XCTAssertEqual( (-2.0).wrapped(around: 0..<4)    ,  2)
        XCTAssertEqual( (-1.0).wrapped(around: 0..<4)    ,  3)
        XCTAssertEqual(    0.0.wrapped(around: 0..<4)    ,  0)
        XCTAssertEqual(    1.0.wrapped(around: 0..<4)    ,  1)
        XCTAssertEqual(    2.0.wrapped(around: 0..<4)    ,  2)
        XCTAssertEqual(    3.0.wrapped(around: 0..<4)    ,  3)
        XCTAssertEqual(    4.0.wrapped(around: 0..<4)    ,  0)
        XCTAssertEqual(    5.0.wrapped(around: 0..<4)    ,  1)
        XCTAssertEqual(    6.0.wrapped(around: 0..<4)    ,  2)
        XCTAssertEqual(    7.0.wrapped(around: 0..<4)    ,  3)
        XCTAssertEqual(    8.0.wrapped(around: 0..<4)    ,  0)
        XCTAssertEqual(    9.0.wrapped(around: 0..<4)    ,  1)
        XCTAssertEqual(   10.0.wrapped(around: 0..<4)    ,  2)
        XCTAssertEqual(   11.0.wrapped(around: 0..<4)    ,  3)
        
        // edge cases
        
        XCTAssert(Double.nan.wrapped(around: 0...1).isNaN)
        XCTAssert(Double.signalingNaN.wrapped(around: 0...1).isNaN)
        XCTAssertEqual(Double.infinity.wrapped(around: 0...1), .infinity)
        
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
        
        // edge cases
        XCTAssert(Double.nan.degreesToRadians.isNaN)
        XCTAssert(Double.signalingNaN.degreesToRadians.isNaN)
        XCTAssertEqual(Double.infinity.degreesToRadians, .infinity)
        
    }
    
    func testTypeConversions_FloatsToString() {
        
        XCTAssertEqual(Double(1.0).string, "1.0")
        XCTAssertEqual(Double.nan.string, "nan")
        XCTAssertEqual(Double.signalingNaN.string, "nan")
        XCTAssertEqual(Double.infinity.string, "inf")
        
        XCTAssertEqual(Float(1.0).string, "1.0")
        XCTAssertEqual(Float.nan.string, "nan")
        XCTAssertEqual(Float.signalingNaN.string, "nan")
        XCTAssertEqual(Float.infinity.string, "inf")
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        XCTAssertEqual(Float80(1.0).string, "1.0")
        XCTAssertEqual(Float80.nan.string, "nan")
        XCTAssertEqual(Float80.signalingNaN.string, "nan")
        XCTAssertEqual(Float80.infinity.string, "inf")
        #endif
        
        XCTAssertEqual(CGFloat(1.0).string, "1.0")
        XCTAssertEqual(CGFloat.nan.string, "nan")
        XCTAssertEqual(CGFloat.signalingNaN.string, "nan")
        XCTAssertEqual(CGFloat.infinity.string, "inf")
        
    }
    
    func testTypeConversions_FloatsToString_decimalPlaces() {
        
        XCTAssertEqual(Double(1.62456).string(decimalPlaces: -1), "2")
        XCTAssertEqual(Double(1.62456).string(decimalPlaces:  0), "2")
        XCTAssertEqual(Double(1.62456).string(decimalPlaces:  1), "1.6")
        XCTAssertEqual(Double(1.62456).string(decimalPlaces:  2), "1.62")
        XCTAssertEqual(Double(1.62456).string(decimalPlaces:  3), "1.625")
        XCTAssertEqual(Double(1.62456).string(decimalPlaces:  4), "1.6246")
        XCTAssertEqual(Double(1.62456).string(decimalPlaces:  5), "1.62456")
        XCTAssertEqual(Double(1.62456).string(decimalPlaces:  6), "1.624560")
        
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces: -1), "2")
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces:  0), "2")
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces:  1), "1.7")
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces:  2), "1.63")
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces:  3), "1.625")
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces:  4), "1.6246")
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces:  5), "1.62456")
        XCTAssertEqual(Double(1.62456).string(rounding: .up, decimalPlaces:  6), "1.624560")
        
        // negative values
        XCTAssertEqual(Double(-1.62456).string(                 decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Double(-1.62456).string(rounding: .up,   decimalPlaces: 1), "-1.6")
        XCTAssertEqual(Double(-1.62456).string(rounding: .up,   decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Double(-1.62456).string(rounding: .down, decimalPlaces: 1), "-1.7")
        XCTAssertEqual(Double(-1.62456).string(rounding: .down, decimalPlaces: 2), "-1.63")
        
        // double
        XCTAssertEqual(Double(1.62456)    .string(decimalPlaces: 1), "1.6")
        XCTAssertEqual(Double.nan         .string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Double.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Double.infinity    .string(decimalPlaces: 2), "inf")
        
        // float
        XCTAssertEqual(Float(1.62456)    .string(decimalPlaces: 1), "1.6")
        XCTAssertEqual(Float.nan         .string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float.infinity    .string(decimalPlaces: 2), "inf")
        
        // float16 - not ready for primetime it seems
        //if #available(macOS 11.0, macCatalyst 14.5, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
        //    XCTAssertEqual(Float16(1.62456).string(decimalPlaces:  1), "1.6")
        //    XCTAssertEqual(Float16.nan.string(decimalPlaces: 2), "nan")
        //    XCTAssertEqual(Float16.signalingNaN.string(decimalPlaces: 2), "nan")
        //    XCTAssertEqual(Float16.infinity.string(decimalPlaces: 2), "inf")
        //}
        
        // float80
        // (we need more thorough unit test here for Float80 because it's internally using a custom implementation)
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces: -1), "2")
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces:  0), "2")
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces:  1), "1.6")
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces:  2), "1.62")
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces:  3), "1.625")
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces:  4), "1.6246")
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces:  5), "1.62456")
        XCTAssertEqual(Float80(1.62456).string(decimalPlaces:  6), "1.624560")
        
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces: -1), "2")
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces:  0), "2")
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces:  1), "1.7")
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces:  2), "1.63")
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces:  3), "1.625")
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces:  4), "1.6246")
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces:  5), "1.62456")
        XCTAssertEqual(Float80(1.62456).string(rounding: .up, decimalPlaces:  6), "1.624560")
        
        // negative values
        XCTAssertEqual(Float80(-1.62456).string(                 decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .up,   decimalPlaces: 1), "-1.6")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .up,   decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .down, decimalPlaces: 1), "-1.7")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .down, decimalPlaces: 2), "-1.63")
        
        // edge cases
        XCTAssertEqual(Float80.nan         .string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float80.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float80.infinity    .string(decimalPlaces: 2), "inf")
        #endif
        
        // cgfloat
        XCTAssertEqual(CGFloat(1.62456)    .string(decimalPlaces: 1), "1.6")
        XCTAssertEqual(CGFloat.nan         .string(decimalPlaces: 2), "nan")
        XCTAssertEqual(CGFloat.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(CGFloat.infinity    .string(decimalPlaces: 2), "inf")
        
    }
    
    func testTypeConversions_StringToFloats() {
        
        // String
        
        let str = "1.0"
        
        XCTAssertEqual(str.double,      1.0)
        
        XCTAssertEqual(str.float,       1.0)
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        XCTAssertEqual(str.float80,     1.0)
        #endif
        
        XCTAssertEqual(str.cgFloat,     1.0)
        
        // Substring
        
        let subStr = str.prefix(3)
        
        XCTAssertEqual(subStr.double,   1.0)
        
        XCTAssertEqual(subStr.float,    1.0)
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        XCTAssertEqual(subStr.float80,  1.0)
        #endif
        
        XCTAssertEqual(subStr.cgFloat,  1.0)
        
    }
}

#endif
