//
//  String and NSRegularExpression Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_StringAndNSRegularExpression_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testRegExPattern() {
        let regPattern = "[0-9]+"
        
        let str = "The 45 turkeys ate 9 sandwiches."
        
        XCTAssertEqual(
            str.regexMatches(pattern: regPattern),
            ["45", "9"]
        )
    }
    
    func testRegExPatternReplacement() {
        let regPattern = "[0-9]+"
        
        let str = "The 45 turkeys ate 9 sandwiches."
        
        XCTAssertEqual(
            str.regexMatches(
                pattern: regPattern,
                replacementTemplate: "$0-some"
            ),
            "The 45-some turkeys ate 9-some sandwiches."
        )
    }
    
    func testRegExCaptureGroups() {
        let capturePattern = #"""
        ([a-zA-z\s]*)\s([0-9]+)\s([a-zA-z\s]*)\s([0-9]+)\s([a-zA-z\s.]*)
        """#
        
        let str = "The 45 turkeys ate 9 sandwiches."
        
        XCTAssertEqual(
            str.regexMatches(captureGroupsFromPattern: capturePattern),
            [
                Optional("The 45 turkeys ate 9 sandwiches."),
                Optional("The"),
                Optional("45"),
                Optional("turkeys ate"),
                Optional("9"),
                Optional("sandwiches.")
            ]
        )
    }
}

#endif
