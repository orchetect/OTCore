//
//  String Wrapped.swift
//  OTCore • https://github.com/orchetect/OTCore
//

extension String {
    /// **OTCore:**
    /// Returns the string adding the passed `with` parameter as a prefix and suffix.
    @inlinable @_disfavoredOverload
    public func wrapped(with prefixAndSuffix: String) -> String {
        prefixAndSuffix + self + prefixAndSuffix
    }
    
    /// **OTCore:**
    /// Returns the string adding the passed `with` parameter as a prefix and suffix.
    @inlinable @_disfavoredOverload
    public func wrapped(with prefixAndSuffix: StringWrappedEnclosingType) -> String {
        switch prefixAndSuffix {
        case .parentheses:      return "(" + self + ")"
        case .brackets:         return "[" + self + "]"
        case .braces:           return "{" + self + "}"
        case .angleBrackets:    return "<" + self + ">"
        case .singleQuotes:     return "'" + self + "'"
        case .quotes:           return "\"" + self + "\""
        }
    }
    
    /// **OTCore:**
    /// Type describing a pair of enclosing brackets/braces or similar characters that are different for prefix and suffix.
    public enum StringWrappedEnclosingType {
        /// ( ) a.k.a. parens
        case parentheses
        
        /// [ ] a.k.a. square brackets
        case brackets
        
        /// { } a.k.a. curly braces
        case braces
        
        /// < >
        case angleBrackets
        
        /// ' '
        case singleQuotes
        
        /// " "
        case quotes
    }
    
    /// **OTCore:**
    /// Syntactic sugar. Returns the string wrapped with parentheses: `( )`.
    /// Same as `self.wrapped(with: .parentheses)`
    @inlinable @_disfavoredOverload
    public var parenthesized: Self {
        wrapped(with: .parentheses)
    }
    
    /// **OTCore:**
    /// Syntactic sugar. Returns the string wrapped with parentheses: `( )`.
    /// Same as `self.wrapped(with: .parentheses)`
    @inlinable @_disfavoredOverload
    @available(*, unavailable, renamed: "parenthesized")
    public var parens: Self {
        parenthesized
    }
    
    /// **OTCore:**
    /// Syntactic sugar. Returns the string wrapped with single quote marks: `' '`.
    /// Same as `self.wrapped(with: .singleQuotes)`
    @inlinable @_disfavoredOverload
    public var singleQuoted: Self {
        wrapped(with: .singleQuotes)
    }
    
    /// **OTCore:**
    /// Syntactic sugar. Returns the string wrapped with double quote marks: `" "`.
    /// Same as `self.wrapped(with: .quotes)`
    @inlinable @_disfavoredOverload
    public var quoted: Self {
        wrapped(with: .quotes)
    }
}
