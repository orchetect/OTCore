//
//  DateComponents Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-02-24.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_Date_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	// MARK: - testdateComponents
	
	func testDateComponents_Init_String() {
		
		var parsed: DateComponents? = nil
		
		// test basic delimiters: space , . / \
		// obvious cases (ones where basic logic can obviously determine which value is which date component)
		
		parsed = "Mar 26, 2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "March 26, 2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "Mar-26-2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "26-Mar-2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "3/26/2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "03/26/2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "26/03/2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "03\\26\\2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "26\\03\\2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "03-26-2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "26-03-2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		// ambiguous cases - two-digit years
		
		parsed = "Mar-26-00".dateComponents
		XCTAssertEqual(parsed?.year,	2000)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "Mar-26-19".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "Mar-26-39".dateComponents
		XCTAssertEqual(parsed?.year,	2039)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		parsed = "Mar-26-40".dateComponents // arbitrary rollover year
		XCTAssertEqual(parsed?.year,	1940)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		26  )
		
		// ambiguous cases - low digit days
		
		parsed = "03-10-2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = "10-03-2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	10  )
		XCTAssertEqual(parsed?.day,		3   )
		
		parsed = "03-10-19".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = "10-03-19".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	10  )
		XCTAssertEqual(parsed?.day,		3   )
		
		// unusual orders
		
		parsed = "2019-03-10".dateComponents	// obvious - year is only four-digit component
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = "2019/03/10".dateComponents	// obvious - year is only four-digit component
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = "2019-10-03".dateComponents	// obvious - year is only four-digit component
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	10  )
		XCTAssertEqual(parsed?.day,		3   )
		
		parsed = "99-10-03".dateComponents		// first component is > 31 so it's taken as the year
		XCTAssertEqual(parsed?.year,	1999)
		XCTAssertEqual(parsed?.month,	10  )
		XCTAssertEqual(parsed?.day,		3   )
		
		parsed = "05-10-03".dateComponents		// defaults to assuming 3rd component is the year
		XCTAssertEqual(parsed?.year,	2003)
		XCTAssertEqual(parsed?.month,	5   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = "2019-Mar-10".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = "March 10, 2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		// missing year
		
		let currentYear = Calendar.current.component(.year, from: Date())
		
		parsed = "Mar-10".dateComponents
		XCTAssertEqual(parsed?.year,	currentYear)
		XCTAssertEqual(parsed?.month,	3          )
		XCTAssertEqual(parsed?.day,		10         )
		
		parsed = "March 10".dateComponents
		XCTAssertEqual(parsed?.year,	currentYear)
		XCTAssertEqual(parsed?.month,	3          )
		XCTAssertEqual(parsed?.day,		10         )
		
		parsed = "10 Mar".dateComponents
		XCTAssertEqual(parsed?.year,	currentYear)
		XCTAssertEqual(parsed?.month,	3          )
		XCTAssertEqual(parsed?.day,		10         )
		
		// string without separators
		
		parsed = "10Mar2019".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = "2019Mar10".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		parsed = " 2019March10 ".dateComponents
		XCTAssertEqual(parsed?.year,	2019)
		XCTAssertEqual(parsed?.month,	3   )
		XCTAssertEqual(parsed?.day,		10  )
		
		// failures
		
		parsed = "Notamonth 10, 2019".dateComponents	// invalid month
		XCTAssertNil(parsed)
		
		parsed = "March 32, 2019".dateComponents		// invalid day
		XCTAssertNil(parsed)
		
	}
	
	func testDateComponents_StringWithMask() {
		
		// empty/nil components
		
		XCTAssertEqual(DateComponents()
			.string(withMask: .YYYYMMDD),
					   "00000000")
		
		// typical components
		
		XCTAssertEqual(DateComponents(year: 2019, month: 3, day: 26)
			.string(withMask: .YYYYMMDD),
					   "20190326")
		
	}
	
}

#endif
