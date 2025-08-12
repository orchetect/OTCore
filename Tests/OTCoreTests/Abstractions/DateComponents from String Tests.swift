//
//  DateComponents from String Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import XCTest

class Abstractions_DateComponentsFromString_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testDateComponents_Init_String() {
        let parsed = DateComponents(fuzzy: "Mar 26, 2019")
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
    }
    
    func testStringParsing() {
        var parsed: DateComponents?
        
        // test basic delimiters: space , . / \
        // obvious cases (ones where basic logic can obviously determine which value is which date
        // component)
        
        parsed = "Mar 26, 2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "March 26, 2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "Mar-26-2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "26-Mar-2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "3/26/2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "03/26/2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "26/03/2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "03\\26\\2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "26\\03\\2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "03-26-2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "26-03-2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        // ambiguous cases - two-digit years
        
        parsed = "Mar-26-00".dateComponents
        XCTAssertEqual(parsed?.year,    2000)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "Mar-26-19".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "Mar-26-39".dateComponents
        XCTAssertEqual(parsed?.year,    2039)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        parsed = "Mar-26-40".dateComponents // arbitrary rollover year
        XCTAssertEqual(parsed?.year,    1940)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     26)
        
        // ambiguous cases - low digit days
        
        parsed = "03-10-2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "10-03-2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   10)
        XCTAssertEqual(parsed?.day,     3)
        
        parsed = "03-10-19".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "10-03-19".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   10)
        XCTAssertEqual(parsed?.day,     3)
        
        // unusual orders
        
        parsed = "2019-03-10".dateComponents    // obvious - year is only four-digit component
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "2019/03/10".dateComponents    // obvious - year is only four-digit component
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "2019-10-03".dateComponents    // obvious - year is only four-digit component
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   10)
        XCTAssertEqual(parsed?.day,     3)
        
        parsed = "99-10-03".dateComponents      // first component is > 31 so it's taken as the year
        XCTAssertEqual(parsed?.year,    1999)
        XCTAssertEqual(parsed?.month,   10)
        XCTAssertEqual(parsed?.day,     3)
        
        parsed = "05-10-03".dateComponents      // defaults to assuming 3rd component is the year
        XCTAssertEqual(parsed?.year,    2003)
        XCTAssertEqual(parsed?.month,   5)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "2019-Mar-10".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "March 10, 2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        // missing year
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        parsed = "Mar-10".dateComponents
        XCTAssertEqual(parsed?.year,    currentYear)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "March 10".dateComponents
        XCTAssertEqual(parsed?.year,    currentYear)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "10 Mar".dateComponents
        XCTAssertEqual(parsed?.year,    currentYear)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        // string without separators
        
        parsed = "10Mar2019".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = "2019Mar10".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        parsed = " 2019March10 ".dateComponents
        XCTAssertEqual(parsed?.year,    2019)
        XCTAssertEqual(parsed?.month,   3)
        XCTAssertEqual(parsed?.day,     10)
        
        // failures
        
        parsed = "Notamonth 10, 2019".dateComponents    // invalid month
        XCTAssertNil(parsed)
        
        parsed = "March 32, 2019".dateComponents        // invalid day
        XCTAssertNil(parsed)
    }
    
    #if compiler(>=6.2) // Swift 6.2 Foundation required
    func testDateComponentsParseStrategy() throws {
        // TODO: have to make this a guard statement with XCTest as it doesn't play nice with @available attributes on test functions, but when migrating to Swift Testing this can transition to being a @availble keyword on the test func
        guard #available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) // DateComponents(_, strategy:) requirement
        else {
            throw XCTSkip("Not available on this platform.")
        }
        
        let parsed = try DateComponents("Mar 26, 2019", strategy: .fuzzyDate)
        XCTAssertEqual(parsed.year,    2019)
        XCTAssertEqual(parsed.month,   3)
        XCTAssertEqual(parsed.day,     26)
    }
    #endif
    
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testDateParseStrategy() throws {
        let parsed = try Date(
            "Mar 26, 2019",
            strategy: .fuzzyDate(calendar: .current, timeZone: .init(secondsFromGMT: 0)!)
        )
        XCTAssertEqual(parsed.timeIntervalSince1970, 1553558400.0)
    }
    
    func testDateComponents_StringWithMask() {
        // empty/nil components
        
        XCTAssertEqual(
            DateComponents()
                .string(withMask: .YYYYMMDD),
            "00000000"
        )
        
        // typical components
        
        XCTAssertEqual(
            DateComponents(year: 2019, month: 3, day: 26)
                .string(withMask: .YYYYMMDD),
            "20190326"
        )
    }
}
