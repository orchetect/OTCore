//
//  TimeInterval.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension TimeInterval {
    /// **OTCore:**
    /// Convenience constructor from `timespec`
    @inlinable @_disfavoredOverload
    public init(_ time: timespec) {
        self = time.doubleValue
    }
}

#endif
