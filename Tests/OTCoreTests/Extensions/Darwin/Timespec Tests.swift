//
//  Timespec Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Darwin_Timespec_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func test_clock_gettime_monotonic_raw() {
        
        let uptime = clock_gettime_monotonic_raw()
        
        XCTAssert(uptime.tv_sec > 0)
        XCTAssert(uptime.tv_nsec > 0)
        
    }
    
    func testTimespec_inits() {
        
        // (seconds:)
        
        let ts = timespec(seconds: 1.234_567_891)
        
        XCTAssertEqual(ts.tv_sec, 1)
        XCTAssertEqual(ts.tv_nsec, 234_567_891)
        
    }
    
    func testTimespecOperators() {
        
        // assuming all tv_sec and tv_nsec values are positive integers when forming original timespec()'s
        
        // + basic
        
        XCTAssertEqual(timespec(tv_sec: 10, tv_nsec: 500) +
                        timespec(tv_sec: 50, tv_nsec: 1000),
                       timespec(tv_sec: 60, tv_nsec: 1500))
        
        // + rollover
        
        XCTAssertEqual(timespec(tv_sec: 10, tv_nsec: 900_000_000) +
                        timespec(tv_sec: 50, tv_nsec: 200_000_000),
                       timespec(tv_sec: 61, tv_nsec: 100_000_000))
        
        // + edge case
        
        XCTAssertEqual(timespec(tv_sec: 10, tv_nsec: 900_000_000) +
                        timespec(tv_sec: 50, tv_nsec: 1_200_000_000),
                       timespec(tv_sec: 62, tv_nsec: 100_000_000))
        
        // - basic
        
        XCTAssertEqual(timespec(tv_sec: 50, tv_nsec: 1000) -
                        timespec(tv_sec: 10, tv_nsec: 500),
                       timespec(tv_sec: 40, tv_nsec: 500))
        
        // - rollover
        
        XCTAssertEqual(timespec(tv_sec: 50, tv_nsec: 100_000_000) -
                        timespec(tv_sec: 10, tv_nsec: 600_000_000),
                       timespec(tv_sec: 39, tv_nsec: 500_000_000))
        
        // - edge cases
        
        XCTAssertEqual(timespec(tv_sec: 50, tv_nsec: 1_000_001_000) -
                        timespec(tv_sec: 10, tv_nsec: 500),
                       timespec(tv_sec: 41, tv_nsec: 500))
        
        XCTAssertEqual(timespec(tv_sec: 50, tv_nsec: 100_000_000) -
                        timespec(tv_sec: 10, tv_nsec: 1_600_000_000),
                       timespec(tv_sec: 38, tv_nsec: 500_000_000))
        
    }
    
    func testTimespecOperators_Boundaries() {
        
        // - boundaries
        
        for x in Array(0...10) + Array(999_999_990...999_999_999) {
            
            XCTAssertEqual(timespec(tv_sec: 0, tv_nsec: x) -
                            timespec(tv_sec: 0, tv_nsec: 0),
                           timespec(tv_sec: 0, tv_nsec: x))
            
        }
        
        for x in Array(1...10) + Array(999_999_990...999_999_999) {
            
            XCTAssertEqual(timespec(tv_sec: 1, tv_nsec: 0) -
                            timespec(tv_sec: 0, tv_nsec: x),
                           timespec(tv_sec: 0, tv_nsec: 1_000_000_000 - x))
            
        }
        
    }
    
    func testTimespecEquatable() {
        
        // basic
        
        XCTAssertTrue(timespec(tv_sec: 10, tv_nsec: 500) ==
                        timespec(tv_sec: 10, tv_nsec: 500))
        
        XCTAssertFalse(timespec(tv_sec: 10, tv_nsec: 500) ==
                        timespec(tv_sec: 10, tv_nsec: 501))
        
        // edge cases
        
        // technically this this is equal, but Equatable internally tests discrete values and not existential equality -- which, for the time being, is intended functionality since in practise, timespec should never be formed with overflowing values
        XCTAssertFalse(timespec(tv_sec: 10, tv_nsec: 1_000_000_500) ==
                        timespec(tv_sec: 11, tv_nsec: 500))
        
    }
    
    func testTimespecComparable() {
        
        // basic - identical values
        
        XCTAssertFalse(timespec(tv_sec: 10, tv_nsec: 500) >
                        timespec(tv_sec: 10, tv_nsec: 500))
        
        XCTAssertFalse(timespec(tv_sec: 10, tv_nsec: 500) <
                        timespec(tv_sec: 10, tv_nsec: 500))
        
        // basic - typical values
        
        XCTAssertTrue(timespec(tv_sec: 10, tv_nsec: 500) <
                        timespec(tv_sec: 10, tv_nsec: 501))
        
        XCTAssertTrue(timespec(tv_sec: 10, tv_nsec: 501) >
                        timespec(tv_sec: 10, tv_nsec: 500))
        
        // edge cases
        
        XCTAssertTrue(timespec(tv_sec: 20, tv_nsec: 500) >
                        timespec(tv_sec: 10, tv_nsec: 1000))
        
    }
    
}

#endif
