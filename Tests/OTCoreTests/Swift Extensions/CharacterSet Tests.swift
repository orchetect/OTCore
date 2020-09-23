//
//  CharacterSet Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-08-17.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import OTCore

class Extensions_CharacterSet_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testContainsCharacter() {
		
		let charset = CharacterSet.alphanumerics
		
		let a = Character("a")
		let one = Character("1")
		let ds = Character("$")
		
		XCTAssertTrue(charset.contains(a))
		XCTAssertTrue(charset.contains(one))
		XCTAssertFalse(charset.contains(ds))
		
	}
	
}
