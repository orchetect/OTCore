//
//  CGPoint.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(CoreGraphics)

import CoreGraphics

extension CGPoint {
    
    /// **OTCore:**
    /// Returns the point with the X value inverted.
    @inlinable public var xInverted: CGPoint {
        
        var newX = x
        newX.negate()
        
        return .init(x: newX, y: y)
        
    }
    
    /// **OTCore:**
    /// Returns the point with the Y value inverted.
    @inlinable public var yInverted: CGPoint {
        
        var newY = y
        newY.negate()
        
        return .init(x: x, y: newY)
        
    }
    
    /// **OTCore:**
    /// Returns the point with the X and Y value inverted.
    @inlinable public var xyInverted: CGPoint {
        
        var newX = x
        newX.negate()
        
        var newY = y
        newY.negate()
        
        return .init(x: newX, y: newY)
        
    }
    
}

extension CGPoint {
    
    /// **OTCore:**
    /// Returns the distance between two coordinate points.
    @inlinable public func distance(to other: CGPoint) -> CGFloat {
        
        hypot(other.x - x, other.y - y)
        
    }
    
    /// **OTCore:**
    /// Returns the angle in degrees (0.0...360.0) between two `CGPoint`s.
    /// The origin (0°/360°) is on the positive X axis.
    /// Degrees ascend counterclockwise.
    ///
    /// To calculate the where cardinal North is the origin (0°), use `cardinalAngle(to:)` instead.
    @inlinable public func angle(to other: CGPoint) -> CGFloat {
        
        let calc = atan2(other.y - y, other.x - x).radiansToDegrees
        
        if calc < 0 {
            return calc + 360.0
        }
        
        return calc
        
    }
    
    /// **OTCore:**
    /// Returns the angle in degrees (0.0...360.0) between two `CGPoint`s.
    /// The origin (0°/360°) is on the positive Y axis (cardinal North).
    /// Degrees ascend clockwise.
    @inlinable public func cardinalAngle(to other: CGPoint) -> CGFloat {
        
        (360.0 - angle(to: other) + 90.0)
            .wrapped(around: 0.0..<360.0)
        
    }
    
}

#endif
