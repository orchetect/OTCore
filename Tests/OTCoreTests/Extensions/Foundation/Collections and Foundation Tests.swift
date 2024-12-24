//
//  Collections and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
@testable import OTCore

final class Extensions_Foundation_Collections_Tests: XCTestCase {
    func testComparisonResultInverted() {
        XCTAssertEqual(ComparisonResult.orderedAscending.inverted, .orderedDescending)
        XCTAssertEqual(ComparisonResult.orderedSame.inverted, .orderedSame)
        XCTAssertEqual(ComparisonResult.orderedDescending.inverted, .orderedAscending)
    }
}
