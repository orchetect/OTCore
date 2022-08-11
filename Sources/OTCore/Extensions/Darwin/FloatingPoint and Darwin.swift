//
//  FloatingPoint and Darwin.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Darwin)

import Darwin

// MARK: - ceiling / floor

extension FloatingPoint {
    /// **OTCore:**
    /// Same as `ceil()`
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var ceiling: Self {
        Darwin.ceil(self)
    }
    
    /// **OTCore:**
    /// Same as `floor()`
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var floor: Self {
        Darwin.floor(self)
    }
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Double: FloatingPointPowerComputable {
    /// **OTCore:**
    /// Same as `pow()`
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: Double) -> Double {
        pow(self, exponent)
    }
}

extension Float: FloatingPointPowerComputable {
    /// **OTCore:**
    /// Same as `powf()`
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: Float) -> Float {
        powf(self, exponent)
    }
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: FloatingPointPowerComputable {
    /// **OTCore:**
    /// Same as `powl()`
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: Float80) -> Float80 {
        powl(self, exponent)
    }
}
#endif

// MARK: - .truncated()

extension FloatingPoint where Self: FloatingPointPowerComputable {
    /// **OTCore:**
    /// Replaces this value by truncating it to `decimalPlaces` number of decimal places.
    ///
    /// If `decimalPlaces` <= 0, then `trunc(self)` is returned.
    @_disfavoredOverload
    public mutating func truncate(decimalPlaces: Int) {
        self = truncated(decimalPlaces: decimalPlaces)
    }
    
    /// **OTCore:**
    /// Truncates decimal places to `decimalPlaces` number of decimal places.
    ///
    /// If `decimalPlaces` <= 0, then `trunc(self)` is returned.
    @_disfavoredOverload
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
    @_disfavoredOverload
    public func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        let calculation = self / rhs
        let integral = trunc(calculation)
        let fraction = self - (integral * rhs)
        return (quotient: integral, remainder: fraction)
    }
    
    /// **OTCore:**
    /// Returns both integral part and fractional part.
    ///
    /// - Note: This method is more computationally efficient than calling both `.integral` and .`fraction` properties separately unless you only require one or the other.
    ///
    /// This method can result in a non-trivial loss of precision for the fractional part.
    @inlinable @_disfavoredOverload
    public var integralAndFraction: (integral: Self, fraction: Self) {
        let integral = trunc(self)
        let fraction = self - integral
        return (integral: integral, fraction: fraction)
    }
    
    /// **OTCore:**
    /// Returns the integral part (digits before the decimal point)
    @inlinable @_disfavoredOverload
    public var integral: Self {
        integralAndFraction.integral
    }
    
    /// **OTCore:**
    /// Returns the fractional part (digits after the decimal point)
    ///
    /// - Note: this method can result in a non-trivial loss of precision for the fractional part.
    @inlinable @_disfavoredOverload
    public var fraction: Self {
        integralAndFraction.fraction
    }
}

#endif
