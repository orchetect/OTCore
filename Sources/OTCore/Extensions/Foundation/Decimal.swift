//
//  Decimal.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

// MARK: - Convenience type conversion methods

extension Int {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension UInt {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension Int8 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension UInt8 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension Int16 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension UInt16 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension Int32 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension UInt32 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension Int64 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}

extension UInt64 {
    
    /// **OTCore:**
    /// Same as `Decimal()`
    /// (Functional convenience method)
    public var decimal: Decimal { Decimal(self) }
    
}


// MARK: - boolValue

extension Decimal {
    
    /// **OTCore:**
    /// Returns true if > 0.0
    @inlinable public var boolValue: Bool { self > 0.0 }
    
}


// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Decimal {
    
    /// **OTCore:**
    /// Same as `pow()`
    /// (Functional convenience method)
    @inlinable public func power(_ exponent: Int) -> Decimal {
        
        pow(self, exponent)
        
    }
    
}


// MARK: - To String

extension Decimal { // already conforms to CustomStringConvertible
    
    /// **OTCore:**
    /// Returns a string representation of a Decimal number.
    /// (Functional convenience method)
    @inlinable public var string: String {
        
        String(describing: self)
        
    }
    
}


// MARK: - From String

extension String {
    
    /// **OTCore:**
    /// Same as `Decimal(string:)` with default locale.
    /// Returns nil if unsuccessful.
    /// (Functional convenience method)
    public var decimal: Decimal? {
        
        Decimal(string: self)
        
    }
    
    /// **OTCore:**
    /// Same as `Decimal(string:, locale:)`.
    /// (Functional convenience method)
    public func decimal(locale: Locale?) -> Decimal? {
        
        Decimal(string: self, locale: locale)
        
    }
    
}

extension Substring {
    
    /// **OTCore:**
    /// Same as `Decimal(string:)` with default locale.
    /// Returns nil if unsuccessful.
    /// (Functional convenience method)
    public var decimal: Decimal? {
        
        Decimal(string: String(self))
        
    }
    
    /// **OTCore:**
    /// Same as `Decimal(string:, locale:)`.
    /// (Functional convenience method)
    public func decimal(locale: Locale?) -> Decimal? {
        
        Decimal(string: String(self), locale: locale)
        
    }
    
}

#endif
