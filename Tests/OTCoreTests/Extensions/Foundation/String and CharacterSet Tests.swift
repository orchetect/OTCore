//
//  String and CharacterSet Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_StringAndCharacterSet_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSplitIntoSequencesOf() {
        // ____ typical cases ____
        
        // complex string
        
        XCTAssertEqual(
            "abc123def456gh78i9"
                .split(intoSequencesOf: .letters, .decimalDigits),
            ["abc", "123", "def", "456", "gh", "78", "i", "9"]
        )
        
        XCTAssertEqual(
            "ab_c123def_456gh78__i9"
                .split(intoSequencesOf: .letters, .decimalDigits),
            ["ab", "c", "123", "def", "456", "gh", "78", "i", "9"]
        )
        
        XCTAssertEqual(
            "ab_c123def_456gh78__i9"
                .split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
            ["ab", "_", "c", "123", "def", "_", "456", "gh", "78", "__", "i", "9"]
        )
        
        XCTAssertEqual(
            "a_c123def_456gh78__i9"
                .split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
            ["a", "_", "c", "123", "def", "_", "456", "gh", "78", "__", "i", "9"]
        )
        
        // character set precedence
        
        // (if character sets have overlapping characters, they are matched in the order listed)
        
        // alphanumerics catches all characters (including .letters and .decimalDigits), so .letters and .decimalDigits will never trigger a new grouping)
        XCTAssertEqual(
            "abc123def456gh78i9"
                .split(intoSequencesOf: .alphanumerics, .letters, .decimalDigits),
            ["abc123def456gh78i9"]
        )
        
        // ____ edge cases ____
        
        // empty
        
        XCTAssertEqual(
            ""
                .split(intoSequencesOf: .letters, .decimalDigits),
            []
        )
        
        // single character
        
        XCTAssertEqual(
            "a"
                .split(intoSequencesOf: .letters, .decimalDigits),
            ["a"]
        )
        
        XCTAssertEqual(
            "1"
                .split(intoSequencesOf: .letters, .decimalDigits),
            ["1"]
        )
        
        XCTAssertEqual(
            "_"
                .split(intoSequencesOf: .letters, .decimalDigits),
            []
        )
        
        XCTAssertEqual(
            "_"
                .split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
            ["_"]
        )
        
        // two characters
        
        XCTAssertEqual(
            "ab"
                .split(intoSequencesOf: .letters, .decimalDigits),
            ["ab"]
        )
        
        XCTAssertEqual(
            "12"
                .split(intoSequencesOf: .letters, .decimalDigits),
            ["12"]
        )
        
        XCTAssertEqual(
            "__"
                .split(intoSequencesOf: .letters, .decimalDigits),
            []
        )
        
        XCTAssertEqual(
            "__"
                .split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false),
            ["__"]
        )
    }
    
    func testOnlyCharacterSet() {
        // .only - single character set
        
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .only(CharacterSet(charactersIn: "def456")),
            "def456def456"
        )
        
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .only(characters: "def456"),
            "def456def456"
        )
        
        XCTAssertEqual(
            "💚test_123,456. 789"
                .only(.alphanumerics),
            "test123456789"
        )
        
        XCTAssertEqual(
            "💚test_123,456. 789"
                .onlyAlphanumerics,
            "💚test_123,456. 789"
                .only(.alphanumerics)
        )
        
        XCTAssertEqual(
            "💚test_123,456. 789"
                .only(CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz1234567890")),
            "test123456789"
        )
        
        XCTAssertEqual(
            "💚test_123,456. 789"
                .only(characters: "abcdefghijklmnopqrstuvwxyz1234567890"),
            "test123456789"
        )
    }
    
    func testOnlyCharacterSets() {
        // .only - more than one character set
        
        XCTAssertEqual(
            "💚test_123,456. 789"
                .only(.letters, .decimalDigits),
            "test123456789"
        )
    }
    
    func testRemovingCharacterSet() {
        // .removing - single character set
        
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.alphanumerics),
            "   "
        )
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.letters),
            " 12345678  12345678"
        )
        
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(CharacterSet(charactersIn: "bdf")),
            "aceg 12345678 aceg 12345678"
        )
        
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(characters: "bdf"),
            "aceg 12345678 aceg 12345678"
        )
    }
    
    func testRemovingCharacterSets() {
        // .removing - more than one character set
        
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.letters, .decimalDigits),
            "   "
        )
        
        XCTAssertEqual(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.letters, .whitespaces),
            "1234567812345678"
        )
    }
    
    func testIsASCII() {
        let asciiString = (0 ... 127)
            .map { UnicodeScalar($0)! }
            .map { "\($0)" }
            .joined()
        
        XCTAssertTrue(asciiString.isASCII)
    }
    
    func testContainsOnlyCharacterSet() {
        // .isOnly - single character set
        
        XCTAssertTrue("abcABC123àÀ".isOnly(.alphanumerics))
        XCTAssertFalse("abcABC123!@#".isOnly(.alphanumerics))
        
        XCTAssertTrue("bcA2".isOnly(characters: "abcABC123"))
        XCTAssertFalse("abcABC123!@#".isOnly(characters: "abcABC123"))
        XCTAssertFalse("abcABC123!@#".isOnly(characters: ""))
    }
    
    func testContainsOnlyCharacterSets() {
        // .isOnly - more than one character set
        
        XCTAssertTrue("abcABC123àÀ".isOnly(.letters, .decimalDigits))
        XCTAssertFalse("abcABC123!@#".isOnly(.letters, .decimalDigits))
    }
    
    func testContainsAnyCharacterSet() {
        // .contains(any:) - single character set
        
        XCTAssertTrue("abcABC123àÀ!@#$".contains(any: .alphanumerics))
        XCTAssertFalse("!@#$ [],.".contains(any: .alphanumerics))
        
        XCTAssertTrue("abcABC123àÀ!@#$".contains(anyCharacters: "abc!"))
        XCTAssertFalse("!@#$ [],.".contains(anyCharacters: "abc"))
        XCTAssertFalse("!@#$ [],.".contains(anyCharacters: ""))
    }
    
    func testContainsAnyCharacterSets() {
        // .contains(any:) - more than one character set
        
        XCTAssertTrue("abcABC123àÀ!@#$".contains(any: .letters, .decimalDigits))
        XCTAssertFalse("!@#$ [],.".contains(any: .letters, .decimalDigits))
    }
}

#endif
