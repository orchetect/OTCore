//
//  TimeInterval Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_TimeInterval_Tests {
    @Test
    func timeInterval_init_Timespec() {
        let ti = TimeInterval(timespec(tv_sec: 1, tv_nsec: 234_567_891))
        
        #expect(ti == TimeInterval(1.234_567_891))
    }
}

#endif
