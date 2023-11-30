//
//  FloatingPoint and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - FloatingPointHighPrecisionStringConvertible

extension Double:  FloatingPointHighPrecisionStringConvertible { }
extension Float:   FloatingPointHighPrecisionStringConvertible { }

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: FloatingPointHighPrecisionStringConvertible { }
#endif

/// Internal - cached
fileprivate let ZeroCharacterSet   = CharacterSet(charactersIn: "0")
fileprivate let PeriodCharacterSet = CharacterSet(charactersIn: ".")

extension FloatingPoint where Self: CVarArg,
                              Self: FloatingPointHighPrecisionStringConvertible {
    /// **OTCore:**
    /// Returns a string representation of a floating-point number, with maximum 100 decimal places of precision.
    @_disfavoredOverload
    public var stringValueHighPrecision: String {
        var formatted = String(format: "%.100f", self)
            .trimmingCharacters(in: ZeroCharacterSet)
        
        if formatted.prefix(1) == "." { formatted = "0\(formatted)" }
        
        formatted.removeSuffix(".")
        
        return formatted
    }
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80 {
    /// **OTCore:**
    /// Returns a string representation of a floating-point number, with maximum 100 decimal places of precision.
    @_disfavoredOverload
    public var stringValueHighPrecision: String {
        // String(format:) does not work with Float80
        // so we need a custom implementation here
        String(describing: self)
    }
}
#endif

extension FloatingPoint where Self: CVarArg,
                              Self: FloatingPointPowerComputable {
    /// **OTCore:**
    /// Returns a string formatted to _n_ decimal places, using the given rounding rule.
    @inlinable @_disfavoredOverload
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
    @inlinable @_disfavoredOverload
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
        + splitComponents[1].padding(
            toLength: decimalPlaces,
            withPad: "0",
            startingAt: 0
        )
    }
}
#endif

// MARK: - Digit Places

extension Double {
    /// **OTCore:**
    /// Returns the number of digit places of the ``integral`` portion (left of the decimal).
    @inlinable @_disfavoredOverload
    public var integralDigitPlaces: Int {
        Decimal(self).integralDigitPlaces
    }
    
    /// **OTCore:**
    /// Returns the number of digit places of the ``fraction`` portion (right of the decimal).
    @inlinable @_disfavoredOverload
    public var fractionDigitPlaces: Int {
        Decimal(self).fractionDigitPlaces
    }
}

#endif
