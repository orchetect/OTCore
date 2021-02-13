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
	
	@inlinable public func angle(to other: CGPoint) -> CGFloat {
		let calc = atan2(other.y - self.y, other.x - self.x).radiansToDegrees
		
		if calc < 0 {
			return calc + 360.0
		}
		return calc
	}
	
}

#endif
