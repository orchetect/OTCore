//
//  CGPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_CoreGraphics_CGPoint_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    #if canImport(AppKit)
    func testNSPoint() {
        let nsPoint = CGPoint(x: 1.23, y: 2.5).nsPoint
        
        XCTAssertEqual(nsPoint.x, 1.23)
        XCTAssertEqual(nsPoint.y, 2.5)
    }
    #endif
    
    func testInverted() {
        // zero
        
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).xInverted,
            CGPoint(x: 0, y: 0)
        )
        
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).yInverted,
            CGPoint(x: 0, y: 0)
        )
        
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).xyInverted,
            CGPoint(x: 0, y: 0)
        )
        
        // X
        
        XCTAssertEqual(
            CGPoint(x:  1, y: 1).xInverted,
            CGPoint(x: -1, y: 1)
        )
        
        XCTAssertEqual(
            CGPoint(x: -1, y: 1).xInverted,
            CGPoint(x:  1, y: 1)
        )
        
        // Y
        
        XCTAssertEqual(
            CGPoint(x: 1, y:  1).yInverted,
            CGPoint(x: 1, y: -1)
        )
        
        XCTAssertEqual(
            CGPoint(x: 1, y: -1).yInverted,
            CGPoint(x: 1, y:  1)
        )
        
        // XY
        
        XCTAssertEqual(
            CGPoint(x: -1, y:  1).xyInverted,
            CGPoint(x:  1, y: -1)
        )
        
        XCTAssertEqual(
            CGPoint(x:  1, y: -1).xyInverted,
            CGPoint(x: -1, y:  1)
        )
    }
    
    func testCGPoint_distanceToOther() {
        // 0 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: 0)),
            1.0
        )
        
        // 45 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: -1)),
            1.4142135623730951
        )
        
        // 90 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 0, y: -1)),
            1.0
        )
        
        // 135 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: -1)),
            1.4142135623730951
        )
        
        // 180 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: 0)),
            1.0
        )
        
        // 225 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: 1)),
            1.4142135623730951
        )
        
        // 270 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 0, y: 1)),
            1.0
        )
        
        // 315 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: 1)),
            1.4142135623730951
        )
    }
    
    func testCGPoint_angleToOther() {
        // 0deg/360deg origin is X:1, Y: 0
        // Degrees ascend counterclockwise
        
        // 0 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 1, y: 0)),
            0.0
        )
        
        // 45 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 1, y: 1)),
            45.0
        )
        
        // 90 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 0, y: 1)),
            90.0
        )
        
        // 135 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: -1, y: 1)),
            135.0
        )
        
        // 180 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: -1, y: 0)),
            180.0
        )
        
        // 225 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: -1, y: -1)),
            225.0
        )
        
        // 270 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 0, y: -1)),
            270.0
        )
        
        // 315 deg
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 1, y: -1)),
            315.0
        )
    }
    
    func testCGPoint_cardinalAngleToOther() {
        // 0deg/360deg origin is X:0, Y: 1 (Cardinal North)
        // Degrees ascend clockwise
        
        // 0 deg - North
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 0, y: 1)),
            0.0
        )
        
        // 45 deg - North East
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 1, y: 1)),
            45.0
        )
        
        // 90 deg - East
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 1, y: 0)),
            90.0
        )
        
        // 135 deg - South East
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 1, y: -1)),
            135.0
        )
        
        // 180 deg - South
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 0, y: -1)),
            180.0
        )
        
        // 225 deg - South West
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: -1, y: -1)),
            225.0
        )
        
        // 270 deg - West
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: -1, y: 0)),
            270.0
        )
        
        // 315 deg - North West
        XCTAssertEqual(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: -1, y: 1)),
            315.0
        )
    }
}

#endif
