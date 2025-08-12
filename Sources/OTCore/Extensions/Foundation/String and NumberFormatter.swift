//
//  String and NumberFormatter.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension DefaultStringInterpolation {
    /// Cache to improve performance, implicitly lazy (as a global static declaration).
    ///
    /// - Warning: This may not be thread-safe if called from more than one thread simultaneously.
    fileprivate static let siNumFormatter = NumberFormatter()
    
    /// **OTCore:**
    /// Convenience interpolator for formatting a number inline.
    ///
    /// Example:
    ///
    /// ```swift
    /// "There are \(3, format: .spellOut) apples"
    /// // "There are three apples"
    /// ```
    ///
    /// - Warning: This may not be thread-safe if called from more than one thread simultaneously.
    @_disfavoredOverload
    public mutating func appendInterpolation(
        _ value: Int,
        format style: NumberFormatter.Style
    ) {
        Self.siNumFormatter.numberStyle = style
        
        if let result = Self.siNumFormatter.string(from: value as NSNumber) {
            appendLiteral(result)
        }
    }
}

#endif
