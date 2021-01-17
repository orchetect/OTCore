//
//  CharacterSet.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-08-17.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if canImport(Foundation)

import Foundation

extension CharacterSet {
	
	/// **OTCore:**
	/// Returns true if the `CharacterSet` contains the given `Character`.
	public func contains(_ character: Character) -> Bool {
		
		return character
			.unicodeScalars
			.allSatisfy(contains(_:))
		
	}
	
}

#endif
