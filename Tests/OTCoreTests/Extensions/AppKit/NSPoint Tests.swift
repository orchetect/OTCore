//
//  NSPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS) && canImport(AppKit)

import XCTest
@testable import OTCore

class Extensions_Foundation_NSPoint_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testCGPoint() {
        
        let cgPoint = NSPoint(x: 1.23, y: 2.5).cgPoint
        
        XCTAssertEqual(cgPoint.x, 1.23)
        XCTAssertEqual(cgPoint.y, 2.5)
        
    }
    
}

#endif
