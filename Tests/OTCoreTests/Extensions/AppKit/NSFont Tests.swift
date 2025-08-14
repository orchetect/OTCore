//
//  NSFont Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(AppKit)

import AppKit
@testable import OTCore
import Testing

@Suite struct Extensions_AppKit_NSFont_Tests {
    @Test
    func cgFont() {
        let nsFont = NSFont.systemFont(ofSize: 10)
        
        let cgFont = nsFont.cgFont
        
        // not much we can test here, but a few properties seem testable
        
        #expect(nsFont.numberOfGlyphs == cgFont.numberOfGlyphs)
        
        if let nsPSN = nsFont.fontDescriptor.postscriptName,
           let cgPSN = cgFont.postScriptName as String?
        {
            #expect(cgPSN.hasPrefix(nsPSN))
        }
    }
}

#endif
