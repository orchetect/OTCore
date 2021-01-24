//
//  XCTWait.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-23.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS) && canImport(XCTest)

import XCTest

public extension XCTestCase {
	
	/// Simple XCTest wait timer that does not block the runloop
	/// - Parameter timeout: floating-point duration in seconds
	func XCTWait(sec timeout: Double) {
		
		let delayExpectation = XCTestExpectation()
		delayExpectation.isInverted = true
		wait(for: [delayExpectation], timeout: timeout)
		
	}
	
}

#endif
