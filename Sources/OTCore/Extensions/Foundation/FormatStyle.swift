//
//  FormatStyle.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension FormatStyle where Self == IntegerFormatStyle<Int> {
    /// Plain integer format style.
    ///
    /// Integer with no decimal places, without grouping (thousands separators), and without sign.
    ///
    /// Suitable for technical integer input, including network port numbers.
    @_disfavoredOverload
    public static var plainInteger: IntegerFormatStyle<Int> {
        IntegerFormatStyle<Int>()
            .precision(.fractionLength(0))
            .grouping(.never)
            .sign(strategy: .never)
    }
}

#endif
