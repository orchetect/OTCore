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


// MARK: - Functional boolean logic methods

extension Bool {
	
	/// **OTCore:**
	/// Returns a new boolean inverted from self.
	@inlinable public func toggled() -> Self {
		
		!self
		
	}
	
	/// **OTCore:**
	/// Ternary operation.
	/// If true, `trueValue` is returned. If false, `falseValue` is returned.
	/// (Functional convenience method)
	@inlinable public func ifTrue<T>(_ trueValue: @autoclosure () throws -> T,
									 else falseValue: @autoclosure () throws -> T) rethrows -> T {
		
		try self ? trueValue() : falseValue()
		
	}
	
	/// **OTCore:**
	/// /// Boolean logic: passes value if true, nil if false.
	/// (Functional convenience method)
	@inlinable public func ifTrue<T>(_ value: @autoclosure () throws -> T) rethrows -> T? {
		
		try self ? value() : nil
		
	}
	
	/// **OTCore:**
	/// Boolean logic: passes value if false, nil if true.
	/// (Functional convenience method)
	@inlinable public func ifFalse<T>(_ value: @autoclosure () throws -> T) rethrows -> T? {
		
		try self ? nil : value()
		
	}
	
}


// MARK: - ExpressibleByIntegerLiteral

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


// MARK: - boolValue

extension BinaryInteger {
	
	/// **OTCore:**
	/// Value > 0 produces true
	@inlinable public var boolValue: Bool {
		
		self > 0
		
	}
	
}
