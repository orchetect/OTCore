//
//  FloatingPoint and Foundation.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if canImport(Foundation)

import Foundation

// MARK: - FloatingPointHighPrecisionStringConvertible

extension Double:	FloatingPointHighPrecisionStringConvertible { }
extension Float:	FloatingPointHighPrecisionStringConvertible { }

/// Internal - cached
fileprivate let ZeroCharacterSet = CharacterSet(charactersIn: "0")
fileprivate let PeriodCharacterSet = CharacterSet(charactersIn: ".")

extension CVarArg where Self : FloatingPointHighPrecisionStringConvertible {
	
	/// **OTCore:**
	/// Returns a string representation of a floating-point number, with maximum 100 decimal places of precision.
	public var stringValueHighPrecision: String {
		
		var formatted = String(format: "%.100f", self)
			.trimmingCharacters(in: ZeroCharacterSet)
		
		if formatted.prefix(1) == "." { formatted = "0\(formatted)" }
		
		formatted.removeSuffix(".")
		
		return formatted
		
	}
	
}

#endif
