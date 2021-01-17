//
//  String and Data Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_StringAndData_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testBase64() {
		
		// encode and decode
		
		let sourceString = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
		
		let encodedString = "ICEiIyQlJicoKSorLC0uLzAxMjM0NTY3ODk6Ozw9Pj9AQUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVpbXF1eX2BhYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ent8fX4="
		
		XCTAssertEqual(sourceString.base64EncodedString, encodedString)
		
		let decodedString = encodedString.base64DecodedString
		
		XCTAssertNotNil(decodedString)
		
		XCTAssertEqual(decodedString!, sourceString)
		
		// malformed encoded data
		
		XCTAssertNil("ld$%#*".base64DecodedString)
		
	}
	
}

#endif
