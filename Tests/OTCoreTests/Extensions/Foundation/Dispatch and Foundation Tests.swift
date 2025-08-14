//
//  Dispatch and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_DispatchAndFoundation_Tests {
    // MARK: - DispatchTimeInterval
    
    @Test
    func dispatchTimeInterval_timeInterval() {
        #expect(DispatchTimeInterval.seconds(2).timeInterval == 2.0)
        
        #expect(DispatchTimeInterval.milliseconds(250).timeInterval == 0.250)
        
        #expect(DispatchTimeInterval.microseconds(250).timeInterval == 0.000_250)
        
        #expect(DispatchTimeInterval.nanoseconds(250).timeInterval == 0.000_000_250)
        
        #expect(DispatchTimeInterval.never.timeInterval == nil)
    }
}

#endif
