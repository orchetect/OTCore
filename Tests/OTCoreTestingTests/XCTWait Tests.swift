//
//  XCTWait Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-23.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import OTCoreTesting
import OTCore

class XCTWait_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testXCTWait() {
		
		let startTime = clock_gettime_monotonic_raw()
		
		XCTWait(sec: 0.5)
		
		let endTime = clock_gettime_monotonic_raw()
		
		let diffTime = (endTime - startTime).doubleValue
		
		// test if wait duration was within reasonable margin of error +/-
		
		XCTAssert(diffTime.isContained(in: 0.499...0.505))
		
	}
	
}
