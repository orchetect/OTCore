//
//  String.swift
//  OTCore
//
//  Created by Steffan Andrews on 2018-06-15.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - Convenience Variables

extension String {
	
	/// OTCore:
	/// Convenience variable.
	public static var quote: Self { "\"" }
	
	/// OTCore:
	/// Convenience variable.
	public static var tab: Self { "\t" }
	
	/// OTCore:
	/// Convenience variable.
	public static var space: Self { " " }
	
	/// OTCore:
	/// Convenience variable.
	public static var newLine: Self { "\n" }
	
	/// OTCore:
	/// Convenience variable.
	public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
	
}

extension String {
	
	/// OTCore:
	/// Appends a newline to the end of the string and returns a copy.
	public var newLined: Self {
		self + Self.newLine
	}
	
	/// OTCore:
	/// Appends a tab to the end of the string and returns a copy.
	public var tabbed: Self {
		self + Self.tab
	}
	
	/// OTCore:
	/// Appends a newline to the end of the string.
	public mutating func newLine() {
		self += Self.newLine
	}
	
	/// OTCore:
	/// Appends a tab to the end of the string.
	public mutating func tab() {
		self += Self.tab
	}
	
}


// MARK: - Character Convenience Variables

extension Character {
	
	/// OTCore:
	/// Convenience variable.
	public static var quote: Self { "\"" }
	
	/// OTCore:
	/// Convenience variable.
	public static var tab: Self { "\t" }
	
	/// OTCore:
	/// Convenience variable.
	public static var space: Self { " " }
	
	/// OTCore:
	/// Convenience variable.
	public static var newLine: Self { "\n" }
	
	/// OTCore:
	/// Convenience variable.
	public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
	
}


// MARK: - Ranges

extension StringProtocol {
	
	/// OTCore:
	/// Convenience method: same as .range(of: find, options: .backwardsSearch)
	public func range(backwards find: Self) -> Range<Index>? {
		
		self.range(of: find, options: .backwards)
		
	}
	
	/// OTCore:
	/// Convenience method: same as .range(of: find, options: [.caseInsensitiveSearch, .backwardsSearch])
	public func range(backwardsCaseInsensitive find: Self) -> Range<Index>? {
		
		self.range(of: find, options: [.caseInsensitive, .backwards])
		
	}
	
	/// OTCore:
	/// Convenience method: returns true if contains string, case-insensitive.
	public func contains(caseInsensitive find: Self) -> Bool {
		
		self.range(of: find, options: .caseInsensitive) != nil
			? true
			: false
		
	}
	
	/// OTCore:
	/// Convenience method: returns true if starts with string, case-insensitive.
	public func starts(withCaseInsensitive prefix: Self) -> Bool {
		
		self.uppercased()
			.starts(with: prefix.uppercased())
		
	}
	
}


// MARK: - Segmentation

extension StringProtocol {
	
	/// OTCore:
	/// Repeats the string a number of times.
	public func repeating(_ count: Int) -> String {
		
		self is String
			? String(repeating: self as! String, count: count)
			: String(repeating: self.string, count: count)
		
	}
	
}

extension StringProtocol {
	
	/// OTCore:
	/// Convenience function to return a new string with whitespaces and newlines trimmed off start and end.
	public var trimmed: String {
		
		self.trimmingCharacters(in: .whitespacesAndNewlines)
		
	}
	
}

extension String {
	
	/// OTCore:
	/// Convenience function to trim whitespaces and newlines off start and end.
	public mutating func trim() {
		
		self = self.trimmed
		
	}
	
}

extension String {
		
	/// OTCore:
	/// Returns the string adding the passed `with` parameter as a prefix and suffix.
	public func wrapped(with prefixAndSuffix: String) -> String {
		
		prefixAndSuffix + self + prefixAndSuffix
		
	}
	
	/// OTCore:
	/// Returns the string adding the passed `with` parameter as a prefix and suffix.
	public func wrapped(with prefixAndSuffix: StringWrappedEnclosingType) -> String {
		
		switch prefixAndSuffix {
		case .parentheses:		return "(" + self + ")"
		case .brackets:			return "[" + self + "]"
		case .braces:			return "{" + self + "}"
		case .angleBrackets:	return "<" + self + ">"
		case .singleQuotes:		return "'" + self + "'"
		case .quotes:			return "\"" + self + "\""
		}
		
	}
	
	/// OTCore:
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
	
	/// OTCore:
	/// Syntactic sugar. Returns the string wrapped with double quote marks (").
	/// Same as `self.wrapped(with: .parentheses)`
	public var parens: Self {
		self.wrapped(with: .parentheses)
	}
	
	/// OTCore:
	/// Syntactic sugar. Returns the string wrapped with double quote marks (').
	/// Same as `self.wrapped(with: .singleQuotes)`
	public var singleQuoted: Self {
		self.wrapped(with: .singleQuotes)
	}
	
	/// OTCore:
	/// Syntactic sugar. Returns the string wrapped with double quote marks (").
	/// Same as `self.wrapped(with: .quotes)`
	public var quoted: Self {
		self.wrapped(with: .quotes)
	}
	
}

extension StringProtocol {
		
	/// OTCore:
	/// Splits a string into groups of `length` characters, grouping from left-to-right. If `backwards` is true, right-to-left.
	public func split(every: Int, backwards: Bool = false) -> [Self.SubSequence] {
		
		var result: [Self.SubSequence] = []
		
		for i in stride(from: 0, to: self.count, by: every) {
			
			switch backwards {
			case true:
				let endIndex = self.index(self.endIndex, offsetBy: -i)
				let startIndex = self.index(endIndex,
											offsetBy: -every,
											limitedBy: self.startIndex)
					?? self.startIndex
				
				result.insert(self[startIndex..<endIndex], at: 0)
				
			case false:
				let startIndex = self.index(self.startIndex, offsetBy: i)
				let endIndex = self.index(startIndex,
										  offsetBy: every,
										  limitedBy: self.endIndex)
					?? self.endIndex
				
				result.append(self[startIndex..<endIndex])
				
			}
			
		}
		
		return result
		
	}
	
}

extension StringProtocol {
	
	/// OTCore:
	/// Splits the string into substrings matching the passed character set(s).
	///
	/// If overlapping character sets are supplied, they are matched in the order listed.
	///
	/// For example:
	///
	/// ```
	/// "abc123def456g7".split(intoSequencesOf: .letters, .decimalDigits)
	/// // ["abc", "123", "def", "456", "g", "7"]
	/// ```
	///
	/// - complexity: O(n) where n is length of string
	public func split(intoSequencesOf characterSets: CharacterSet...,
					  omitNonmatching: Bool = true)
	-> [Self.SubSequence]
	{
		
		var result: [Self.SubSequence] = []
		
		// iterate over characters
		
		var currentGroupingStartIndex: Self.Index? = self.indices.first
		var lastCharSetIndex: Int? = nil
		
		for idx in self.indices {
			
			// helper
			
			func closeGrouping(closingIdx: Self.Index) {
				
				if let startIdx = currentGroupingStartIndex {
					
					// if grouping didn't match char sets, only add grouping if omitNonmatching == true
					if lastCharSetIndex == nil && omitNonmatching { return }
					
					result.append(self[startIdx...closingIdx])
				}
			}
			
			// find index of first char set that contains the char
			
			guard let scalar = Unicode.Scalar(String(self[idx]))
				else { return [] }
			
			let firstMatchingCharSetIndex = characterSets.firstIndex(where: { $0.contains(scalar) })
			
			if lastCharSetIndex != firstMatchingCharSetIndex
				&& idx != self.indices.first {
				
				// grouping separator here
				
				// close off previous grouping and append to result array
				
				closeGrouping(closingIdx: self.index(before: idx))
				
				// start new grouping
				
				currentGroupingStartIndex = idx
				
			}
			
			// close off if we've reached the end of the string
			
			if idx == self.indices.last {
				if idx == self.indices.first {
					lastCharSetIndex = firstMatchingCharSetIndex
				}
				
				closeGrouping(closingIdx: idx)
			}
			
			// update last found index
			
			lastCharSetIndex = firstMatchingCharSetIndex
			
		}
		
		return result
		
	}
	
}


// MARK: - Character filters

extension StringProtocol {

	/// OTCore:
	/// Returns a string preserving only characters from the CharacterSet and removing all other characters.
	/// Example: "A string 123".only(.alphanumerics)
	public func only(_ characterSet: CharacterSet) -> String {
		self.map { characterSet.contains(UnicodeScalar("\($0)")!) ? "\($0)" : "" }
			.joined()
	}
	
	/// OTCore:
	/// Returns a string preserving only characters from the passed string and removing all other characters.
	public func only(characters: String) -> String {
		self.only(CharacterSet(charactersIn: characters))
	}
	
	/// OTCore:
	/// Returns a string containing only alphanumeric characters and removing all other characters.
	public var onlyAlphanumerics: String {
		self.only(.alphanumerics)
	}
	
	/// OTCore:
	/// Returns a string removing all characters from the passed CharacterSet.
	public func removing(_ characterSet: CharacterSet) -> String {
		self.components(separatedBy: characterSet)
			.joined()
	}
	
	/// OTCore:
	/// Returns a string removing all characters from the passed string.
	public func removing(characters: String) -> String {
		self.components(separatedBy: CharacterSet(charactersIn: characters))
			.joined()
	}
	
}


// MARK: - Prefix and Suffix

extension String {
	
	/// OTCore:
	/// Removes the suffix of a String if it exists and returns a new String.
	public func removingSuffix(_ suffix: String) -> String {
		if self.hasSuffix(suffix) {
			return String(self.dropLast(suffix.count))
		}
		
		return self
	}
	
	/// OTCore:
	/// Removes the suffix of a String if it exists.
	public mutating func removeSuffix(_ suffix: String) {
		if self.hasSuffix(suffix) {
			self.removeLast(suffix.count)
		}
	}
	
	/// OTCore:
	/// Removes the prefix of a String if it exists and returns a new String.
	public func removingPrefix(_ prefix: String) -> String {
		if self.hasPrefix(prefix) {
			return String(self.dropFirst(prefix.count))
		}
		
		return self
	}
	
	/// OTCore:
	/// Removes the prefix of a String if it exists.
	public mutating func removePrefix(_ prefix: String) {
		if self.hasPrefix(prefix) {
			self.removeFirst(prefix.count)
		}
	}
	
}


// MARK: - RegEx

extension String {
	
	/// OTCore:
	/// Returns an array of RegEx matches
	public func regexMatches(pattern: String) -> [String] {
		
		do {
			let regex = try NSRegularExpression(pattern: pattern)
			let nsString = self as NSString
			let results = regex.matches(in: self, range: NSMakeRange(0, nsString.length))
			return results.map { nsString.substring(with: $0.range)}
		} catch {
			return []
		}
		
	}
	
	/// OTCore:
	/// Returns a string from a tokenized string of RegEx matches
	public func regexMatches(pattern: String, replacementTemplate: String) -> String? {
		
		do {
			let regex = try NSRegularExpression(pattern: pattern)
			let nsString = self as NSString
			regex.numberOfMatches(in: self,
								  options: .withTransparentBounds,
								  range: NSMakeRange(0, nsString.length))
			let replaced = regex.stringByReplacingMatches(in: self,
														  options: .withTransparentBounds,
														  range: NSMakeRange(0, nsString.length),
														  withTemplate: replacementTemplate)
			
			return replaced
		} catch {
			return nil
		}
		
	}
	
	/// OTCore:
	/// Returns capture groups from regex matches. nil if an optional capture group is not matched.
	public func regexMatches(captureGroupsFromPattern: String) -> [String?] {
		
		do {
			let regex = try NSRegularExpression(pattern: captureGroupsFromPattern, options: [])
			let nsString = self as NSString
			let results = regex.matches(in: self,
										options: .withTransparentBounds,
										range: NSMakeRange(0, nsString.length))
			var matches: [String?] = []
			
			for result in results {
				for i in 1..<result.numberOfRanges {
					let range = result.range(at: i)
					
					if range.location == NSNotFound {
						matches.append(nil)
					} else {
						matches.append(nsString.substring( with: range ))
					}
				}
			}
			
			return matches
		} catch {
			return []
		}
		
	}
	
}


// MARK: - Title Case

extension String {
	
	/// OTCore:
	/// Used by `titleCased`. Private array of title case particles to leave as lowercase
	static private let titleCasedParticles = [
		"a", "an", "the",				// articles
		"and", "but", "for",			// coordinating conjunctions
		"at", "by", "of", "in", "on",	// prepositions
		"to", "with",
		"is"]
	
	/// OTCore:
	/// Returns a representation of the string in title case style, ie: "What to Capitalize in a Title" (English only)
	@available(OSX 10.11, *)
	public var titleCased: String {
		
		var words = self.localizedCapitalized.split(separator: " ").map({ String($0) })
		
		// only process if there are more than 2 words
		if words.count > 2 {
			for idx in 1...words.count - 2 {
				let currentWord = words[idx].localizedLowercase
				
				if String.titleCasedParticles.contains(currentWord) {
					words[idx] = currentWord
				}
			}
		}
		
		return words.joined(separator: " ")
		
	}
	
}


// MARK: - String Optionals

/// OTCore:
/// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns contents of `default` string.
///
/// Also accessible through the string interpolation variant:
///
/// ```
/// "\(object, ifNil: "Object is nil.")"
/// ```
public func optionalString(describing object: Any?, ifNil: String) -> String {
	
	object != nil
		? String(describing: object!)
		: ifNil
	
}


// MARK: - String Interpolation Extensions

extension String.StringInterpolation {
	
	/// OTCore:
	/// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns contents of `ifNil` string.
	public mutating func appendInterpolation(_ object: Any?, ifNil: String) {
		appendLiteral(optionalString(describing: object, ifNil: ifNil))
	}
	
}

extension String.StringInterpolation {
	
	// cache to improve performance, implicitly lazy (as a global static declaration)
	// ***** this may not be thread safe if the code gets more complex or multiple custom appendInterpolation funcs share it
	static fileprivate let formatter = NumberFormatter()
	
	/// OTCore:
	/// Convenience interpolator for formatting a number inline.
	public mutating func appendInterpolation(_ value: Int, format style: NumberFormatter.Style) {
		
		Self.formatter.numberStyle = style
		
		if let result = String.StringInterpolation.formatter.string(from: value as NSNumber) {
			appendLiteral(result)
		}
		
	}
	
}

extension String.StringInterpolation {
	
	/// OTCore:
	/// Convenience interpolator for converting a value to a given radix.
	public mutating func appendInterpolation(_ value: String, radix: Int) {
		guard let result = Int(value, radix: radix) else {
			appendLiteral("nil")
			return
		}
		appendLiteral(String(result))
	}
	
}


// MARK: - String Encoding

extension String {
	
	/// OTCore:
	/// Encode a utf8 String to Base64
	public var base64EncodedString: String {
		Data(self.utf8).base64EncodedString()
	}
	
	/// OTCore:
	/// Decode a utf8 String from Base64. Returns nil if unsuccessful.
	public var base64DecodedString: String? {
		guard let data = Data(base64Encoded: self) else { return nil }
		return String(data: data, encoding: .utf8)
	}
	
}


// MARK: - Functional methods

extension StringProtocol {
	
	/// OTCore:
	/// Return a new `String`.
	public var string: String {
		String(self)
	}
	
}

extension Character {
	
	/// OTCore:
	/// Return a new `String`.
	public var string: String {
		String(self)
	}
	
}
