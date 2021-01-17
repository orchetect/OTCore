//
//  String and NSRegularExpression Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_StringAndNSRegularExpression_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testRegEx() {
		
		let regPattern = "[0-9]+"
		
		let str = "The 45 turkeys ate 9 sandwiches."
		
		XCTAssertEqual(str.regexMatches(pattern: regPattern), ["45", "9"])
		
		XCTAssertEqual(str.regexMatches(pattern: regPattern, replacementTemplate: "$0-some"), "The 45-some turkeys ate 9-some sandwiches.")
		
		let capturePattern = """
			([a-zA-z\\s]*)\\s([0-9]+)\\s([a-zA-z\\s]*)\\s([0-9]+)\\s([a-zA-z\\s.]*)
			"""
		
		XCTAssertEqual(str.regexMatches(captureGroupsFromPattern: capturePattern),
					   [Optional("The"), Optional("45"), Optional("turkeys ate"), Optional("9"), Optional("sandwiches.")])
		
	}
	
}

#endif
