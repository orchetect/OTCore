//
//  String and NSRegularExpression.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if canImport(Foundation)

import Foundation

// MARK: - RegEx

extension String {
	
	/// **OTCore:**
	/// Returns an array of RegEx matches
	public func regexMatches(
		pattern: String,
		options: NSRegularExpression.Options = [],
		matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
	) -> [String] {
		
		do {
			
			let regex = try NSRegularExpression(pattern: pattern,
												options: options)
			let nsString = self as NSString
			let results = regex.matches(in: self,
										options: matchesOptions,
										range: NSMakeRange(0, nsString.length))
			
			return results.map { nsString.substring(with: $0.range)}
			
		} catch {
			
			return []
			
		}
		
	}
	
	/// **OTCore:**
	/// Returns a string from a tokenized string of RegEx matches
	public func regexMatches(
		pattern: String,
		replacementTemplate: String,
		options: NSRegularExpression.Options = [],
		matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds],
		replacingOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
	) -> String? {
		
		do {
			
			let regex = try NSRegularExpression(pattern: pattern,
												options: options)
			
			let nsString = self as NSString
			
			let replaced = regex.stringByReplacingMatches(
				in: self,
				options: replacingOptions,
				range: NSMakeRange(0, nsString.length),
				withTemplate: replacementTemplate
			)
			
			return replaced
			
		} catch {
			
			return nil
			
		}
		
	}
	
	/// **OTCore:**
	/// Returns capture groups from regex matches. If any capture group is not matched it will be `nil`.
	public func regexMatches(
		captureGroupsFromPattern: String,
		options: NSRegularExpression.Options = [],
		matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
	) -> [String?] {
		
		do {
			
			let regex = try NSRegularExpression(pattern: captureGroupsFromPattern,
												options: options)
			
			let nsString = self as NSString
			
			let results = regex.matches(
				in: self,
				options: matchesOptions,
				range: NSMakeRange(0, nsString.length)
			)
			
			var matches: [String?] = []
			
			for result in results {
				for i in 0..<result.numberOfRanges {
					let range = result.range(at: i)
					
					if range.location == NSNotFound {
						matches.append(nil)
					} else {
						matches.append(nsString.substring(with: range ))
					}
				}
			}
			
			return matches
			
		} catch {
			
			return []
			
		}
		
	}
	
}

#endif
