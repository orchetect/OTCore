//
//  Dispatch and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_DispatchAndFoundation_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - DispatchTimeInterval
    
    func testDispatchTimeInterval_timeInterval() {
        XCTAssertEqual(DispatchTimeInterval.seconds(2).timeInterval, 2.0)
        
        XCTAssertEqual(DispatchTimeInterval.milliseconds(250).timeInterval, 0.250)
        
        XCTAssertEqual(DispatchTimeInterval.microseconds(250).timeInterval, 0.000_250)
        
        XCTAssertEqual(DispatchTimeInterval.nanoseconds(250).timeInterval, 0.000_000_250)
        
        XCTAssertNil(DispatchTimeInterval.never.timeInterval)
    }
}

#endif
