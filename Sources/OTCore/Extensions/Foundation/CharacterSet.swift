//
//  CharacterSet.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension CharacterSet {
    
    /// **OTCore:**
    /// Returns true if the `CharacterSet` contains the given `Character`.
    public func contains(_ character: Character) -> Bool {
        
        character
            .unicodeScalars
            .allSatisfy(contains(_:))
        
    }
    
}

#endif
