//
//  Collections and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

@testable import OTCore
import XCTest

final class Extensions_Foundation_Collections_Tests: XCTestCase {
    func testComparisonResultInverted() {
        XCTAssertEqual(ComparisonResult.orderedAscending.inverted, .orderedDescending)
        XCTAssertEqual(ComparisonResult.orderedSame.inverted, .orderedSame)
        XCTAssertEqual(ComparisonResult.orderedDescending.inverted, .orderedAscending)
    }
}
