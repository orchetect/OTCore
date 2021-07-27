//
//  XCTWait Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class XCTest_XCTWait_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    @available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func testXCTWait() {
        
        let duration = 0.5
        
        let startTime = clock_gettime_monotonic_raw()
        
        XCTWait(sec: duration)
        
        let endTime = clock_gettime_monotonic_raw()
        
        let diffTime = (endTime - startTime).doubleValue
        
        // test if wait duration was within reasonable margin of error +/-
        
        let margin = 0.499...0.505
        
        // this unit test is flakey because it depends on the performance of the hardware it is run on so we need to give it more leeway
        
        // check for complete out-of-spec failure first
        XCTAssertGreaterThan(diffTime, 0.499)
        XCTAssertLessThan(diffTime, 0.550)
        
        // allow for
        if !diffTime.isContained(in: margin) {
            Log.error("Tested XCTWait duration of \(duration)sec, with an accuracy margin of \(margin.lowerBound)...\(margin.upperBound) but measured time was \(diffTime)sec.")
        }
        
    }
    
}

#endif
