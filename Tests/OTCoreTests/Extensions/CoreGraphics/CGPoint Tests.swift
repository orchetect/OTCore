//
//  CGPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreGraphics)

import CoreGraphics
@testable import OTCore
import Testing

#if canImport(Foundation)
import Foundation
#endif

@Suite struct Extensions_CoreGraphics_CGPoint_Tests {
    #if canImport(AppKit)
    /// This method used to test the OTCore property `nsPoint` which was removed in OTCore 1.7.9.
    @Test
    func nsPoint() {
        // just to confirm that the compiler sees both types as the same
        let nsPoint: NSPoint = CGPoint(x: 1.23, y: 2.5) // .nsPoint
        
        #expect(nsPoint.x == 1.23)
        #expect(nsPoint.y == 2.5)
    }
    #endif
    
    @Test
    func inverted() {
        // zero
        
        #expect(
            CGPoint(x: 0, y: 0).xInverted
                == CGPoint(x: 0, y: 0)
        )
        
        #expect(
            CGPoint(x: 0, y: 0).yInverted
                == CGPoint(x: 0, y: 0)
        )
        
        #expect(
            CGPoint(x: 0, y: 0).xyInverted
                == CGPoint(x: 0, y: 0)
        )
        
        // X
        
        #expect(
            CGPoint(x:  1, y: 1).xInverted
                == CGPoint(x: -1, y: 1)
        )
        
        #expect(
            CGPoint(x: -1, y: 1).xInverted
                == CGPoint(x:  1, y: 1)
        )
        
        // Y
        
        #expect(
            CGPoint(x: 1, y:  1).yInverted
                == CGPoint(x: 1, y: -1)
        )
        
        #expect(
            CGPoint(x: 1, y: -1).yInverted
                == CGPoint(x: 1, y:  1)
        )
        
        // XY
        
        #expect(
            CGPoint(x: -1, y:  1).xyInverted
                == CGPoint(x:  1, y: -1)
        )
        
        #expect(
            CGPoint(x:  1, y: -1).xyInverted
                == CGPoint(x: -1, y:  1)
        )
    }
    
    @Test
    func cgPoint_distanceToOther() {
        // 0 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: 0))
                == 1.0
        )
        
        // 45 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: -1))
                == 1.4142135623730951
        )
        
        // 90 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 0, y: -1))
                == 1.0
        )
        
        // 135 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: -1))
                == 1.4142135623730951
        )
        
        // 180 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: 0))
                == 1.0
        )
        
        // 225 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: -1, y: 1))
                == 1.4142135623730951
        )
        
        // 270 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 0, y: 1))
                == 1.0
        )
        
        // 315 deg
        #expect(
            CGPoint(x: 0, y: 0).distance(to: CGPoint(x: 1, y: 1))
                == 1.4142135623730951
        )
    }
    
    @Test
    func cgPoint_angleToOther() {
        // 0deg/360deg origin is X:1, Y: 0
        // Degrees ascend counterclockwise
        
        // 0 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 1, y: 0))
                == 0.0
        )
        
        // 45 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 1, y: 1))
                == 45.0
        )
        
        // 90 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 0, y: 1))
                == 90.0
        )
        
        // 135 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: -1, y: 1))
                == 135.0
        )
        
        // 180 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: -1, y: 0))
                == 180.0
        )
        
        // 225 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: -1, y: -1))
                == 225.0
        )
        
        // 270 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 0, y: -1))
                == 270.0
        )
        
        // 315 deg
        #expect(
            CGPoint(x: 0, y: 0).angle(to: CGPoint(x: 1, y: -1))
                == 315.0
        )
    }
    
    @Test
    func cgPoint_cardinalAngleToOther() {
        // 0deg/360deg origin is X:0, Y: 1 (Cardinal North)
        // Degrees ascend clockwise
        
        // 0 deg - North
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 0, y: 1))
                == 0.0
        )
        
        // 45 deg - North East
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 1, y: 1))
                == 45.0
        )
        
        // 90 deg - East
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 1, y: 0))
                == 90.0
        )
        
        // 135 deg - South East
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 1, y: -1))
                == 135.0
        )
        
        // 180 deg - South
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: 0, y: -1))
                == 180.0
        )
        
        // 225 deg - South West
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: -1, y: -1))
                == 225.0
        )
        
        // 270 deg - West
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: -1, y: 0))
                == 270.0
        )
        
        // 315 deg - North West
        #expect(
            CGPoint(x: 0, y: 0).cardinalAngle(to: CGPoint(x: -1, y: 1))
                == 315.0
        )
    }
}

#endif
