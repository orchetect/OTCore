//
//  Decimal.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Convenience type conversion methods

extension Int {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension UInt {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension Int8 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension UInt8 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension Int16 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension UInt16 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension Int32 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension UInt32 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension Int64 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

extension UInt64 {
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal { Decimal(self) }
}

// MARK: - boolValue

extension Decimal {
    /// **OTCore:**
    /// Returns true if > 0.0
    @inlinable @_disfavoredOverload
    public var boolValue: Bool { self > 0.0 }
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Decimal {
    /// **OTCore:**
    /// Same as `pow()`
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: Int) -> Decimal {
        pow(self, exponent)
    }
}

// MARK: - To String

extension Decimal { // already conforms to CustomStringConvertible
    /// **OTCore:**
    /// Returns a string representation of a Decimal number.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var string: String {
        String(describing: self)
    }
}

// MARK: - From String

extension String {
    /// **OTCore:**
    /// Same as `Decimal(string:)` with default locale.
    /// Returns nil if unsuccessful.
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal? {
        Decimal(string: self)
    }
    
    /// **OTCore:**
    /// Same as `Decimal(string:, locale:)`.
    /// (Functional convenience method)
    @_disfavoredOverload
    public func decimal(locale: Locale?) -> Decimal? {
        Decimal(string: self, locale: locale)
    }
}

extension Substring {
    /// **OTCore:**
    /// Same as `Decimal(string:)` with default locale.
    /// Returns nil if unsuccessful.
    /// (Functional convenience method)
    @_disfavoredOverload
    public var decimal: Decimal? {
        Decimal(string: String(self))
    }
    
    /// **OTCore:**
    /// Same as `Decimal(string:, locale:)`.
    /// (Functional convenience method)
    @_disfavoredOverload
    public func decimal(locale: Locale?) -> Decimal? {
        Decimal(string: String(self), locale: locale)
    }
}

// MARK: - .truncated() / .rounded()

extension Decimal {
    /// **OTCore:**
    /// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
    @_disfavoredOverload
    public func rounded(
        _ rule: NSDecimalNumber.RoundingMode = .plain,
        decimalPlaces: Int
    ) -> Self {
        var initialDecimal = self
        var roundedDecimal = Decimal()
        let decimalPlaces = decimalPlaces.clamped(to: 0...)
        
        NSDecimalRound(&roundedDecimal, &initialDecimal, decimalPlaces, rule)
        
        return roundedDecimal
    }
    
    /// **OTCore:**
    /// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`.
    @_disfavoredOverload
    public mutating func round(
        _ rule: NSDecimalNumber.RoundingMode = .plain,
        decimalPlaces: Int
    ) {
        self = rounded(rule, decimalPlaces: decimalPlaces)
    }
    
    /// Alternative method for rounding a number to a fixed number of decimal places
    /// that does not rely on `NSDecimalRound`.
    ///
    /// The Xcode 16.0 RC build had a bug where `NSDecimal*` methods could cause a crash.
    /// However the bug appears to have been fixed for the GM release.
    ///
    /// See https://developer.apple.com/documentation/xcode-release-notes/xcode-16-release-notes#Foundation
    ///
    /// This method is not currently used, but its functionality was tested and it works as expected.
    // private func _roundedAlternative(
    //     _ rule: NSDecimalNumber.RoundingMode = .plain,
    //     decimalPlaces: Int
    // ) -> Self {
    //     let fpRule: FloatingPointRoundingRule
    //     switch rule {
    //     case .plain: fpRule = .toNearestOrEven
    //     case .down: fpRule = .down
    //     case .up: fpRule = .up
    //     case .bankers: fpRule = .toNearestOrEven // not identical, but close
    //     @unknown default:
    //         assertionFailure("Unknown rounding mode: \(rule). Defaulting to .toNearestOrEven.")
    //         fpRule = .toNearestOrEven
    //     }
    //
    //     let double = abs((self as NSDecimalNumber).doubleValue)
    //     let significand = Decimal((double * pow(10, Double(decimalPlaces))).rounded(fpRule))
    //     return Decimal(sign: sign, exponent: -decimalPlaces, significand: significand)
    // }
    
    /// **OTCore:**
    /// Replaces this value by truncating it to `decimalPlaces` number of decimal places.
    @_disfavoredOverload
    public mutating func truncate(decimalPlaces: Int) {
        self = truncated(decimalPlaces: decimalPlaces)
    }
    
    /// **OTCore:**
    /// Truncates decimal places to `decimalPlaces` number of decimal places.
    @_disfavoredOverload
    public func truncated(decimalPlaces: Int) -> Self {
        var initialDecimal = self
        var roundedDecimal = Decimal()
        let decimalPlaces = decimalPlaces.clamped(to: 0...)
        
        if self > 0 {
            NSDecimalRound(&roundedDecimal, &initialDecimal, decimalPlaces, .down)
        } else {
            NSDecimalRound(&roundedDecimal, &initialDecimal, decimalPlaces, .up)
        }
        
        return roundedDecimal
    }
}

extension Decimal {
    /// **OTCore:**
    /// Similar to `Double.truncatingRemainder(dividingBy:)` from the standard Swift library.
    @_disfavoredOverload
    public func truncatingRemainder(dividingBy rhs: Self) -> Self {
        let calculation = self / rhs
        let integral = calculation.truncated(decimalPlaces: 0)
        let fraction = self - (integral * rhs)
        return fraction
    }
    
    /// **OTCore:**
    /// Similar to `Int.quotientAndRemainder(dividingBy:)` from the standard Swift library.
    @_disfavoredOverload
    public func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        let calculation = self / rhs
        let integral = calculation.truncated(decimalPlaces: 0)
        let fraction = self - (integral * rhs)
        return (quotient: integral, remainder: fraction)
    }
    
    /// **OTCore:**
    /// Returns both integral part and fractional part.
    ///
    /// - Note: This method is more computationally efficient than calling both `.integral` and
    ///   `.fraction` properties separately unless you only require one or the other.
    @inlinable @_disfavoredOverload
    public var integralAndFraction: (integral: Self, fraction: Self) {
        let integral = truncated(decimalPlaces: 0)
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
    /// Note: this can result in a non-trivial loss of precision for the fractional part.
    @inlinable @_disfavoredOverload
    public var fraction: Self {
        integralAndFraction.fraction
    }
}

// MARK: - Digit Places

extension Decimal {
    /// **OTCore:**
    /// Returns the number of digit places of the ``integral`` portion (left of the decimal).
    @inlinable @_disfavoredOverload
    public var integralDigitPlaces: Int {
        // this works but may be brittle.
        // not sure if some locales will localize the number differently than expected.
        // on English systems the `significand` string interpolation produces
        // a string of digits with no thousands separators or other characters.
        
        if abs(self) <= 1 { return 0 }
        return "\(abs(significand))".count + exponent
    }
    
    /// **OTCore:**
    /// Returns the number of digit places of the ``fraction`` portion (right of the decimal).
    @inlinable @_disfavoredOverload
    public var fractionDigitPlaces: Int {
        max(-exponent, 0)
    }
}

#endif
