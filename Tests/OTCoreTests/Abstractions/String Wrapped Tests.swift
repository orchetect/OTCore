//
//  String Wrapped Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Abstractions_StringWrapped_Tests {
    @Test
    func wrapped() {
        // .wrapped
        
        #expect("string".wrapped(with: "-") == "-string-")
        
        #expect("string".wrapped(with: .parentheses) == "(string)")
        #expect("string".wrapped(with: .brackets) == "[string]")
        #expect("string".wrapped(with: .braces) == "{string}")
        #expect("string".wrapped(with: .angleBrackets) == "<string>")
        #expect("string".wrapped(with: .singleQuotes) == "'string'")
        #expect("string".wrapped(with: .quotes) == #""string""#)
    }
    
    @Test
    func categoryMethods() {
        #expect("string".parenthesized == "(string)")
        #expect("string".singleQuoted == "'string'")
        #expect("string".quoted == #""string""#)
    }
}
