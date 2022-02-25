//
//  CGRect.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(CoreGraphics)

import CoreGraphics

extension CGRect {
    
    /// **OTCore:**
    /// Returns the center-point of the rect.
    @_disfavoredOverload
    public var center: CGPoint {
        
        CGPoint(x: origin.x + (width / 2),
                y: origin.y + (height / 2))
        
    }
    
    /// **OTCore:**
    /// Returns a new rect by increasing its four edges outward by the given distance.
    @_disfavoredOverload
    public func grow(by distance: CGFloat) -> Self {
        
        CGRect(x: origin.x - distance,
               y: origin.y - distance,
               width: width + (distance * 2),
               height: height + (distance * 2))
        
    }
    
    /// **OTCore:**
    /// Returns a new rect by reducing its four edges inward by the given distance.
    @_disfavoredOverload
    public func shrink(by distance: CGFloat) -> Self {
        
        CGRect(x: origin.x + distance,
               y: origin.y + distance,
               width: width - (distance * 2),
               height: height - (distance * 2))
        
    }
    
}

#endif
