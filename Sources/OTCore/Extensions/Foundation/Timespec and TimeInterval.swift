//
//  Timespec and TimeInterval.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Timespec constructors

extension timespec {
    /// **OTCore:**
    /// Convenience constructor from `TimeInterval`
    @inlinable @_disfavoredOverload
    public init(_ interval: TimeInterval) {
        self.init(seconds: interval)
    }
}

// MARK: - Timespec properties

extension timespec {
    /// **OTCore:**
    /// Return a `TimeInterval`
    @inlinable @_disfavoredOverload
    public var doubleValue: TimeInterval {
        Double(tv_sec) + (Double(tv_nsec) / 1_000_000_000)
    }
}

#endif
