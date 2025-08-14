//
//  DispatchTimeInterval Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Dispatch)

import Dispatch
@testable import OTCore
import Testing

@Suite struct Extensions_Dispatch_DispatchTimeInterval_Tests {
    @Test
    func dispatchTimeInterval_Microseconds() {
        #expect(
            DispatchTimeInterval.seconds(2).microseconds
                == 2_000_000
        )
        
        #expect(
            DispatchTimeInterval.milliseconds(2000).microseconds
                == 2_000_000
        )
        
        #expect(
            DispatchTimeInterval.microseconds(2_000_000).microseconds
                == 2_000_000
        )
        
        #expect(
            DispatchTimeInterval.nanoseconds(2_000_000_000).microseconds
                == 2_000_000
        )
        
        // assertion error:
        // #expect(
        //     DispatchTimeInterval.never.microseconds
        //     == 0
        // )
    }
}

#endif
