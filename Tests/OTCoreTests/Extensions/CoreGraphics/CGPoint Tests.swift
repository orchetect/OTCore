//
//  CGPoint Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-02-12.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_CoreGraphics_CGPoint_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testCGPoint_distanceToOther() {
		
		// 0 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 0, y: 1)),
			1.0
		)
		
		// 45 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: 1)),
			1.4142135623730951
		)
		
		// 90 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: 0)),
			1.0
		)
		
		// 135 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: -1)),
			1.4142135623730951
		)
		
		// 180 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 0, y: -1)),
			1.0
		)
		
		// 225 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: -1)),
			1.4142135623730951
		)
		
		// 270 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: 0)),
			1.0
		)
		
		// 315 deg
		XCTAssertEqual(
			CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: 1)),
			1.4142135623730951
		)
		
	}
	
}

#endif
