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
    
    /// Ensure that using a Substring as the input string works as expected.
    func testRegExPattern_InSubString() {
        let regPattern = "^([0-9]+)X([0-9]+)$"
        
        let str: String = " 123X456 "
        let subStr: Substring = str[
            str.index(str.startIndex, offsetBy: 1) ..< str.index(str.startIndex, offsetBy: 8)
        ]
        
        XCTAssertEqual(
            subStr.regexMatches(pattern: regPattern),
            ["123X456"]
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
    
    /// Ensure that using a Substring as the input string works as expected.
    func testRegExPatternReplacement_InSubString() {
        let regPattern = "^([0-9]+)X([0-9]+)$"
        
        let str: String = " 123X456 "
        let subStr: Substring = str[
            str.index(str.startIndex, offsetBy: 1) ..< str.index(str.startIndex, offsetBy: 8)
        ]
        
        XCTAssertEqual(
            subStr.regexMatches(
                pattern: regPattern, 
                replacementTemplate: "A$1B$2C"
            ),
            "A123B456C"
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
    
    /// Ensure that using a Substring as the input string works as expected.
    func testRegExCaptureGroups_InSubString() {
        let regPattern = "^([0-9]+)X([0-9]+)$"
        
        let str: String = " 123X456 "
        let subStr: Substring = str[
            str.index(str.startIndex, offsetBy: 1) ..< str.index(str.startIndex, offsetBy: 8)
        ]
        
        XCTAssertEqual(
            subStr.regexMatches(captureGroupsFromPattern: regPattern),
            ["123X456", "123", "456"]
        )
    }
}
