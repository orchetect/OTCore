//
//  String Title Case.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

// MARK: - Title Case

extension String {
	
	/// **OTCore:**
	/// Used by `titleCased`. Private array of title case particles to leave as lowercase
	static private let titleCasedParticles = [
		"a", "an", "the",				// articles
		"and", "but", "for",			// coordinating conjunctions
		"at", "by", "of", "in", "on",	// prepositions
		"to", "with",
		"is"]
	
	/// **OTCore:**
	/// Returns a representation of the string in title case style, ie: "What to Capitalize in a Title" (English only)
	@available(macOS 10.11, *)
	public var titleCased: String {
		
		var words =
			self.localizedCapitalized
			.split(separator: " ")
			.map({ String($0) })
		
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
