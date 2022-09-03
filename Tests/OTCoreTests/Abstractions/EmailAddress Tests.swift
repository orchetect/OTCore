//
//  EmailAddress Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Abstractions_EmailAddress_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testIsValid() {
        // see isValidEmailAddress method comments for email address formatting details
        
        XCTAssertFalse(EmailAddress("").isValid)
        XCTAssertFalse(EmailAddress("@").isValid)
        XCTAssertFalse(EmailAddress("@.").isValid)
        XCTAssertFalse(EmailAddress(".@.").isValid)
        XCTAssertFalse(EmailAddress("a@b.c").isValid)
        
        XCTAssertFalse(EmailAddress(".user@domain.com").isValid)
        XCTAssertTrue(EmailAddress("-user@domain.com").isValid) // ?
        XCTAssertTrue(EmailAddress("+user@domain.com").isValid) // ?
        
        XCTAssertFalse(EmailAddress("user.@domain.com").isValid)
        XCTAssertTrue(EmailAddress("user-@domain.com").isValid) // ?
        XCTAssertTrue(EmailAddress("user+@domain.com").isValid) // ?
        
        // prefix: can't start or end with period
        XCTAssertFalse(EmailAddress(".a@domain.com").isValid)
        XCTAssertFalse(EmailAddress("a.@domain.com").isValid)
        XCTAssertTrue(EmailAddress("a-@domain.com").isValid) // ?
        XCTAssertTrue(EmailAddress("a+@domain.com").isValid) // ?
        
        XCTAssertTrue(EmailAddress("a@b.ca").isValid)
        XCTAssertTrue(EmailAddress("aa@b.ca").isValid)
        XCTAssertTrue(EmailAddress("a@bb.ca").isValid)
        XCTAssertTrue(EmailAddress("aa@bb.ca").isValid)
        
        XCTAssertTrue(EmailAddress("user@domain.com").isValid)
        XCTAssertTrue(EmailAddress("user@subdomain.domain.com").isValid)
        
        XCTAssertTrue(EmailAddress("first.last@domain.com").isValid)
        XCTAssertTrue(EmailAddress("first.last@subdomain.domain.com").isValid)
        
        // prefix: can't contain two or more consecutive periods
        XCTAssertFalse(EmailAddress("first..last@domain.com").isValid)
        
        XCTAssertTrue(EmailAddress("first+last@domain.com").isValid)
        XCTAssertTrue(EmailAddress("first+last@subdomain.domain.com").isValid)
        
        XCTAssertTrue(EmailAddress("first-last@domain.com").isValid)
        XCTAssertTrue(EmailAddress("first-last@subdomain.domain.com").isValid)
        
        XCTAssertTrue(EmailAddress("user@some-domain.com").isValid)
        XCTAssertTrue(EmailAddress("user@subdomain.some-domain.com").isValid)
        
        // domain: can't start or end with hyphen
        XCTAssertFalse(EmailAddress("user@-somedomain.com").isValid)
        XCTAssertFalse(EmailAddress("user@somedomain-.com").isValid)
        
        XCTAssertTrue(EmailAddress("user@123456.com").isValid)
        
        // domain: 70 chars, too many
        XCTAssertFalse(
            EmailAddress(
                "user@1234567890123456789012345678901234567890123456789012345678901234567890.com"
            )
            .isValid
        )
        
        // domain: 63 chars max, is valid
        XCTAssertTrue(
            EmailAddress("user@890123456789012345678901234567890123456789012345678901234567890.com")
                .isValid
        )
        
        // TLD: can't be all numbers
        XCTAssertFalse(EmailAddress("user@domain.123").isValid)
        
        // TLD: only latin alphabet
        XCTAssertFalse(EmailAddress("user@domain.c-m").isValid)
        
        // hostname: must not exceed 255 characters
        // 256 characters
        XCTAssertFalse(
            EmailAddress(
                "user@1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.com"
            )
            .isValid
        )
        
        // hostname: must not exceed 255 characters
        // 255 characters
        XCTAssertTrue(
            EmailAddress(
                "user@1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.123456789.com"
            ).isValid
        )
    }
}

#endif
