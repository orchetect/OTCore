//
//  Decimal Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
@testable import OTCore

class Extensions_Foundation_Decimal_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testTypeConversions_IntsToInts() {
        _ = 1.decimal
        _ = UInt(1).decimal
        
        _ = Int8(1).decimal
        _ = UInt8(1).decimal
        
        _ = Int16(1).decimal
        _ = UInt16(1).decimal
        
        _ = Int32(1).decimal
        _ = UInt32(1).decimal
        
        _ = Int64(1).decimal
        _ = UInt64(1).decimal
    }
    
    func testBoolValue() {
        _ = Decimal(1).boolValue
    }
    
    func testPower() {
        XCTAssertEqual(Decimal(string: "2.0")!.power(3), 8.0)
    }
    
    func testString() {
        XCTAssertEqual(Decimal(1).string, "1")
    }
    
    func testFromString() {
        // String
        
        let str = "1.0"
        
        XCTAssertEqual(str.decimal, Decimal(string: "1.0")!)
        XCTAssertEqual(str.decimal(locale: .init(identifier: "en_US")), Decimal(string: "1.0")!)
        
        // Substring
        
        let subStr = str.prefix(3)
        
        XCTAssertEqual(subStr.decimal, Decimal(string: "1.0")!)
        XCTAssertEqual(subStr.decimal(locale: .init(identifier: "en_US")), Decimal(string: "1.0")!)
    }
    
    func testRounded() {
        // .rounded()
        
        XCTAssertEqual(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: -1),
            Decimal(string: "1.0")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 0),
            Decimal(string: "1.0")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 1),
            Decimal(string: "1.1")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 2),
            Decimal(string: "1.12")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 3),
            Decimal(string: "1.124")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 4),
            Decimal(string: "1.1236")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 5),
            Decimal(string: "1.1236")!
        )
        
        XCTAssertEqual(
            Decimal(string: "0.123456789")!.rounded(decimalPlaces: 8),
            Decimal(string: "0.12345679")!
        )
        
        XCTAssertEqual(Decimal(string: "-0.1")!.rounded(decimalPlaces: 0), Decimal(string: "-0.0")!)
        XCTAssertEqual(Decimal(string: "-0.1")!.rounded(decimalPlaces: 1), Decimal(string: "-0.1")!)
        XCTAssertEqual(Decimal(string: "-1.7")!.rounded(decimalPlaces: 0), Decimal(string: "-2.0")!)
        XCTAssertEqual(Decimal(string: "-1.7")!.rounded(decimalPlaces: 1), Decimal(string: "-1.7")!)
        
        // .round()
        
        var dec = Decimal(string: "0.1264")!
        dec.round(decimalPlaces: 2)
        XCTAssertEqual(dec, Decimal(string: "0.13")!)
        
        dec = Decimal(string: "0.1264")!
        dec.round(decimalPlaces: 3)
        XCTAssertEqual(dec, Decimal(string: "0.126")!)
    }
    
    func testTruncated() {
        // .truncated()
        
        XCTAssertEqual(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: -1),
            Decimal(string: "1.0")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 0),
            Decimal(string: "1.0")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 1),
            Decimal(string: "1.1")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 2),
            Decimal(string: "1.12")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 3),
            Decimal(string: "1.123")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 4),
            Decimal(string: "1.1236")!
        )
        XCTAssertEqual(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 5),
            Decimal(string: "1.1236")!
        )
        
        XCTAssertEqual(
            Decimal(string: "0.123456789")!.truncated(decimalPlaces: 8),
            Decimal(string: "0.12345678")!
        )
        
        XCTAssertEqual(Decimal(string: "-0.1")!.truncated(decimalPlaces: 0), Decimal(string: "0")!)
        XCTAssertEqual(
            Decimal(string: "-0.1")!.truncated(decimalPlaces: 1),
            Decimal(string: "-0.1")!
        )
        XCTAssertEqual(
            Decimal(string: "-1.7")!.truncated(decimalPlaces: 0),
            Decimal(string: "-1.0")!
        )
        XCTAssertEqual(
            Decimal(string: "-1.7")!.truncated(decimalPlaces: 1),
            Decimal(string: "-1.7")!
        )
        
        // .truncate()
        
        var dec = Decimal(0.1264)
        dec.truncate(decimalPlaces: 2)
        XCTAssertEqual(dec, Decimal(0.12))
    }
    
    func testTruncatingRemainder() {
        let tr = Decimal(string: "20.5")!.truncatingRemainder(dividingBy: Decimal(8))
        
        XCTAssertEqual(tr, Decimal(string: "4.5")!)
    }
    
    func testQuotientAndRemainder() {
        let qr = Decimal(string: "17.5")!.quotientAndRemainder(dividingBy: 5.0)
        
        XCTAssertEqual(qr.quotient, Decimal(string: "3")!)
        XCTAssertEqual(qr.remainder, Decimal(string: "2.5")!)
    }
    
    func testIntegralAndFraction() {
        let iaf = Decimal(string: "17.5")!.integralAndFraction
        
        XCTAssertEqual(iaf.integral, Decimal(string: "17")!)
        XCTAssertEqual(iaf.fraction, Decimal(string: "0.5")!)
        
        XCTAssertEqual(Decimal(string: "17.5")!.integral, Decimal(string: "17")!)
        XCTAssertEqual(Decimal(string: "17.5")!.fraction, Decimal(string: "0.5")!)
    }
    
    func testIntegralDigitPlaces_and_fractionDigitPlaces() {
        // we'll cast the number literals as Double to see if Decimal converts them and results are
        // still as expected
        
        XCTAssertEqual(Decimal(0.05 as Double).integralDigitPlaces, 0)
        XCTAssertEqual(Decimal(0.05 as Double).fractionDigitPlaces, 2)
        XCTAssertEqual(Decimal(-0.05 as Double).integralDigitPlaces, 0)
        XCTAssertEqual(Decimal(-0.05 as Double).fractionDigitPlaces, 2)
        
        XCTAssertEqual(Decimal(10.0 as Double).integralDigitPlaces, 2)
        XCTAssertEqual(Decimal(10.0 as Double).fractionDigitPlaces, 0)
        XCTAssertEqual(Decimal(-10.0 as Double).integralDigitPlaces, 2)
        XCTAssertEqual(Decimal(-10.0 as Double).fractionDigitPlaces, 0)
        
        XCTAssertEqual(Decimal(10.123 as Double).integralDigitPlaces, 2)
        XCTAssertEqual(Decimal(10.123 as Double).fractionDigitPlaces, 3)
        XCTAssertEqual(Decimal(-10.123 as Double).integralDigitPlaces, 2)
        XCTAssertEqual(Decimal(-10.123 as Double).fractionDigitPlaces, 3)
        
        XCTAssertEqual(Decimal(10_000.123 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(10_000.123 as Double).fractionDigitPlaces, 3)
        XCTAssertEqual(Decimal(-10_000.123 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(-10_000.123 as Double).fractionDigitPlaces, 3)
        
        XCTAssertEqual(Decimal(10_000.0 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(10_000.0 as Double).fractionDigitPlaces, 0)
        XCTAssertEqual(Decimal(-10_000.0 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(-10_000.0 as Double).fractionDigitPlaces, 0)
        
        XCTAssertEqual(Decimal(12_345.0 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(12_345.0 as Double).fractionDigitPlaces, 0)
        XCTAssertEqual(Decimal(-12_345.0 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(-12_345.0 as Double).fractionDigitPlaces, 0)
        
        XCTAssertEqual(Decimal(12_345.67 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(12_345.67 as Double).fractionDigitPlaces, 2)
        XCTAssertEqual(Decimal(-12_345.67 as Double).integralDigitPlaces, 5)
        XCTAssertEqual(Decimal(-12_345.67 as Double).fractionDigitPlaces, 2)
    }
}
