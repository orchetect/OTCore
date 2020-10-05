//
//  Integers.swift
//  OTCore
//
//  Created by Steffan Andrews on 2016-06-16.
//  Copyright © 2016 orchsoft. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Convenience type conversion methods

extension BinaryInteger {
	
	/// OTCore: Convenience method to return an Int
	public var int: Int { return Int(self) }
	
	/// OTCore: Convenience method to return an Int
	public var uint: UInt { return UInt(self) }
	
	/// OTCore: Convenience method to return an Int8
	public var int8: Int8 { return Int8(self) }
	
	/// OTCore: Convenience method to return a UInt8
	public var uint8: UInt8 { return UInt8(self) }
	
	/// OTCore: Convenience method to return an Int16
	public var int16: Int16 { return Int16(self) }
	
	/// OTCore: Convenience method to return a UInt16
	public var uint16: UInt16 { return UInt16(self) }
	
	/// OTCore: Convenience method to return an Int32
	public var int32: Int32 { return Int32(self) }
	
	/// OTCore: Convenience method to return a UInt32
	public var uint32: UInt32 { return UInt32(self) }
	
	/// OTCore: Convenience method to return an Int64
	public var int64: Int64 { return Int64(self) }
	
	/// OTCore: Convenience method to return a UInt64
	public var uint64: UInt64 { return UInt64(self) }
	
}

extension BinaryInteger {
	
	/// OTCore: Convenience method to return a Double
	public var double: Double { return Double(self) }
	
	/// OTCore: Convenience method to return a Float
	public var float: Float { return Float(self) }
	
	/// OTCore: Convenience method to return a Float32
	public var float32: Float32 { return Float32(self) }
	
	#if !arch(arm64) // Float80 is removed for ARM64
	/// OTCore: Convenience method to return a Float80
	public var float80: Float80 { return Float80(self) }
	#endif
	
	/// OTCore: Convenience method to return a CGFloat
	public var cgFloat: CGFloat { return CGFloat(self) }
	
}

extension Int {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension UInt {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension Int8 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension UInt8 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension Int16 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension UInt16 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension Int32 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension UInt32 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension Int64 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}

extension UInt64 {
	/// OTCore: Convenience method to return a Decimal
	public var decimal: Decimal { return Decimal(self) }
}


extension StringProtocol {
	
	/// OTCore: Convenience method to return an Int
	public var int: Int? { return Int(self) }
	
	/// OTCore: Convenience method to return an Int
	public var uint: UInt? { return UInt(self) }
	
	/// OTCore: Convenience method to return an Int8
	public var int8: Int8? { return Int8(self) }
	
	/// OTCore: Convenience method to return a UInt8
	public var uint8: UInt8? { return UInt8(self) }
	
	/// OTCore: Convenience method to return an Int16
	public var int16: Int16? { return Int16(self) }
	
	/// OTCore: Convenience method to return a UInt16
	public var uint16: UInt16? { return UInt16(self) }
	
	/// OTCore: Convenience method to return an Int32
	public var int32: Int32? { return Int32(self) }
	
	/// OTCore: Convenience method to return a UInt32
	public var uint32: UInt32? { return UInt32(self) }
	
	/// OTCore: Convenience method to return an Int64
	public var int64: Int64? { return Int64(self) }
	
	/// OTCore: Convenience method to return a UInt64
	public var uint64: UInt64? { return UInt64(self) }
	
}


// MARK: - String Formatting

extension BinaryInteger {
	
	/// OTCore: Convenience method to return a String
	public var string: String { return String(describing: self) }
	
	/// OTCore: Convenience method to return a String, padded to `paddedTo` number of leading zeros
	public func string(paddedTo: Int) -> String { return String(format: "%0\(paddedTo)d", self as! CVarArg) }
	
}


// MARK: - Rounding

extension BinaryInteger {
	
	/// OTCore:
	/// Rounds an integer away from zero to the nearest multiple of `toMultiplesOf`. Works on negative integers too, away from 0.
	public func roundedAwayFromZero(toMultiplesOf: Self) -> Self {
		let source: Self = self >= 0 ? self : 0 - self
		let isNegative: Bool = self < 0
		
		let rem = source % toMultiplesOf
		let divisions = rem == 0 ? source : source + toMultiplesOf - rem
		return isNegative ? 0 - divisions : divisions
	}
	
	/// OTCore:
	/// Rounds an integer up to the nearest multiple of `toMultiplesOf`. Works on negative integers too, trending positive.
	public func roundedUp(toMultiplesOf: Self) -> Self {
		if toMultiplesOf < 1 { return self }
		
		let source: Self = self >= 0 ? self : 0 - self
		let isNegative: Bool = self < 0
		
		let rem = source % toMultiplesOf
		let divisions = rem == 0 ? self : self + (isNegative ? rem : toMultiplesOf - rem )
		return divisions
	}
	
	/// OTCore:
	/// Rounds an integer down to the nearest multiple of `toMultiplesOf`. Works on negative integers too, trending negative.
	public func roundedDown(toMultiplesOf: Self) -> Self {
		let source: Self = self >= 0 ? self : 0 - self
		let isNegative: Bool = self < 0
		
		let rem = source % toMultiplesOf
		let divisions = rem == 0 ? self : self - (isNegative ? toMultiplesOf - rem : rem)
		return divisions
	}
	
}


// MARK: - Binary & Bitwise

extension UnsignedInteger {
	/// OTCore:
	/// Access bits, zero-based from right-to-left
	public func bit(_ position: Int) -> Int {
		return Int((self & (0b1 << position)) >> position)
	}
}

extension Int8 {
	/// OTCore:
	/// Returns a two's complement bit format of an Int8 so it can be stored as a byte (UInt8)
	public var twosComplement: UInt8 {
		return UInt8(bitPattern: self)
	}
}

// MARK: - Random numbers

extension Array where Element : FixedWidthInteger {
	/// OTCore:
	/// Returns an array of random numbers. Values will be beween the range given, with an array size of `count`.
	///
	/// Example:
	/// ```
	/// [UInt8](randomValuesBetween: 0...255, count: 4)
	/// ```
	@inlinable public init(randomValuesBetween: ClosedRange<Element>, count: Int) {
		self.init()
		
		for _ in 0..<count {
			self.append(Element.random(in: randomValuesBetween))
		}
	}
}


// MARK: - Wrapping numbers

extension BinaryInteger {
	
	/** OTCore:
	Returns a number that has been wrapped around a range. If the number already falls within the range, the number is returned as-is. If the number underflows or overflows the range, it is wrapped around the range's bounds continuously.
	
	ie:
	```
	(-2).wrapped(around: -1...3) // 3
	(-1).wrapped(around: -1...3) // -1
	   0.wrapped(around: -1...3) // 0
	   1.wrapped(around: -1...3) // 1
	   2.wrapped(around: -1...3) // 2
	   3.wrapped(around: -1...3) // 3
	   4.wrapped(around: -1...3) // -1
	   5.wrapped(around: -1...3) // 0
	   6.wrapped(around: -1...3) // 1
	   7.wrapped(around: -1...3) // 2
	   8.wrapped(around: -1...3) // 3
	   9.wrapped(around: -1...3) // -1
	```
	- parameter range: integer range, allowing negative and positive bounds.
	*/
	public func wrapped(around range: ClosedRange<Self>) -> Self {
		let min = range.lowerBound
		let max = range.upperBound + 1
		
		if self >= min {
			let calculation = (self - min) % (max - min)
			return min + calculation
		} else {
			let calculation = max - (min - self) % (min - max)
			return calculation != max ? calculation : min
		}
	}
	
	public func wrapped(around range: Range<Self>) -> Self {
		let min = range.lowerBound
		var max = range.upperBound - 1
		
		if max < min { max = min }
		
		return self.wrapped(around: min...max)
	}
	
}


// MARK: - Digits

extension BinaryInteger {
	
	/// OTCore:
	/// Returns number of digits (places to the left of the decimal) in the number.
	///
	/// ie:
	/// - for the integer 0, this would return 1
	/// - for the integer 5, this would return 1
	/// - for the integer 10, this would return 2
	/// - for the integer 250, this would return 3
	public var numberOfDigits: Int {
		
		if self < 10 && self >= 0 || self > -10 && self < 0 {
			return 1
		} else {
			return 1 + (self / 10).numberOfDigits
		}
		
	}
	
}
