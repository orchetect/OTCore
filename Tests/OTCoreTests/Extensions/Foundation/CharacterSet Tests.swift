//
//  CharacterSet Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_CharacterSet_Tests: XCTestCase {
    
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
    
    func testConsonants() {
        
        // random sampling of test characters
        let matchingChars = "bckmzBCKMZĜǧ"
        
        XCTAssert(
            matchingChars.allSatisfy(CharacterSet.consonants.contains(_:))
        )
        
        // random sampling of test characters
        let nonMatchingChars = "aeiouàëïöùAEIOUÀËÏÖÙ"
        
        XCTAssert(
            !nonMatchingChars.allSatisfy(CharacterSet.consonants.contains(_:))
        )
        
    }
    
    func testVowels() {
        
        // random sampling of test characters
        let matchingChars = "aeiouàëïöùAEIOUÀËÏÖÙ"
        
        XCTAssert(
            matchingChars.allSatisfy(CharacterSet.vowels.contains(_:))
        )
        
        // random sampling of test characters
        let nonMatchingChars = "bckmzBCKMZĜǧ"
        
        XCTAssert(
            !nonMatchingChars.allSatisfy(CharacterSet.vowels.contains(_:))
        )
        
    }
    
    func testLowercaseVowels() {
        
        // random sampling of test characters
        let matchingChars = "aeiouàëïöù"
        
        XCTAssert(
            matchingChars.allSatisfy(CharacterSet.lowercaseVowels.contains(_:))
        )
        
        // random sampling of test characters
        let nonMatchingChars = "AEIOUÀËÏÖÙ"
        
        XCTAssert(
            !nonMatchingChars.allSatisfy(CharacterSet.lowercaseVowels.contains(_:))
        )
        
    }
    
    func testUppercaseVowels() {
        
        // random sampling of test characters
        let matchingChars = "AEIOUÀËÏÖÙ"
        
        XCTAssert(
            matchingChars.allSatisfy(CharacterSet.uppercaseVowels.contains(_:))
        )
        
        // random sampling of test characters
        let nonMatchingChars = "aeiouàëïöù"
        
        XCTAssert(
            !nonMatchingChars.allSatisfy(CharacterSet.uppercaseVowels.contains(_:))
        )
        
    }
    
}

#endif
