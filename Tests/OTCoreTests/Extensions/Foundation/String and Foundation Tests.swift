//
//  String and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
@testable import OTCore

class Extensions_Foundation_StringAndFoundation_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testFirstIndexOfSubstring() {
        // .firstIndex(of:)
        
        let str = "This is an example string of an example."
        
        XCTAssertEqual(
            str.firstIndex(of: ""),
            nil
        )
        
        XCTAssertEqual(
            str.firstIndex(of: "i"),
            str.index(str.startIndex, offsetBy: 2)
        )
        
        XCTAssertEqual(
            str.firstIndex(of: "This"),
            str.startIndex
        )
        
        XCTAssertEqual(
            str.firstIndex(of: "example"),
            str.index(str.startIndex, offsetBy: 11)
        )
        
        // ensure Swift Standard Library method works
        // and does not produce ambiguous overloads
        XCTAssertEqual(
            str.firstIndex(of: Character("i")),
            str.index(str.startIndex, offsetBy: 2)
        )
    }
    
    func testRangeBackwards() {
        // .range(backwards:)
        
        let str = "This is an example string of an example."
        
        let rangeBackwards = str.range(backwards: "example")!
        
        XCTAssertEqual(str.distance(
            from: str.startIndex,
            to: rangeBackwards.lowerBound
        ), 32)
        
        XCTAssertEqual(str.distance(
            from: str.startIndex,
            to: rangeBackwards.upperBound
        ), 39)
        
        XCTAssertNil(str.range(backwards: "EXAMPLE"))   // nil, case sensitive
        
        XCTAssertNil(str.range(backwards: "zzz"))       // nil, not in the string
    }
    
    func testRangeBackwardsCaseInsensitive() {
        // .range(backwardsCaseInsensitive:)
        
        let str = "This is an example string of an example."
        
        let rangeBackwards = str.range(backwardsCaseInsensitive: "eXaMpLe")!
        
        XCTAssertEqual(str.distance(
            from: str.startIndex,
            to: rangeBackwards.lowerBound
        ), 32)
        
        XCTAssertEqual(str.distance(
            from: str.startIndex,
            to: rangeBackwards.upperBound
        ), 39)
        
        XCTAssertNotNil(str.range(backwardsCaseInsensitive: "EXAMPLE")) // case insensitive
        
        XCTAssertNil(str.range(backwardsCaseInsensitive: "zzz"))        // nil, not in the string
    }
    
    func testSubscriptPosition_NSRange() {
        let nsRange = NSMakeRange(1, 2) // (start: 1, length: 2) == 1...3
        
        // String
        
        XCTAssertEqual("abc123"[position: nsRange], "bc1")
        
        // Substring
        
        let string = "abc123"
        let substring = string.suffix(4)
        XCTAssertEqual(substring[position: nsRange], "123")
    }
    
    func testContainsCaseInsensitive() {
        // .contains(caseInsensitive:)
        
        let str = "This is an example string."
        
        XCTAssertTrue(str.contains(caseInsensitive: "example"))
        XCTAssertTrue(str.contains(caseInsensitive: "EXAMPLE"))
        XCTAssertFalse(str.contains(caseInsensitive: "zzz"))
        XCTAssertFalse(str.contains(caseInsensitive: ""))
    }
    
    func testHasPrefixCaseInsensitive() {
        // .hasPrefix(caseInsensitive:)
        
        let str = "This is an example string."
        
        XCTAssertTrue(str.hasPrefix(caseInsensitive: "This"))
        XCTAssertTrue(str.hasPrefix(caseInsensitive: "this"))
        XCTAssertTrue(str.hasPrefix(caseInsensitive: "THIS"))
        XCTAssertFalse(str.hasPrefix(caseInsensitive: "HIS"))
        XCTAssertFalse(str.hasPrefix(caseInsensitive: "zzz"))
        XCTAssertFalse(str.hasPrefix(caseInsensitive: ""))
    }
    
    func testHasSuffixCaseInsensitive() {
        // .hasSuffix(caseInsensitive:)
        
        let str = "This is an example string."
        
        XCTAssertTrue(str.hasSuffix(caseInsensitive: "String."))
        XCTAssertTrue(str.hasSuffix(caseInsensitive: "string."))
        XCTAssertTrue(str.hasSuffix(caseInsensitive: "STRING."))
        XCTAssertFalse(str.hasSuffix(caseInsensitive: "STRING"))
        XCTAssertFalse(str.hasSuffix(caseInsensitive: "zzz"))
        XCTAssertFalse(str.hasSuffix(caseInsensitive: ""))
    }
    
    func testTrimmed() {
        // String
        
        XCTAssertEqual("    string    ".trimmed, "string")
        
        // Substring
        
        let substring = "    string    ".suffix(13)
        XCTAssertEqual(substring.trimmed, "string")
    }
}
