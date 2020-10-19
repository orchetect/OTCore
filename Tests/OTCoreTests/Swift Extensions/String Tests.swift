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

class Extensions_String_Tests: XCTestCase {
	
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
	
	func testSplitIntoSequencesOf() {
		
		// ____ typical cases ____
		
		
		// complex string
		
		XCTAssertEqual(
			"abc123def456gh78i9"
				.split(intoSequencesOf: .letters, .decimalDigits),
			["abc", "123", "def", "456", "gh", "78", "i", "9"])
		
		XCTAssertEqual(
			"ab_c123def_456gh78__i9"
				.split(intoSequencesOf: .letters, .decimalDigits),
			["ab", "c", "123", "def", "456", "gh", "78", "i", "9"])
		
		XCTAssertEqual(
			"ab_c123def_456gh78__i9"
				.split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
			["ab", "_", "c", "123", "def", "_", "456", "gh", "78", "__", "i", "9"])
		
		XCTAssertEqual(
			"a_c123def_456gh78__i9"
				.split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
			["a", "_", "c", "123", "def", "_", "456", "gh", "78", "__", "i", "9"])
		
		// character set precedence
		
		// (if character sets have overlapping characters, they are matched in the order listed)
		
		// alphanumerics catches all characters (including .letters and .decimalDigits), so .letters and .decimalDigits will never trigger a new grouping)
		XCTAssertEqual(
			"abc123def456gh78i9"
				.split(intoSequencesOf: .alphanumerics, .letters, .decimalDigits),
			["abc123def456gh78i9"])
		
		
		// ____ edge cases ____
		
		// empty
		
		XCTAssertEqual(
			""
				.split(intoSequencesOf: .letters, .decimalDigits),
			[])
		
		// single character
		
		XCTAssertEqual(
			"a"
				.split(intoSequencesOf: .letters, .decimalDigits),
			["a"])
		
		XCTAssertEqual(
			"1"
				.split(intoSequencesOf: .letters, .decimalDigits),
			["1"])
		
		XCTAssertEqual(
			"_"
				.split(intoSequencesOf: .letters, .decimalDigits),
			[])
		
		XCTAssertEqual(
			"_"
				.split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
			["_"])
		
		// two characters
		
		XCTAssertEqual(
			"ab"
				.split(intoSequencesOf: .letters, .decimalDigits),
			["ab"])
		
		XCTAssertEqual(
			"12"
				.split(intoSequencesOf: .letters, .decimalDigits),
			["12"])
		
		XCTAssertEqual(
			"__"
				.split(intoSequencesOf: .letters, .decimalDigits),
			[])
		
		XCTAssertEqual(
			"__"
				.split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
			["__"])
		
	}
	
	func testFilters() {
		
		// .only
		
		let str = "abcdefg 12345678 abcdefg 12345678"
		
		XCTAssertEqual(str.only(CharacterSet(charactersIn: "def456")),
					   "def456def456")
		XCTAssertEqual(str.only(characters: "def456"),
					   "def456def456")
		
		XCTAssertEqual("💚test_123,456. 789".only(.alphanumerics),
					   "test123456789")
		XCTAssertEqual("💚test_123,456. 789".onlyAlphanumerics,
					   "💚test_123,456. 789".only(.alphanumerics))
		XCTAssertEqual("💚test_123,456. 789".only(CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz1234567890")),
					   "test123456789")
		XCTAssertEqual("💚test_123,456. 789".only(characters: "abcdefghijklmnopqrstuvwxyz1234567890"),
					   "test123456789")
		
		// .removing
		
		XCTAssertEqual("abcdefg 12345678 abcdefg 12345678".removing(.alphanumerics),
					   "   ")
		XCTAssertEqual("abcdefg 12345678 abcdefg 12345678".removing(.letters),
					   " 12345678  12345678")
		XCTAssertEqual("abcdefg 12345678 abcdefg 12345678".removing(CharacterSet(charactersIn: "bdf")),
					   "aceg 12345678 aceg 12345678")
		XCTAssertEqual("abcdefg 12345678 abcdefg 12345678".removing(characters: "bdf"),
		"aceg 12345678 aceg 12345678")
		
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
	
	func testStringInterpolationFormatter() {
		
		XCTAssertEqual("\(3, format: .ordinal)", "3rd")
		XCTAssertEqual("\(3, format: .spellOut)", "three")
		
	}
	
	func testStringInterpolationRadix() {
		
		XCTAssertEqual("\("7F", radix: 16)", "127")
		XCTAssertEqual("\("7F", radix: 2)", "nil")
	}
	
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
