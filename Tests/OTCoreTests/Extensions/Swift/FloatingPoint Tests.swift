//
//  FloatingPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import CoreGraphics
import OTCore
import Testing

@Suite struct Extensions_Swift_FloatingPoint_Tests {
    @Test
    func typeConversions_FloatsToInts() {
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
    
    @Test
    func boolValue() {
        // double
        #expect(Double(-1.0).boolValue == false)
        #expect(Double(0.0).boolValue == false)
        #expect(Double(1.0).boolValue == true)
        #expect(Double(123.0).boolValue == true)
        #expect(Double.nan.boolValue == false)
        #expect(Double.signalingNaN.boolValue == false)
        #expect(Double.infinity.boolValue == true)
        
        // float
        #expect(Float(-1.0).boolValue == false)
        #expect(Float(0.0).boolValue == false)
        #expect(Float(1.0).boolValue == true)
        #expect(Float(123.0).boolValue == true)
        #expect(Float.nan.boolValue == false)
        #expect(Float.signalingNaN.boolValue == false)
        #expect(Float.infinity.boolValue == true)
        
        // float80
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        #expect(Float80(-1.0).boolValue == false)
        #expect(Float80(0.0).boolValue == false)
        #expect(Float80(1.0).boolValue == true)
        #expect(Float80(123.0).boolValue == true)
        #expect(Float80.nan.boolValue == false)
        #expect(Float80.signalingNaN.boolValue == false)
        #expect(Float80.infinity.boolValue == true)
        #endif
        
        // cgfloat
        #expect(CGFloat(-1.0).boolValue == false)
        #expect(CGFloat(0.0).boolValue == false)
        #expect(CGFloat(1.0).boolValue == true)
        #expect(CGFloat(123.0).boolValue == true)
        #expect(CGFloat.nan.boolValue == false)
        #expect(CGFloat.signalingNaN.boolValue == false)
        #expect(CGFloat.infinity.boolValue == true)
    }
    
    @Test
    func rounded() {
        // Double .rounded(decimalPlaces:)
        
        #expect(Double(1.62456).rounded(decimalPlaces: -1) == 2.0)
        #expect(Double(1.62456).rounded(decimalPlaces: 0) == 2.0)
        #expect(Double(1.62456).rounded(decimalPlaces: 1) == 1.6)
        #expect(Double(1.62456).rounded(decimalPlaces: 2) == 1.62)
        #expect(Double(1.62456).rounded(decimalPlaces: 3) == 1.625)
        #expect(Double(1.62456).rounded(decimalPlaces: 4) == 1.6246)
        #expect(Double(1.62456).rounded(decimalPlaces: 5) == 1.62456)
        #expect(Double(1.62456).rounded(decimalPlaces: 6) == 1.62456)
        
        #expect(Double(1.62456).rounded(.up, decimalPlaces: -1) == 2.0)
        #expect(Double(1.62456).rounded(.up, decimalPlaces: 0) == 2.0)
        #expect(Double(1.62456).rounded(.up, decimalPlaces: 1) == 1.7)
        #expect(Double(1.62456).rounded(.up, decimalPlaces: 2) == 1.63)
        #expect(Double(1.62456).rounded(.up, decimalPlaces: 3) == 1.625)
        #expect(Double(1.62456).rounded(.up, decimalPlaces: 4) == 1.6246)
        #expect(Double(1.62456).rounded(.up, decimalPlaces: 5) == 1.62456)
        #expect(Double(1.62456).rounded(.up, decimalPlaces: 6) == 1.62456)
        
        // negative values
        
        #expect(Double(-1.62456).rounded(decimalPlaces: 2) == -1.62)
        #expect(Double(-1.62456).rounded(.up, decimalPlaces: 1) == -1.6)
        #expect(Double(-1.62456).rounded(.up, decimalPlaces: 2) == -1.62)
        #expect(Double(-1.62456).rounded(.down, decimalPlaces: 1) == -1.7)
        #expect(Double(-1.62456).rounded(.down, decimalPlaces: 2) == -1.63)
        
        // edge cases
        
        #expect(Double.nan.rounded(decimalPlaces: 2).isNaN)
        #expect(Double.signalingNaN.rounded(decimalPlaces: 2).isNaN)
        #expect(Double.infinity.rounded(decimalPlaces: 2) == .infinity)
        
        #expect(Float.nan.rounded(decimalPlaces: 2).isNaN)
        #expect(Float.signalingNaN.rounded(decimalPlaces: 2).isNaN)
        #expect(Float.infinity.rounded(decimalPlaces: 2) == .infinity)
        
        #expect(CGFloat.nan.rounded(decimalPlaces: 2).isNaN)
        #expect(CGFloat.signalingNaN.rounded(decimalPlaces: 2).isNaN)
        #expect(CGFloat.infinity.rounded(decimalPlaces: 2) == .infinity)
    }
    
    @Test
    func round() {
        // Double .round(decimalPlaces:)
        
        var dbl = 0.1264
        dbl.round(decimalPlaces: 2)
        #expect(dbl == 0.13)
        
        dbl = 0.1264
        dbl.round(.up, decimalPlaces: 1)
        #expect(dbl == 0.2)
    }
    
    @Test
    func wrappingNumbers() {
        // ClosedRange
        
        // single value ranges
        
        #expect(1.0.wrapped(around: 0 ... 0) == 0)
        #expect(1.0.wrapped(around: -1 ... (-1)) == -1)
        
        // basic ranges
        
        #expect((-11.0).wrapped(around: 0 ... 4) == 4)
        #expect((-10.0).wrapped(around: 0 ... 4) == 0)
        #expect((-9.0).wrapped(around: 0 ... 4) == 1)
        #expect((-8.0).wrapped(around: 0 ... 4) == 2)
        #expect((-7.0).wrapped(around: 0 ... 4) == 3)
        #expect((-6.0).wrapped(around: 0 ... 4) == 4)
        #expect((-5.0).wrapped(around: 0 ... 4) == 0)
        #expect((-4.0).wrapped(around: 0 ... 4) == 1)
        #expect((-3.0).wrapped(around: 0 ... 4) == 2)
        #expect((-2.0).wrapped(around: 0 ... 4) == 3)
        #expect((-1.0).wrapped(around: 0 ... 4) == 4)
        #expect(0.0.wrapped(around: 0 ... 4) == 0)
        #expect(1.0.wrapped(around: 0 ... 4) == 1)
        #expect(2.0.wrapped(around: 0 ... 4) == 2)
        #expect(3.0.wrapped(around: 0 ... 4) == 3)
        #expect(4.0.wrapped(around: 0 ... 4) == 4)
        #expect(5.0.wrapped(around: 0 ... 4) == 0)
        #expect(6.0.wrapped(around: 0 ... 4) == 1)
        #expect(7.0.wrapped(around: 0 ... 4) == 2)
        #expect(8.0.wrapped(around: 0 ... 4) == 3)
        #expect(9.0.wrapped(around: 0 ... 4) == 4)
        #expect(10.0.wrapped(around: 0 ... 4) == 0)
        #expect(11.0.wrapped(around: 0 ... 4) == 1)
        
        #expect((-11.0).wrapped(around: 1 ... 5) == 4)
        #expect((-10.0).wrapped(around: 1 ... 5) == 5)
        #expect((-9.0).wrapped(around: 1 ... 5) == 1)
        #expect((-8.0).wrapped(around: 1 ... 5) == 2)
        #expect((-7.0).wrapped(around: 1 ... 5) == 3)
        #expect((-6.0).wrapped(around: 1 ... 5) == 4)
        #expect((-5.0).wrapped(around: 1 ... 5) == 5)
        #expect((-4.0).wrapped(around: 1 ... 5) == 1)
        #expect((-3.0).wrapped(around: 1 ... 5) == 2)
        #expect((-2.0).wrapped(around: 1 ... 5) == 3)
        #expect((-1.0).wrapped(around: 1 ... 5) == 4)
        #expect(0.0.wrapped(around: 1 ... 5) == 5)
        #expect(1.0.wrapped(around: 1 ... 5) == 1)
        #expect(2.0.wrapped(around: 1 ... 5) == 2)
        #expect(3.0.wrapped(around: 1 ... 5) == 3)
        #expect(4.0.wrapped(around: 1 ... 5) == 4)
        #expect(5.0.wrapped(around: 1 ... 5) == 5)
        #expect(6.0.wrapped(around: 1 ... 5) == 1)
        #expect(7.0.wrapped(around: 1 ... 5) == 2)
        #expect(8.0.wrapped(around: 1 ... 5) == 3)
        #expect(9.0.wrapped(around: 1 ... 5) == 4)
        #expect(10.0.wrapped(around: 1 ... 5) == 5)
        #expect(11.0.wrapped(around: 1 ... 5) == 1)
        
        #expect((-11.0).wrapped(around: -1 ... 3) == -1)
        #expect((-10.0).wrapped(around: -1 ... 3) == 0)
        #expect((-9.0).wrapped(around: -1 ... 3) == 1)
        #expect((-8.0).wrapped(around: -1 ... 3) == 2)
        #expect((-7.0).wrapped(around: -1 ... 3) == 3)
        #expect((-6.0).wrapped(around: -1 ... 3) == -1)
        #expect((-5.0).wrapped(around: -1 ... 3) == 0)
        #expect((-4.0).wrapped(around: -1 ... 3) == 1)
        #expect((-3.0).wrapped(around: -1 ... 3) == 2)
        #expect((-2.0).wrapped(around: -1 ... 3) == 3)
        #expect((-1.0).wrapped(around: -1 ... 3) == -1)
        #expect(0.0.wrapped(around: -1 ... 3) == 0)
        #expect(1.0.wrapped(around: -1 ... 3) == 1)
        #expect(2.0.wrapped(around: -1 ... 3) == 2)
        #expect(3.0.wrapped(around: -1 ... 3) == 3)
        #expect(4.0.wrapped(around: -1 ... 3) == -1)
        #expect(5.0.wrapped(around: -1 ... 3) == 0)
        #expect(6.0.wrapped(around: -1 ... 3) == 1)
        #expect(7.0.wrapped(around: -1 ... 3) == 2)
        #expect(8.0.wrapped(around: -1 ... 3) == 3)
        #expect(9.0.wrapped(around: -1 ... 3) == -1)
        #expect(10.0.wrapped(around: -1 ... 3) == 0)
        #expect(11.0.wrapped(around: -1 ... 3) == 1)
        
        // Range
        
        // single value ranges
        
        #expect(1.0.wrapped(around: 0 ..< 0) == 0)
        #expect(1.0.wrapped(around: -1 ..< (-1)) == -1)
        
        // basic ranges
        
        #expect((-11.0).wrapped(around: 0 ..< 4) == 1)
        #expect((-10.0).wrapped(around: 0 ..< 4) == 2)
        #expect((-9.0).wrapped(around: 0 ..< 4) == 3)
        #expect((-8.0).wrapped(around: 0 ..< 4) == 0)
        #expect((-7.0).wrapped(around: 0 ..< 4) == 1)
        #expect((-6.0).wrapped(around: 0 ..< 4) == 2)
        #expect((-5.0).wrapped(around: 0 ..< 4) == 3)
        #expect((-4.0).wrapped(around: 0 ..< 4) == 0)
        #expect((-3.0).wrapped(around: 0 ..< 4) == 1)
        #expect((-2.0).wrapped(around: 0 ..< 4) == 2)
        #expect((-1.0).wrapped(around: 0 ..< 4) == 3)
        #expect(0.0.wrapped(around: 0 ..< 4) == 0)
        #expect(1.0.wrapped(around: 0 ..< 4) == 1)
        #expect(2.0.wrapped(around: 0 ..< 4) == 2)
        #expect(3.0.wrapped(around: 0 ..< 4) == 3)
        #expect(4.0.wrapped(around: 0 ..< 4) == 0)
        #expect(5.0.wrapped(around: 0 ..< 4) == 1)
        #expect(6.0.wrapped(around: 0 ..< 4) == 2)
        #expect(7.0.wrapped(around: 0 ..< 4) == 3)
        #expect(8.0.wrapped(around: 0 ..< 4) == 0)
        #expect(9.0.wrapped(around: 0 ..< 4) == 1)
        #expect(10.0.wrapped(around: 0 ..< 4) == 2)
        #expect(11.0.wrapped(around: 0 ..< 4) == 3)
        
        // edge cases
        
        #expect(Double.nan.wrapped(around: 0 ... 1).isNaN)
        #expect(Double.signalingNaN.wrapped(around: 0 ... 1).isNaN)
        #expect(Double.infinity.wrapped(around: 0 ... 1) == .infinity)
    }
    
    @Test
    func degreesToRadians() {
        // Double
        #expect(360.0.degreesToRadians == 6.28318530717958647693)
        #expect(6.28318530717958647693.radiansToDegrees == 360.0)
        
        // Float
        #expect(Float(360.0).degreesToRadians == 6.283185)
        #expect(Float(6.283185).radiansToDegrees == 360.0)
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        // Float80
        #expect(Float80(360.0).degreesToRadians == 6.28318530717958647693)
        #expect(Float80(6.28318530717958647693).radiansToDegrees == 360.0)
        #endif
        
        // CGFloat
        #expect(CGFloat(360.0).degreesToRadians == 6.28318530717958647693)
        #expect(CGFloat(6.28318530717958647693).radiansToDegrees == 360.0)
        
        // edge cases
        #expect(Double.nan.degreesToRadians.isNaN)
        #expect(Double.signalingNaN.degreesToRadians.isNaN)
        #expect(Double.infinity.degreesToRadians == .infinity)
    }
    
    @Test
    func typeConversions_FloatsToString() {
        #expect(Double(1.0).string == "1.0")
        #expect(Double.nan.string == "nan")
        #expect(Double.signalingNaN.string == "nan")
        #expect(Double.infinity.string == "inf")
        
        #expect(Float(1.0).string == "1.0")
        #expect(Float.nan.string == "nan")
        #expect(Float.signalingNaN.string == "nan")
        #expect(Float.infinity.string == "inf")
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        #expect(Float80(1.0).string == "1.0")
        #expect(Float80.nan.string == "nan")
        #expect(Float80.signalingNaN.string == "nan")
        #expect(Float80.infinity.string == "inf")
        #endif
        
        #expect(CGFloat(1.0).string == "1.0")
        #expect(CGFloat.nan.string == "nan")
        #expect(CGFloat.signalingNaN.string == "nan")
        #expect(CGFloat.infinity.string == "inf")
    }
    
    @Test
    func typeConversions_StringToFloats() {
        // String
        
        let str = "1.0"
        
        #expect(str.double == 1.0)
        
        #expect(str.float == 1.0)
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        #expect(str.float80 == 1.0)
        #endif
        
        #expect(str.cgFloat == 1.0)
        
        // Substring
        
        let subStr = str.prefix(3)
        
        #expect(subStr.double == 1.0)
        
        #expect(subStr.float == 1.0)
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        #expect(subStr.float80 == 1.0)
        #endif
        
        #expect(subStr.cgFloat == 1.0)
    }
}
