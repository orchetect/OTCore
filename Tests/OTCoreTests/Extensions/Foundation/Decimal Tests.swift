//
//  Decimal Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

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
        
        XCTAssertEqual(Decimal(2.0).power(3) , 8.0)
        
    }
    
    func testString() {
        
        XCTAssertEqual(Decimal(1).string, "1")
        
    }
    
    func testFromString() {
        
        // String
        
        let str = "1.0"
        
        XCTAssertEqual(str.decimal, 1.0)
        XCTAssertEqual(str.decimal(locale: .init(identifier: "en_US")), 1.0)
        
        // Substring
        
        let subStr = str.prefix(3)
        
        XCTAssertEqual(subStr.decimal, 1.0)
        XCTAssertEqual(subStr.decimal(locale: .init(identifier: "en_US")), 1.0)
        
    }
    
    func testRounded() {
        
        // .rounded()
        
        XCTAssertEqual(Decimal(1.1236).rounded(decimalPlaces: -1), Decimal(1.0))
        XCTAssertEqual(Decimal(1.1236).rounded(decimalPlaces: 0),  Decimal(1.0))
        XCTAssertEqual(Decimal(string: "1.1236")!.rounded(decimalPlaces: 2), Decimal(string: "1.12")!)
        XCTAssertEqual(Decimal(string: "1.1236")!.rounded(decimalPlaces: 3), Decimal(string: "1.124")!)
        XCTAssertEqual(Decimal(1.1236).rounded(decimalPlaces: 4),  Decimal(1.1236))
        XCTAssertEqual(Decimal(1.1236).rounded(decimalPlaces: 5),  Decimal(1.1236))
        
        XCTAssertEqual(Decimal(string: "0.123456789")!.rounded(decimalPlaces: 8), Decimal(string: "0.12345679")!)
        
        var dec = Decimal(0.1264)
        dec.round(decimalPlaces: 2)
        XCTAssertEqual(dec, Decimal(0.13))
        
        dec = Decimal(0.1264)
        dec.round(decimalPlaces: 3)
        XCTAssertEqual(dec, Decimal(0.126))
        
    }
    
    func testTruncated() {
        
        // .truncated()
        
        XCTAssertEqual(Decimal(1.1236).truncated(decimalPlaces: -1), Decimal(1.0))
        XCTAssertEqual(Decimal(1.1236).truncated(decimalPlaces: 0),  Decimal(1.0))
        //XCTAssertEqual(Decimal(1.1236).truncated(decimalPlaces: 2),  Decimal(1.12)) // becomes 1.1200000000000002048 because of the Double literal
        XCTAssertEqual(Decimal(string: "1.1236")!.truncated(decimalPlaces: 2), Decimal(string: "1.12")!)
        XCTAssertEqual(Decimal(1.1236).truncated(decimalPlaces: 3),  Decimal(1.123))
        XCTAssertEqual(Decimal(1.1236).truncated(decimalPlaces: 4),  Decimal(1.1236))
        XCTAssertEqual(Decimal(1.1236).truncated(decimalPlaces: 5),  Decimal(1.1236))
        
        XCTAssertEqual(Decimal(0.123456789).truncated(decimalPlaces: 8), Decimal(0.12345678))
        
        var dec = Decimal(0.1264)
        dec.truncate(decimalPlaces: 2)
        XCTAssertEqual(dec, Decimal(0.12))
        
    }
    
}

#endif
