//
//  NSPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(AppKit)

import AppKit
import XCTest
@testable import OTCore

class Extensions_Foundation_NSPoint_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    /// This method used to test an OTCore category property `cgPoint` which was removed in OTCore 1.7.8
    func testCGPoint() {
        // just to confirm that the compiler sees both types as the same
        let cgPoint: CGPoint = NSPoint(x: 1.23, y: 2.5) // .cgPoint
        
        XCTAssertEqual(cgPoint.x, 1.23)
        XCTAssertEqual(cgPoint.y, 2.5)
    }
}

#endif
