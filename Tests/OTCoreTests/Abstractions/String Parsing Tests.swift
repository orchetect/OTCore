//
//  String Parsing Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Abstractions_StringParsing_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testIsValidEmailAddress() {
        // see isValidEmailAddress method comments for email address formatting details
        
        XCTAssertFalse("".isValidEmailAddress)
        XCTAssertFalse("@".isValidEmailAddress)
        XCTAssertFalse("@.".isValidEmailAddress)
        XCTAssertFalse(".@.".isValidEmailAddress)
        XCTAssertFalse("a@b.c".isValidEmailAddress)
        
        XCTAssertFalse(".user@domain.com".isValidEmailAddress)
        XCTAssertTrue("-user@domain.com".isValidEmailAddress) // ?
        XCTAssertTrue("+user@domain.com".isValidEmailAddress) // ?
        
        XCTAssertFalse("user.@domain.com".isValidEmailAddress)
        XCTAssertTrue("user-@domain.com".isValidEmailAddress) // ?
        XCTAssertTrue("user+@domain.com".isValidEmailAddress) // ?
        
        // prefix: can't start or end with period
        XCTAssertFalse(".a@domain.com".isValidEmailAddress)
        XCTAssertFalse("a.@domain.com".isValidEmailAddress)
        XCTAssertTrue("a-@domain.com".isValidEmailAddress) // ?
        XCTAssertTrue("a+@domain.com".isValidEmailAddress) // ?
        
        XCTAssertTrue("a@b.ca".isValidEmailAddress)
        XCTAssertTrue("aa@b.ca".isValidEmailAddress)
        XCTAssertTrue("a@bb.ca".isValidEmailAddress)
        XCTAssertTrue("aa@bb.ca".isValidEmailAddress)
        
        XCTAssertTrue("user@domain.com".isValidEmailAddress)
        XCTAssertTrue("user@subdomain.domain.com".isValidEmailAddress)
        
        XCTAssertTrue("first.last@domain.com".isValidEmailAddress)
        XCTAssertTrue("first.last@subdomain.domain.com".isValidEmailAddress)
        
        // prefix: can't contain two or more consecutive periods
        XCTAssertFalse("first..last@domain.com".isValidEmailAddress)
        
        XCTAssertTrue("first+last@domain.com".isValidEmailAddress)
        XCTAssertTrue("first+last@subdomain.domain.com".isValidEmailAddress)
        
        XCTAssertTrue("first-last@domain.com".isValidEmailAddress)
        XCTAssertTrue("first-last@subdomain.domain.com".isValidEmailAddress)
        
        XCTAssertTrue("user@some-domain.com".isValidEmailAddress)
        XCTAssertTrue("user@subdomain.some-domain.com".isValidEmailAddress)
        
        // domain: can't start or end with hyphen
        XCTAssertFalse("user@-somedomain.com".isValidEmailAddress)
        XCTAssertFalse("user@somedomain-.com".isValidEmailAddress)
        
        XCTAssertTrue("user@123456.com".isValidEmailAddress)
        
        // domain: 70 chars, too many
        XCTAssertFalse(
            "user@1234567890123456789012345678901234567890123456789012345678901234567890.com"
                .isValidEmailAddress
        )
        
        // domain: 63 chars max, is valid
        XCTAssertTrue(
            "user@890123456789012345678901234567890123456789012345678901234567890.com"
                .isValidEmailAddress
        )
        
        // TLD: can't be all numbers
        XCTAssertFalse("user@domain.123".isValidEmailAddress)
        
        // TLD: only latin alphabet
        XCTAssertFalse("user@domain.c-m".isValidEmailAddress)
        
        // hostname: must not exceed 255 characters
        // 256 characters
        XCTAssertFalse(
            "user@1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.com"
                .isValidEmailAddress
        )
        
        // hostname: must not exceed 255 characters
        // 255 characters
        XCTAssertTrue(
            "user@1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.123456789.com"
                .isValidEmailAddress
        )
    }
}

#endif
