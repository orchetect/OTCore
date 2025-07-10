//
//  IPAddress Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OTCore

class Abstractions_IPAddress_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testIPAddress() {
        // MARK: IPv4
        
        // valid unspecified
        XCTAssertEqual(IPAddress("0.0.0.0")?.version, .ipV4)
        
        XCTAssertEqual(IPAddress("10.0.0.100")?.version, .ipV4)
        XCTAssertEqual(IPAddress("255.255.255.255")?.version, .ipV4)
        XCTAssertEqual(IPAddress("001.001.001.001")?.version, .ipV4)
        
        XCTAssertNil(IPAddress("..."))
        XCTAssertNil(IPAddress(" . . . "))
        XCTAssertNil(IPAddress("300.300.300.300"))
        XCTAssertNil(IPAddress("300.1.1.1"))
        XCTAssertNil(IPAddress("1.300.1.1"))
        XCTAssertNil(IPAddress("1.1.300.1"))
        XCTAssertNil(IPAddress("1.1.1.300"))
        XCTAssertNil(IPAddress("1 .102.103.104"))
        XCTAssertNil(IPAddress("1.2.3.4.5"))
        
        // no surrounding spaces allowed, even if IP address is valid
        XCTAssertNil(IPAddress(" 1.2.3.4 "))
        
        // MARK: IPv6
        
        // local loopback address
        XCTAssertEqual(IPAddress("::1")?.version, .ipV6)
        
        // valid unspecified
        XCTAssertEqual(IPAddress("::")?.version, .ipV6)
        
        // includes interface component
        XCTAssertEqual(
            IPAddress("fe80::479:5a0d:bf0f:130%en0")?.version,
            .ipV6
        )
        
        // includes interface component
        XCTAssertEqual(
            IPAddress("fe80::c6a:a089:1eec:80a7%awdl0")?.version,
            .ipV6
        )
        XCTAssertEqual(IPAddress("2001:470:9b36:1::2")?.version, .ipV6)
        XCTAssertEqual(IPAddress("2001:cdba:0000:0000:0000:0000:3257:9652")?.version, .ipV6)
        XCTAssertEqual(IPAddress("2001:cdba:0:0:0:0:3257:9652")?.version, .ipV6)
        XCTAssertEqual(IPAddress("2001:db8:85a3::8a2e:370:7334")?.version, .ipV6)
        
        // IPv4 address mapped to IPv6
        XCTAssertEqual(IPAddress("::ffff:192.0.2.128")?.version, .ipV6)
        
        XCTAssertNil(IPAddress("::_"))
        
        // uses '::' twice - not allowed
        XCTAssertNil(IPAddress("1200::AB00:1234::2552:7777:1313"))
        
        XCTAssertNil(IPAddress("1200:0000:AB00:1234:O000:2552:7777:1313"))
    }
}
