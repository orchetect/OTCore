//
//  IPAddress Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Abstractions_IPAddress_Tests {
    @Test
    func ipAddress() {
        // MARK: IPv4
        
        // valid unspecified
        #expect(IPAddress("0.0.0.0")?.version == .ipV4)
        
        #expect(IPAddress("10.0.0.100")?.version == .ipV4)
        #expect(IPAddress("255.255.255.255")?.version == .ipV4)
        #expect(IPAddress("001.001.001.001")?.version == .ipV4)
        
        #expect(IPAddress("...") == nil)
        #expect(IPAddress(" . . . ") == nil)
        #expect(IPAddress("300.300.300.300") == nil)
        #expect(IPAddress("300.1.1.1") == nil)
        #expect(IPAddress("1.300.1.1") == nil)
        #expect(IPAddress("1.1.300.1") == nil)
        #expect(IPAddress("1.1.1.300") == nil)
        #expect(IPAddress("1 .102.103.104") == nil)
        #expect(IPAddress("1.2.3.4.5") == nil)
        
        // no surrounding spaces allowed, even if IP address is valid
        #expect(IPAddress(" 1.2.3.4 ") == nil)
        
        // MARK: IPv6
        
        // local loopback address
        #expect(IPAddress("::1")?.version == .ipV6)
        
        // valid unspecified
        #expect(IPAddress("::")?.version == .ipV6)
        
        // includes interface component
        #expect(
            IPAddress("fe80::479:5a0d:bf0f:130%en0")?.version
                == .ipV6
        )
        
        // includes interface component
        #expect(
            IPAddress("fe80::c6a:a089:1eec:80a7%awdl0")?.version
                == .ipV6
        )
        #expect(IPAddress("2001:470:9b36:1::2")?.version == .ipV6)
        #expect(IPAddress("2001:cdba:0000:0000:0000:0000:3257:9652")?.version == .ipV6)
        #expect(IPAddress("2001:cdba:0:0:0:0:3257:9652")?.version == .ipV6)
        #expect(IPAddress("2001:db8:85a3::8a2e:370:7334")?.version == .ipV6)
        
        // IPv4 address mapped to IPv6
        #expect(IPAddress("::ffff:192.0.2.128")?.version == .ipV6)
        
        #expect(IPAddress("::_") == nil)
        
        // uses '::' twice - not allowed
        #expect(IPAddress("1200::AB00:1234::2552:7777:1313") == nil)
        
        #expect(IPAddress("1200:0000:AB00:1234:O000:2552:7777:1313") == nil)
    }
}
