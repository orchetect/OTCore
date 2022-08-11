//
//  NSFont Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)

import XCTest
@testable import OTCore
import AppKit

class Extensions_AppKit_NSFont_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testCGFont() {
        let nsFont = NSFont.systemFont(ofSize: 10)
        
        let cgFont = nsFont.cgFont
        
        // not much we can test here, but a few properties seem testable
        
        XCTAssertEqual(nsFont.numberOfGlyphs, cgFont.numberOfGlyphs)
        
        if let nsPSN = nsFont.fontDescriptor.postscriptName,
           let cgPSN = cgFont.postScriptName as String?
        {
            XCTAssert(cgPSN.hasPrefix(nsPSN))
        }
    }
}

#endif
