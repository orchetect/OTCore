//
//  String and CharacterSet.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
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
    @_disfavoredOverload
    public func split(
        intoSequencesOf characterSets: CharacterSet...,
        omitNonmatching: Bool = true
    ) -> [Self.SubSequence] {
        var result: [Self.SubSequence] = []
        
        // iterate over characters
        
        var currentGroupingStartIndex: Self.Index? = indices.first
        var lastCharSetIndex: Int?
        
        for idx in indices {
            // helper
            
            func closeGrouping(closingIdx: Self.Index) {
                if let startIdx = currentGroupingStartIndex {
                    // if grouping didn't match char sets, only add grouping if omitNonmatching == true
                    if lastCharSetIndex == nil, omitNonmatching { return }
                    
                    result.append(self[startIdx ... closingIdx])
                }
            }
            
            // find index of first char set that contains the char
            
            guard let scalar = Unicode.Scalar(String(self[idx]))
            else { return [] }
            
            let firstMatchingCharSetIndex = characterSets.firstIndex(where: { $0.contains(scalar) })
            
            if lastCharSetIndex != firstMatchingCharSetIndex,
               idx != indices.first
            {
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
    /// Returns a string preserving only characters from one or more `CharacterSet`s.
    ///
    /// Example:
    ///
    ///     "A string 123".only(.alphanumerics)`
    ///     "A string 123".only(.letters, .decimalDigits)`
    ///
    @_disfavoredOverload
    public func only(
        _ characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> String {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet, +=)
        
        return unicodeScalars
            .filter { mergedCharacterSet.contains($0) }
            .map { "\($0)" }
            .joined()
    }
    
    /// **OTCore:**
    /// Returns a string preserving only characters from the passed string and removing all other characters.
    @_disfavoredOverload
    public func only(charactersIn string: String) -> String {
        only(CharacterSet(charactersIn: string))
    }
    
    /// **OTCore:**
    /// Returns a string containing only alphanumeric characters and removing all other characters.
    @_disfavoredOverload
    public var onlyAlphanumerics: String {
        only(.alphanumerics)
    }
    
    /// **OTCore:**
    /// Returns a string removing all characters from the passed `CharacterSet`s.
    ///
    /// Example:
    ///
    ///     "A string 123".removing(.whitespaces)`
    ///     "A string 123".removing(.letters, .decimalDigits)`
    ///
    @_disfavoredOverload
    public func removing(
        _ characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> String {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet, +=)
        
        return components(separatedBy: mergedCharacterSet)
            .joined()
    }
    
    /// **OTCore:**
    /// Returns a string removing all characters from the passed string.
    @_disfavoredOverload
    public func removing(characters: String) -> String {
        components(separatedBy: CharacterSet(charactersIn: characters))
            .joined()
    }
}

// MARK: - Character tests

extension StringProtocol {
    /// **OTCore:**
    /// Returns true if the string is entirely comprised of ASCII characters (0-127).
    @inlinable @_disfavoredOverload
    public var isASCII: Bool {
        allSatisfy(\.isASCII)
    }
    
    /// **OTCore:**
    /// Returns true if all characters in the string are contained in the character set.
    @_disfavoredOverload
    public func isOnly(
        _ characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> Bool {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet, +=)
        
        return allSatisfy(mergedCharacterSet.contains(_:))
    }
    
    /// **OTCore:**
    /// Returns true if all characters in the string are contained in the character set.
    @_disfavoredOverload
    public func isOnly(charactersIn string: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: string)
        return allSatisfy(characterSet.contains(_:))
    }
    
    /// **OTCore:**
    /// Returns true if any character in the string are contained in the character set.
    @_disfavoredOverload
    public func contains(
        any characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> Bool {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet, +=)
        
        for char in self {
            if mergedCharacterSet.contains(char) { return true }
        }
        
        return false
    }
    
    /// **OTCore:**
    /// Returns true if any character in the string are contained in the character set.
    @_disfavoredOverload
    public func contains(anyCharactersIn characters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: characters)
        
        for char in self {
            if characterSet.contains(char) { return true }
        }
        
        return false
    }
}

#endif
