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
        
        let startTime = clock_gettime_monotonic_raw()
        
        XCTWait(sec: 0.5)
        
        let endTime = clock_gettime_monotonic_raw()
        
        let diffTime = (endTime - startTime).doubleValue
        
        // test if wait duration was within reasonable margin of error +/-
        
        XCTAssert(diffTime.isContained(in: 0.499...0.510))
        
    }
    
}

#endif
