//
//  String and CharacterSet.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension StringProtocol {
    
    /// **OTCore:**
    /// Splits the string into substrings matching the passed character set(s).
    ///
    /// If overlapping character sets are supplied, they are matched in the order listed.
    ///
    /// For example:
    ///
    ///     "abc123def456g7".split(intoSequencesOf: .letters, .decimalDigits)
    ///     // ["abc", "123", "def", "456", "g", "7"]
    ///
    /// - complexity: O(*n*) where *n* is length of string
    public func split(intoSequencesOf characterSets: CharacterSet...,
                      omitNonmatching: Bool = true) -> [Self.SubSequence] {
        
        var result: [Self.SubSequence] = []
        
        // iterate over characters
        
        var currentGroupingStartIndex: Self.Index? = indices.first
        var lastCharSetIndex: Int? = nil
        
        for idx in indices {
            
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
                && idx != indices.first {
                
                // grouping separator here
                
                // close off previous grouping and append to result array
                
                closeGrouping(closingIdx: index(before: idx))
                
                // start new grouping
                
                currentGroupingStartIndex = idx
                
            }
            
            // close off if we've reached the end of the string
            
            if idx == indices.last {
                if idx == indices.first {
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
    
    /// **OTCore:**
    /// Returns a string preserving only characters from the CharacterSet and removing all other characters.
    ///
    /// Example:
    ///
    ///     "A string 123".only(.alphanumerics)`
    ///
    public func only(_ characterSet: CharacterSet) -> String {
        
        map { characterSet.contains(UnicodeScalar("\($0)")!) ? "\($0)" : "" }
            .joined()
        
    }
    
    /// **OTCore:**
    /// Returns a string preserving only characters from the passed string and removing all other characters.
    public func only(characters: String) -> String {
        
        only(CharacterSet(charactersIn: characters))
        
    }
    
    /// **OTCore:**
    /// Returns a string containing only alphanumeric characters and removing all other characters.
    public var onlyAlphanumerics: String {
        
        only(.alphanumerics)
        
    }
    
    /// **OTCore:**
    /// Returns a string removing all characters from the passed CharacterSet.
    public func removing(_ characterSet: CharacterSet) -> String {
        
        components(separatedBy: characterSet)
            .joined()
        
    }
    
    /// **OTCore:**
    /// Returns a string removing all characters from the passed string.
    public func removing(characters: String) -> String {
        
        components(separatedBy: CharacterSet(charactersIn: characters))
            .joined()
        
    }
    
}

#endif
