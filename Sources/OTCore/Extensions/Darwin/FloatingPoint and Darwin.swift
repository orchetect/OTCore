//
//  FloatingPoint and Darwin.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if canImport(Darwin)

import Darwin

// MARK: - ceiling / floor

extension FloatingPoint {
	
	/// **OTCore:**
	/// Same as `ceil()`
	/// (Functional convenience method)
	@inlinable public var ceiling: Self {
		
		Darwin.ceil(self)
		
	}
	
	/// **OTCore:**
	/// Same as `floor()`
	/// (Functional convenience method)
	@inlinable public var floor: Self {
		
		Darwin.floor(self)
		
	}
	
}


// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Double: FloatingPointPowerComputable {
	
	/// **OTCore:**
	/// Same as `pow()`
	/// (Functional convenience method)
	@inlinable public func power(_ exponent: Double) -> Double {
		
		pow(self, exponent)
		
	}
	
}

extension Float: FloatingPointPowerComputable {
	
	/// **OTCore:**
	/// Same as `powf()`
	/// (Functional convenience method)
	@inlinable public func power(_ exponent: Float) -> Float {
		
		powf(self, exponent)
		
	}
	
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: FloatingPointPowerComputable {
	
	/// **OTCore:**
	/// Same as `powl()`
	/// (Functional convenience method)
	@inlinable public func power(_ exponent: Float80) -> Float80 {
		
		powl(self, exponent)
		
	}
	
}
#endif


// MARK: - .truncated() / .rounded

extension FloatingPoint where Self : FloatingPointPowerComputable {
	
	/// **OTCore:**
	/// Replaces this value by truncating it to `decimalPlaces` number of decimal places.
	///
	/// If `decimalPlaces` <= 0, then `trunc(self)` is returned.
	public mutating func formTruncated(decimalPlaces: Int) {
		
		self = self.truncated(decimalPlaces: decimalPlaces)
		
	}
	
	/// **OTCore:**
	/// Truncates decimal places to `decimalPlaces` number of decimal places.
	///
	/// If `decimalPlaces` <= 0, then trunc(self) is returned.
	public func truncated(decimalPlaces: Int) -> Self {
		
		if decimalPlaces < 1 {
			return trunc(self)
		}
		
		let offset = Self(10).power(Self(decimalPlaces))
		return trunc(self * offset) / offset
		
	}
	
}

extension FloatingPoint {
	
	/// **OTCore:**
	/// Similar to `Int.quotientAndRemainder(dividingBy:)` from the standard Swift library.
	///
	/// - Note: Internally, employs `trunc()` and `.truncatingRemainder(dividingBy:)`.
	public func quotientAndRemainder(dividingBy: Self) -> (quotient: Self, remainder: Self) {
		
		let calculation = (self / dividingBy)
		let integral = trunc(calculation)
		let fraction = self.truncatingRemainder(dividingBy: dividingBy)
		return (quotient: integral, remainder: fraction)
		
	}
	
	/// **OTCore:**
	/// Returns both integral part and fractional part.
	/// This method is more computationally efficient than calling `.integral` and .`fraction` properties separately unless you only require one or the other.
	///
	/// Note: this can result in a non-trivial loss of precision for the fractional part.
	@inlinable public var integralAndFraction: (integral: Self, fraction: Self) {
		
		let integral = trunc(self)
		let fraction = self - integral
		return (integral: integral, fraction: fraction)
		
	}
	
	/// **OTCore:**
	/// Returns the integral part (digits before the decimal point)
	@inlinable public var integral: Self {
		
		integralAndFraction.integral
		
	}
	
	/// **OTCore:**
	/// Returns the fractional part (digits after the decimal point)
	///
	/// Note: this can result in a non-trivial loss of precision for the fractional part.
	@inlinable public var fraction: Self {
		
		integralAndFraction.fraction
		
	}
	
}

#endif
