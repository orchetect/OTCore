//
//  Darwin and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// Convenience to convert a `TimeInterval` to microseconds and run `usleep()`.
@_disfavoredOverload
public func sleep(_ timeInterval: TimeInterval) {
    
    let ms = timeInterval * 1_000_000
    guard ms > 0.0 else { return }
    usleep(UInt32(ms))
    
}

#endif
