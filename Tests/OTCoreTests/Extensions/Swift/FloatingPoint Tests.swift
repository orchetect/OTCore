//
//  FloatingPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OTCore

class Extensions_Swift_FloatingPoint_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testTypeConversions_FloatsToInts() {
        // Double
        
        let double = 123.456
        
        _ = double.int
        _ = double.intExactly
        _ = double.uInt
        _ = double.uIntExactly
        
        _ = double.int8
        _ = double.int8Exactly
        _ = double.uInt8
        _ = double.uInt8Exactly
        
        _ = double.int16
        _ = double.int16Exactly
        _ = double.uInt16
        _ = double.uInt16Exactly
        
        _ = double.int32
        _ = double.int32Exactly
        _ = double.uInt32
        _ = double.uInt32Exactly
        
        _ = double.int64
        _ = double.int64Exactly
        _ = double.uInt64
        _ = double.uInt64Exactly
        
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
        _ = float.uInt
        _ = float.uIntExactly
        
        _ = float.int8
        _ = float.int8Exactly
        _ = float.uInt8
        _ = float.uInt8Exactly
        
        _ = float.int16
        _ = float.int16Exactly
        _ = float.uInt16
        _ = float.uInt16Exactly
        
        _ = float.int32
        _ = float.int32Exactly
        _ = float.uInt32
        _ = float.uInt32Exactly
        
        _ = float.int64
        _ = float.int64Exactly
        _ = float.uInt64
        _ = float.uInt64Exactly
        
        // Float80
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        
        let float80 = Float80(123.456)
        
        _ = float80.int
        _ = float80.intExactly
        _ = float80.uInt
        _ = float80.uIntExactly
        
        _ = float80.int8
        _ = float80.int8Exactly
        _ = float80.uInt8
        _ = float80.uInt8Exactly
        
        _ = float80.int16
        _ = float80.int16Exactly
        _ = float80.uInt16
        _ = float80.uInt16Exactly
        
        _ = float80.int32
        _ = float80.int32Exactly
        _ = float80.uInt32
        _ = float80.uInt32Exactly
        
        _ = float80.int64
        _ = float80.int64Exactly
        _ = float80.uInt64
        _ = float80.uInt64Exactly
        
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
        _ = cgfloat.uInt
        _ = cgfloat.uIntExactly
        
        _ = cgfloat.int8
        _ = cgfloat.int8Exactly
        _ = cgfloat.uInt8
        _ = cgfloat.uInt8Exactly
        
        _ = cgfloat.int16
        _ = cgfloat.int16Exactly
        _ = cgfloat.uInt16
        _ = cgfloat.uInt16Exactly
        
        _ = cgfloat.int32
        _ = cgfloat.int32Exactly
        _ = cgfloat.uInt32
        _ = cgfloat.uInt32Exactly
        
        _ = cgfloat.int64
        _ = cgfloat.int64Exactly
        _ = cgfloat.uInt64
        _ = cgfloat.uInt64Exactly
        
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
        XCTAssertEqual(Double(-1.0).boolValue, false)
        XCTAssertEqual(Double(0.0).boolValue, false)
        XCTAssertEqual(Double(1.0).boolValue, true)
        XCTAssertEqual(Double(123.0).boolValue, true)
        XCTAssertEqual(Double.nan.boolValue, false)
        XCTAssertEqual(Double.signalingNaN.boolValue, false)
        XCTAssertEqual(Double.infinity.boolValue, true)
        
        // float
        XCTAssertEqual(Float(-1.0).boolValue, false)
        XCTAssertEqual(Float(0.0).boolValue, false)
        XCTAssertEqual(Float(1.0).boolValue, true)
        XCTAssertEqual(Float(123.0).boolValue, true)
        XCTAssertEqual(Float.nan.boolValue, false)
        XCTAssertEqual(Float.signalingNaN.boolValue, false)
        XCTAssertEqual(Float.infinity.boolValue, true)
        
        // float80
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        XCTAssertEqual(Float80(-1.0).boolValue, false)
        XCTAssertEqual(Float80(0.0).boolValue, false)
        XCTAssertEqual(Float80(1.0).boolValue, true)
        XCTAssertEqual(Float80(123.0).boolValue, true)
        XCTAssertEqual(Float80.nan.boolValue, false)
        XCTAssertEqual(Float80.signalingNaN.boolValue, false)
        XCTAssertEqual(Float80.infinity.boolValue, true)
        #endif
        
        // cgfloat
        XCTAssertEqual(CGFloat(-1.0).boolValue, false)
        XCTAssertEqual(CGFloat(0.0).boolValue, false)
        XCTAssertEqual(CGFloat(1.0).boolValue, true)
        XCTAssertEqual(CGFloat(123.0).boolValue, true)
        XCTAssertEqual(CGFloat.nan.boolValue, false)
        XCTAssertEqual(CGFloat.signalingNaN.boolValue, false)
        XCTAssertEqual(CGFloat.infinity.boolValue, true)
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
        
        XCTAssertEqual(1.0.wrapped(around: 0 ... 0),  0)
        XCTAssertEqual(1.0.wrapped(around: -1 ... (-1)), -1)
        
        // basic ranges
        
        XCTAssertEqual((-11.0).wrapped(around: 0 ... 4),  4)
        XCTAssertEqual((-10.0).wrapped(around: 0 ... 4),  0)
        XCTAssertEqual((-9.0).wrapped(around: 0 ... 4),  1)
        XCTAssertEqual((-8.0).wrapped(around: 0 ... 4),  2)
        XCTAssertEqual((-7.0).wrapped(around: 0 ... 4),  3)
        XCTAssertEqual((-6.0).wrapped(around: 0 ... 4),  4)
        XCTAssertEqual((-5.0).wrapped(around: 0 ... 4),  0)
        XCTAssertEqual((-4.0).wrapped(around: 0 ... 4),  1)
        XCTAssertEqual((-3.0).wrapped(around: 0 ... 4),  2)
        XCTAssertEqual((-2.0).wrapped(around: 0 ... 4),  3)
        XCTAssertEqual((-1.0).wrapped(around: 0 ... 4),  4)
        XCTAssertEqual(0.0.wrapped(around: 0 ... 4),  0)
        XCTAssertEqual(1.0.wrapped(around: 0 ... 4),  1)
        XCTAssertEqual(2.0.wrapped(around: 0 ... 4),  2)
        XCTAssertEqual(3.0.wrapped(around: 0 ... 4),  3)
        XCTAssertEqual(4.0.wrapped(around: 0 ... 4),  4)
        XCTAssertEqual(5.0.wrapped(around: 0 ... 4),  0)
        XCTAssertEqual(6.0.wrapped(around: 0 ... 4),  1)
        XCTAssertEqual(7.0.wrapped(around: 0 ... 4),  2)
        XCTAssertEqual(8.0.wrapped(around: 0 ... 4),  3)
        XCTAssertEqual(9.0.wrapped(around: 0 ... 4),  4)
        XCTAssertEqual(10.0.wrapped(around: 0 ... 4),  0)
        XCTAssertEqual(11.0.wrapped(around: 0 ... 4),  1)
        
        XCTAssertEqual((-11.0).wrapped(around: 1 ... 5),  4)
        XCTAssertEqual((-10.0).wrapped(around: 1 ... 5),  5)
        XCTAssertEqual((-9.0).wrapped(around: 1 ... 5),  1)
        XCTAssertEqual((-8.0).wrapped(around: 1 ... 5),  2)
        XCTAssertEqual((-7.0).wrapped(around: 1 ... 5),  3)
        XCTAssertEqual((-6.0).wrapped(around: 1 ... 5),  4)
        XCTAssertEqual((-5.0).wrapped(around: 1 ... 5),  5)
        XCTAssertEqual((-4.0).wrapped(around: 1 ... 5),  1)
        XCTAssertEqual((-3.0).wrapped(around: 1 ... 5),  2)
        XCTAssertEqual((-2.0).wrapped(around: 1 ... 5),  3)
        XCTAssertEqual((-1.0).wrapped(around: 1 ... 5),  4)
        XCTAssertEqual(0.0.wrapped(around: 1 ... 5),  5)
        XCTAssertEqual(1.0.wrapped(around: 1 ... 5),  1)
        XCTAssertEqual(2.0.wrapped(around: 1 ... 5),  2)
        XCTAssertEqual(3.0.wrapped(around: 1 ... 5),  3)
        XCTAssertEqual(4.0.wrapped(around: 1 ... 5),  4)
        XCTAssertEqual(5.0.wrapped(around: 1 ... 5),  5)
        XCTAssertEqual(6.0.wrapped(around: 1 ... 5),  1)
        XCTAssertEqual(7.0.wrapped(around: 1 ... 5),  2)
        XCTAssertEqual(8.0.wrapped(around: 1 ... 5),  3)
        XCTAssertEqual(9.0.wrapped(around: 1 ... 5),  4)
        XCTAssertEqual(10.0.wrapped(around: 1 ... 5),  5)
        XCTAssertEqual(11.0.wrapped(around: 1 ... 5),  1)
        
        XCTAssertEqual((-11.0).wrapped(around: -1 ... 3), -1)
        XCTAssertEqual((-10.0).wrapped(around: -1 ... 3),  0)
        XCTAssertEqual((-9.0).wrapped(around: -1 ... 3),  1)
        XCTAssertEqual((-8.0).wrapped(around: -1 ... 3),  2)
        XCTAssertEqual((-7.0).wrapped(around: -1 ... 3),  3)
        XCTAssertEqual((-6.0).wrapped(around: -1 ... 3), -1)
        XCTAssertEqual((-5.0).wrapped(around: -1 ... 3),  0)
        XCTAssertEqual((-4.0).wrapped(around: -1 ... 3),  1)
        XCTAssertEqual((-3.0).wrapped(around: -1 ... 3),  2)
        XCTAssertEqual((-2.0).wrapped(around: -1 ... 3),  3)
        XCTAssertEqual((-1.0).wrapped(around: -1 ... 3), -1)
        XCTAssertEqual(0.0.wrapped(around: -1 ... 3),  0)
        XCTAssertEqual(1.0.wrapped(around: -1 ... 3),  1)
        XCTAssertEqual(2.0.wrapped(around: -1 ... 3),  2)
        XCTAssertEqual(3.0.wrapped(around: -1 ... 3),  3)
        XCTAssertEqual(4.0.wrapped(around: -1 ... 3), -1)
        XCTAssertEqual(5.0.wrapped(around: -1 ... 3),  0)
        XCTAssertEqual(6.0.wrapped(around: -1 ... 3),  1)
        XCTAssertEqual(7.0.wrapped(around: -1 ... 3),  2)
        XCTAssertEqual(8.0.wrapped(around: -1 ... 3),  3)
        XCTAssertEqual(9.0.wrapped(around: -1 ... 3), -1)
        XCTAssertEqual(10.0.wrapped(around: -1 ... 3),  0)
        XCTAssertEqual(11.0.wrapped(around: -1 ... 3),  1)
        
        // Range
        
        // single value ranges
        
        XCTAssertEqual(1.0.wrapped(around: 0 ..< 0),  0)
        XCTAssertEqual(1.0.wrapped(around: -1 ..< (-1)), -1)
        
        // basic ranges
        
        XCTAssertEqual((-11.0).wrapped(around: 0 ..< 4),  1)
        XCTAssertEqual((-10.0).wrapped(around: 0 ..< 4),  2)
        XCTAssertEqual((-9.0).wrapped(around: 0 ..< 4),  3)
        XCTAssertEqual((-8.0).wrapped(around: 0 ..< 4),  0)
        XCTAssertEqual((-7.0).wrapped(around: 0 ..< 4),  1)
        XCTAssertEqual((-6.0).wrapped(around: 0 ..< 4),  2)
        XCTAssertEqual((-5.0).wrapped(around: 0 ..< 4),  3)
        XCTAssertEqual((-4.0).wrapped(around: 0 ..< 4),  0)
        XCTAssertEqual((-3.0).wrapped(around: 0 ..< 4),  1)
        XCTAssertEqual((-2.0).wrapped(around: 0 ..< 4),  2)
        XCTAssertEqual((-1.0).wrapped(around: 0 ..< 4),  3)
        XCTAssertEqual(0.0.wrapped(around: 0 ..< 4),  0)
        XCTAssertEqual(1.0.wrapped(around: 0 ..< 4),  1)
        XCTAssertEqual(2.0.wrapped(around: 0 ..< 4),  2)
        XCTAssertEqual(3.0.wrapped(around: 0 ..< 4),  3)
        XCTAssertEqual(4.0.wrapped(around: 0 ..< 4),  0)
        XCTAssertEqual(5.0.wrapped(around: 0 ..< 4),  1)
        XCTAssertEqual(6.0.wrapped(around: 0 ..< 4),  2)
        XCTAssertEqual(7.0.wrapped(around: 0 ..< 4),  3)
        XCTAssertEqual(8.0.wrapped(around: 0 ..< 4),  0)
        XCTAssertEqual(9.0.wrapped(around: 0 ..< 4),  1)
        XCTAssertEqual(10.0.wrapped(around: 0 ..< 4),  2)
        XCTAssertEqual(11.0.wrapped(around: 0 ..< 4),  3)
        
        // edge cases
        
        XCTAssert(Double.nan.wrapped(around: 0 ... 1).isNaN)
        XCTAssert(Double.signalingNaN.wrapped(around: 0 ... 1).isNaN)
        XCTAssertEqual(Double.infinity.wrapped(around: 0 ... 1), .infinity)
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
