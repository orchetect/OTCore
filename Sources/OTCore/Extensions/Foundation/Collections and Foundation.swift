//
//  Collections and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Comparison

extension ComparisonResult {
    /// **OTCore:**
    /// Returns the inverted comparison result.
    @inlinable @_disfavoredOverload
    public var inverted: Self {
        switch self {
        case .orderedAscending: .orderedDescending
        case .orderedSame: .orderedSame
        case .orderedDescending: .orderedAscending
        }
    }
}

#endif
