//
//  Protocols.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

// MARK: - NumberEndianness

/// **OTCore:**
/// Enum describing endianness when stored in data form.
public enum NumberEndianness {
	case platformDefault
	case littleEndian
	case bigEndian
}

#if canImport(CoreFoundation)
import CoreFoundation

extension NumberEndianness {
	/// **OTCore:**
	/// Returns the current system hardware's byte order endianness.
	public static let system: NumberEndianness =
		CFByteOrderGetCurrent() == CFByteOrderBigEndian.rawValue
		? .bigEndian
		: .littleEndian
}
#endif


// MARK: - FloatingPointPowerComputable

/// **OTCore:**
/// Protocol allowing implementation of convenience method `.power(_ exponent:)`
/// - warning: (Internal use. Do not use this protocol.)
public protocol FloatingPointPowerComputable {
	func power(_ exponent: Self) -> Self
}


// MARK: - FloatingPointHighPrecisionStringConvertible

/// **OTCore:**
/// Protocol allowing implementation of convenience method `.stringValueHighPrecision`
/// - warning: (Internal use. Do not use this protocol.)
public protocol FloatingPointHighPrecisionStringConvertible {
	var stringValueHighPrecision: String { get }
}
