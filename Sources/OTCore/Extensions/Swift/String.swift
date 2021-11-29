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
    /// Returns a new String appending a newline character to the end.
    @inlinable public var newLined: Self {
        self + Self.newLine
    }
    
    /// **OTCore:**
    /// Returns a new String appending a tab character to the end.
    @inlinable public var tabbed: Self {
        self + Self.tab
    }
    
    /// **OTCore:**
    /// Appends a newline character to the end of the string.
    @inlinable public mutating func newLine() {
        self += Self.newLine
    }
    
    /// **OTCore:**
    /// Appends a tab character to the end of the string.
    @inlinable public mutating func tab() {
        self += Self.tab
    }
    
}

extension Substring {
    
    /// **OTCore:**
    /// Returns a new String appending a newline character to the end.
    @inlinable public var newLined: String {
        String(self) + String.newLine
    }
    
    /// **OTCore:**
    /// Returns a new String appending a tab character to the end.
    @inlinable public var tabbed: String {
        String(self) + String.tab
    }
    
}

// MARK: - Segmentation

extension String {
    
    /// **OTCore:**
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    @_disfavoredOverload
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

extension Character {
    
    /// **OTCore:**
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    public func repeating(_ count: Int) -> String {
        
        String(repeating: self, count: count)
        
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
    public func split(every: Int,
                      backwards: Bool = false) -> [SubSequence] {
        
        var result: [Self.SubSequence] = []
        
        for i in stride(from: 0, to: count, by: every) {
            
            switch backwards {
            case true:
                let offsetEndIndex = index(endIndex, offsetBy: -i)
                let offsetStartIndex = index(offsetEndIndex,
                                       offsetBy: -every,
                                       limitedBy: startIndex)
                ?? startIndex
                
                result.insert(self[offsetStartIndex..<offsetEndIndex], at: 0)
                
            case false:
                let offsetStartIndex = index(startIndex, offsetBy: i)
                let offsetEndIndex = index(offsetStartIndex,
                                     offsetBy: every,
                                     limitedBy: endIndex)
                ?? endIndex
                
                result.append(self[offsetStartIndex..<offsetEndIndex])
                
            }
            
        }
        
        return result
        
    }
    
}


// MARK: - Indexes

extension StringProtocol {
    
    /// **OTCore:**
    /// Returns an index that is the specified distance from the start index.
    public func startIndex(offsetBy distance: Int) -> Index {
        index(startIndex, offsetBy: distance)
    }
    
    /// **OTCore:**
    /// Returns an index that is the specified distance from the start index.
    public func endIndex(offsetBy distance: Int) -> Index {
        index(endIndex, offsetBy: distance)
    }
    
}

extension StringProtocol {
    
    /// **OTCore:**
    /// Returns the character at the given character position (offset from the start index).
    public subscript(position offsetIndex: Int) -> Character {
        
        let index = index(startIndex, offsetBy: offsetIndex)
        return self[index]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: ClosedRange<Int>) -> SubSequence {
        
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex...toIndex]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: Range<Int>) -> SubSequence {
        
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex..<toIndex]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: PartialRangeFrom<Int>) -> SubSequence {
        
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        return self[fromIndex...]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: PartialRangeThrough<Int>) -> SubSequence {
        
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[...toIndex]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: PartialRangeUpTo<Int>) -> SubSequence {
        
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[..<toIndex]
        
    }
    
}


// MARK: - Prefix and Suffix

extension StringProtocol {
    
    /// **OTCore:**
    /// Returns a new SubSequence, removing the prefix if it matches.
    @inlinable public func removingPrefix<T: StringProtocol>(_ prefix: T) -> SubSequence {
        
        hasPrefix(prefix)
            ? dropFirst(prefix.count)
            : self[startIndex..<endIndex]
        
    }
    
    /// **OTCore:**
    /// Returns a new SubSequence, removing the suffix if it matches.
    @inlinable public func removingSuffix<T: StringProtocol>(_ suffix: T) -> SubSequence {
        
        hasSuffix(suffix)
            ? dropLast(suffix.count)
            : self[startIndex..<endIndex]
        
    }
    
}

extension String {
    
    /// **OTCore:**
    /// Removes the prefix of a String if it exists.
    @inlinable public mutating func removePrefix<T: StringProtocol>(_ prefix: T) {
        
        if hasPrefix(prefix) {
            removeFirst(prefix.count)
        }
        
    }
    
    /// **OTCore:**
    /// Removes the suffix of a String if it exists.
    @inlinable public mutating func removeSuffix<T: StringProtocol>(_ suffix: T) {
        
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
@inlinable public func optionalString(describing object: Any?,
                                      ifNil: String) -> String {
    
    object != nil
        ? String(describing: object!)
        : ifNil
    
}


// MARK: - String Interpolation Extensions

extension DefaultStringInterpolation {
    
    /// **OTCore:**
    /// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns contents of `ifNil` string.
    @inlinable public mutating func appendInterpolation(_ object: Any?,
                                                        ifNil: String) {
        
        appendLiteral(optionalString(describing: object, ifNil: ifNil))
        
    }
    
}

extension DefaultStringInterpolation {
    
    /// **OTCore:**
    /// Convenience interpolator for converting a value to a given radix.
    @inlinable public mutating func appendInterpolation(_ value: String,
                                                        radix: Int) {
        
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
