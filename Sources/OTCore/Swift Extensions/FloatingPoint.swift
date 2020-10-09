//
//  FloatingPoint.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-12.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation
import CoreGraphics


// MARK: - Convenience type conversion methods

extension BinaryFloatingPoint {
	
	/// OTCore: Convenience method to return an Int()
	public var int: Int { return Int(self) }
	
	/// OTCore: Convenience method to return an Int(exaclty:)
	public var intExactly: Int? { return Int(exactly: self) }
	
	
	/// OTCore: Convenience method to return a UInt()
	public var uint: UInt { return UInt(self) }
	
	/// OTCore: Convenience method to return a UInt(exactly:)
	public var uintExactly: UInt? { return UInt(exactly: self) }
	
	
	/// OTCore: Convenience method to return an Int8()
	public var int8: Int8 { return Int8(self) }
	
	/// OTCore: Convenience method to return an Int8(exaclty:)
	public var int8Exactly: Int8? { return Int8(exactly: self) }
	
	
	/// OTCore: Convenience method to return a UInt8()
	public var uint8: UInt8 { return UInt8(self) }
	
	/// OTCore: Convenience method to return a UInt8(exactly:)
	public var uint8Exactly: UInt8? { return UInt8(exactly: self) }
	
	
	/// OTCore: Convenience method to return an Int16()
	public var int16: Int16 { return Int16(self) }
	
	/// OTCore: Convenience method to return an Int16(exaclty:)
	public var int16Exactly: Int16? { return Int16(exactly: self) }
	
	
	/// OTCore: Convenience method to return a UInt16()
	public var uint16: UInt16 { return UInt16(self) }
	
	/// OTCore: Convenience method to return a UInt16(exactly:)
	public var uint16Exactly: UInt16? { return UInt16(exactly: self) }
	
	
	/// OTCore: Convenience method to return an Int32()
	public var int32: Int32 { return Int32(self) }
	
	/// OTCore: Convenience method to return an Int32(exaclty:)
	public var int32Exactly: Int32? { return Int32(exactly: self) }
	
	
	/// OTCore: Convenience method to return a UInt32()
	public var uint32: UInt32 { return UInt32(self) }
	
	/// OTCore: Convenience method to return a UInt32(exactly:)
	public var uint32Exactly: UInt32? { return UInt32(exactly: self) }
	
	
	/// OTCore: Convenience method to return an Int64()
	public var int64: Int64 { return Int64(self) }
	
	/// OTCore: Convenience method to return an Int64(exaclty:)
	public var int64Exactly: Int64? { return Int64(exactly: self) }
	
	
	/// OTCore: Convenience method to return a UInt64()
	public var uint64: UInt64 { return UInt64(self) }
	
	/// OTCore: Convenience method to return a UInt64(exactly:)
	public var uint64Exactly: UInt64? { return UInt64(exactly: self) }
	
}


// MARK: - ceiling / floor 

extension FloatingPoint {
	
	/// OTCore: Convenience method to call `ceil()`
	public var ceiling: Self {
		Darwin.ceil(self)
	}
	
	/// OTCore: Convenience method to call `floor()`
	public var floor: Self {
		Darwin.floor(self)
	}
	
}


// MARK: - boolValue

extension BinaryFloatingPoint {
	
	/// OTCore:
	/// Returns true if > 0.0
	public var boolValue: Bool { self > 0.0 }
	
}

extension Decimal {
	
	/// OTCore:
	/// Returns true if > 0.0
	public var boolValue: Bool { self > 0.0 }
	
}


// MARK: - FloatingPointPower

/// OTCore:
/// Protocol allowing implementation of convenience methods for .power(_ exponent:)
public protocol FloatingPointPower {
	func power(_ exponent: Self) -> Self
}


// MARK: - .power()

extension Double: FloatingPointPower {
	/// OTCore:
	/// Convenience method for pow()
	public func power(_ exponent: Double) -> Double {
		pow(self, exponent)
	}
}

extension Float: FloatingPointPower {
	/// OTCore:
	/// Convenience method for pow()
	public func power(_ exponent: Float) -> Float {
		powf(self, exponent)
	}
}

#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
extension Float80: FloatingPointPower {
	/// OTCore:
	/// Convenience method for pow()
	public func power(_ exponent: Float80) -> Float80 {
		powl(self, exponent)
	}
}
#endif

extension CGFloat: FloatingPointPower {
	/// OTCore:
	/// Convenience method for pow()
	public func power(_ exponent: CGFloat) -> CGFloat {
		pow(self, exponent)
	}
}

extension Decimal {
	/// OTCore:
	/// Convenience method for pow()
	public func power(_ exponent: Int) -> Decimal {
		pow(self, exponent)
	}
}


// MARK: - .truncated() / .rounded

extension FloatingPoint where Self : FloatingPointPower {
	
	/// OTCore:
	/// Truncates decimal places to `decimalPlaces` number of decimal places. If `decimalPlaces` <= 0, trunc(self) is returned.
	public func truncated(decimalPlaces: Int) -> Self {
		if decimalPlaces < 1 {
			return trunc(self)
		}
		
		let offset = Self(10).power(Self(decimalPlaces))
		return trunc(self * offset) / offset
	}
	
	/// OTCore:
	/// Replaces this value by truncating it to `decimalPlaces` number of decimal places. If `decimalPlaces` <= 0, trunc(self) is used.
	public mutating func formTruncated(decimalPlaces: Int) {
		self = self.truncated(decimalPlaces: decimalPlaces)
	}
	
	/// OTCore:
	/// Rounds to `decimalPlaces` number of decimal places using rounding `rule`. If `decimalPlaces` <= 0, trunc(self) is returned.
	public func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero, decimalPlaces: Int) -> Self {
		if decimalPlaces < 1 {
			return self.rounded(rule)
		}
		
		let offset = Self(10).power(Self(decimalPlaces))
		
		return (self * offset).rounded(rule) / offset
	}
	
	/// OTCore:
	/// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`. If `decimalPlaces` <= 0, trunc(self) is used.
	public mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero, decimalPlaces: Int) {
		self = self.rounded(rule, decimalPlaces: decimalPlaces)
	}
	
}

extension FloatingPoint {
	
	/// OTCore:
	/// Similar to `Int.quotientAndRemainder(dividingBy:)` from the standard Swift library.
	///
	/// Note: Internally, employs `trunc()` and `.truncatingRemainder(dividingBy:)`.
	public func quotientAndRemainder(dividingBy: Self) -> (quotient: Self, remainder: Self) {
		let calculation = (self / dividingBy)
		let integral = trunc(calculation)
		let fraction = self.truncatingRemainder(dividingBy: dividingBy)
		return (quotient: integral, remainder: fraction)
	}
	
	/// OTCore:
	/// Returns both integral part and fractional part.
	/// This methos is more computationally efficient than calling `.integral` and .`fraction` properties separately unless you only require one or the other.
	///
	/// Note: this can result in a non-trivial loss of precision for the fractional part.
	public var integralAndFraction: (integral: Self, fraction: Self) {
		let integral = trunc(self)
		let fraction = self - integral
		return (integral: integral, fraction: fraction)
	}
	
	/// OTCore:
	/// Returns the integral part (digits before the decimal point)
	public var integral: Self {
		integralAndFraction.integral
	}
	
	/// OTCore:
	/// Returns the fractional part (digits after the decimal point)
	///
	/// Note: this can result in a non-trivial loss of precision for the fractional part.
	public var fraction: Self {
		integralAndFraction.fraction
	}
	
}


// MARK: - FloatingPointHighPrecisionStringConvertible

/// OTCore:
/// Protocol allowing implementation of convenience methods for .power(_ exponent:)
public protocol FloatingPointHighPrecisionStringConvertible {
	var stringValueHighPrecision: String { get }
}

extension Double:	FloatingPointHighPrecisionStringConvertible { }
extension Float:	FloatingPointHighPrecisionStringConvertible { }
extension CGFloat:	FloatingPointHighPrecisionStringConvertible { }

/// Internal - cached
fileprivate let ZeroCharacterSet = CharacterSet(charactersIn: "0")
fileprivate let PeriodCharacterSet = CharacterSet(charactersIn: ".")

extension CVarArg where Self : FloatingPointHighPrecisionStringConvertible {
	
	/// OTCore:
	/// Returns a string representation of a floating-point number, with maximum 100 decimal places of precision.
	public var stringValueHighPrecision: String {
		var formatted = String(format: "%.100f", self)
			.trimmingCharacters(in: ZeroCharacterSet)
		
		if formatted.prefix(1) == "." { formatted = "0\(formatted)" }
		
		formatted.removeSuffix(".")
		
		return formatted
	}
	
}


// MARK: - To String

extension FloatingPoint { // where Self : LosslessStringConvertible {
	
	/// OTCore:
	/// Returns a string representation of a floating-point number.
	public var string: String {
		String(describing: self)
	}
	
}

extension Decimal {
	
	/// OTCore:
	/// Returns a string representation of a Decimal number.
	public var string: String {
		String(describing: self)
	}
	
}


// MARK: - String To FloatingPoint

extension StringProtocol {
	
	/// OTCore: Convenience method to return a Double
	public var double: Double? { Double(self) }
	
	/// OTCore: Convenience method to return a Float
	public var float: Float? { Float(self) }
	
	#if !(arch(arm64) || arch(arm)) // Float80 is now removed for ARM
	/// OTCore: Convenience method to return a Float80
	public var float80: Float80? { Float80(self) }
	#endif
	
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal? { Decimal(string: String(self)) }
	
}
