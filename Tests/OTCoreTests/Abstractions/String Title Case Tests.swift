//
//  String Title Case Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Abstractions_StringTitleCase_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testTitleCased() {
		
		XCTAssertEqual("this".titleCased,
					   "This")
		
		XCTAssertEqual("this thing".titleCased,
					   "This Thing")
		
		XCTAssertEqual("this is a test".titleCased,
					   "This is a Test")
		
	}
	
}

#endif
