//
//  Timespec and TimeInterval Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_TimespecAndTimeInterval_Tests: XCTestCase {

	func testTimespec_inits() {
		
		// timespec(_ interval:)
		
		let ts = timespec(TimeInterval(2.987_654_321))
		
		XCTAssertEqual(ts.tv_sec, 2)
		XCTAssertEqual(ts.tv_nsec, 987_654_321)
		
	}

	func testTimespec_doubleValue() {
		
		// timespec.doubleValue
		
		var ts = timespec(tv_sec: 1, tv_nsec: 234_567_891)
		
		XCTAssertEqual(ts.doubleValue, 1.234_567_891)
		
		ts = timespec(tv_sec: 2, tv_nsec: 987_654_321)
		
		XCTAssertEqual(ts.doubleValue, 2.987_654_321)
		
	}

}

#endif
