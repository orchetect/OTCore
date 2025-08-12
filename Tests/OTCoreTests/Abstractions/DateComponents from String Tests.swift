//
//  DateComponents from String Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import Testing

@Suite struct Abstractions_DateComponentsFromString_Tests {
    @Test
    func dateComponents_Init_String() {
        let parsed = DateComponents(fuzzy: "Mar 26, 2019")
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
    }
    
    @Test
    func stringParsing() {
        var parsed: DateComponents?
        
        // test basic delimiters: space , . / \
        // obvious cases (ones where basic logic can obviously determine which value is which date
        // component)
        
        parsed = "Mar 26, 2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "March 26, 2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "Mar-26-2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "26-Mar-2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "3/26/2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "03/26/2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "26/03/2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "03\\26\\2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "26\\03\\2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "03-26-2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "26-03-2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        // ambiguous cases - two-digit years
        
        parsed = "Mar-26-00".dateComponents
        #expect(parsed?.year ==    2000)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "Mar-26-19".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "Mar-26-39".dateComponents
        #expect(parsed?.year ==    2039)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        parsed = "Mar-26-40".dateComponents // arbitrary rollover year
        #expect(parsed?.year ==    1940)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     26)
        
        // ambiguous cases - low digit days
        
        parsed = "03-10-2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "10-03-2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   10)
        #expect(parsed?.day ==     3)
        
        parsed = "03-10-19".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "10-03-19".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   10)
        #expect(parsed?.day ==     3)
        
        // unusual orders
        
        parsed = "2019-03-10".dateComponents    // obvious - year is only four-digit component
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "2019/03/10".dateComponents    // obvious - year is only four-digit component
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "2019-10-03".dateComponents    // obvious - year is only four-digit component
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   10)
        #expect(parsed?.day ==     3)
        
        parsed = "99-10-03".dateComponents      // first component is > 31 so it's taken as the year
        #expect(parsed?.year ==    1999)
        #expect(parsed?.month ==   10)
        #expect(parsed?.day ==     3)
        
        parsed = "05-10-03".dateComponents      // defaults to assuming 3rd component is the year
        #expect(parsed?.year ==    2003)
        #expect(parsed?.month ==   5)
        #expect(parsed?.day ==     10)
        
        parsed = "2019-Mar-10".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "March 10, 2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        // missing year
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        parsed = "Mar-10".dateComponents
        #expect(parsed?.year ==    currentYear)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "March 10".dateComponents
        #expect(parsed?.year ==    currentYear)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "10 Mar".dateComponents
        #expect(parsed?.year ==    currentYear)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        // string without separators
        
        parsed = "10Mar2019".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = "2019Mar10".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        parsed = " 2019March10 ".dateComponents
        #expect(parsed?.year ==    2019)
        #expect(parsed?.month ==   3)
        #expect(parsed?.day ==     10)
        
        // failures
        
        parsed = "Notamonth 10, 2019".dateComponents    // invalid month
        #expect(parsed == nil)
        
        parsed = "March 32, 2019".dateComponents        // invalid day
        #expect(parsed == nil)
    }
    
    #if compiler(>=6.2) // Swift 6.2 Foundation required
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) // DateComponents(_, strategy:) requirement
    @Test
    func dateComponentsParseStrategy() throws {
        let parsed = try DateComponents("Mar 26, 2019", strategy: .fuzzyDate)
        #expect(parsed.year ==    2019)
        #expect(parsed.month ==   3)
        #expect(parsed.day ==     26)
    }
    #endif
    
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @Test
    func dateParseStrategy() throws {
        let parsed = try Date(
            "Mar 26, 2019",
            strategy: .fuzzyDate(calendar: .current, timeZone: .init(secondsFromGMT: 0)!)
        )
        #expect(parsed.timeIntervalSince1970 == 1553558400.0)
    }
    
    @Test
    func dateComponents_StringWithMask() {
        // empty/nil components
        
        #expect(
            DateComponents()
                .string(withMask: .YYYYMMDD)
            == "00000000"
        )
        
        // typical components
        
        #expect(
            DateComponents(year: 2019, month: 3, day: 26)
                .string(withMask: .YYYYMMDD)
            == "20190326"
        )
    }
}
