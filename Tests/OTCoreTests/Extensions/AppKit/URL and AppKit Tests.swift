//
//  URL and AppKit Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
@testable import OTCore
import XCTest

class Extensions_AppKit_URLAndAppKit_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testURLIcon() {
        // on most, if not all, systems this should produce a value
        
        let url = URL(fileURLWithPath: "/")
        let fileIcon = url.fileIcon
        XCTAssertNotNil(fileIcon)
    }
}

#endif
