//
//  File.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation // imports Dispatch

extension QualityOfService {
    /// Returns the Dispatch framework `DispatchQoS.QoSClass` equivalent.
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

#endif
