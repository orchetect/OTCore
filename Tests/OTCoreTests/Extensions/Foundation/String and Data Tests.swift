//
//  String and Data Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_StringAndData_Tests {
    @Test
    func base64() throws {
        // encode and decode
        
        let sourceString =
            " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
        
        let encodedString =
            "ICEiIyQlJicoKSorLC0uLzAxMjM0NTY3ODk6Ozw9Pj9AQUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVpbXF1eX2BhYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ent8fX4="
        
        #expect(sourceString.base64EncodedString == encodedString)
        
        let decodedString = try #require(encodedString.base64DecodedString)
        
        #expect(decodedString == sourceString)
        
        // malformed encoded data
        
        #expect("ld$%#*".base64DecodedString == nil)
    }
}

#endif
