//
//  Equatable.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - .if(then:)

extension Equatable {
    
    /// **OTCore:**
    /// If-statement producing a new value if the `test` closure evaluates as `true`, otherwise returns `nil`.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.if({ $0 > 100 }, then: "yes") // Optional("yes")
    ///
    ///     123.if({ $0 < 100 }, then: "yes") // nil
    ///
    @inlinable public func `if`<T>(_ test: (Self) throws -> Bool,
                                   then trueValue: T) rethrows -> T? {
        
        try test(self) ? trueValue : nil
        
    }
    
    /// **OTCore:**
    /// If-statement producing a transformed value if the `test` closure evaluates as `true`, otherwise returns `nil`.
    /// `self` is passed to the `trueValue` closure so the source value can be propagated.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.if({ $0 > 100 }, then: { "\($0 * 2)" }) // Optional("246")
    ///
    ///     123.if({ $0 < 100 }, then: { "\($0 * 2)" }) // nil
    ///
    @inlinable public func `if`<T>(_ test: (Self) throws -> Bool,
                                   then trueValue: (Self) throws -> T) rethrows -> T? {
        
        try test(self) ? trueValue(self) : nil
        
    }
    
}


// MARK: - .if(then:else:)

extension Equatable {
    
    /// **OTCore:**
    /// If-statement producing one of two values depending on the `test` closure.
    /// (Functional convenience method)
    ///
    /// Example 1 - single line:
    ///
    ///     123.if({ $0 > 100 }, then: "yes", else: "no") // "yes"
    ///
    ///     123.if({ $0 < 100 }, then: "yes", else: "no") // "no"
    ///
    /// Example 2 - one clause per line:
    ///
    ///     123.if({ $0 > 100 },
    ///            then: { "yes" },
    ///            else: { "no" })
    ///     // "no"
    ///
    /// Example 3 - using trailing closure syntax:
    ///
    ///     let number = 50
    ///
    ///     number
    ///         .if {
    ///             $0 > 100
    ///         } then: {
    ///             "yes"
    ///         } else: {
    ///             "no"
    ///         }
    ///     // "no"
    ///
    @inlinable public func `if`<T>(_ test: (Self) throws -> Bool,
                                   then trueValue: T,
                                   else falseValue: T) rethrows -> T {
        
        try test(self) ? trueValue : falseValue
        
    }
    
    /// **OTCore:**
    /// If-statement producing one of two values depending on the `test` closure.
    /// `self` is passed to the resulting closures so the source value can be propagated.
    /// (Functional convenience method)
    ///
    /// Example 1 - single line:
    ///
    ///     123.if({ $0 > 100 }, then: { "high: \($0)" }, else: { "low: \($0)" })
    ///     // "high: 123"
    ///
    /// Example 2 - one clause per line:
    ///
    ///     123.if({ $0 > 100 },
    ///            then: { "high: \($0)" },
    ///            else: { "low: \($0)" })
    ///     // "high: 123"
    ///
    /// Example 3 - using trailing closure syntax:
    ///
    ///     let number = 50
    ///
    ///     number
    ///         .if {
    ///             $0 > 100
    ///         } then: {
    ///             "high: \($0)"
    ///         } else: {
    ///             "low: \($0)"
    ///         }
    ///     // "low: 50"
    ///
    @inlinable public func `if`<T>(_ test: (Self) throws -> Bool,
                                   then trueValue: (Self) throws -> T,
                                   else falseValue: (Self) throws -> T) rethrows -> T {
        
        try test(self) ? trueValue(self) : falseValue(self)
        
    }
    
    /// **OTCore:**
    /// If-statement producing one of two values depending on the `test` closure.
    /// `self` is passed to the resulting closures so the source value can be propagated.
    /// (Functional convenience method)
    ///
    /// Example 1 - single line:
    ///
    ///     123.if({ $0 > 100 }, then: { "high: \($0)" }, else: { "low: \($0)" })
    ///     // "high: 123"
    ///
    /// Example 2 - one clause per line:
    ///
    ///     123.if({ $0 > 100 },
    ///            then: { "high: \($0)" },
    ///            else: { "low: \($0)" })
    ///     // "high: 123"
    ///
    /// Example 3 - using trailing closure syntax:
    ///
    ///     let number = 50
    ///
    ///     number
    ///         .if {
    ///             $0 > 100
    ///         } then: {
    ///             "high: \($0)"
    ///         } else: {
    ///             "low: \($0)"
    ///         }
    ///     // "low: 50"
    ///
    @inlinable public func `if`(_ test: (Self) throws -> Bool,
                                then trueValue: (Self) throws -> Self,
                                else falseValue: (Self) throws -> Self) rethrows -> Self {
        
        try test(self) ? trueValue(self) : falseValue(self)
        
    }
    
}
