//
//  FloatingPoint and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_FloatingPointAndFoundation_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testStringValueHighPrecision() {
        // Double
        
        XCTAssertEqual(Double(0.0).stringValueHighPrecision, "0")
        XCTAssertEqual(
            Double(0.1).stringValueHighPrecision,
            "0.1000000000000000055511151231257827021181583404541015625"
        )
        XCTAssertEqual(Double(1.0).stringValueHighPrecision, "1")
        
        let double = 3603.59999999999990905052982270717620849609375
        XCTAssertEqual(
            double.stringValueHighPrecision,
            "3603.59999999999990905052982270717620849609375"
        )
        
        // Float
        
        let float: Float = 3603.59999999999990905052982270717620849609375
        XCTAssertEqual(float.stringValueHighPrecision, "3603.60009765625")
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        // Float80
        let float80: Float80 = 3603.59999999999990905052982270717620849609375
        XCTAssertEqual(float80.stringValueHighPrecision, "3603.599999999999909")
        #endif
        
        // CGFloat
        
        let cgfloat = CGFloat(exactly: 3603.59999999999990905052982270717620849609375)!
        XCTAssertEqual(
            cgfloat.stringValueHighPrecision,
            "3603.59999999999990905052982270717620849609375"
        )
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
        XCTAssertEqual(Double(-1.62456).string(decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Double(-1.62456).string(rounding: .up,   decimalPlaces: 1), "-1.6")
        XCTAssertEqual(Double(-1.62456).string(rounding: .up,   decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Double(-1.62456).string(rounding: .down, decimalPlaces: 1), "-1.7")
        XCTAssertEqual(Double(-1.62456).string(rounding: .down, decimalPlaces: 2), "-1.63")
        
        // double
        XCTAssertEqual(Double(1.62456).string(decimalPlaces: 1), "1.6")
        XCTAssertEqual(Double.nan.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Double.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Double.infinity.string(decimalPlaces: 2), "inf")
        
        // float
        XCTAssertEqual(Float(1.62456).string(decimalPlaces: 1), "1.6")
        XCTAssertEqual(Float.nan.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float.infinity.string(decimalPlaces: 2), "inf")
        
        // float16 - not ready for primetime it seems
        // if #available(macOS 11.0, macCatalyst 14.5, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
        //    XCTAssertEqual(Float16(1.62456).string(decimalPlaces:  1), "1.6")
        //    XCTAssertEqual(Float16.nan.string(decimalPlaces: 2), "nan")
        //    XCTAssertEqual(Float16.signalingNaN.string(decimalPlaces: 2), "nan")
        //    XCTAssertEqual(Float16.infinity.string(decimalPlaces: 2), "inf")
        // }
        
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
        XCTAssertEqual(Float80(-1.62456).string(decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .up,   decimalPlaces: 1), "-1.6")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .up,   decimalPlaces: 2), "-1.62")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .down, decimalPlaces: 1), "-1.7")
        XCTAssertEqual(Float80(-1.62456).string(rounding: .down, decimalPlaces: 2), "-1.63")
        
        // edge cases
        XCTAssertEqual(Float80.nan.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float80.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(Float80.infinity.string(decimalPlaces: 2), "inf")
#endif
        
        // cgfloat
        XCTAssertEqual(CGFloat(1.62456).string(decimalPlaces: 1), "1.6")
        XCTAssertEqual(CGFloat.nan.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(CGFloat.signalingNaN.string(decimalPlaces: 2), "nan")
        XCTAssertEqual(CGFloat.infinity.string(decimalPlaces: 2), "inf")
    }
}

#endif
