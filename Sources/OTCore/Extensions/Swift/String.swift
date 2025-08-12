//
//  String.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - String Convenience Constants

extension String {
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var quote: Self { "\"" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var tab: Self { "\t" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var space: Self { " " }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var newLine: Self { "\n" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
}

// MARK: - Character Convenience Constants

extension Character {
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var quote: Self { "\"" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var tab: Self { "\t" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var space: Self { " " }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var newLine: Self { "\n" }
    
    /// **OTCore:**
    /// Convenience constant.
    @inlinable @_disfavoredOverload
    public static var null: Self { "\0" } // { Self(UnicodeScalar(0)) }
}

// MARK: - String functional append constants

extension String {
    /// **OTCore:**
    /// Returns a new String appending a newline character to the end.
    @inlinable @_disfavoredOverload
    public var newLined: Self {
        self + Self.newLine
    }
    
    /// **OTCore:**
    /// Returns a new String appending a tab character to the end.
    @inlinable @_disfavoredOverload
    public var tabbed: Self {
        self + Self.tab
    }
    
    /// **OTCore:**
    /// Appends a newline character to the end of the string.
    @inlinable @_disfavoredOverload
    public mutating func newLine() {
        self += Self.newLine
    }
    
    /// **OTCore:**
    /// Appends a tab character to the end of the string.
    @inlinable @_disfavoredOverload
    public mutating func tab() {
        self += Self.tab
    }
}

extension Substring {
    /// **OTCore:**
    /// Returns a new String appending a newline character to the end.
    @inlinable @_disfavoredOverload
    public var newLined: String {
        String(self) + String.newLine
    }
    
    /// **OTCore:**
    /// Returns a new String appending a tab character to the end.
    @inlinable @_disfavoredOverload
    public var tabbed: String {
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
    @_disfavoredOverload
    public func repeating(_ count: Int) -> String {
        String(repeating: string, count: count)
    }
}

extension Character {
    /// **OTCore:**
    /// Same as `String(repeating: self, count: count)`
    /// (Functional convenience method)
    @_disfavoredOverload
    public func repeating(_ count: Int) -> String {
        String(repeating: self, count: count)
    }
}

extension String {
    /// **OTCore:**
    /// Convenience function to trim whitespaces and newlines off start and end.
    @inlinable @_disfavoredOverload
    public mutating func trim() {
        self = trimmed
    }
}

// MARK: - Prefix and Suffix

extension StringProtocol {
    /// **OTCore:**
    /// Returns a new `SubSequence` removing the prefix if it matches.
    @inlinable @_disfavoredOverload
    public func removingPrefix<T: StringProtocol>(_ prefix: T) -> SubSequence {
        hasPrefix(prefix)
            ? dropFirst(prefix.count)
            : self[startIndex ..< endIndex]
    }
    
    /// **OTCore:**
    /// Returns a new `SubSequence` removing the suffix if it matches.
    @inlinable @_disfavoredOverload
    public func removingSuffix<T: StringProtocol>(_ suffix: T) -> SubSequence {
        hasSuffix(suffix)
            ? dropLast(suffix.count)
            : self[startIndex ..< endIndex]
    }
}

extension String {
    /// **OTCore:**
    /// Removes the prefix of a String if it exists.
    @inlinable @_disfavoredOverload
    public mutating func removePrefix<T: StringProtocol>(_ prefix: T) {
        if hasPrefix(prefix) {
            removeFirst(prefix.count)
        }
    }
    
    /// **OTCore:**
    /// Removes the suffix of a String if it exists.
    @inlinable @_disfavoredOverload
    public mutating func removeSuffix<T: StringProtocol>(_ suffix: T) {
        if hasSuffix(suffix) {
            removeLast(suffix.count)
        }
    }
}

// MARK: - String Optionals

/// **OTCore:**
/// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns
/// contents of `default` string.
///
/// Also accessible through the string interpolation variant:
///
/// ```swift
/// "\(object, ifNil: "Object is nil.")"
/// ```
@inlinable @_disfavoredOverload
public func optionalString(
    describing object: Any?,
    ifNil: String
) -> String {
    object != nil
        ? String(describing: object!)
        : ifNil
}

// MARK: - String Interpolation Extensions

extension DefaultStringInterpolation {
    /// **OTCore:**
    /// Convenience: Returns unwrapped String representation of a Swift Optional, otherwise returns
    /// contents of `ifNil` string.
    @inlinable @_disfavoredOverload
    public mutating func appendInterpolation(
        _ object: Any?,
        ifNil: String
    ) {
        appendLiteral(optionalString(describing: object, ifNil: ifNil))
    }
}

extension DefaultStringInterpolation {
    /// **OTCore:**
    /// Convenience interpolator for converting a value to a given radix.
    @inlinable @_disfavoredOverload
    public mutating func appendInterpolation(
        _ value: String,
        radix: Int
    ) {
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
    /// Same as `String(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var string: String {
        String(self)
    }
}

extension Character {
    /// **OTCore:**
    /// Same as `String(self)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var string: String {
        String(self)
    }
}
