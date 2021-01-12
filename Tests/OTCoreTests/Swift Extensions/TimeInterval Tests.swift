//
//  TimeInterval Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-09.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

import Foundation

#if !os(watchOS)

import XCTest
@testable import OTCore

class TimeInterval_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testTimeInterval_init_Timespec() {
		
		let ti = TimeInterval(timespec(tv_sec: 1, tv_nsec: 234_567_891))
		
		XCTAssertEqual(ti, TimeInterval(1.234_567_891))
		
	}
	
}

#endif
