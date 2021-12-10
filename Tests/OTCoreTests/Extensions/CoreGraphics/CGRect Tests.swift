//
//  CGRect Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_CoreGraphics_CGRect_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testCenter() {
        
        let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
        
        let center = rect.center
        
        XCTAssertEqual(center.x, 7)
        XCTAssertEqual(center.y, 13)
        
    }
    
    func testGrow() {
        
        let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
        
        let newRect = rect.grow(by: 1.5)
        
        XCTAssertEqual(newRect.origin.x, 0.5)
        XCTAssertEqual(newRect.origin.y, 1.5)
        XCTAssertEqual(newRect.width, 13.0)
        XCTAssertEqual(newRect.height, 23.0)
        
    }
    
    func testShrink() {
        
        let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
        
        let newRect = rect.shrink(by: 1.5)
        
        XCTAssertEqual(newRect.origin.x, 3.5)
        XCTAssertEqual(newRect.origin.y, 4.5)
        XCTAssertEqual(newRect.width, 7.0)
        XCTAssertEqual(newRect.height, 17.0)
        
    }
    
}

#endif
