//
//  Bool.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Bool

extension Bool {
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var intValue:    Int    { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var int8Value:   Int8   { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var int16Value:  Int16  { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var int32Value:  Int32  { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var int64Value:  Int64  { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var uIntValue:   UInt   { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var uInt8Value:  UInt8  { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var uInt16Value: UInt16 { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var uInt32Value: UInt32 { self ? 1 : 0 }
    
    /// **OTCore:**
    /// Returns 1 (true) or 0 (false)
    @inlinable @_disfavoredOverload
    public var uInt64Value: UInt64 { self ? 1 : 0 }
}

// MARK: - Functional boolean logic methods

extension Bool {
    /// **OTCore:**
    /// Returns a new boolean inverted from self.
    @inline(__always) @_disfavoredOverload
    public func toggled() -> Self {
        !self
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Bool: ExpressibleByIntegerLiteral {
    /// **OTCore:**
    /// Value > 0 produces `true`.
    @inline(__always) @_disfavoredOverload
    public init(integerLiteral value: IntegerLiteralType) {
        self = value > 0
    }
    
    /// **OTCore:**
    /// Value > 0 produces `true`.
    @inline(__always) @_disfavoredOverload
    public init<T: BinaryInteger>(_ value: T) {
        self = value > 0
    }
}

// MARK: - boolValue

extension BinaryInteger {
    /// **OTCore:**
    /// Value > 0 produces `true`.
    @inline(__always) @_disfavoredOverload
    public var boolValue: Bool {
        self > 0
    }
}
