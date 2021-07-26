//
//  String Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_String_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testStringConstants() {
        
        _ = String.quote
        _ = String.tab
        _ = String.space
        _ = String.newLine
        _ = String.null
        
    }
    
    func testCharacterConstants() {
        
        _ = Character.quote
        _ = Character.tab
        _ = Character.space
        _ = Character.newLine
        _ = Character.null
        
    }
    
    func testStringFunctionalAppendConstants() {
        
        // .newLined
        
        XCTAssertEqual("test".newLined, "test\n")
        
        // .tabbed
        
        XCTAssertEqual("test".tabbed, "test\t")
        
        // .newLine()
        
        var strNL = "test"
        strNL.newLine()
        XCTAssertEqual(strNL, "test\n")
        
        // .tab()
        
        var strTab = "test"
        strTab.tab()
        XCTAssertEqual(strTab, "test\t")
        
    }
    
    func testRangeBackwards() {
        
        // .range(backwards:)
        
        let str = "This is an example string of an example."
        
        let rangeBackwards = str.range(backwards: "example")!
        
        XCTAssertEqual(str.distance(from: str.startIndex,
                                    to: rangeBackwards.lowerBound), 32)
        
        XCTAssertEqual(str.distance(from: str.startIndex,
                                    to: rangeBackwards.upperBound), 39)
        
        XCTAssertNil(str.range(backwards: "EXAMPLE"))   // nil, case sensitive
        
        XCTAssertNil(str.range(backwards: "zzz"))       // nil, not in the string
        
    }
    
    func testRangeBackwardsCaseInsensitive() {
        
        // .range(backwardsCaseInsensitive:)
        
        let str = "This is an example string of an example."
        
        let rangeBackwards = str.range(backwardsCaseInsensitive: "eXaMpLe")!
        
        XCTAssertEqual(str.distance(from: str.startIndex,
                                    to: rangeBackwards.lowerBound), 32)
        
        XCTAssertEqual(str.distance(from: str.startIndex,
                                    to: rangeBackwards.upperBound), 39)
        
        XCTAssertNotNil(str.range(backwardsCaseInsensitive: "EXAMPLE")) // case insensitive
        
        XCTAssertNil(str.range(backwardsCaseInsensitive: "zzz"))        // nil, not in the string
        
    }
    
    func testRangeContainsCaseInsensitive() {
        
        // .contains(caseInsensitive:)
        
        let str = "This is an example string."
        
        XCTAssertTrue( str.contains(caseInsensitive: "example"))
        XCTAssertTrue( str.contains(caseInsensitive: "EXAMPLE"))
        XCTAssertFalse(str.contains(caseInsensitive: "zzz"))
        
    }
    
    func testRangeStartsWithCaseInsensitive() {
        
        // .starts(withCaseInsensitive:)
        
        let str = "This is an example string."
        
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
        
    }
    
    func testTrim() {
        
        // .trim()
        
        var str = "    string    "
        str.trim()
        
        XCTAssertEqual(str, "string")
        
    }
    
    func testSplitEvery() {
        
        // .split(every:)
        
        let str = "1234567890"
        
        XCTAssertEqual(str.split(every: 2), ["12", "34", "56", "78", "90"])
        XCTAssertEqual(str.split(every: 4), ["1234", "5678", "90"])
        XCTAssertEqual(str.split(every: 4, backwards: true), ["12", "3456", "7890"])
        
    }
    
    func testRemovePrefix() {
        
        var strrr = "///Users/user"
        
        // .removingPrefix
        
        XCTAssertEqual(strrr.removingPrefix("/"), "//Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
        XCTAssertEqual(strrr.removingPrefix("/"), "//Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
        XCTAssertEqual(strrr.removingPrefix("zz"), "///Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
        // .removePrefix
        
        strrr.removePrefix("/")
        XCTAssertEqual(strrr, "//Users/user")
        
        strrr.removePrefix("/")
        XCTAssertEqual(strrr, "/Users/user")
        
        strrr.removePrefix("/")
        XCTAssertEqual(strrr, "Users/user")
        
        strrr.removePrefix("/")
        XCTAssertEqual(strrr, "Users/user")
        
    }
    
    func testRemoveSuffix() {
        
        var strrr = "file:///Users/user///"
        
        // .removingSuffix
        
        XCTAssertEqual(strrr.removingSuffix("/"), "file:///Users/user//")
        XCTAssertEqual(strrr, "file:///Users/user///")
        
        XCTAssertEqual(strrr.removingSuffix("/"), "file:///Users/user//")
        XCTAssertEqual(strrr, "file:///Users/user///")
        
        XCTAssertEqual(strrr.removingSuffix("zz"), "file:///Users/user///")
        XCTAssertEqual(strrr, "file:///Users/user///")
        
        // .removeSuffix
        
        strrr.removeSuffix("/")
        XCTAssertEqual(strrr, "file:///Users/user//")
        
        strrr.removeSuffix("/")
        XCTAssertEqual(strrr, "file:///Users/user/")
        
        strrr.removeSuffix("/")
        XCTAssertEqual(strrr, "file:///Users/user")
        
        strrr.removeSuffix("/")
        XCTAssertEqual(strrr, "file:///Users/user")
        
    }
    
    func testOptionalString() {
        
        XCTAssertEqual(optionalString(describing: Int(exactly: 123),
                                      ifNil: "0"),
                       "123")
        
        XCTAssertEqual(optionalString(describing: Int(exactly: 123.4),
                                      ifNil: "0"),
                       "0")
        
    }
    
    func testStringInterpolationIfNil() {
        
        XCTAssertEqual("\(Int(exactly: 123), ifNil: "0")",
                       "123")
        
        XCTAssertEqual("\(Int(exactly: 123.4), ifNil: "0")",
                       "0")
        
    }
    
    func testStringInterpolationRadix() {
        
        XCTAssertEqual("\("7F", radix: 16)", "127")
        XCTAssertEqual("\("7F", radix: 2)", "nil")
    }
    
    func testSubstringToString() {
        
        let str = "123"
        
        // form Substring
        
        let subStr = str.prefix(3)
        XCTAssertEqual(String(describing: type(of: subStr)), "Substring")
        
        // .string
        
        let toStr = subStr.string
        
        XCTAssertEqual(toStr, String("123"))
        XCTAssertEqual(String(describing: type(of: toStr)), "String")
        
    }
    
    func testCharacterToString() {
        
        let char = Character("1")
        
        // .string
        
        let toStr = char.string
        
        XCTAssertEqual(toStr, String("1"))
        XCTAssertEqual(String(describing: type(of: toStr)), "String")
        
    }
    
}

#endif
