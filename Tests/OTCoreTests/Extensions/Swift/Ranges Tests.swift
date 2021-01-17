//
//  Ranges Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-15.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_Ranges_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testClampedRanges() {
		
		// .clamped(ClosedRange)
		
		XCTAssertEqual(    5.clamped(to: 7...10),		  7  )
		XCTAssertEqual(    8.clamped(to: 7...10),		  8  )
		XCTAssertEqual(   20.clamped(to: 7...10),		 10  )
		
		XCTAssertEqual(  5.0.clamped(to: 7.0...10.0),	  7.0)
		XCTAssertEqual(  8.0.clamped(to: 7.0...10.0),	  8.0)
		XCTAssertEqual( 20.0.clamped(to: 7.0...10.0),	 10.0)
		
		XCTAssertEqual(  "a".clamped(to: "b"..."h"),	"b"  )
		XCTAssertEqual(  "c".clamped(to: "b"..."h"),	"c"  )
		XCTAssertEqual(  "k".clamped(to: "b"..."h"),	"h"  )
		
		// .clamped(Range)
		
		XCTAssertEqual(    5.clamped(to: 7..<10),		  7  )
		XCTAssertEqual(    8.clamped(to: 7..<10),		  8  )
		XCTAssertEqual(   20.clamped(to: 7..<10),		  9  )
		
		// .clamped(PartialRangeFrom)
		
		XCTAssertEqual(    5.clamped(to: 300...),		300  )
		XCTAssertEqual(  400.clamped(to: 300...),		400  )
		
		XCTAssertEqual(  5.0.clamped(to: 300.00...),	300.0)
		XCTAssertEqual(400.0.clamped(to: 300.00...),	400.0)
		
		XCTAssertEqual(  "a".clamped(to: "b"...),		"b"  )
		XCTAssertEqual(  "g".clamped(to: "b"...),		"g"  )

		// .clamped(PartialRangeThrough)

		XCTAssertEqual(200  .clamped(to: ...300),		200  )
		XCTAssertEqual(400  .clamped(to: ...300),		300  )
		
		XCTAssertEqual(200.0.clamped(to: ...300.0),		200.0)
		XCTAssertEqual(400.0.clamped(to: ...300.0),		300.0)
		
		XCTAssertEqual(  "a".clamped(to: ..."h"),		"a"  )
		XCTAssertEqual(  "k".clamped(to: ..."h"),		"h"  )
		
		// .clamped(PartialRangeUpTo)
		
		XCTAssertEqual(200  .clamped(to: ..<300),		200  )
		XCTAssertEqual(400  .clamped(to: ..<300),		299  )
		
	}
	
	func testFirstExcluding_ClosedRange() {
		
		// .first(excluding:) Generic Tests
		XCTAssertEqual((0...10).first(excluding: [2,5]),	0)
		XCTAssertEqual((0...10).first(excluding: [0,2,5]),	1)
		
		XCTAssertEqual((0...10).first(excluding: 0...0),	1)
		XCTAssertEqual((0...10).first(excluding: 2...5),	0)
		XCTAssertEqual((0...10).first(excluding: 0...5),	6)
		
		XCTAssertEqual((0...10).first(excluding: 2..<5),	0)
		XCTAssertEqual((0...10).first(excluding: 0..<5),	5)
		
		XCTAssertEqual((0...10).first(excluding: 2...),		0)
		XCTAssertEqual((0...10).first(excluding: 0...),		nil)
		
		XCTAssertEqual((0...10).first(excluding: ...0),		1)
		XCTAssertEqual((0...10).first(excluding: ...10),	nil)
		
		XCTAssertEqual((0...10).first(excluding: ..<0),		0)
		XCTAssertEqual((0...10).first(excluding: ..<10),	10)
		XCTAssertEqual((0...10).first(excluding: ..<11),	nil)
		
		// .first(excluding: [])
		XCTAssertEqual((1...10).first(excluding: [])						, 1)
		XCTAssertEqual((1...10).first(excluding: [-1])						, 1)
		XCTAssertEqual((1...10).first(excluding: [1])						, 2)
		XCTAssertEqual((1...10).first(excluding: [5,1,2])					, 3)
		XCTAssertEqual((1...10).first(excluding: [5,1,2,4,3,9,7,8,6])		, 10)
		XCTAssertEqual((1...10).first(excluding: [5,1,2,4,3,9,7,8,6,-1])	, 10)
		XCTAssertEqual((1...10).first(excluding: [5,1,2,4,3,9,10,7,8,6])	, nil)
		
		// first(presortedExcluding: [])
		XCTAssertEqual((1...10).first(presortedExcluding: [])						, 1)
		XCTAssertEqual((1...10).first(presortedExcluding: [-1])						, 1)
		XCTAssertEqual((1...10).first(presortedExcluding: [1])						, 2)
		XCTAssertEqual((1...10).first(presortedExcluding: [1,2])					, 3)
		XCTAssertEqual((1...10).first(presortedExcluding: [1,2,3,4,5,6,7,8,9])		, 10)
		XCTAssertEqual((1...10).first(presortedExcluding: [-1,1,2,3,4,5,6,7,8,9])	, 10)
		XCTAssertEqual((1...10).first(presortedExcluding: [1,2,3,4,6,7,9,8,10])		, 5)
		XCTAssertEqual((1...10).first(presortedExcluding: [1,2,3,4,5,6,7,8,9,10])	, nil)
		
		// .first(sortingAndExcluding: [])
		XCTAssertEqual((1...10).first(sortingAndExcluding: [])						, 1)
		XCTAssertEqual((1...10).first(sortingAndExcluding: [-1])					, 1)
		XCTAssertEqual((1...10).first(sortingAndExcluding: [1])						, 2)
		XCTAssertEqual((1...10).first(sortingAndExcluding: [2])						, 1)
		XCTAssertEqual((1...10).first(sortingAndExcluding: [5,1,2])					, 3)
		XCTAssertEqual((1...10).first(sortingAndExcluding: [5,1,2,4,3,9,7,8,6])		, 10)
		XCTAssertEqual((1...10).first(sortingAndExcluding: [5,1,2,4,3,9,7,8,6,-1])	, 10)
		XCTAssertEqual((1...10).first(sortingAndExcluding: [5,1,2,4,3,9,10,7,8,6])	, nil)
		XCTAssertEqual((1...200).first(sortingAndExcluding: Array(-10...150))		, 151)
		XCTAssertEqual((1...1000).first(sortingAndExcluding: Array(-10...999))		, 1000)
		XCTAssertEqual((1...1000).first(sortingAndExcluding: Array(-10...1100))		, nil)
		XCTAssertEqual((10...20).first(sortingAndExcluding: [15,11,10,12,14,13,19,17,18,16,9,8,7]), 20)

		// .first(excluding: ClosedRange)
		XCTAssertEqual((1...10_000).first(excluding:    10000...12000)		, 1)
		XCTAssertEqual((1...10_000).first(excluding: (-12000)...(-10000))	, 1)
		
		XCTAssertEqual((1...10_000).first(excluding: -1...(-1))				, 1)
		XCTAssertEqual((1...10_000).first(excluding: -1...0)				, 1)
		XCTAssertEqual((1...10_000).first(excluding: -1...1)				, 2)
		XCTAssertEqual((1...10_000).first(excluding: -1...2)				, 3)
		XCTAssertEqual((1...10_000).first(excluding: -1...3)				, 4)
		
		XCTAssertEqual((1...10_000).first(excluding:  0...0)				, 1)
		XCTAssertEqual((1...10_000).first(excluding:  0...1)				, 2)
		XCTAssertEqual((1...10_000).first(excluding:  0...2)				, 3)
		XCTAssertEqual((1...10_000).first(excluding:  0...3)				, 4)
		
		XCTAssertEqual((1...10_000).first(excluding:  1...1)				, 2)
		XCTAssertEqual((1...10_000).first(excluding:  1...2)				, 3)
		XCTAssertEqual((1...10_000).first(excluding:  1...3)				, 4)
		
		XCTAssertEqual((1...10_000).first(excluding:  2...2)				, 1)
		XCTAssertEqual((1...10_000).first(excluding:  2...3)				, 1)
		
		XCTAssertEqual((1...10_000).first(excluding:  3...3)				, 1)
		
		XCTAssertEqual((1...10_000).first(excluding:  1...9999)				, 10000)
		XCTAssertEqual((1...10_000).first(excluding:  1...10_000)			, nil)
		XCTAssertEqual((1...10_000).first(excluding:  2...9999)				, 1)
		
		// .first(excluding: Range)
		XCTAssertEqual((1...10_000).first(excluding:    10000..<12000)		, 1)
		XCTAssertEqual((1...10_000).first(excluding: (-12000)..<(-10000))	, 1)
		
		XCTAssertEqual((1...10_000).first(excluding: -1..<(-1))				, 1)
		XCTAssertEqual((1...10_000).first(excluding: -1..<0)				, 1)
		XCTAssertEqual((1...10_000).first(excluding: -1..<1)				, 1)
		XCTAssertEqual((1...10_000).first(excluding: -1..<2)				, 2)
		XCTAssertEqual((1...10_000).first(excluding: -1..<3)				, 3)
		
		XCTAssertEqual((1...10_000).first(excluding:  0..<0)				, 1)
		XCTAssertEqual((1...10_000).first(excluding:  0..<1)				, 1)
		XCTAssertEqual((1...10_000).first(excluding:  0..<2)				, 2)
		XCTAssertEqual((1...10_000).first(excluding:  0..<3)				, 3)
		
		XCTAssertEqual((1...10_000).first(excluding:  1..<1)				, 1)
		XCTAssertEqual((1...10_000).first(excluding:  1..<2)				, 2)
		XCTAssertEqual((1...10_000).first(excluding:  1..<3)				, 3)
		
		XCTAssertEqual((1...10_000).first(excluding:  2..<2)				, 1)
		XCTAssertEqual((1...10_000).first(excluding:  2..<3)				, 1)
		
		XCTAssertEqual((1...10_000).first(excluding:  3..<3)				, 1)
		
		XCTAssertEqual((1...10_000).first(excluding:  1..<9999)				, 9999)
		XCTAssertEqual((1...10_000).first(excluding:  1..<10_000)			, 10000)
		XCTAssertEqual((1...10_000).first(excluding:  1..<10_001)			, nil)
		XCTAssertEqual((1...10_000).first(excluding:  2..<9999)				, 1)
		
		// .first(excluding: PartialRangeFrom)
		XCTAssertEqual((1...10_000).first(excluding:  9999...)				, 1)
		XCTAssertEqual((1...10_000).first(excluding: 10000...)				, 1)
		XCTAssertEqual((1...10_000).first(excluding: 10001...)				, 1)
		XCTAssertEqual((1...10_000).first(excluding: (-1)...)				, nil)
		XCTAssertEqual((1...10_000).first(excluding: 0...)					, nil)
		XCTAssertEqual((1...10_000).first(excluding: 1...)					, nil)
		XCTAssertEqual((1...10_000).first(excluding: 2...)					, 1)
		
		// .first(excluding: PartialRangeThrough)
		XCTAssertEqual((1...10_000).first(excluding: ...9998)				, 9999)
		XCTAssertEqual((1...10_000).first(excluding: ...9999)				, 10000)
		XCTAssertEqual((1...10_000).first(excluding: ...10000)				, nil)
		XCTAssertEqual((1...10_000).first(excluding: ...10001)				, nil)
		XCTAssertEqual((1...10_000).first(excluding: ...(-1))				, 1)
		XCTAssertEqual((1...10_000).first(excluding: ...0)					, 1)
		XCTAssertEqual((1...10_000).first(excluding: ...1)					, 2)
		XCTAssertEqual((1...10_000).first(excluding: ...2)					, 3)
		
		// .first(excluding: PartialRangeUpTo)
		XCTAssertEqual((1...10_000).first(excluding: ..<9999)				, 9999)
		XCTAssertEqual((1...10_000).first(excluding: ..<10000)				, 10000)
		XCTAssertEqual((1...10_000).first(excluding: ..<10001)				, nil)
		XCTAssertEqual((1...10_000).first(excluding: ..<(-1))				, 1)
		XCTAssertEqual((1...10_000).first(excluding: ..<0)					, 1)
		XCTAssertEqual((1...10_000).first(excluding: ..<1)					, 1)
		XCTAssertEqual((1...10_000).first(excluding: ..<2)					, 2)
		
		// very large ranges
		XCTAssertEqual((1...10_000_000_000).first(excluding: [1])			, 2)
		
		// zero element ranges
		XCTAssertEqual((0...0).first(excluding: 0...5)						, nil)
		
	}
	
	func testFirstExcluding_Range() {
		
		// .first(excluding:) Generic Tests
		
		XCTAssertEqual((0..<10).first(excluding: [2,5]),	0)
		XCTAssertEqual((0..<10).first(excluding: [0,2,5]),	1)

		XCTAssertEqual((0..<10).first(excluding: 0...0),	1)
		XCTAssertEqual((0..<10).first(excluding: 2...5),	0)
		XCTAssertEqual((0..<10).first(excluding: 0...5),	6)

		XCTAssertEqual((0..<10).first(excluding: 2..<5),	0)
		XCTAssertEqual((0..<10).first(excluding: 0..<5),	5)

		XCTAssertEqual((0..<10).first(excluding: 2...),		0)
		XCTAssertEqual((0..<10).first(excluding: 0...),		nil)

		XCTAssertEqual((0..<10).first(excluding: ...0),		1)
		XCTAssertEqual((0..<10).first(excluding: ...10),	nil)

		XCTAssertEqual((0..<10).first(excluding: ..<0),		0)
		XCTAssertEqual((0..<10).first(excluding: ..<9),		9)
		XCTAssertEqual((0..<10).first(excluding: ..<10),	nil)
		
		// .first(excluding: [])
		XCTAssertEqual((1..<10).first(excluding: [])						, 1)
		XCTAssertEqual((1..<10).first(excluding: [-1])						, 1)
		XCTAssertEqual((1..<10).first(excluding: [1])						, 2)
		XCTAssertEqual((1..<10).first(excluding: [5,1,2])					, 3)
		XCTAssertEqual((1..<11).first(excluding: [5,1,2,4,3,9,7,8,6])		, 10)
		XCTAssertEqual((1..<11).first(excluding: [5,1,2,4,3,9,7,8,6,-1])	, 10)
		XCTAssertEqual((1..<11).first(excluding: [5,1,2,4,3,9,10,7,8,6])	, nil)
		
		// first(presortedExcluding: [])
		XCTAssertEqual((1..<11).first(presortedExcluding: [])						, 1)
		XCTAssertEqual((1..<11).first(presortedExcluding: [-1])						, 1)
		XCTAssertEqual((1..<11).first(presortedExcluding: [1])						, 2)
		XCTAssertEqual((1..<11).first(presortedExcluding: [1,2])					, 3)
		XCTAssertEqual((1..<11).first(presortedExcluding: [1,2,3,4,5,6,7,8,9])		, 10)
		XCTAssertEqual((1..<11).first(presortedExcluding: [-1,1,2,3,4,5,6,7,8,9])	, 10)
		XCTAssertEqual((1..<11).first(presortedExcluding: [1,2,3,4,6,7,9,8,10])		, 5)
		XCTAssertEqual((1..<11).first(presortedExcluding: [1,2,3,4,5,6,7,8,9,10])	, nil)
		
		// .first(sortingAndExcluding: [])
		XCTAssertEqual((1..<10).first(sortingAndExcluding: [])						, 1)
		XCTAssertEqual((1..<10).first(sortingAndExcluding: [-1])					, 1)
		XCTAssertEqual((1..<10).first(sortingAndExcluding: [1])						, 2)
		XCTAssertEqual((1..<10).first(sortingAndExcluding: [5,1,2])					, 3)
		XCTAssertEqual((1..<11).first(sortingAndExcluding: [5,1,2,4,3,9,7,8,6])		, 10)
		XCTAssertEqual((1..<11).first(sortingAndExcluding: [5,1,2,4,3,9,7,8,6,-1])	, 10)
		XCTAssertEqual((1..<11).first(sortingAndExcluding: [5,1,2,4,3,9,10,7,8,6])	, nil)
		XCTAssertEqual((1..<200).first(sortingAndExcluding: Array(-10...150))		, 151)
		XCTAssertEqual((1..<1001).first(sortingAndExcluding: Array(-10...999))		, 1000)
		XCTAssertEqual((1..<1000).first(sortingAndExcluding: Array(-10...1100))		, nil)
		XCTAssertEqual((10..<21).first(sortingAndExcluding: [15,11,10,12,14,13,19,17,18,16,9,8,7]), 20)
		
		// .first(excluding: ClosedRange)
		XCTAssertEqual((1..<10_000).first(excluding:     9999...12000)		, 1)
		XCTAssertEqual((1..<10_000).first(excluding: (-12000)...(-10000))	, 1)
		
		XCTAssertEqual((1..<10_000).first(excluding: -1...(-1))				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: -1...0)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: -1...1)				, 2)
		XCTAssertEqual((1..<10_000).first(excluding: -1...2)				, 3)
		XCTAssertEqual((1..<10_000).first(excluding: -1...3)				, 4)
		
		XCTAssertEqual((1..<10_000).first(excluding:  0...0)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  0...1)				, 2)
		XCTAssertEqual((1..<10_000).first(excluding:  0...2)				, 3)
		XCTAssertEqual((1..<10_000).first(excluding:  0...3)				, 4)
		
		XCTAssertEqual((1..<10_000).first(excluding:  1...1)				, 2)
		XCTAssertEqual((1..<10_000).first(excluding:  1...2)				, 3)
		XCTAssertEqual((1..<10_000).first(excluding:  1...3)				, 4)
		
		XCTAssertEqual((1..<10_000).first(excluding:  2...2)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  2...3)				, 1)
		
		XCTAssertEqual((1..<10_000).first(excluding:  3...3)				, 1)
		
		XCTAssertEqual((1..<10_000).first(excluding:  1...9998)				, 9999)
		XCTAssertEqual((1..<10_000).first(excluding:  1...9999)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding:  2...9999)				, 1)

		// .first(excluding: Range)
		XCTAssertEqual((1..<10_000).first(excluding:     9999..<12000)		, 1)
		XCTAssertEqual((1..<10_000).first(excluding: (-12000)..<(-10000))	, 1)
		
		XCTAssertEqual((1..<10_000).first(excluding: -1..<(-1))				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: -1..<0)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: -1..<1)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: -1..<2)				, 2)
		XCTAssertEqual((1..<10_000).first(excluding: -1..<3)				, 3)
		
		XCTAssertEqual((1..<10_000).first(excluding:  0..<0)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  0..<1)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  0..<2)				, 2)
		XCTAssertEqual((1..<10_000).first(excluding:  0..<3)				, 3)
		
		XCTAssertEqual((1..<10_000).first(excluding:  1..<1)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  1..<2)				, 2)
		XCTAssertEqual((1..<10_000).first(excluding:  1..<3)				, 3)
		
		XCTAssertEqual((1..<10_000).first(excluding:  2..<2)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  2..<3)				, 1)
		
		XCTAssertEqual((1..<10_000).first(excluding:  3..<3)				, 1)
		
		XCTAssertEqual((1..<10_000).first(excluding:  1..<9998)				, 9998)
		XCTAssertEqual((1..<10_000).first(excluding:  1..<9999)				, 9999)
		XCTAssertEqual((1..<10_000).first(excluding:  1..<10_000)			, nil)
		XCTAssertEqual((1..<10_000).first(excluding:  2..<9999)				, 1)

		// .first(excluding: PartialRangeFrom)
		XCTAssertEqual((1..<10_000).first(excluding:  9998...)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  9999...)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: 10000...)				, 1)
		XCTAssertEqual((1..<10_000).first(excluding:  (-1)...)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding:     0...)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding:     1...)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding:     2...)				, 1)
			
		// .first(excluding: PartialRangeThrough)
		XCTAssertEqual((1..<10_000).first(excluding: ...9997)				, 9998)
		XCTAssertEqual((1..<10_000).first(excluding: ...9998)				, 9999)
		XCTAssertEqual((1..<10_000).first(excluding: ...9999)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding: ...10000)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding: ...(-1))				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: ...0)					, 1)
		XCTAssertEqual((1..<10_000).first(excluding: ...1)					, 2)
		XCTAssertEqual((1..<10_000).first(excluding: ...2)					, 3)
		
		// .first(excluding: PartialRangeUpTo)
		XCTAssertEqual((1..<10_000).first(excluding: ..<9998)				, 9998)
		XCTAssertEqual((1..<10_000).first(excluding: ..<9999)				, 9999)
		XCTAssertEqual((1..<10_000).first(excluding: ..<10000)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding: ..<10001)				, nil)
		XCTAssertEqual((1..<10_000).first(excluding: ..<(-1))				, 1)
		XCTAssertEqual((1..<10_000).first(excluding: ..<0)					, 1)
		XCTAssertEqual((1..<10_000).first(excluding: ..<1)					, 1)
		XCTAssertEqual((1..<10_000).first(excluding: ..<2)					, 2)
		
		// very large ranges
		XCTAssertEqual((1..<10_000_000_000).first(excluding: [1])			, 2)
		
		// zero element ranges
		XCTAssertEqual((0..<0).first(excluding: 0...5)						, nil)
		
	}
	
	func testFirstExcluding_PartialRangeFrom() {
		
		// .first(excluding: [])
		XCTAssertEqual((1...).first(excluding: [])						, 1)
		XCTAssertEqual((1...).first(excluding: [-1])					, 1)
		XCTAssertEqual((1...).first(excluding: [1])						, 2)
		XCTAssertEqual((1...).first(excluding: [5,1,2])					, 3)
		XCTAssertEqual((1...).first(excluding: [5,1,2,4,3,9,7,8,6])		, 10)
		XCTAssertEqual((1...).first(excluding: [5,1,2,4,3,9,7,8,6,-1])	, 10)
		XCTAssertEqual((1...).first(excluding: [5,2,4,3,9,10,7,8,6])	, 1)
		
		// first(presortedExcluding: [])
		XCTAssertEqual((1...).first(presortedExcluding: [])						, 1)
		XCTAssertEqual((1...).first(presortedExcluding: [-1])					, 1)
		XCTAssertEqual((1...).first(presortedExcluding: [1])					, 2)
		XCTAssertEqual((1...).first(presortedExcluding: [1,2])					, 3)
		XCTAssertEqual((1...).first(presortedExcluding: [1,2,3,4,5,6,7,8,9])	, 10)
		XCTAssertEqual((1...).first(presortedExcluding: [-1,1,2,3,4,5,6,7,8,9])	, 10)
		XCTAssertEqual((1...).first(presortedExcluding: [1,2,3,4,6,7,9,8,10])	, 5)
		XCTAssertEqual((1...).first(presortedExcluding: [1,2,3,4,5,6,7,8,9,10])	, 11)
		
		// .first(sortingAndExcluding: [])
		XCTAssertEqual((1...).first(sortingAndExcluding: [])						, 1)
		XCTAssertEqual((1...).first(sortingAndExcluding: [-1])						, 1)
		XCTAssertEqual((1...).first(sortingAndExcluding: [1])						, 2)
		XCTAssertEqual((1...).first(sortingAndExcluding: [5,1,2])					, 3)
		XCTAssertEqual((1...).first(sortingAndExcluding: [5,1,2,4,3,9,7,8,6])		, 10)
		XCTAssertEqual((1...).first(sortingAndExcluding: [5,1,2,4,3,9,7,6,-1])		, 8)
		XCTAssertEqual((1...).first(sortingAndExcluding: [5,1,2,4,3,9,10,7,8,6])	, 11)
		XCTAssertEqual((1...).first(sortingAndExcluding: Array(-10...150))			, 151)
		XCTAssertEqual((1...).first(sortingAndExcluding: Array(-10...999))			, 1000)
		XCTAssertEqual((10...).first(sortingAndExcluding: [15,11,10,12,14,13,16,9,8,7]), 17)
		
		// .first(excluding: ClosedRange)
		XCTAssertEqual((1...).first(excluding: -3...(-1))			, 1)
		XCTAssertEqual((1...).first(excluding: -3...0)				, 1)
		XCTAssertEqual((1...).first(excluding: -3...1)				, 2)
		XCTAssertEqual((1...).first(excluding:  1...1)				, 2)
		XCTAssertEqual((1...).first(excluding:  1...1000)			, 1001)
		XCTAssertEqual((1...).first(excluding:  2...1000)			, 1)


		// .first(excluding: Range)
		XCTAssertEqual((1...).first(excluding: -3..<(-1))			, 1)
		XCTAssertEqual((1...).first(excluding: -3..<0)				, 1)
		XCTAssertEqual((1...).first(excluding: -3..<1)				, 1)
		XCTAssertEqual((1...).first(excluding: -3..<2)				, 2)
		XCTAssertEqual((1...).first(excluding:  1..<1)				, 1)
		XCTAssertEqual((1...).first(excluding:  1..<2)				, 2)
		XCTAssertEqual((1...).first(excluding:  1..<1000)			, 1000)
		XCTAssertEqual((1...).first(excluding:  2..<1000)			, 1)

		// .first(excluding: PartialRangeFrom)
		XCTAssertEqual((1...).first(excluding: 100...)				, 1)
		XCTAssertEqual((1...).first(excluding: (-1)...)				, nil)
		XCTAssertEqual((1...).first(excluding: 0...)				, nil)
		XCTAssertEqual((1...).first(excluding: 1...)				, nil)
		XCTAssertEqual((1...).first(excluding: 2...)				, 1)
		XCTAssertEqual((1...).first(excluding: 3...)				, 1)

		// .first(excluding: PartialRangeThrough)
		XCTAssertEqual((1...).first(excluding: ...100)				, 101)
		XCTAssertEqual((1...).first(excluding: ...(-1))				, 1)
		XCTAssertEqual((1...).first(excluding: ...0)				, 1)
		XCTAssertEqual((1...).first(excluding: ...1)				, 2)
		XCTAssertEqual((1...).first(excluding: ...2)				, 3)
		XCTAssertEqual((1...).first(excluding: ...3)				, 4)

		// .first(excluding: PartialRangeUpTo)
		XCTAssertEqual((1...).first(excluding: ..<100)				, 100)
		XCTAssertEqual((1...).first(excluding: ..<(-1))				, 1)
		XCTAssertEqual((1...).first(excluding: ..<0)				, 1)
		XCTAssertEqual((1...).first(excluding: ..<1)				, 1)
		XCTAssertEqual((1...).first(excluding: ..<2)				, 2)
		XCTAssertEqual((1...).first(excluding: ..<3)				, 3)
		
	}
	
	func testRepeatEach() {
		
		// basic functionality
		
		var count = 0
		5.repeatEach { count += 1 }
		XCTAssertEqual(count, 5)
		
		count = 0
		(1...5).repeatEach { count += 1 }
		XCTAssertEqual(count, 5)
		
		count = 0
		(1..<5).repeatEach { count += 1 }
		XCTAssertEqual(count, 4)
		
		// edge cases
		
		count = 0
		(-1).repeatEach { count += 1 }
		XCTAssertEqual(count, 0)				// only iterates on values > 0
		
		count = 0
		(1...1).repeatEach { count += 1 }		// single member range
		XCTAssertEqual(count, 1)
		
		count = 0
		(1..<1).repeatEach { count += 1 }		// no-member range
		XCTAssertEqual(count, 0)
		
		count = 0
		((-5)...(-1)).repeatEach { count += 1 }	// doesn't matter if bounds are negative
		XCTAssertEqual(count, 5)
		
		count = 0
		((-5)..<(-1)).repeatEach { count += 1 }	// doesn't matter if bounds are negative
		XCTAssertEqual(count, 4)
		
	}
	
}

#endif
