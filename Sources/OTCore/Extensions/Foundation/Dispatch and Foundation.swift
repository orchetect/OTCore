//
//  Dispatch and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation // imports Dispatch

// MARK: - QualityOfService / QoSClass

extension QualityOfService {
    
    /// Returns the Dispatch framework `DispatchQoS.QoSClass` equivalent.
    @_disfavoredOverload
    public var dispatchQoSClass: DispatchQoS.QoSClass {
        
        switch self {
        case .userInteractive:
            return .userInteractive
            
        case .userInitiated:
            return .userInitiated
            
        case .utility:
            return .utility
            
        case .background:
            return .background
            
        case .default:
            return .default
            
        @unknown default:
            return .default
        }
        
    }
    
}

extension DispatchQoS.QoSClass {
    
    /// Returns the Foundation framework `QualityOfService` equivalent.
    @_disfavoredOverload
    public var qualityOfService: QualityOfService {
        
        switch self {
        case .userInteractive:
            return .userInteractive
            
        case .userInitiated:
            return .userInitiated
            
        case .utility:
            return .utility
            
        case .background:
            return .background
            
        case .default:
            return .default
            
        case .unspecified:
            return .default
            
        @unknown default:
            return .default
        }
        
    }
    
}

// MARK: - DispatchTimeInterval

extension DispatchTimeInterval {
    
    /// **OTCore:**
    /// Return the interval as a `TimeInterval` (floating-point seconds).
    @_disfavoredOverload
    public var timeInterval: TimeInterval? {
        
        switch self {
        case .seconds(let val):
            return TimeInterval(val)
            
        case .milliseconds(let val): // ms
            return TimeInterval(val) / 1_000
            
        case .microseconds(let val): // µs
            return TimeInterval(val) / 1_000_000
            
        case .nanoseconds(let val): // ns
            return TimeInterval(val) / 1_000_000_000
            
        case .never:
            //assertionFailure("Cannot convert 'never' to TimeInterval.")
            return nil
            
        @unknown default:
            assertionFailure("Unhandled DispatchTimeInterval case when attempting to convert to TimeInterval.")
            return nil
            
        }
        
    }
    
}

#endif
