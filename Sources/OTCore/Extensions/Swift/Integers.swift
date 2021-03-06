//
//  Integers.swift
//  OTCore
//
//  Created by Steffan Andrews on 2016-06-16.
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

// MARK: - Convenience type conversion methods

extension BinaryInteger {
	
	/// **OTCore:**
	/// Same as `Int`
	/// (Functional convenience method)
	@inlinable public var int: Int { Int(self) }
	
	/// **OTCore:**
	/// Same as `UInt`
	/// (Functional convenience method)
	@inlinable public var uint: UInt { UInt(self) }
	
	/// **OTCore:**
	/// Same as `Int8`
	/// (Functional convenience method)
	@inlinable public var int8: Int8 { Int8(self) }
	
	/// **OTCore:**
	/// Same as `UInt8`
	/// (Functional convenience method)
	@inlinable public var uint8: UInt8 { UInt8(self) }
	
	/// **OTCore:**
	/// Same as `Int16`
	/// (Functional convenience method)
	@inlinable public var int16: Int16 { Int16(self) }
	
	/// **OTCore:**
	/// Same as `UInt16`
	/// (Functional convenience method)
	@inlinable public var uint16: UInt16 { UInt16(self) }
	
	/// **OTCore:**
	/// Same as `Int32`
	/// (Functional convenience method)
	@inlinable public var int32: Int32 { Int32(self) }
	
	/// **OTCore:**
	/// Same as `UInt32`
	/// (Functional convenience method)
	@inlinable public var uint32: UInt32 { UInt32(self) }
	
	/// **OTCore:**
	/// Same as `Int64`
	/// (Functional convenience method)
	@inlinable public var int64: Int64 { Int64(self) }
	
	/// **OTCore:**
	/// Same as `UInt64`
	/// (Functional convenience method)
	@inlinable public var uint64: UInt64 { UInt64(self) }
	
}

extension BinaryInteger {
	
	/// **OTCore:**
	/// Same as `Int(exactly:)`
	/// (Functional convenience method)
	@inlinable public var intExactly: Int? { Int(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uintExactly: UInt? { UInt(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int8(exactly:)`
	/// (Functional convenience method)
	@inlinable public var int8Exactly: Int8? { Int8(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt8(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint8Exactly: UInt8? { UInt8(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int16(exactly:)`
	/// (Functional convenience method)
	@inlinable public var int16Exactly: Int16? { Int16(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt16(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint16Exactly: UInt16? { UInt16(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int32(exactly:)`
	/// (Functional convenience method)
	@inlinable public var int32Exactly: Int32? { Int32(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt32(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint32Exactly: UInt32? { UInt32(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Int64(exactly:)`
	/// (Functional convenience method)
	@inlinable public var int64Exactly: Int64? { Int64(exactly: self) }
	
	/// **OTCore:**
	/// Same as `UInt64(exactly:)`
	/// (Functional convenience method)
	@inlinable public var uint64Exactly: UInt64? { UInt64(exactly: self) }
	
}

extension BinaryInteger {
	
	/// **OTCore:**
	/// Same as `Double()`
	/// (Functional convenience method)
	@inlinable public var double: Double { Double(self) }
	
	/// **OTCore:**
	/// Same as `Double(exactly:)`
	/// (Functional convenience method)
	@inlinable public var doubleExactly: Double? { Double(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Float()`
	/// (Functional convenience method)
	@inlinable public var float: Float { Float(self) }
	
	/// **OTCore:**
	/// Same as `Float(exactly:)`
	/// (Functional convenience method)
	@inlinable public var floatExactly: Float? { Float(exactly: self) }
	
	/// **OTCore:**
	/// Same as `Float32()`
	/// (Functional convenience method)
	@inlinable public var float32: Float32 { Float32(self) }
	
	#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
	/// **OTCore:**
	/// Same as `Float80()`
	/// (Functional convenience method)
	@inlinable public var float80: Float80 { Float80(self) }
	#endif
	
}

extension StringProtocol {
	
	/// **OTCore:**
	/// Same as `Int()`
	/// (Functional convenience method)
	@inlinable public var int: Int? { Int(self) }
	
	/// **OTCore:**
	/// Same as `Int()`
	/// (Functional convenience method)
	@inlinable public var uint: UInt? { UInt(self) }
	
	/// **OTCore:**
	/// Same as `Int8()`
	/// (Functional convenience method)
	@inlinable public var int8: Int8? { Int8(self) }
	
	/// **OTCore:**
	/// Same as `UInt8()`
	/// (Functional convenience method)
	@inlinable public var uint8: UInt8? { UInt8(self) }
	
	/// **OTCore:**
	/// Same as `Int16()`
	/// (Functional convenience method)
	@inlinable public var int16: Int16? { Int16(self) }
	
	/// **OTCore:**
	/// Same as `UInt16()`
	/// (Functional convenience method)
	@inlinable public var uint16: UInt16? { UInt16(self) }
	
	/// **OTCore:**
	/// Same as `Int32()`
	/// (Functional convenience method)
	@inlinable public var int32: Int32? { Int32(self) }
	
	/// **OTCore:**
	/// Same as `UInt32()`
	/// (Functional convenience method)
	@inlinable public var uint32: UInt32? { UInt32(self) }
	
	/// **OTCore:**
	/// Same as `Int64()`
	/// (Functional convenience method)
	@inlinable public var int64: Int64? { Int64(self) }
	
	/// **OTCore:**
	/// Same as `UInt64()`
	/// (Functional convenience method)
	@inlinable public var uint64: UInt64? { UInt64(self) }
	
}


// MARK: - String Formatting

extension BinaryInteger {
	
	/// **OTCore:**
	/// Same as `String(describing: self)`
	/// (Functional convenience method)
	@inlinable public var string: String { String(describing: self) }
	
	/// **OTCore:**
	/// Convenience method to return a String, padded to `paddedTo` number of leading zeros
	@inlinable public func string(paddedTo: Int) -> String {
		
		if let cVarArg = self as? CVarArg {
			return String(format: "%0\(paddedTo)d", cVarArg)
		} else {
			// Typically this will never happen,
			// but BinaryInteger does not implicitly conform to CVarArg, and we can't assume all concrete types that conform to BinaryInteger CVarArg now or in the future.
			// Just return a string as-is as a failsafe:
			return String(describing: self)
		}
		
	}
	
}


// MARK: - Rounding

extension BinaryInteger {
	
	/// **OTCore:**
	/// Rounds an integer away from zero to the nearest multiple of `toMultiplesOf`.
	///
	/// Example:
	///
	///        1.roundedAwayFromZero(toMultiplesOf: 2) // 2
	///        5.roundedAwayFromZero(toMultiplesOf: 4) // 8
	///     (-1).roundedAwayFromZero(toMultiplesOf: 2) // -2
	///
	@inlinable public func roundedAwayFromZero(toMultiplesOf: Self) -> Self {
		
		let source: Self = self >= 0 ? self : 0 - self
		let isNegative: Bool = self < 0
		
		let rem = source % toMultiplesOf
		let divisions = rem == 0 ? source : source + toMultiplesOf - rem
		return isNegative ? 0 - divisions : divisions
		
	}
	
	/// **OTCore:**
	/// Rounds an integer up to the nearest multiple of `toMultiplesOf`.
	///
	/// Example:
	///
	///        1.roundedUp(toMultiplesOf: 2) // 2
	///        5.roundedUp(toMultiplesOf: 4) // 8
	///     (-3).roundedUp(toMultiplesOf: 2) // -2
	///
	@inlinable public func roundedUp(toMultiplesOf: Self) -> Self {
		
		if toMultiplesOf < 1 { return self }
		
		let source: Self = self >= 0 ? self : 0 - self
		let isNegative: Bool = self < 0
		
		let rem = source % toMultiplesOf
		let divisions = rem == 0 ? self : self + (isNegative ? rem : toMultiplesOf - rem )
		return divisions
		
	}
	
	/// **OTCore:**
	/// Rounds an integer down to the nearest multiple of `toMultiplesOf`.
	///
	/// Example:
	///
	///        1.roundedDown(toMultiplesOf: 2) // 0
	///        3.roundedDown(toMultiplesOf: 4) // 0
	///        5.roundedDown(toMultiplesOf: 4) // 4
	///     (-1).roundedDown(toMultiplesOf: 4) // -4
	///
	@inlinable public func roundedDown(toMultiplesOf: Self) -> Self {
		
		let source: Self = self >= 0 ? self : 0 - self
		let isNegative: Bool = self < 0
		
		let rem = source % toMultiplesOf
		let divisions = rem == 0 ? self : self - (isNegative ? toMultiplesOf - rem : rem)
		return divisions
		
	}
	
}


// MARK: - Binary & Bitwise

extension UnsignedInteger {
	
	/// **OTCore:**
	/// Access binary bits, zero-based from right-to-left
	@inlinable public func bit(_ position: Int) -> Int {
		
		Int((self & (0b1 << position)) >> position)
		
	}
	
}

extension Int8 {
	
	/// **OTCore:**
	/// Returns a two's complement bit format of an `Int8` so it can be stored as a byte (`UInt8`)
	@inlinable public var twosComplement: UInt8 {
		
		UInt8(bitPattern: self)
		
	}
	
}

// MARK: - Random numbers

extension RangeReplaceableCollection where Element : FixedWidthInteger {
	
	/// **OTCore:**
	/// Returns a collection of random numbers.
	/// Values will be between the range given, with a collection size of `count`.
	///
	/// Example:
	///
	///     [UInt8](randomValuesBetween: 0...255, count: 4)
	///
	@inlinable public init(randomValuesBetween: ClosedRange<Element>,
						   count: Int) {
		
		self.init()
		self.reserveCapacity(count)
		
		for _ in 0..<count {
			self.append(Element.random(in: randomValuesBetween))
		}
		
	}
	
}


// MARK: - Wrapping numbers

extension BinaryInteger {
	
	/// **OTCore:**
	/// Returns a number that has been wrapped around a range.
	/// If the number already falls within the range, the number is returned as-is.
	/// If the number underflows or overflows the range, it is wrapped around the range's bounds continuously.
	///
	/// Example:
	///
	///     (-2).wrapped(around: -1...3) // 3
	///     (-1).wrapped(around: -1...3) // -1
	///        0.wrapped(around: -1...3) // 0
	///        1.wrapped(around: -1...3) // 1
	///        2.wrapped(around: -1...3) // 2
	///        3.wrapped(around: -1...3) // 3
	///        4.wrapped(around: -1...3) // -1
	///        5.wrapped(around: -1...3) // 0
	///        6.wrapped(around: -1...3) // 1
	///        7.wrapped(around: -1...3) // 2
	///        8.wrapped(around: -1...3) // 3
	///        9.wrapped(around: -1...3) // -1
	///
	/// - parameter range: integer range, allowing negative and positive bounds.
	@inlinable public func wrapped(around range: ClosedRange<Self>) -> Self {
		
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
	
	/// **OTCore:**
	/// Returns a number that has been wrapped around a range.
	/// If the number already falls within the range, the number is returned as-is.
	/// If the number underflows or overflows the range, it is wrapped around the range's bounds continuously.
	@inlinable public func wrapped(around range: Range<Self>) -> Self {
		
		let min = range.lowerBound
		var max = range.upperBound - 1
		
		if max < min { max = min }
		
		return self.wrapped(around: min...max)
		
	}
	
}


// MARK: - Digits

extension BinaryInteger {
	
	/// **OTCore:**
	/// Returns number of digits (places to the left of the decimal) in the number.
	///
	/// ie:
	/// - for the integer 0, this would return 1
	/// - for the integer 5, this would return 1
	/// - for the integer 10, this would return 2
	/// - for the integer 250, this would return 3
	@inlinable public var numberOfDigits: Int {
		
		if self < 10 && self >= 0 || self > -10 && self < 0 {
			return 1
		} else {
			return 1 + (self / 10).numberOfDigits
		}
		
	}
	
}
