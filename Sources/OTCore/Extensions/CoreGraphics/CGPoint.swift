//
//  CGPoint.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-02-12.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if canImport(CoreGraphics)

import CoreGraphics

extension CGPoint {
	
	/// **OTCore:**
	/// Returns the distance between two coordinate points.
	@inlinable public func distance(to other: CGPoint) -> CGFloat {
		
		hypot(other.x - self.x, other.y - self.y)
		
	}
	
	/// **OTCore:**
	/// Returns the angle in degrees (0.0...360.0) between two `CGPoint`s.
	/// The origin (0°/360°) is on the positive X axis.
	/// Degrees ascend counterclockwise.
	///
	/// To calculate the where cardinal North is the origin (0°), use `cardinalAngle(to:)` instead.
	@inlinable public func angle(to other: CGPoint) -> CGFloat {
		
		let calc = atan2(other.y - self.y, other.x - self.x).radiansToDegrees
		
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
