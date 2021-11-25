//
//  String.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - String Convenience Constants

extension String {
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var quote: Self { "\"" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var tab: Self { "\t" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var space: Self { " " }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var newLine: Self { "\n" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
    
}


// MARK: - Character Convenience Constants

extension Character {
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var quote: Self { "\"" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var tab: Self { "\t" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var space: Self { " " }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var newLine: Self { "\n" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
    
}


// MARK: - String functional append constants

extension String {
    
    /// **OTCore:**
    /// Appends a newline to the end of the string and returns a copy.
    public var newLined: Self {
        self + Self.newLine
    }
    
    /// **OTCore:**
    /// Appends a tab to the end of the string and returns a copy.
    public var tabbed: Self {
        self + Self.tab
    }
    
    /// **OTCore:**
    /// Appends a newline to the end of the string.
    public mutating func newLine() {
        self += Self.newLine
    }
    
    /// **OTCore:**
    /// Appends a tab to the end of the string.
    public mutating func tab() {
        self += Self.tab
    }
    
}


// MARK: - Ranges

extension StringProtocol {
    
    /// **OTCore:**
    /// Same as `.range(of: find, options: .backwards)`
    /// (Functional convenience method)
    public func range(backwards find: Self) -> Range<Index>? {
        
        range(of: find, options: .backwards)
        
    }
    
    /// **OTCore:**
    /// Same as `.range(of: find, options: [.caseInsensitiveSearch, .backwards])`
    /// (Functional convenience method)
    public func range(backwardsCaseInsensitive find: Self) -> Range<Index>? {
        
        range(of: find, options: [.caseInsensitive, .backwards])
        
    }
    
    /// **OTCore:**
    /// Convenience method: returns `true` if contains string. Case-insensitive.
    public func contains(caseInsensitive find: Self) -> Bool {
        
        range(of: find, options: .caseInsensitive) != nil
            ? true
            : false
        
    }
    
    /// **OTCore:**
    /// Convenience method: returns `true` if starts with the specified string. Case-insensitive.
    public func starts(withCaseInsensitive prefix: Self) -> Bool {
        
        uppercased()
            .starts(with: prefix.uppercased())
        
    }
    
}


// MARK: - Segmentation

extension String {
    
    /// **OTCore:**
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    public func repeating(_ count: Int) -> String {
        
        String(repeating: self, count: count)
        
    }
    
}

extension Substring {
    
    /// **OTCore:**
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    public func repeating(_ count: Int) -> String {
        
        String(repeating: string, count: count)
        
    }
    
}

extension StringProtocol {
    
    /// **OTCore:**
    /// Convenience function to return a new string with whitespaces and newlines trimmed off start and end.
    @inlinable public var trimmed: String {
        
        trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
}

extension String {
    
    /// **OTCore:**
    /// Convenience function to trim whitespaces and newlines off start and end.
    @inlinable public mutating func trim() {
        
        self = trimmed
        
    }
    
}

extension StringProtocol {
    
    /// **OTCore:**
    /// Splits a string into groups of `length` characters, grouping from left-to-right. If `backwards` is true, right-to-left.
    public func split(every: Int, backwards: Bool = false) -> [Self.SubSequence] {
        
        var result: [Self.SubSequence] = []
        
        for i in stride(from: 0, to: count, by: every) {
            
            switch backwards {
            case true:
                let endIndex = index(endIndex, offsetBy: -i)
                let startIndex = index(endIndex,
                                       offsetBy: -every,
                                       limitedBy: startIndex)
                ?? startIndex
                
                result.insert(self[startIndex..<endIndex], at: 0)
                
            case false:
                let startIndex = index(startIndex, offsetBy: i)
                let endIndex = index(startIndex,
                                     offsetBy: every,
                                     limitedBy: endIndex)
                ?? endIndex
                
                result.append(self[startIndex..<endIndex])
                
            }
            
        }
        
        return result
        
    }
    
}


// MARK: - Prefix and Suffix

extension String {
    
    /// **OTCore:**
    /// Removes the prefix of a String if it exists and returns a new String.
    public func removingPrefix(_ prefix: String) -> String {
        
        if hasPrefix(prefix) {
            return String(dropFirst(prefix.count))
        }
        
        return self
        
    }
    
    /// **OTCore:**
    /// Removes the prefix of a String if it exists.
    public mutating func removePrefix(_ prefix: String) {
        
        if hasPrefix(prefix) {
            removeFirst(prefix.count)
        }
        
    }
    
    /// **OTCore:**
    /// Removes the suffix of a String if it exists and returns a new String.
    public func removingSuffix(_ suffix: String) -> String {
        
        if hasSuffix(suffix) {
            return String(dropLast(suffix.count))
        }
        
        return self
        
    }
    
    /// **OTCore:**
    /// Removes the suffix of a String if it exists.
    public mutating func removeSuffix(_ suffix: String) {
        
        if hasSuffix(suffix) {
            removeLast(suffix.count)
        }
        
    }
    
}


// MARK: - String Optionals

/// **OTCore:**
/// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns contents of `default` string.
///
/// Also accessible through the string interpolation variant:
///
///     "\(object, ifNil: "Object is nil.")"
///
@inlinable public func optionalString(describing object: Any?, ifNil: String) -> String {
    
    object != nil
        ? String(describing: object!)
        : ifNil
    
}


// MARK: - String Interpolation Extensions

extension DefaultStringInterpolation {
    
    /// **OTCore:**
    /// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns contents of `ifNil` string.
    @inlinable public mutating func appendInterpolation(_ object: Any?, ifNil: String) {
        
        appendLiteral(optionalString(describing: object, ifNil: ifNil))
        
    }
    
}

extension DefaultStringInterpolation {
    
    /// **OTCore:**
    /// Convenience interpolator for converting a value to a given radix.
    @inlinable public mutating func appendInterpolation(_ value: String, radix: Int) {
        
        guard let result = Int(value, radix: radix) else {
            appendLiteral("nil")
            return
        }
        appendLiteral(String(result))
    }
    
}


// MARK: - Functional methods

extension Substring {
    
    /// **OTCore:**
    /// Same as `String(self)`
    /// (Functional convenience method)
    @inlinable public var string: String {
        
        String(self)
        
    }
    
}

extension Character {
    
    /// **OTCore:**
    /// Same as `String(self)`
    /// (Functional convenience method)
    @inlinable public var string: String {
        
        String(self)
        
    }
    
}
