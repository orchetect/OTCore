//
//  String and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Ranges

extension StringProtocol {
    /// **OTCore:**
    /// Returns the index of the first match, or `nil` if no matches are found.
    @_disfavoredOverload
    public func firstIndex<T: StringProtocol>(of substring: T) -> String.Index? {
        range(
            of: substring,
            options: .literal,
            range: nil,
            locale: nil
        )?.lowerBound
    }
    
    /// **OTCore:**
    /// Same as `.range(of: find, options: .backwards)`
    /// (Functional convenience method)
    @_disfavoredOverload
    public func range<T: StringProtocol>(backwards find: T) -> Range<Index>? {
        range(of: find, options: .backwards)
    }
    
    /// **OTCore:**
    /// Same as `.range(of: find, options: [.caseInsensitiveSearch, .backwards])`
    /// (Functional convenience method)
    @_disfavoredOverload
    public func range<T: StringProtocol>(backwardsCaseInsensitive find: T) -> Range<Index>? {
        range(of: find, options: [.caseInsensitive, .backwards])
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    public subscript(position offsetRange: NSRange) -> SubSequence {
        let fromIndex = index(startIndex, offsetBy: offsetRange.location)
        let toIndex = index(startIndex, offsetBy: offsetRange.location + offsetRange.length)
        return self[fromIndex ... toIndex]
    }
    
    /// **OTCore:**
    /// Convenience method: returns `true` if contains string. Case-insensitive.
    @_disfavoredOverload
    public func contains<T: StringProtocol>(caseInsensitive find: T) -> Bool {
        range(of: find, options: .caseInsensitive) != nil
            ? true
            : false
    }
    
    /// **OTCore:**
    /// Convenience method: returns `true` if starts with the specified string. Case-insensitive, non-localized.
    @_disfavoredOverload
    public func hasPrefix<T: StringProtocol>(caseInsensitive prefix: T) -> Bool {
        // Method 1
        // --------
        // uppercased()
        //    .starts(with: prefix.uppercased())
        
        // Method 2
        // --------
        // guard count >= prefix.count else { return false }
        //
        // let selfPrefix = self[self.startIndex ..<
        //                       self.index(self.startIndex,
        //                                  offsetBy: prefix.count)]
        // return selfPrefix.caseInsensitiveCompare(prefix) == .orderedSame
        
        // Method 3
        // --------
        guard let range = range(
            of: prefix,
            options: [.caseInsensitive, .anchored]
        ) else { return false }
        return range.lowerBound == startIndex
    }
    
    /// **OTCore:**
    /// Convenience method: returns `true` if ends with the specified string. Case-insensitive, non-localized.
    @_disfavoredOverload
    public func hasSuffix<T: StringProtocol>(caseInsensitive prefix: T) -> Bool {
        guard let range = range(
            of: prefix,
            options: [
                .caseInsensitive,
                .anchored,
                .backwards
            ]
        )
        else { return false }
        
        return range.upperBound == endIndex
    }
}

#endif
