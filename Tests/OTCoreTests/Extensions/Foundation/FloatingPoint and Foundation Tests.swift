//
//  FloatingPoint and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_FloatingPointAndFoundation_Tests {
    @Test
    func double_stringValueHighPrecision() {
        #expect(Double(0.0).stringValueHighPrecision == "0")
        #expect(
            Double(0.1).stringValueHighPrecision
                == "0.1000000000000000055511151231257827021181583404541015625"
        )
        #expect(Double(1.0).stringValueHighPrecision == "1")
        
        let double = 3603.59999999999990905052982270717620849609375
        #expect(
            double.stringValueHighPrecision
                == "3603.59999999999990905052982270717620849609375"
        )
    }
    
    @Test
    func float_stringValueHighPrecision() {
        // Float
        let float: Float = 3603.59999999999990905052982270717620849609375
        #expect(float.stringValueHighPrecision == "3603.60009765625")
        
        // Float80
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        let float80: Float80 = 3603.59999999999990905052982270717620849609375
        #expect(float80.stringValueHighPrecision == "3603.599999999999909")
        #endif
    }
     
    @Test
    func cgFloat_stringValueHighPrecision() throws {
        let cgfloat = try #require(CGFloat(exactly: 3603.59999999999990905052982270717620849609375))
        #expect(
            cgfloat.stringValueHighPrecision
                == "3603.59999999999990905052982270717620849609375"
        )
    }
    
    @Test
    func double_stringDecimalPlaces() {
        #expect(Double(1.62456).string(decimalPlaces: -1) == "2")
        #expect(Double(1.62456).string(decimalPlaces:  0) == "2")
        #expect(Double(1.62456).string(decimalPlaces:  1) == "1.6")
        #expect(Double(1.62456).string(decimalPlaces:  2) == "1.62")
        #expect(Double(1.62456).string(decimalPlaces:  3) == "1.625")
        #expect(Double(1.62456).string(decimalPlaces:  4) == "1.6246")
        #expect(Double(1.62456).string(decimalPlaces:  5) == "1.62456")
        #expect(Double(1.62456).string(decimalPlaces:  6) == "1.624560")
        
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces: -1) == "2")
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces:  0) == "2")
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces:  1) == "1.7")
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces:  2) == "1.63")
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces:  3) == "1.625")
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces:  4) == "1.6246")
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces:  5) == "1.62456")
        #expect(Double(1.62456).string(rounding: .up, decimalPlaces:  6) == "1.624560")
        
        // negative values
        #expect(Double(-1.62456).string(decimalPlaces: 2) == "-1.62")
        #expect(Double(-1.62456).string(rounding: .up,   decimalPlaces: 1) == "-1.6")
        #expect(Double(-1.62456).string(rounding: .up,   decimalPlaces: 2) == "-1.62")
        #expect(Double(-1.62456).string(rounding: .down, decimalPlaces: 1) == "-1.7")
        #expect(Double(-1.62456).string(rounding: .down, decimalPlaces: 2) == "-1.63")
        
        // double
        #expect(Double(1.62456).string(decimalPlaces: 1) == "1.6")
        #expect(Double.nan.string(decimalPlaces: 2) == "nan")
        #expect(Double.signalingNaN.string(decimalPlaces: 2) == "nan")
        #expect(Double.infinity.string(decimalPlaces: 2) == "inf")
    }
    
    @Test
    func float_stringDecimalPlaces() {
        #expect(Float(1.62456).string(decimalPlaces: 1) == "1.6")
        #expect(Float.nan.string(decimalPlaces: 2) == "nan")
        #expect(Float.signalingNaN.string(decimalPlaces: 2) == "nan")
        #expect(Float.infinity.string(decimalPlaces: 2) == "inf")
    }
    
    #if arch(arm64) || arch(arm)
    // Float16 is available on Apple silicon, and unavailable on Intel when targeting macOS.
    // @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    // @Test
    // func float16_stringDecimalPlaces() {
    //     #expect(Float16(1.62456).string(decimalPlaces:  1) == "1.6")
    //     #expect(Float16.nan.string(decimalPlaces: 2) == "nan")
    //     #expect(Float16.signalingNaN.string(decimalPlaces: 2) == "nan")
    //     #expect(Float16.infinity.string(decimalPlaces: 2) == "inf")
    // }
    #endif
    
    #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
    @Test
    func float80_stringDecimalPlaces() {
        // (we need more thorough unit test here for Float80 because it's internally using a custom
        // implementation)
        #expect(Float80(1.62456).string(decimalPlaces: -1) == "2")
        #expect(Float80(1.62456).string(decimalPlaces:  0) == "2")
        #expect(Float80(1.62456).string(decimalPlaces:  1) == "1.6")
        #expect(Float80(1.62456).string(decimalPlaces:  2) == "1.62")
        #expect(Float80(1.62456).string(decimalPlaces:  3) == "1.625")
        #expect(Float80(1.62456).string(decimalPlaces:  4) == "1.6246")
        #expect(Float80(1.62456).string(decimalPlaces:  5) == "1.62456")
        #expect(Float80(1.62456).string(decimalPlaces:  6) == "1.624560")
        
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces: -1) == "2")
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces:  0) == "2")
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces:  1) == "1.7")
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces:  2) == "1.63")
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces:  3) == "1.625")
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces:  4) == "1.6246")
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces:  5) == "1.62456")
        #expect(Float80(1.62456).string(rounding: .up, decimalPlaces:  6) == "1.624560")
        
        // negative values
        #expect(Float80(-1.62456).string(decimalPlaces: 2) == "-1.62")
        #expect(Float80(-1.62456).string(rounding: .up,   decimalPlaces: 1) == "-1.6")
        #expect(Float80(-1.62456).string(rounding: .up,   decimalPlaces: 2) == "-1.62")
        #expect(Float80(-1.62456).string(rounding: .down, decimalPlaces: 1) == "-1.7")
        #expect(Float80(-1.62456).string(rounding: .down, decimalPlaces: 2) == "-1.63")
        
        // edge cases
        #expect(Float80.nan.string(decimalPlaces: 2) == "nan")
        #expect(Float80.signalingNaN.string(decimalPlaces: 2) == "nan")
        #expect(Float80.infinity.string(decimalPlaces: 2) == "inf")
    }
    #endif
    
    @Test
    func cgFloat_stringDecimalPlaces() {
        #expect(CGFloat(1.62456).string(decimalPlaces: 1) == "1.6")
        #expect(CGFloat.nan.string(decimalPlaces: 2) == "nan")
        #expect(CGFloat.signalingNaN.string(decimalPlaces: 2) == "nan")
        #expect(CGFloat.infinity.string(decimalPlaces: 2) == "inf")
    }
}

#endif
