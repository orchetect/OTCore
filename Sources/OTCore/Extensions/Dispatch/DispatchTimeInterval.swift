//
//  DispatchTimeInterval.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Dispatch)

import Dispatch

extension DispatchTimeInterval {
    
    /// **OTCore:**
    /// Return the interval as `Int` seconds.
    @_disfavoredOverload
    public var microseconds: Int {
        
        switch self {
        case .seconds(let val):
            return val * 1_000_000
            
        case .milliseconds(let val): // ms
            return val * 1_000
            
        case .microseconds(let val): // µs
            return val
            
        case .nanoseconds(let val): // ns
            return val / 1_000
            
        case .never:
            assertionFailure("Cannot convert 'never' to microseconds.")
            return 0
            
        @unknown default:
            assertionFailure("Unhandled DispatchTimeInterval case when attempting to convert to microseconds.")
            return 0
            
        }
        
    }
    
}

/// **OTCore:**
/// Convenience to convert a `DispatchTimeInterval` to microseconds and run `usleep()`.
@_disfavoredOverload
public func sleep(_ dispatchTimeInterval: DispatchTimeInterval) {
    
    let ms = dispatchTimeInterval.microseconds
    guard ms > 0 else { return }
    usleep(UInt32(ms))
    
}

#endif
