//
//  Bool.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-12.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

// MARK: - Bool

extension Bool {

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var intValue:    Int    { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var int8Value:   Int8   { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var int16Value:  Int16  { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var int32Value:  Int32  { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var int64Value:  Int64  { return self ? 1 : 0 }
	
	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var uintValue:   UInt   { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var uint8Value:  UInt8  { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var uint16Value: UInt16 { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var uint32Value: UInt32 { return self ? 1 : 0 }

	/// **OTCore:**
	/// Returns 1 (true) or 0 (false)
	@inlinable public var uint64Value: UInt64 { return self ? 1 : 0 }

}

extension Bool {
	
	/// **OTCore:**
	/// Returns a new boolean inverted from self.
	@inlinable public func toggled() -> Self {
		return !self
	}
	
}

extension Bool : ExpressibleByIntegerLiteral {
	
	/// **OTCore:**
	/// Value > 0 produces true
	@inlinable public init(integerLiteral value: IntegerLiteralType) {
		self = value > 0
	}
	
	/// **OTCore:**
	/// Value > 0 produces true
	@inlinable public init<T: BinaryInteger>(_ value: T) {
		self = value > 0
	}
	
}

extension BinaryInteger {
	
	/// **OTCore:**
	/// Value > 0 produces true
	@inlinable public var boolValue: Bool {
		return self > 0
	}
	
}
