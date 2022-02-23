//
//  FloatingPoint.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - Convenience type conversion methods

extension BinaryFloatingPoint {
    
    /// **OTCore:**
    /// Same as `Int()`
    /// (Functional convenience method)
    @inlinable
    public var int: Int { Int(self) }
    
    /// **OTCore:**
    /// Same as `Int(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var intExactly: Int? { Int(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt()`
    /// (Functional convenience method)
    @inlinable
    public var uInt: UInt { UInt(self) }
    
    /// **OTCore:**
    /// Same as `UInt(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var uIntExactly: UInt? { UInt(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int8()`
    /// (Functional convenience method)
    @inlinable
    public var int8: Int8 { Int8(self) }
    
    /// **OTCore:**
    /// Same as `Int8(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var int8Exactly: Int8? { Int8(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt8()`
    /// (Functional convenience method)
    @inlinable
    public var uInt8: UInt8 { UInt8(self) }
    
    /// **OTCore:**
    /// Same as `UInt8(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var uInt8Exactly: UInt8? { UInt8(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int16()`
    /// (Functional convenience method)
    @inlinable
    public var int16: Int16 { Int16(self) }
    
    /// **OTCore:**
    /// Same as `Int16(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var int16Exactly: Int16? { Int16(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt16()`
    /// (Functional convenience method)
    @inlinable
    public var uInt16: UInt16 { UInt16(self) }
    
    /// **OTCore:**
    /// Same as `UInt16(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var uInt16Exactly: UInt16? { UInt16(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int32()`
    /// (Functional convenience method)
    @inlinable
    public var int32: Int32 { Int32(self) }
    
    /// **OTCore:**
    /// Same as `Int32(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var int32Exactly: Int32? { Int32(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt32()`
    /// (Functional convenience method)
    @inlinable
    public var uInt32: UInt32 { UInt32(self) }
    
    /// **OTCore:**
    /// Same as `UInt32(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var uInt32Exactly: UInt32? { UInt32(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Int64()`
    /// (Functional convenience method)
    @inlinable
    public var int64: Int64 { Int64(self) }
    
    /// **OTCore:**
    /// Same as `Int64(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var int64Exactly: Int64? { Int64(exactly: self) }
    
    /// **OTCore:**
    /// Same as `UInt64()`
    /// (Functional convenience method)
    @inlinable
    public var uInt64: UInt64 { UInt64(self) }
    
    /// **OTCore:**
    /// Same as `UInt64(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var uInt64Exactly: UInt64? { UInt64(exactly: self) }
    
}

extension BinaryFloatingPoint {
    
    /// **OTCore:**
    /// Same as `Double()`
    /// (Functional convenience method)
    @inlinable
    public var double: Double { Double(self) }
    
    /// **OTCore:**
    /// Same as `Double(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var doubleExactly: Double? { Double(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Float()`
    /// (Functional convenience method)
    @inlinable
    public var float: Float { Float(self) }
    
    /// **OTCore:**
    /// Same as `Float(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var floatExactly: Float? { Float(exactly: self) }
    
    /// **OTCore:**
    /// Same as `Float32()`
    /// (Functional convenience method)
    @inlinable
    public var float32: Float32 { Float32(self) }
    
    /// **OTCore:**
    /// Same as `Float32(exactly:)`
    /// (Functional convenience method)
    @inlinable
    public var float32Exactly: Float32? { Float32(exactly: self) }
    
    #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
    /// **OTCore:**
    /// Same as `Float80()`
    /// (Functional convenience method)
    @inlinable
    public var float80: Float80 { Float80(self) }
    #endif
    
}


// MARK: - boolValue

extension BinaryFloatingPoint {
    
    /// **OTCore:**
    /// Returns true if > 0.0
    @inlinable
    public var boolValue: Bool { self > 0.0 }
    
}


// MARK: - .truncated() / .rounded

extension FloatingPoint where Self : FloatingPointPowerComputable {
    
    /// **OTCore:**
    /// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces` <= 0, trunc(self) is returned.
    public func rounded(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) -> Self {
        
        if decimalPlaces < 1 {
            return rounded(rule)
        }
        
        let offset = Self(10).power(Self(decimalPlaces))
        
        return (self * offset).rounded(rule) / offset
        
    }
    
    /// **OTCore:**
    /// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces` <= 0, `trunc(self)` is used.
    public mutating func round(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) {
        
        self = rounded(rule, decimalPlaces: decimalPlaces)
        
    }
    
}


// MARK: - Wrapping numbers

extension FloatingPoint {
    
    /// **OTCore:**
    /// Returns a number that has been wrapped around a range.
    /// If the number already falls within the range, the number is returned as-is.
    /// If the number underflows or overflows the range, it is wrapped around the range's bounds continuously.
    ///
    /// Example:
    ///
    ///     (-2.0).wrapped(around: -1.0...3.0) // 3.0
    ///     (-1.0).wrapped(around: -1.0...3.0) // -1.0
    ///        0.0.wrapped(around: -1.0...3.0) // 0.0
    ///        1.0.wrapped(around: -1.0...3.0) // 1.0
    ///        2.0.wrapped(around: -1.0...3.0) // 2.0
    ///        3.0.wrapped(around: -1.0...3.0) // 3.0
    ///        4.0.wrapped(around: -1.0...3.0) // -1.0
    ///        5.0.wrapped(around: -1.0...3.0) // 0.0
    ///        6.0.wrapped(around: -1.0...3.0) // 1.0
    ///        7.0.wrapped(around: -1.0...3.0) // 2.0
    ///        8.0.wrapped(around: -1.0...3.0) // 3.0
    ///        9.0.wrapped(around: -1.0...3.0) // -1.0
    ///
    /// - parameter range: integer range, allowing negative and positive bounds.
    @inlinable
    public func wrapped(around range: ClosedRange<Self>) -> Self {
        
        guard !isNaN, !isInfinite else { return self }
        
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
    @inlinable
    public func wrapped(around range: Range<Self>) -> Self {
        
        guard !isNaN, !isInfinite else { return self }
        
        let min = range.lowerBound
        var max = range.upperBound - 1
        
        if max < min { max = min }
        
        return wrapped(around: min...max)
        
    }
    
}

// MARK: - Radians

extension BinaryFloatingPoint {
    
    /// **OTCore:**
    /// Returns degrees converted to radians.
    @inlinable
    public var degreesToRadians: Self {
        
        self * .pi / 180
        
    }
    
    /// **OTCore:**
    /// Returns radians converted to degrees.
    @inlinable
    public var radiansToDegrees: Self {
        
        self * 180 / .pi
        
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
    @inlinable
    public var string: String {
        
        String(describing: self)
        
    }
    
}

extension FloatingPoint where Self : CVarArg,
                              Self : FloatingPointPowerComputable {
    
    /// **OTCore:**
    /// Returns a string formatted to _n_ decimal places, using the given rounding rule.
    @inlinable
    public func string(
        rounding rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) -> String {
        
        let roundedValue = rounded(rule, decimalPlaces: decimalPlaces)
        
        // (FYI: String(format:) does not work with Float80)
        
        return String(format: "%.\(decimalPlaces)f", roundedValue)
        
    }
    
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80 {
    
    /// **OTCore:**
    /// Returns a string formatted to _n_ decimal places, using the given rounding rule.
    @inlinable
    public func string(
        rounding rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) -> String {
        
        let roundedValue = rounded(rule, decimalPlaces: decimalPlaces)
        
        // String(format:) does not work with Float80
        // so we need a custom implementation here
        
        let rawString = String(describing: roundedValue)
        let splitComponents = rawString.split(separator: ".")
        if decimalPlaces < 1 || splitComponents.count < 2 {
            return String(splitComponents.first ?? "0")
        }
        
        return (splitComponents[0])
        + "."
        + splitComponents[1].padding(toLength: decimalPlaces,
                                     withPad: "0",
                                     startingAt: 0)
        
    }
    
}
#endif


// MARK: - String To FloatingPoint

extension String {
    
    // float types init(_ text:) are inlinable when passed a StringProtocol type (including String)
    
    /// **OTCore:**
    /// Returns a `Double`, or `nil` if unsuccessful.
    /// (Functional convenience method)
    @inlinable
    public var double: Double? { Double(self) }
    
    /// **OTCore:**
    /// Returns a `Float`, or `nil` if unsuccessful.
    /// (Functional convenience method)
    @inlinable
    public var float: Float? { Float(self) }
    
    #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
    /// **OTCore:**
    /// Returns a `Float80`, or `nil` if unsuccessful.
    /// (Functional convenience method)
    @inlinable
    public var float80: Float80? { Float80(self) }
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
