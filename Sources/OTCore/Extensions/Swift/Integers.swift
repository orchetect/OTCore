//
//  Integers.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Convenience type conversion methods

extension BinaryInteger {
    /// **OTCore:**
    /// Same as `Int`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int: Int { Int(self) }
    
    /// **OTCore:**
    /// Same as `UInt`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt: UInt { UInt(self) }
    
    /// **OTCore:**
    /// Same as `Int8`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int8: Int8 { Int8(self) }
    
    /// **OTCore:**
    /// Same as `UInt8`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt8: UInt8 { UInt8(self) }
    
    /// **OTCore:**
    /// Same as `Int16`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int16: Int16 { Int16(self) }
    
    /// **OTCore:**
    /// Same as `UInt16`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt16: UInt16 { UInt16(self) }
    
    /// **OTCore:**
    /// Same as `Int32`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int32: Int32 { Int32(self) }
    
    /// **OTCore:**
    /// Same as `UInt32`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt32: UInt32 { UInt32(self) }
    
    /// **OTCore:**
    /// Same as `Int64`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int64: Int64 { Int64(self) }
    
    /// **OTCore:**
    /// Same as `UInt64`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt64: UInt64 { UInt64(self) }
}

extension BinaryInteger {
    /// **OTCore:**
    /// Same as `Int(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var intExactly: Int? { Int(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uIntExactly: UInt? { UInt(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int8(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int8Exactly: Int8? { Int8(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt8(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt8Exactly: UInt8? { UInt8(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int16(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int16Exactly: Int16? { Int16(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt16(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt16Exactly: UInt16? { UInt16(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int32(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int32Exactly: Int32? { Int32(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt32(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt32Exactly: UInt32? { UInt32(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int64(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int64Exactly: Int64? { Int64(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt64(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt64Exactly: UInt64? { UInt64(exactly: self) }
}

extension BinaryInteger {
    /// **OTCore:**
    /// Same as `Double()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var double: Double { Double(self) }
    
    /// **OTCore:**
    /// Same as `Double(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var doubleExactly: Double? { Double(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Float()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var float: Float { Float(self) }
    
    /// **OTCore:**
    /// Same as `Float(exactly:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var floatExactly: Float? { Float(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Float32()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var float32: Float32 { Float32(self) }
    
    #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
    /// **OTCore:**
    /// Same as `Float80()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var float80: Float80 { Float80(self) }
    #endif
}

extension StringProtocol {
    /// **OTCore:**
    /// Same as `Int()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int: Int? { Int(self) }
    
    /// **OTCore:**
    /// Same as `Int()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt: UInt? { UInt(self) }
    
    /// **OTCore:**
    /// Same as `Int8()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int8: Int8? { Int8(self) }
    
    /// **OTCore:**
    /// Same as `UInt8()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt8: UInt8? { UInt8(self) }
    
    /// **OTCore:**
    /// Same as `Int16()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int16: Int16? { Int16(self) }
    
    /// **OTCore:**
    /// Same as `UInt16()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt16: UInt16? { UInt16(self) }
    
    /// **OTCore:**
    /// Same as `Int32()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int32: Int32? { Int32(self) }
    
    /// **OTCore:**
    /// Same as `UInt32()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt32: UInt32? { UInt32(self) }
    
    /// **OTCore:**
    /// Same as `Int64()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var int64: Int64? { Int64(self) }
    
    /// **OTCore:**
    /// Same as `UInt64()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var uInt64: UInt64? { UInt64(self) }
}

// MARK: - String Formatting

extension BinaryInteger {
    /// **OTCore:**
    /// Same as `String(describing: self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var string: String { String(describing: self) }
}

// MARK: - Rounding

extension BinaryInteger {
    /// **OTCore:**
    /// Rounds an integer away from zero to the nearest multiple of `toMultiplesOf`.
    ///
    /// Example:
    ///
    /// ```swift
    ///    1.roundedAwayFromZero(toMultiplesOf: 2) // 2
    ///    5.roundedAwayFromZero(toMultiplesOf: 4) // 8
    /// (-1).roundedAwayFromZero(toMultiplesOf: 2) // -2
    /// ```
    @inlinable @_disfavoredOverload
    public func roundedAwayFromZero(toMultiplesOf: Self) -> Self {
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
    /// ```swift
    ///    1.roundedUp(toMultiplesOf: 2) // 2
    ///    5.roundedUp(toMultiplesOf: 4) // 8
    /// (-3).roundedUp(toMultiplesOf: 2) // -2
    /// ```
    @inlinable @_disfavoredOverload
    public func roundedUp(toMultiplesOf: Self) -> Self {
        if toMultiplesOf < 1 { return self }
        
        let source: Self = self >= 0 ? self : 0 - self
        let isNegative: Bool = self < 0
        
        let rem = source % toMultiplesOf
        let divisions = rem == 0 ? self : self + (isNegative ? rem : toMultiplesOf - rem)
        return divisions
    }
    
    /// **OTCore:**
    /// Rounds an integer down to the nearest multiple of `toMultiplesOf`.
    ///
    /// Example:
    ///
    /// ```swift
    ///    1.roundedDown(toMultiplesOf: 2) // 0
    ///    3.roundedDown(toMultiplesOf: 4) // 0
    ///    5.roundedDown(toMultiplesOf: 4) // 4
    /// (-1).roundedDown(toMultiplesOf: 4) // -4
    /// ```
    @inlinable @_disfavoredOverload
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
    /// **OTCore:**
    /// Access binary bits, zero-based from right-to-left.
    @inlinable @_disfavoredOverload
    public func bit(_ position: Int) -> Int {
        Int((self & (0b1 << position)) >> position)
    }
}

extension Int8 {
    /// **OTCore:**
    /// Returns a two's complement bit format of an `Int8` so it can be stored as a byte (`UInt8`).
    @inlinable @_disfavoredOverload
    public var twosComplement: UInt8 {
        UInt8(bitPattern: self)
    }
}

// MARK: - Random numbers

extension RangeReplaceableCollection where Element: FixedWidthInteger {
    /// **OTCore:**
    /// Returns a collection of random numbers.
    /// Values will be between the range given, with a collection size of `count`.
    ///
    /// Example:
    ///
    /// ```swift
    /// [UInt8](randomValuesBetween: 0...255, count: 4)
    /// ```
    @inlinable @_disfavoredOverload
    public init(
        randomValuesBetween: ClosedRange<Element>,
        count: Int
    ) {
        self.init()
        reserveCapacity(count)
        
        for _ in 0 ..< count {
            append(Element.random(in: randomValuesBetween))
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
    /// ```swift
    /// (-2).wrapped(around: -1...3) // 3
    /// (-1).wrapped(around: -1...3) // -1
    ///    0.wrapped(around: -1...3) // 0
    ///    1.wrapped(around: -1...3) // 1
    ///    2.wrapped(around: -1...3) // 2
    ///    3.wrapped(around: -1...3) // 3
    ///    4.wrapped(around: -1...3) // -1
    ///    5.wrapped(around: -1...3) // 0
    ///    6.wrapped(around: -1...3) // 1
    ///    7.wrapped(around: -1...3) // 2
    ///    8.wrapped(around: -1...3) // 3
    ///    9.wrapped(around: -1...3) // -1
    /// ```
    ///
    /// - parameter range: integer range, allowing negative and positive bounds.
    @inlinable @_disfavoredOverload
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
    
    /// **OTCore:**
    /// Returns a number that has been wrapped around a range.
    /// If the number already falls within the range, the number is returned as-is.
    /// If the number underflows or overflows the range, it is wrapped around the range's bounds continuously.
    @inlinable @_disfavoredOverload
    public func wrapped(around range: Range<Self>) -> Self {
        let min = range.lowerBound
        var max = range.upperBound - 1
        
        if max < min { max = min }
        
        return wrapped(around: min ... max)
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
    @inlinable @_disfavoredOverload
    public var numberOfDigits: Int {
        if self < 10 && self >= 0 || self > -10 && self < 0 {
            return 1
        } else {
            return 1 + (self / 10).numberOfDigits
        }
    }
}
