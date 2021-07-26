//
//  URL and AppKit Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)

import XCTest
@testable import OTCore
import AppKit

class Extensions_AppKit_URLAndAppKit_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testURLIcon() {
        
        // on most, if not all, systems this should produce a value
        
        let url = URL(fileURLWithPath: "/")
        let fileIcon = url.icon
        XCTAssertNotNil(fileIcon)
        
    }
    
}

#endif
