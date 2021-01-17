//
//  String and NumberFormatter Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_StringAndNumberFormatter_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testStringInterpolationFormatter() {
		
		XCTAssertEqual("\(3, format: .ordinal)", "3rd")
		XCTAssertEqual("\(3, format: .spellOut)", "three")
		
	}
	
}

#endif
