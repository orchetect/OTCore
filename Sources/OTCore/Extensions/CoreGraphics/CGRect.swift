//
//  CGRect.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreGraphics)

import CoreGraphics

extension CGRect {
    /// **OTCore:**
    /// Returns the center-point of the rect.
    @_disfavoredOverload
    public var center: CGPoint {
        CGPoint(
            x: origin.x + (width / 2),
            y: origin.y + (height / 2)
        )
    }
    
    /// **OTCore:**
    /// Returns a new rect by increasing its four edges outward by the given distance.
    @_disfavoredOverload
    public func grow(by distance: CGFloat) -> Self {
        CGRect(
            x: origin.x - distance,
            y: origin.y - distance,
            width: width + (distance * 2),
            height: height + (distance * 2)
        )
    }
    
    /// **OTCore:**
    /// Returns a new rect by reducing its four edges inward by the given distance.
    @_disfavoredOverload
    public func shrink(by distance: CGFloat) -> Self {
        CGRect(
            x: origin.x + distance,
            y: origin.y + distance,
            width: width - (distance * 2),
            height: height - (distance * 2)
        )
    }
    
    /// **OTCore:**
    /// Returns a new rect by scaling its four edges by the given scale factor.
    @_disfavoredOverload
    public func scale(factor: CGFloat) -> Self {
        CGRect(
            x: origin.x + ((width - (width * factor)) / 2),
            y: origin.y + ((height - (height * factor)) / 2),
            width: width * factor,
            height: height * factor
        )
    }
}

#endif
