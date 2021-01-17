//
//  String and NumberFormatter.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if canImport(Foundation)

import Foundation

extension DefaultStringInterpolation {
	
	/// Cache to improve performance, implicitly lazy (as a global static declaration)
	///
	/// ***** Note: This may not be thread-safe if called from more than one thread simultaneously. *****
	static fileprivate let siNumFormatter = NumberFormatter()
	
	/// **OTCore:**
	/// Convenience interpolator for formatting a number inline.
	///
	/// Example:
	///
	///     "There are \(3, format: .spellOut) apples"
	///     // == "There are three apples"
	///
	/// - warning: This may not be thread-safe if called from more than one thread simultaneously.
	public mutating func appendInterpolation(_ value: Int, format style: NumberFormatter.Style) {
		
		Self.siNumFormatter.numberStyle = style
		
		if let result = Self.siNumFormatter.string(from: value as NSNumber) {
			appendLiteral(result)
		}
		
	}
	
}

#endif
