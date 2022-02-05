//
//  Pasteboard Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)

import XCTest
@testable import OTCore

class Extensions_AppKit_Pasteboard_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testFileURLBackCompat() {
        
        // no meaningful tests can be devised here
        
        _ = NSPasteboard.PasteboardType.fileURLBackCompat
        
    }
    
}

#endif
