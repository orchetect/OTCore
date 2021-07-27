//
//  XCTWait.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS) && canImport(XCTest)

import XCTest

extension XCTestCase {
    
    /// **OTCore:**
    /// Simple XCTest wait timer that does not block the runloop
    /// - Parameter timeout: floating-point duration in seconds
    @available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public func XCTWait(sec timeout: Double) {
        
        var inTime = timespec()
        _ = clock_gettime(CLOCK_MONOTONIC_RAW, &inTime)
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        
        var adjustTime = timespec()
        _ = clock_gettime(CLOCK_MONOTONIC_RAW, &adjustTime)
        
        let newTimeout =
            timeout
            - (adjustTime.doubleValue - inTime.doubleValue)
            - 0.0015
        
        wait(for: [delayExpectation], timeout: newTimeout)
        
    }
    
}

#endif
