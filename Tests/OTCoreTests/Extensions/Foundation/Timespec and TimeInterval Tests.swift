//
//  Timespec and TimeInterval Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_TimespecAndTimeInterval_Tests {
    @Test
    func timespec_inits() {
        // timespec(_ interval:)
        
        let ts = timespec(TimeInterval(2.987_654_321))
        #expect(ts.tv_sec == 2)
        #expect(ts.tv_nsec == 987_654_321)
    }
    
    @Test
    func timespec_doubleValue() {
        // timespec.doubleValue
        
        var ts = timespec(tv_sec: 1, tv_nsec: 234_567_891)
        #expect(ts.doubleValue == 1.234_567_891)
        
        ts = timespec(tv_sec: 2, tv_nsec: 987_654_321)
        #expect(ts.doubleValue == 2.987_654_321)
    }
}

#endif
