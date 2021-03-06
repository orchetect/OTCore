//
//  CGFloat.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if canImport(CoreGraphics)

import CoreGraphics

// MARK: - FloatingPointHighPrecisionStringConvertible

extension CGFloat: FloatingPointHighPrecisionStringConvertible { }


// MARK: - Convenience type conversion methods

extension BinaryInteger {
	
	/// **OTCore:**
	/// Same as `CGFloat()`
	/// (Functional convenience method)
	@inlinable public var cgFloat: CGFloat { CGFloat(self) }
	
	/// **OTCore:**
	/// Same as `CGFloat(exactly:)`
	/// (Functional convenience method)
	@inlinable public var cgFloatExactly: CGFloat? { CGFloat(exactly: self) }
	
}

extension BinaryFloatingPoint {
	
	/// **OTCore:**
	/// Same as `CGFloat()`
	/// (Functional convenience method)
	@inlinable public var cgFloat: CGFloat { CGFloat(self) }
	
	/// **OTCore:**
	/// Same as `CGFloat(exactly:)`
	/// (Functional convenience method)
	@inlinable public var cgFloatExactly: CGFloat? { CGFloat(exactly: self) }
	
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension CGFloat: FloatingPointPowerComputable {
	
	/// **OTCore:**
	/// Same as `pow()`
	/// (Functional convenience method)
	@inlinable public func power(_ exponent: CGFloat) -> CGFloat {
		
		pow(self, exponent)
		
	}
	
}

// MARK: - From String

extension StringProtocol {
	
	/// **OTCore:**
	/// Constructs `CGFloat` from a `String` by converting to `Double` as intermediary.
	/// (Functional convenience method)
	@inlinable public var cgFloat: CGFloat? {
		
		guard let doubleValue = Double(self) else { return nil }
		return CGFloat(doubleValue)
		
	}
	
}

#endif
