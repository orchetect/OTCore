//
//  String and NSRegularExpression Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

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
    
    func testRegExPattern_ExtendedCharacters() {
        let regPattern = "[0-9]+"
        
        let str = "Thé 45 smiling 😀 túrkêÿs åte →●₩√【】♞‱ 9 Şandwiches."
        
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
    
    func testRegExPatternReplacement_ExtendedCharacters() {
        let regPattern = "[0-9]+"
        
        let str = "Thé 45 smiling 😀 túrkêÿs åte →●₩√【】♞‱ 9 Şandwiches."
        
        XCTAssertEqual(
            str.regexMatches(
                pattern: regPattern,
                replacementTemplate: "$0-some"
            ),
            "Thé 45-some smiling 😀 túrkêÿs åte →●₩√【】♞‱ 9-some Şandwiches."
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
                Optional(Substring(str)),
                Optional("The"),
                Optional("45"),
                Optional("turkeys ate"),
                Optional("9"),
                Optional("sandwiches.")
            ]
        )
    }
    
    func testRegExCaptureGroups_ExtendedCharacters() {
        let capturePattern = #"^([^\.]*)\.([^\.]*)\.([\d]+)$"#
        
        let str = "Hellõ țhiș is ǎ têst.Śtřįng 😀→●₩√【】♞‱.1234"
        
        XCTAssertEqual(
            str.regexMatches(captureGroupsFromPattern: capturePattern),
            [
                Optional(Substring(str)),
                Optional("Hellõ țhiș is ǎ têst"),
                Optional("Śtřįng 😀→●₩√【】♞‱"),
                Optional("1234")
            ]
        )
    }
}
