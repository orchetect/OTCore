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
    /// Convenience constructor from `TimeInterval`.
    ///
    /// > Note:
    /// > As of macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, Swift adds a new `Duration` type allowing this
    /// > functionality to be used natively.
    /// >
    /// > For example:
    /// >
    /// > ```swift
    /// > timespec(.seconds(1.5))
    /// > timespec(.milliseconds(1500))
    /// > timespec(.microseconds(1_500_000))
    /// > timespec(.nanoseconds(1_500_000_000))
    /// > ```
    @inlinable @_disfavoredOverload
    public init(_ interval: TimeInterval) {
        self.init(seconds: interval)
    }
}

// MARK: - Timespec properties

extension timespec {
    /// **OTCore:**
    /// Returns a `TimeInterval`.
    @inlinable @_disfavoredOverload
    public var doubleValue: TimeInterval { // TODO: rename to `timeInterval` or `toTimeInterval()`
        Double(tv_sec) + (Double(tv_nsec) / 1_000_000_000)
    }
}

#endif
