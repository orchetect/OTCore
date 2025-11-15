//
//  Integers and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
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

// MARK: - Duration

#if !(arch(arm) || arch(arm64_32) || arch(i386))

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    /// **OTCore:**
    /// Returns the duration as a floating-point time interval in seconds.
    /// Note that this may be lossy and result in the loss of some precision.
    @_disfavoredOverload
    public var timeInterval: TimeInterval {
        let (seconds, attoseconds) = components
        let interval = Double(seconds) + ((Double(attoseconds) / 1_000_000_000_000_000_000.0))
        return interval
    }
}

#endif

#endif
