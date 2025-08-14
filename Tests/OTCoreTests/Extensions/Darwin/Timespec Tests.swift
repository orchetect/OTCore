//
//  Timespec Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)

import Darwin
@testable import OTCore
import Testing

@Suite struct Extensions_Darwin_Timespec_Tests {
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    @Test
    func clock_gettime_monotonic_rawTest() {
        let uptime = clock_gettime_monotonic_raw()
        
        #expect(uptime.tv_sec > 0)
        #expect(uptime.tv_nsec > 0)
    }
    
    @Test
    func timespec_inits() {
        // (seconds:)
        
        let ts = timespec(seconds: 1.234_567_891)
        
        #expect(ts.tv_sec == 1)
        #expect(ts.tv_nsec == 234_567_891)
    }
    
    @Test
    func timespecOperators() {
        // assuming all tv_sec and tv_nsec values are positive integers when forming original
        // timespec()'s
        
        // + basic
        
        #expect(
            timespec(tv_sec: 10, tv_nsec: 500) +
                timespec(tv_sec: 50, tv_nsec: 1000)
                == timespec(tv_sec: 60, tv_nsec: 1500)
        )
        
        // + rollover
        
        #expect(
            timespec(tv_sec: 10, tv_nsec: 900_000_000) +
                timespec(tv_sec: 50, tv_nsec: 200_000_000)
                == timespec(tv_sec: 61, tv_nsec: 100_000_000)
        )
        
        // + edge case
        
        #expect(
            timespec(tv_sec: 10, tv_nsec: 900_000_000) +
                timespec(tv_sec: 50, tv_nsec: 1_200_000_000)
                == timespec(tv_sec: 62, tv_nsec: 100_000_000)
        )
        
        // - basic
        
        #expect(
            timespec(tv_sec: 50, tv_nsec: 1000) -
                timespec(tv_sec: 10, tv_nsec: 500)
                == timespec(tv_sec: 40, tv_nsec: 500)
        )
        
        // - rollover
        
        #expect(
            timespec(tv_sec: 50, tv_nsec: 100_000_000) -
                timespec(tv_sec: 10, tv_nsec: 600_000_000)
                == timespec(tv_sec: 39, tv_nsec: 500_000_000)
        )
        
        // - edge cases
        
        #expect(
            timespec(tv_sec: 50, tv_nsec: 1_000_001_000) -
                timespec(tv_sec: 10, tv_nsec: 500)
                == timespec(tv_sec: 41, tv_nsec: 500)
        )
        
        #expect(
            timespec(tv_sec: 50, tv_nsec: 100_000_000) -
                timespec(tv_sec: 10, tv_nsec: 1_600_000_000)
                == timespec(tv_sec: 38, tv_nsec: 500_000_000)
        )
    }
    
    @Test
    func timespecOperators_Boundaries() {
        // - boundaries
        
        for x in Array(0 ... 10) + Array(999_999_990 ... 999_999_999) {
            #expect(
                timespec(tv_sec: 0, tv_nsec: x) -
                    timespec(tv_sec: 0, tv_nsec: 0)
                    == timespec(tv_sec: 0, tv_nsec: x)
            )
        }
        
        for x in Array(1 ... 10) + Array(999_999_990 ... 999_999_999) {
            #expect(
                timespec(tv_sec: 1, tv_nsec: 0) -
                    timespec(tv_sec: 0, tv_nsec: x)
                    == timespec(tv_sec: 0, tv_nsec: 1_000_000_000 - x)
            )
        }
    }
    
    @Test
    func timespecEquatable() {
        // basic
        
        #expect(
            timespec(tv_sec: 10, tv_nsec: 500) ==
                timespec(tv_sec: 10, tv_nsec: 500)
        )
        
        #expect(!(
            timespec(tv_sec: 10, tv_nsec: 500) ==
                timespec(tv_sec: 10, tv_nsec: 501)
        ))
        
        // edge cases
        
        // technically this this is equal, but Equatable internally tests discrete values and not
        // existential equality -- which, for the time being, is intended functionality since in
        // practise, timespec should never be formed with overflowing values
        #expect(!(
            timespec(tv_sec: 10, tv_nsec: 1_000_000_500) ==
                timespec(tv_sec: 11, tv_nsec: 500)
        ))
    }
    
    @Test
    func timespecComparable() {
        // basic - identical values
        
        #expect(!(
            timespec(tv_sec: 10, tv_nsec: 500) >
                timespec(tv_sec: 10, tv_nsec: 500)
        ))
        
        #expect(!(
            timespec(tv_sec: 10, tv_nsec: 500) <
                timespec(tv_sec: 10, tv_nsec: 500)
        ))
        
        // basic - typical values
        
        #expect(
            timespec(tv_sec: 10, tv_nsec: 500) <
                timespec(tv_sec: 10, tv_nsec: 501)
        )
        
        #expect(
            timespec(tv_sec: 10, tv_nsec: 501) >
                timespec(tv_sec: 10, tv_nsec: 500)
        )
        
        // edge cases
        
        #expect(
            timespec(tv_sec: 20, tv_nsec: 500) >
                timespec(tv_sec: 10, tv_nsec: 1000)
        )
    }
}

#endif
