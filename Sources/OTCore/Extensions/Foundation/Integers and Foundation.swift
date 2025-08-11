//
//  Integers and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - String Formatting

extension BinaryInteger {
    /// **OTCore:**
    /// Convenience method to return a String, padded to `paddedTo` number of leading zeros.
    @inlinable @_disfavoredOverload
    public func string(paddedTo: Int) -> String {
        if let cVarArg = self as? CVarArg {
            return String(format: "%0\(paddedTo)d", cVarArg)
        } else {
            // Typically this will never happen,
            // but BinaryInteger does not implicitly conform to CVarArg,
            // and we can't assume all concrete types that conform
            // to BinaryInteger CVarArg now or in the future.
            // Just return a string as-is as a failsafe:
            return String(describing: self)
        }
    }
}

#endif
