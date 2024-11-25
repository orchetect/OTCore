//
//  DispatchTimeInterval Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
@testable import OTCore

class Extensions_Dispatch_DispatchTimeInterval_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testMicroseconds() {
        XCTAssertEqual(
            DispatchTimeInterval.seconds(2).microseconds,
            2_000_000
        )
        
        XCTAssertEqual(
            DispatchTimeInterval.milliseconds(2000).microseconds,
            2_000_000
        )
        
        XCTAssertEqual(
            DispatchTimeInterval.microseconds(2_000_000).microseconds,
            2_000_000
        )
        
        XCTAssertEqual(
            DispatchTimeInterval.nanoseconds(2_000_000_000).microseconds,
            2_000_000
        )
        
        // assertion error:
        // XCTAssertEqual(
        //    DispatchTimeInterval.never.microseconds,
        //    0
        // )
    }
}
