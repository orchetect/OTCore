//
//  TimeInterval.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension TimeInterval {
    // TODO: should remove this since TimeInterval is an alias for Double and this init may be ambiguous.
    /// **OTCore:**
    /// Convenience constructor from `timespec`.
    @inlinable @_disfavoredOverload
    public init(_ time: timespec) {
        self = time.doubleValue
    }
}

#endif
