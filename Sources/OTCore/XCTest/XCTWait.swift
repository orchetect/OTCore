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
    public func XCTWait(sec timeout: Double) {
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: timeout)
        
    }
    
}

#endif
