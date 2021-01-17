//
//  String Wrapped.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

extension String {
		
	/// **OTCore:**
	/// Returns the string adding the passed `with` parameter as a prefix and suffix.
	@inlinable public func wrapped(with prefixAndSuffix: String) -> String {
		
		prefixAndSuffix + self + prefixAndSuffix
		
	}
	
	/// **OTCore:**
	/// Returns the string adding the passed `with` parameter as a prefix and suffix.
	@inlinable public func wrapped(with prefixAndSuffix: StringWrappedEnclosingType) -> String {
		
		switch prefixAndSuffix {
		case .parentheses:		return "(" + self + ")"
		case .brackets:			return "[" + self + "]"
		case .braces:			return "{" + self + "}"
		case .angleBrackets:	return "<" + self + ">"
		case .singleQuotes:		return "'" + self + "'"
		case .quotes:			return "\"" + self + "\""
		}
		
	}
	
	/// **OTCore:**
	/// Type describing a pair of enclosing brackets/braces or similar characters that are different for prefix and suffix.
	public enum StringWrappedEnclosingType {
		
		/// ( ), aka parens
		case parentheses
		
		/// [ ], aka square brackets
		case brackets
		
		/// { }, aka curly braces
		case braces
		
		/// < >
		case angleBrackets
		
		/// ' '
		case singleQuotes
		
		/// " "
		case quotes
		
	}
	
	/// **OTCore:**
	/// Syntactic sugar. Returns the string wrapped with double quote marks (").
	/// Same as `self.wrapped(with: .parentheses)`
	@inlinable public var parens: Self {
		self.wrapped(with: .parentheses)
	}
	
	/// **OTCore:**
	/// Syntactic sugar. Returns the string wrapped with double quote marks (').
	/// Same as `self.wrapped(with: .singleQuotes)`
	@inlinable public var singleQuoted: Self {
		self.wrapped(with: .singleQuotes)
	}
	
	/// **OTCore:**
	/// Syntactic sugar. Returns the string wrapped with double quote marks (").
	/// Same as `self.wrapped(with: .quotes)`
	@inlinable public var quoted: Self {
		self.wrapped(with: .quotes)
	}
	
}
