//
//  EmailAddress Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Abstractions_EmailAddress_Tests {
    @Test
    func isValid() {
        // see isValidEmailAddress method comments for email address formatting details
        
        #expect(!EmailAddress("").isValid)
        #expect(!EmailAddress("@").isValid)
        #expect(!EmailAddress("@.").isValid)
        #expect(!EmailAddress(".@.").isValid)
        #expect(!EmailAddress("a@b.c").isValid)
        
        #expect(!EmailAddress(".user@domain.com").isValid)
        #expect(EmailAddress("-user@domain.com").isValid) // ?
        #expect(EmailAddress("+user@domain.com").isValid) // ?
        
        #expect(!EmailAddress("user.@domain.com").isValid)
        #expect(EmailAddress("user-@domain.com").isValid) // ?
        #expect(EmailAddress("user+@domain.com").isValid) // ?
        
        // prefix: can't start or end with period
        #expect(!EmailAddress(".a@domain.com").isValid)
        #expect(!EmailAddress("a.@domain.com").isValid)
        #expect(EmailAddress("a-@domain.com").isValid) // ?
        #expect(EmailAddress("a+@domain.com").isValid) // ?
        
        #expect(EmailAddress("a@b.ca").isValid)
        #expect(EmailAddress("aa@b.ca").isValid)
        #expect(EmailAddress("a@bb.ca").isValid)
        #expect(EmailAddress("aa@bb.ca").isValid)
        
        #expect(EmailAddress("user@domain.com").isValid)
        #expect(EmailAddress("user@subdomain.domain.com").isValid)
        
        #expect(EmailAddress("first.last@domain.com").isValid)
        #expect(EmailAddress("first.last@subdomain.domain.com").isValid)
        
        // prefix: can't contain two or more consecutive periods
        #expect(!EmailAddress("first..last@domain.com").isValid)
        
        #expect(EmailAddress("first+last@domain.com").isValid)
        #expect(EmailAddress("first+last@subdomain.domain.com").isValid)
        
        #expect(EmailAddress("first-last@domain.com").isValid)
        #expect(EmailAddress("first-last@subdomain.domain.com").isValid)
        
        #expect(EmailAddress("user@some-domain.com").isValid)
        #expect(EmailAddress("user@subdomain.some-domain.com").isValid)
        
        // domain: can't start or end with hyphen
        #expect(!EmailAddress("user@-somedomain.com").isValid)
        #expect(!EmailAddress("user@somedomain-.com").isValid)
        
        #expect(EmailAddress("user@123456.com").isValid)
        
        // domain: 70 chars, too many
        #expect(
            !EmailAddress(
                "user@1234567890123456789012345678901234567890123456789012345678901234567890.com"
            )
            .isValid
        )
        
        // domain: 63 chars max, is valid
        #expect(
            EmailAddress("user@890123456789012345678901234567890123456789012345678901234567890.com")
                .isValid
        )
        
        // TLD: can't be all numbers
        #expect(!EmailAddress("user@domain.123").isValid)
        
        // TLD: only latin alphabet
        #expect(!EmailAddress("user@domain.c-m").isValid)
        
        // hostname: must not exceed 255 characters
        // 256 characters
        #expect(
            !EmailAddress(
                "user@1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.com"
            )
            .isValid
        )
        
        // hostname: must not exceed 255 characters
        // 255 characters
        #expect(
            EmailAddress(
                "user@1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.1234567890.123456789.com"
            ).isValid
        )
    }
}
