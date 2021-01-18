//
//  FloatingPoint.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-12.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

// MARK: - Convenience type conversion methods

extension BinaryFloatingPoint {
	
	/// **OTCore:**
	/// Same as `Int()`
	/// (Functional convenience method)
	@inlinable public var int: Int { Int(self) }
	
	/// **OTCore:**
	/// Same as `Int(exactly:)`
	/// (Functional convenience method)
	@inlinable public var intExactly: Int? { Int(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt()`
	/// (Functional convenience method)
	@inlinable public var uint: UInt { UInt(self) }
	
	/// **OTCore:**
	/// Same as `UInt(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uintExactly: UInt? { UInt(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int8()`
	/// (Functional convenience method)
	@inlinable public var int8: Int8 { Int8(self) }
	
	/// **OTCore:**
	/// Same as `Int8(exaclty:)`
	/// (Functional convenience method)
	@inlinable public var int8Exactly: Int8? { Int8(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt8()`
	/// (Functional convenience method)
	@inlinable public var uint8: UInt8 { UInt8(self) }
	
	/// **OTCore:**
	/// Same as `UInt8(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint8Exactly: UInt8? { UInt8(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int16()`
	/// (Functional convenience method)
	@inlinable public var int16: Int16 { Int16(self) }
	
	/// **OTCore:**
	/// Same as `Int16(exaclty:)`
	/// (Functional convenience method)
	@inlinable public var int16Exactly: Int16? { Int16(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt16()`
	/// (Functional convenience method)
	@inlinable public var uint16: UInt16 { UInt16(self) }
	
	/// **OTCore:**
	/// Same as `UInt16(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint16Exactly: UInt16? { UInt16(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int32()`
	/// (Functional convenience method)
	@inlinable public var int32: Int32 { Int32(self) }
	
	/// **OTCore:**
	/// Same as `Int32(exaclty:)`
	/// (Functional convenience method)
	@inlinable public var int32Exactly: Int32? { Int32(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt32()`
	/// (Functional convenience method)
	@inlinable public var uint32: UInt32 { UInt32(self) }
	
	/// **OTCore:**
	/// Same as `UInt32(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint32Exactly: UInt32? { UInt32(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int64()`
	/// (Functional convenience method)
	@inlinable public var int64: Int64 { Int64(self) }
	
	/// **OTCore:**
	/// Same as `Int64(exaclty:)`
	/// (Functional convenience method)
	@inlinable public var int64Exactly: Int64? { Int64(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt64()`
	/// (Functional convenience method)
	@inlinable public var uint64: UInt64 { UInt64(self) }
	
	/// **OTCore:**
	/// Same as `UInt64(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint64Exactly: UInt64? { UInt64(exactly: self) }
	
}


// MARK: - boolValue

extension BinaryFloatingPoint {
	
	/// **OTCore:**
	/// Returns true if > 0.0
	@inlinable public var boolValue: Bool { self > 0.0 }
	
}


// MARK: - .truncated() / .rounded

extension FloatingPoint where Self : FloatingPointPowerComputable {
	
	/// **OTCore:**
	/// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
	///
	/// If `decimalPlaces` <= 0, trunc(self) is returned.
	public func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
						decimalPlaces: Int) -> Self {
		
		if decimalPlaces < 1 {
			return self.rounded(rule)
		}
		
		let offset = Self(10).power(Self(decimalPlaces))
		
		return (self * offset).rounded(rule) / offset
		
	}
	
	/// **OTCore:**
	/// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`.
	///
	/// If `decimalPlaces` <= 0, `trunc(self)` is used.
	public mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
							   decimalPlaces: Int) {
		
		self = self.rounded(rule, decimalPlaces: decimalPlaces)
		
	}
	
}


// MARK: - To String

extension FloatingPoint {
	
	// String(describing:) is not inlinable when passed float types that do not conform to CustomStringConvertible
	
	/// **OTCore:**
	/// Returns a string representation of a floating-point number.
	/// (Functional convenience method)
	public var string: String {
		
		String(describing: self)
		
	}
	
}

extension FloatingPoint where Self : CustomStringConvertible {
	
	// String(describing:) are inlinable when passed float types that conform to CustomStringConvertible
	
	/// **OTCore:**
	/// Returns a string representation of a floating-point number.
	/// (Functional convenience method)
	@inlinable public var string: String {
		
		String(describing: self)
		
	}
	
}


// MARK: - String To FloatingPoint

extension String {
	
	// float types init(_ text:) are inlinable when passed a StringProtocol type (including String)
	
	/// **OTCore:**
	/// Returns a `Double`, or `nil` if unsuccessful.
	/// (Functional convenience method)
	@inlinable public var double: Double? { Double(self) }
	
	/// **OTCore:**
	/// Returns a `Float`, or `nil` if unsuccessful.
	/// (Functional convenience method)
	@inlinable public var float: Float? { Float(self) }
	
	#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
	/// **OTCore:**
	/// Returns a `Float80`, or `nil` if unsuccessful.
	/// (Functional convenience method)
	@inlinable public var float80: Float80? { Float80(self) }
	#endif
	
}

extension Substring {
	
	// float types init(_ text:) are not inlinable when passed a Substring, even though when passed a StringProtocol type the init is inlinable
	
	/// **OTCore:**
	/// Returns a `Double`, or `nil` if unsuccessful.
	/// (Functional convenience method)
	public var double: Double? { Double(self) }
	
	/// **OTCore:**
	/// Returns a `Float`, or `nil` if unsuccessful.
	/// (Functional convenience method)
	public var float: Float? { Float(self) }
	
	#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
	/// **OTCore:**
	/// Returns a `Float80`, or `nil` if unsuccessful.
	/// (Functional convenience method)
	public var float80: Float80? { Float80(self) }
	#endif
	
}
