//
//  String and CharacterSet Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_StringAndCharacterSet_Tests {
    @Test
    func splitIntoSequencesOf() {
        // ____ typical cases ____
        
        // complex string
        
        #expect(
            "abc123def456gh78i9"
                .split(intoSequencesOf: .letters, .decimalDigits)
                == ["abc", "123", "def", "456", "gh", "78", "i", "9"]
        )
        
        #expect(
            "ab_c123def_456gh78__i9"
                .split(intoSequencesOf: .letters, .decimalDigits)
                == ["ab", "c", "123", "def", "456", "gh", "78", "i", "9"]
        )
        
        #expect(
            "ab_c123def_456gh78__i9"
                .split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false)
                == ["ab", "_", "c", "123", "def", "_", "456", "gh", "78", "__", "i", "9"]
        )
        
        #expect(
            "a_c123def_456gh78__i9"
                .split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false)
                == ["a", "_", "c", "123", "def", "_", "456", "gh", "78", "__", "i", "9"]
        )
        
        // character set precedence
        
        // (if character sets have overlapping characters, they are matched in the order listed)
        
        // alphanumerics catches all characters (including .letters and .decimalDigits), so .letters
        // and .decimalDigits will never trigger a new grouping)
        #expect(
            "abc123def456gh78i9"
                .split(intoSequencesOf: .alphanumerics, .letters, .decimalDigits)
                == ["abc123def456gh78i9"]
        )
        
        // ____ edge cases ____
        
        // empty
        
        #expect(
            "".split(intoSequencesOf: .letters, .decimalDigits)
                == []
        )
        
        // single character
        
        #expect(
            "a".split(intoSequencesOf: .letters, .decimalDigits)
                == ["a"]
        )
        
        #expect(
            "1".split(intoSequencesOf: .letters, .decimalDigits)
                == ["1"]
        )
        
        #expect(
            "_".split(intoSequencesOf: .letters, .decimalDigits)
                == []
        )
        
        #expect(
            "_".split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false)
                == ["_"]
        )
        
        // two characters
        
        #expect(
            "ab".split(intoSequencesOf: .letters, .decimalDigits)
                == ["ab"]
        )
        
        #expect(
            "12".split(intoSequencesOf: .letters, .decimalDigits)
                == ["12"]
        )
        
        #expect(
            "__".split(intoSequencesOf: .letters, .decimalDigits)
                == []
        )
        
        #expect(
            "__".split(intoSequencesOf: .letters, .decimalDigits, omitNonmatching: false)
                == ["__"]
        )
    }
    
    @Test
    func onlyCharacterSet() {
        // .only - single character set
        
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .only(CharacterSet(charactersIn: "def456"))
                == "def456def456"
        )
        
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .only(charactersIn: "def456")
                == "def456def456"
        )
        
        #expect(
            "💚test_123,456. 789"
                .only(.alphanumerics)
                == "test123456789"
        )
        
        #expect(
            "💚test_123,456. 789"
                .onlyAlphanumerics
                == "💚test_123,456. 789"
                .only(.alphanumerics)
        )
        
        #expect(
            "💚test_123,456. 789"
                .only(CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz1234567890"))
                == "test123456789"
        )
        
        #expect(
            "💚test_123,456. 789"
                .only(charactersIn: "abcdefghijklmnopqrstuvwxyz1234567890")
                == "test123456789"
        )
    }
    
    @Test
    func onlyCharacterSets() {
        // .only - more than one character set
        
        #expect(
            "💚test_123,456. 789"
                .only(.letters, .decimalDigits)
                == "test123456789"
        )
    }
    
    @Test
    func removingCharacterSet() {
        // .removing - single character set
        
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.alphanumerics)
                == "   "
        )
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.letters)
                == " 12345678  12345678"
        )
        
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(CharacterSet(charactersIn: "bdf"))
                == "aceg 12345678 aceg 12345678"
        )
        
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(characters: "bdf")
                == "aceg 12345678 aceg 12345678"
        )
    }
    
    @Test
    func removingCharacterSets() {
        // .removing - more than one character set
        
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.letters, .decimalDigits)
                == "   "
        )
        
        #expect(
            "abcdefg 12345678 abcdefg 12345678"
                .removing(.letters, .whitespaces)
                == "1234567812345678"
        )
    }
    
    @Test
    func isASCII() {
        let asciiString = (0 ... 127)
            .map { UnicodeScalar($0)! }
            .map { "\($0)" }
            .joined()
        
        #expect(asciiString.isASCII)
    }
    
    @Test
    func containsOnlyCharacterSet() {
        // .isOnly - single character set
        
        #expect("abcABC123àÀ".isOnly(.alphanumerics))
        #expect(!"abcABC123!@#".isOnly(.alphanumerics))
        
        #expect("bcA2".isOnly(charactersIn: "abcABC123"))
        #expect(!"abcABC123!@#".isOnly(charactersIn: "abcABC123"))
        #expect(!"abcABC123!@#".isOnly(charactersIn: ""))
    }
    
    @Test
    func containsOnlyCharacterSets() {
        // .isOnly - more than one character set
        
        #expect("abcABC123àÀ".isOnly(.letters, .decimalDigits))
        #expect(!"abcABC123!@#".isOnly(.letters, .decimalDigits))
    }
    
    @Test
    func containsAnyCharacterSet() {
        // .contains(any:) - single character set
        
        #expect("abcABC123àÀ!@#$".contains(any: .alphanumerics))
        #expect(!"!@#$ [],.".contains(any: .alphanumerics))
        
        #expect("abcABC123àÀ!@#$".contains(anyCharactersIn: "abc!"))
        #expect(!"!@#$ [],.".contains(anyCharactersIn: "abc"))
        #expect(!"!@#$ [],.".contains(anyCharactersIn: ""))
    }
    
    @Test
    func containsAnyCharacterSets() {
        // .contains(any:) - more than one character set
        
        #expect("abcABC123àÀ!@#$".contains(any: .letters, .decimalDigits))
        #expect(!"!@#$ [],.".contains(any: .letters, .decimalDigits))
    }
}

#endif
