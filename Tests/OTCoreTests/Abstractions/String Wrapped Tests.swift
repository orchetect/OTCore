//
//  String Wrapped Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Abstractions_StringWrapped_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testWrapped() {
		
		// .wrapped
		
		XCTAssertEqual("string".wrapped(with: "-"),				"-string-")
		
		XCTAssertEqual("string".wrapped(with: .parentheses),	"(string)")
		XCTAssertEqual("string".wrapped(with: .brackets),		"[string]")
		XCTAssertEqual("string".wrapped(with: .braces),			"{string}")
		XCTAssertEqual("string".wrapped(with: .angleBrackets),	"<string>")
		XCTAssertEqual("string".wrapped(with: .singleQuotes),	"'string'")
		XCTAssertEqual("string".wrapped(with: .quotes),			"\"string\"")
		
		
	}
	
	func testCategoryMethods() {
		
		XCTAssertEqual("string".parens, "(string)")
		
		XCTAssertEqual("string".singleQuoted, "'string'")
		
		XCTAssertEqual("string".quoted, "\"string\"")
		
	}
	
}

#endif
