//
//  TimeInterval Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
@testable import OTCore

class Extensions_Foundation_TimeInterval_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testTimeInterval_init_Timespec() {
        let ti = TimeInterval(timespec(tv_sec: 1, tv_nsec: 234_567_891))
        
        XCTAssertEqual(ti, TimeInterval(1.234_567_891))
    }
}
