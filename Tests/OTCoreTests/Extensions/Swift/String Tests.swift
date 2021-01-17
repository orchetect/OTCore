//
//  String Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-07.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_String_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testRanges() {
		
		// .range(backwards:)
		
		var str = "This is an example string of an example."
		
		var rangeBackwards = str.range(backwards: "example")!
		XCTAssertEqual(str.distance(from: str.startIndex, to: rangeBackwards.lowerBound), 32)
		XCTAssertEqual(str.distance(from: str.startIndex, to: rangeBackwards.upperBound), 39)
		
		XCTAssertNil(str.range(backwards: "EXAMPLE"))	// nil, case sensitive
		
		XCTAssertNil(str.range(backwards: "zzz"))		// nil, not in the string
		
		
		// .range(backwardsCaseInsensitive:)
		
		str = "This is an example string of an example."
		
		rangeBackwards = str.range(backwardsCaseInsensitive: "eXaMpLe")!
		XCTAssertEqual(str.distance(from: str.startIndex, to: rangeBackwards.lowerBound), 32)
		XCTAssertEqual(str.distance(from: str.startIndex, to: rangeBackwards.upperBound), 39)
		
		XCTAssertNotNil(str.range(backwardsCaseInsensitive: "EXAMPLE"))	// case insensitive
		
		XCTAssertNil(str.range(backwardsCaseInsensitive: "zzz"))		// nil, not in the string
		
		
		// .contains(caseInsensitive:)
		
		str = "This is an example string."
		
		XCTAssertTrue( str.contains(caseInsensitive: "example"))
		XCTAssertTrue( str.contains(caseInsensitive: "EXAMPLE"))
		XCTAssertFalse(str.contains(caseInsensitive: "zzz"))
		
		
		// .starts(withCaseInsensitive:)
		
		str = "This is an example string."
		
		XCTAssertTrue( str.starts(withCaseInsensitive: "this"))
		XCTAssertTrue( str.starts(withCaseInsensitive: "THIS"))
		XCTAssertFalse(str.starts(withCaseInsensitive: "zzz"))
		
	}
	
	func testRepeating() {
		
		XCTAssertEqual("A".repeating(5), "AAAAA")
		
	}
	
	func testTrimmed() {
		
		// .trimmed
		
		XCTAssertEqual("    string    ".trimmed, "string")
		
		// .trim()
		
		var str = "    string    "
		str.trim()
		
		XCTAssertEqual(str, "string")
		
	}
	
	func testWrapped() {
		
		// .wrapped
		
		XCTAssertEqual("string".wrapped(with: "-"),				"-string-")
		
		XCTAssertEqual("string".wrapped(with: .parentheses),	"(string)")
		XCTAssertEqual("string".wrapped(with: .brackets),		"[string]")
		XCTAssertEqual("string".wrapped(with: .braces),			"{string}")
		XCTAssertEqual("string".wrapped(with: .angleBrackets),	"<string>")
		
		
	}
	
	func testSplitEvery() {
		
		// .split(every:)
		
		let str = "1234567890"
		
		XCTAssertEqual(str.split(every: 2), ["12", "34", "56", "78", "90"])
		XCTAssertEqual(str.split(every: 4), ["1234", "5678", "90"])
		XCTAssertEqual(str.split(every: 4, backwards: true), ["12", "3456", "7890"])
		
	}
	
	func testPrefixAndSuffixExtensions() {
		
		// Suffix
		
		var strrr = "file:///Users/user///"
		XCTAssertEqual(strrr.removingSuffix("/"),  "file:///Users/user//")	; XCTAssertEqual(strrr, "file:///Users/user///")
		XCTAssertEqual(strrr.removingSuffix("/"),  "file:///Users/user//")	; XCTAssertEqual(strrr, "file:///Users/user///")
		XCTAssertEqual(strrr.removingSuffix("zz"), "file:///Users/user///")	; XCTAssertEqual(strrr, "file:///Users/user///")
		strrr.removeSuffix("/")												; XCTAssertEqual(strrr, "file:///Users/user//")
		strrr.removeSuffix("/")												; XCTAssertEqual(strrr, "file:///Users/user/")
		strrr.removeSuffix("/")												; XCTAssertEqual(strrr, "file:///Users/user")
		strrr.removeSuffix("/")												; XCTAssertEqual(strrr, "file:///Users/user")
		
		// Prefix
		
		strrr = "///Users/user"
		XCTAssertEqual(strrr.removingPrefix("/"),   "//Users/user")			; XCTAssertEqual(strrr, "///Users/user")
		XCTAssertEqual(strrr.removingPrefix("/"),   "//Users/user")			; XCTAssertEqual(strrr, "///Users/user")
		XCTAssertEqual(strrr.removingPrefix("zz"), "///Users/user")			; XCTAssertEqual(strrr, "///Users/user")
		strrr.removePrefix("/")												; XCTAssertEqual(strrr, "//Users/user")
		strrr.removePrefix("/")												; XCTAssertEqual(strrr, "/Users/user")
		strrr.removePrefix("/")												; XCTAssertEqual(strrr, "Users/user")
		strrr.removePrefix("/")												; XCTAssertEqual(strrr, "Users/user")
	}
	
	func testTitleCased() {
		
		XCTAssertEqual("this".titleCased,
					   "This")
		
		XCTAssertEqual("this thing".titleCased,
					   "This Thing")
		
		XCTAssertEqual("this is a test".titleCased,
					   "This is a Test")
		
	}
	
	func testOptionalString() {
		
		// method
		
		XCTAssertEqual(optionalString(describing: Int(exactly: 123), ifNil: "0"), "123")
		
		XCTAssertEqual(optionalString(describing: Int(exactly: 123.4), ifNil: "0"), "0")
		
		// string interpolation
		
		XCTAssertEqual("\(Int(exactly: 123), ifNil: "0")", "123")
		
		XCTAssertEqual("\(Int(exactly: 123.4), ifNil: "0")", "0")
		
	}
	
	func testStringInterpolationRadix() {
		
		XCTAssertEqual("\("7F", radix: 16)", "127")
		XCTAssertEqual("\("7F", radix: 2)", "nil")
	}
	
}

#endif
