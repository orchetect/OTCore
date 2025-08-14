//
//  String and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_StringAndFoundation_Tests {
    @Test
    func firstIndexOfSubstring() {
        // .firstIndex(of:)
        
        let str = "This is an example string of an example."
        
        #expect(
            str.firstIndex(of: "")
                == nil
        )
        
        #expect(
            str.firstIndex(of: "i")
                == str.index(str.startIndex, offsetBy: 2)
        )
        
        #expect(
            str.firstIndex(of: "This")
                == str.startIndex
        )
        
        #expect(
            str.firstIndex(of: "example")
                == str.index(str.startIndex, offsetBy: 11)
        )
        
        // ensure Swift Standard Library method works
        // and does not produce ambiguous overloads
        #expect(
            str.firstIndex(of: Character("i"))
                == str.index(str.startIndex, offsetBy: 2)
        )
    }
    
    @Test
    func rangeBackwards() {
        // .range(backwards:)
        
        let str = "This is an example string of an example."
        
        let rangeBackwards = str.range(backwards: "example")!
        
        #expect(
            str.distance(from: str.startIndex, to: rangeBackwards.lowerBound)
                == 32
        )
        
        #expect(
            str.distance(from: str.startIndex, to: rangeBackwards.upperBound)
                == 39
        )
        
        #expect(str.range(backwards: "EXAMPLE") == nil) // case sensitive
        
        #expect(str.range(backwards: "zzz") == nil) // not in the string
    }
    
    @Test
    func rangeBackwardsCaseInsensitive() {
        // .range(backwardsCaseInsensitive:)
        
        let str = "This is an example string of an example."
        
        let rangeBackwards = str.range(backwardsCaseInsensitive: "eXaMpLe")!
        
        #expect(
            str.distance(from: str.startIndex, to: rangeBackwards.lowerBound)
                == 32
        )
        
        #expect(
            str.distance(from: str.startIndex, to: rangeBackwards.upperBound)
                == 39
        )
        
        #expect(str.range(backwardsCaseInsensitive: "EXAMPLE") != nil) // case insensitive
        
        #expect(str.range(backwardsCaseInsensitive: "zzz") == nil) // not in the string
    }
    
    @Test
    func subscriptPosition_NSRange() {
        let nsRange = NSMakeRange(1, 2) // (start: 1, length: 2) == 1...3
        
        // String
        
        #expect("abc123"[position: nsRange] == "bc1")
        
        // Substring
        
        let string = "abc123"
        let substring = string.suffix(4)
        #expect(substring[position: nsRange] == "123")
    }
    
    @Test
    func containsCaseInsensitive() {
        // .contains(caseInsensitive:)
        
        let str = "This is an example string."
        
        #expect(str.contains(caseInsensitive: "example"))
        #expect(str.contains(caseInsensitive: "EXAMPLE"))
        #expect(!str.contains(caseInsensitive: "zzz"))
        #expect(!str.contains(caseInsensitive: ""))
    }
    
    @Test
    func hasPrefixCaseInsensitive() {
        // .hasPrefix(caseInsensitive:)
        
        let str = "This is an example string."
        
        #expect(str.hasPrefix(caseInsensitive: "This"))
        #expect(str.hasPrefix(caseInsensitive: "this"))
        #expect(str.hasPrefix(caseInsensitive: "THIS"))
        #expect(!str.hasPrefix(caseInsensitive: "HIS"))
        #expect(!str.hasPrefix(caseInsensitive: "zzz"))
        #expect(!str.hasPrefix(caseInsensitive: ""))
    }
    
    @Test
    func hasSuffixCaseInsensitive() {
        // .hasSuffix(caseInsensitive:)
        
        let str = "This is an example string."
        
        #expect(str.hasSuffix(caseInsensitive: "String."))
        #expect(str.hasSuffix(caseInsensitive: "string."))
        #expect(str.hasSuffix(caseInsensitive: "STRING."))
        #expect(!str.hasSuffix(caseInsensitive: "STRING"))
        #expect(!str.hasSuffix(caseInsensitive: "zzz"))
        #expect(!str.hasSuffix(caseInsensitive: ""))
    }
    
    @Test
    func trimmed() {
        // String
        
        #expect("    string    ".trimmed == "string")
        
        // Substring
        
        let substring = "    string    ".suffix(13)
        #expect(substring.trimmed == "string")
    }
}

#endif
