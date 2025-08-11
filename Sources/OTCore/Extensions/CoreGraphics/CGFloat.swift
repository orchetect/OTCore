//
//  CGFloat.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreGraphics)

import CoreGraphics

// MARK: - FloatingPointHighPrecisionStringConvertible

extension CGFloat: FloatingPointHighPrecisionStringConvertible { }

// MARK: - Convenience type conversion methods

extension BinaryInteger {
    /// **OTCore:**
    /// Same as `CGFloat(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloat: CGFloat { CGFloat(self) }
    
    /// **OTCore:**
    /// Same as `CGFloat(exactly: self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloatExactly: CGFloat? { CGFloat(exactly: self) }
}

extension BinaryFloatingPoint {
    /// **OTCore:**
    /// Same as `CGFloat(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloat: CGFloat { CGFloat(self) }
    
    /// **OTCore:**
    /// Same as `CGFloat(exactly: self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloatExactly: CGFloat? { CGFloat(exactly: self) }
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension CGFloat: FloatingPointPowerComputable {
    /// **OTCore:**
    /// Same as `pow()`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func power(_ exponent: CGFloat) -> CGFloat {
        pow(self, exponent)
    }
}

// MARK: - From String

extension StringProtocol {
    /// **OTCore:**
    /// Constructs `CGFloat` from a `String` by converting to `Double` as intermediary.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var cgFloat: CGFloat? {
        guard let doubleValue = Double(self) else { return nil }
        return CGFloat(doubleValue)
    }
}

#if canImport(Foundation)
import Foundation

// MARK: - Digit Places

extension CGFloat {
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

#endif
