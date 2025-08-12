//
//  CharacterSet Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

@testable import OTCore
import XCTest

class Extensions_Foundation_CharacterSet_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInitCharactersArray() {
        let chars: [Character] = ["a", "á", "e", "ö", "1", "%", "😄", "👨‍👩‍👦"]
        
        let cs = CharacterSet(chars)
        
        XCTAssert(chars.allSatisfy(cs.contains))
        
        XCTAssertFalse(cs.contains(.init("é")))
        XCTAssertFalse(cs.contains(.init("o")))
        
        XCTAssertEqual("ghijkl234567890âēAÁEÖ_a_á_e_ö_1_%_😄_👨‍👩‍👦".only(cs), "aáeö1%😄👨‍👩‍👦")
    }
    
    func testInitCharactersVariadic() {
        let chars: [Character] = ["a", "á", "e", "ö", "1", "%", "😄", "👨‍👩‍👦"]
        
        // variadic parameter
        let cs = CharacterSet("a", "á", "e", "ö", "1", "%", "😄", "👨‍👩‍👦")
        
        XCTAssert(chars.allSatisfy(cs.contains))
        
        XCTAssertFalse(cs.contains(.init("é")))
        XCTAssertFalse(cs.contains(.init("o")))
        
        XCTAssertEqual("ghijkl234567890âēAÁEÖ_a_á_e_ö_1_%_😄_👨‍👩‍👦".only(cs), "aáeö1%😄👨‍👩‍👦")
    }
    
    func testContainsCharacter() {
        let charset = CharacterSet.alphanumerics
        
        let a: Character = "a"
        let one: Character = "1"
        let ds: Character = "$"
        
        XCTAssertTrue(charset.contains(a))
        XCTAssertTrue(charset.contains(one))
        XCTAssertFalse(charset.contains(ds))
    }
    
    func testOperators() {
        // +
        
        let added: CharacterSet = .letters + .decimalDigits
        
        XCTAssertTrue(added.contains("a"))
        XCTAssertTrue(added.contains("1"))
        XCTAssertFalse(added.contains("!"))
        
        // +=
        
        var addedInPlace: CharacterSet = .letters
        addedInPlace += .decimalDigits
        
        XCTAssertTrue(addedInPlace.contains("a"))
        XCTAssertTrue(addedInPlace.contains("1"))
        XCTAssertFalse(addedInPlace.contains("!"))
        
        // -
        
        let subtracted: CharacterSet = .alphanumerics - .decimalDigits
        
        XCTAssertTrue(subtracted.contains("a"))
        XCTAssertFalse(subtracted.contains("1"))
        XCTAssertFalse(subtracted.contains("!"))
        
        // -=
        
        var subtractedInPlace: CharacterSet = .alphanumerics
        subtractedInPlace -= .decimalDigits
        
        XCTAssertTrue(subtractedInPlace.contains("a"))
        XCTAssertFalse(subtractedInPlace.contains("1"))
        XCTAssertFalse(subtractedInPlace.contains("!"))
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
