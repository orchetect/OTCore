//
//  String Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
import OTCore

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
    
    func testRepeating() {
        
        // String
        
        XCTAssertEqual("AB".repeating(0), "")
        XCTAssertEqual("AB".repeating(1), "AB")
        XCTAssertEqual("AB".repeating(5), "ABABABABAB")
        
        // Substring
        
        let substring = "ABCD".suffix(2)
        XCTAssertEqual(substring.repeating(0), "")
        XCTAssertEqual(substring.repeating(1), "CD")
        XCTAssertEqual(substring.repeating(5), "CDCDCDCDCD")
        
        // Character
        
        XCTAssertEqual(Character("A").repeating(0), "")
        XCTAssertEqual(Character("A").repeating(1), "A")
        XCTAssertEqual(Character("A").repeating(5), "AAAAA")
        
    }
    
    func testTrimmed() {
        
        // String
        
        XCTAssertEqual("    string    ".trimmed, "string")
        
        // Substring
        
        let substring = "    string    ".suffix(13)
        XCTAssertEqual(substring.trimmed, "string")
        
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
    
    func testRemovingPrefix() {
        
        // .removingPrefix
        
        let strrr = "///Users/user"
        
        XCTAssertEqual(strrr.removingPrefix(""), "///Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
        XCTAssertEqual(strrr.removingPrefix("nonexisting"), "///Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
        XCTAssertEqual(strrr.removingPrefix("/"), "//Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
        XCTAssertEqual(strrr.removingPrefix("/"), "//Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
        XCTAssertEqual(strrr.removingPrefix("zz"), "///Users/user")
        XCTAssertEqual(strrr, "///Users/user")
        
    }
    
    func testRemovePrefix() {
        
        // .removePrefix
        
        var strrr = "///Users/user"
        
        strrr.removePrefix("")
        XCTAssertEqual(strrr, "///Users/user")
        
        strrr.removePrefix("nonexisting")
        XCTAssertEqual(strrr, "///Users/user")
        
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
    
    // MARK: Collections tests
    // the following tests are using methods from Collections.swift
    // but specifically testing their implementation on String/StringProtocol here
    
    func testStartIndexOffsetBy() {
        
        // .startIndex(offsetBy:)
        
        let str = "1234567890"
        
        XCTAssertEqual(str.startIndex(offsetBy: 0),
                       str.startIndex)
        
        XCTAssertEqual(str.startIndex(offsetBy: 1),
                       str.index(str.startIndex, offsetBy: 1))
        
    }
    
    func testEndIndexOffsetBy() {
        
        // .endIndex(offsetBy:)
        
        let str = "1234567890"
        
        XCTAssertEqual(str.endIndex(offsetBy: 0),
                       str.endIndex)
        
        XCTAssertEqual(str.endIndex(offsetBy: -1),
                       str.index(str.endIndex, offsetBy: -1))
        
    }
    
    func testSubscriptPosition_OffsetIndex() {
        
        // String
        
        XCTAssertEqual("abc123"[position: 2], "c")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        XCTAssertEqual(substring[position: 2], "2")
        
    }
    
    func testSubscriptPosition_ClosedRange() {
        
        // String
        
        XCTAssertEqual("abc123"[position: 1...3], "bc1")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        XCTAssertEqual(substring[position: 1...3], "123")
        
    }
    
    func testSubscriptPosition_Range() {
        
        // String
        
        XCTAssertEqual("abc123"[position: 1..<3], "bc")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        XCTAssertEqual(substring[position: 1..<3], "12")
        
    }
    
    func testSubscriptPosition_PartialRangeFrom() {
        
        // String
        
        XCTAssertEqual("abc123"[position: 2...], "c123")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        XCTAssertEqual(substring[position: 2...], "23")
        
    }
    
    func testSubscriptPosition_PartialRangeThrough() {
        
        // String
        
        XCTAssertEqual("abc123"[position: ...3], "abc1")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        XCTAssertEqual(substring[position: ...3], "c123")
        
    }
    
    func testSubscriptPosition_PartialRangeUpTo() {
        
        // String
        
        XCTAssertEqual("abc123"[position: ..<3], "abc")
        
        // Substring
        
        let substring = "abc123".suffix(4)
        XCTAssertEqual(substring[position: ..<3], "c12")
        
    }
    
}

#endif
