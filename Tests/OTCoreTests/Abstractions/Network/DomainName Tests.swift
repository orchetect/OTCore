//
//  DomainName Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct DomainNameTests {
    @Test
    func initString_OneTLDComponent_NoPrefix() throws {
        #expect(DomainName("apple.com").components == ["apple", "com"])
        #expect(DomainName("apple.com").string == "apple.com")
        
        #expect(DomainName("apple.com").prefix == "")
        #expect(DomainName("apple.com").prefixComponents == [])
        
        #expect(DomainName("apple.com").domainComponent == "apple")
        
        #expect(DomainName("apple.com").domainAndExtension == "apple.com")
        #expect(DomainName("apple.com").domainAndExtensionComponents == ["apple", "com"])
        
        #expect(DomainName("apple.com").domainExtension == "com")
        #expect(DomainName("apple.com").domainExtensionComponents == ["com"])
    }
    
    @Test
    func initString_OneTLDComponent_OnePrefix() throws {
        #expect(DomainName("www.apple.com").components == ["www", "apple", "com"])
        #expect(DomainName("www.apple.com").string == "www.apple.com")
        
        #expect(DomainName("www.apple.com").prefix == "www")
        #expect(DomainName("www.apple.com").prefixComponents == ["www"])
        
        #expect(DomainName("www.apple.com").domainComponent == "apple")
        
        #expect(DomainName("www.apple.com").domainAndExtension == "apple.com")
        #expect(DomainName("www.apple.com").domainAndExtensionComponents == ["apple", "com"])
        
        #expect(DomainName("www.apple.com").domainExtension == "com")
        #expect(DomainName("www.apple.com").domainExtensionComponents == ["com"])
    }
    
    @Test
    func initString_OneTLDComponent_TwoPrefixes() throws {
        #expect(DomainName("zzz.www.apple.com").components == ["zzz", "www", "apple", "com"])
        #expect(DomainName("zzz.www.apple.com").string == "zzz.www.apple.com")
        
        #expect(DomainName("zzz.www.apple.com").prefix == "zzz.www")
        #expect(DomainName("zzz.www.apple.com").prefixComponents == ["zzz", "www"])
        
        #expect(DomainName("zzz.www.apple.com").domainComponent == "apple")
        
        #expect(DomainName("zzz.www.apple.com").domainAndExtension == "apple.com")
        #expect(DomainName("zzz.www.apple.com").domainAndExtensionComponents == ["apple", "com"])
        
        #expect(DomainName("zzz.www.apple.com").domainExtension == "com")
        #expect(DomainName("zzz.www.apple.com").domainExtensionComponents == ["com"])
    }
    
    @Test
    func initString_TwoTLDComponents_NoPrefix() throws {
        #expect(DomainName("apple.co.uk").components == ["apple", "co", "uk"])
        #expect(DomainName("apple.co.uk").string == "apple.co.uk")
        
        #expect(DomainName("apple.co.uk").prefix == "")
        #expect(DomainName("apple.co.uk").prefixComponents == [])
        
        #expect(DomainName("apple.co.uk").domainComponent == "apple")
        
        #expect(DomainName("apple.co.uk").domainAndExtension == "apple.co.uk")
        #expect(DomainName("apple.co.uk").domainAndExtensionComponents == ["apple", "co", "uk"])
        
        #expect(DomainName("apple.co.uk").domainExtension == "co.uk")
        #expect(DomainName("apple.co.uk").domainExtensionComponents == ["co", "uk"])
    }
    
    @Test
    func initString_TwoTLDComponents_OnePrefix() throws {
        #expect(DomainName("www.apple.co.uk").components == ["www", "apple", "co", "uk"])
        #expect(DomainName("www.apple.co.uk").string == "www.apple.co.uk")
        
        #expect(DomainName("www.apple.co.uk").prefix == "www")
        #expect(DomainName("www.apple.co.uk").prefixComponents == ["www"])
        
        #expect(DomainName("www.apple.co.uk").domainComponent == "apple")
        
        #expect(DomainName("www.apple.co.uk").domainAndExtension == "apple.co.uk")
        #expect(DomainName("www.apple.co.uk").domainAndExtensionComponents == ["apple", "co", "uk"])
        
        #expect(DomainName("www.apple.co.uk").domainExtension == "co.uk")
        #expect(DomainName("www.apple.co.uk").domainExtensionComponents == ["co", "uk"])
    }
    
    @Test
    func initString_TwoTLDComponents_TwoPrefixes() throws {
        #expect(DomainName("zzz.www.apple.co.uk").components == ["zzz", "www", "apple", "co", "uk"])
        #expect(DomainName("zzz.www.apple.co.uk").string == "zzz.www.apple.co.uk")
        
        #expect(DomainName("zzz.www.apple.co.uk").prefix == "zzz.www")
        #expect(DomainName("zzz.www.apple.co.uk").prefixComponents == ["zzz", "www"])
        
        #expect(DomainName("zzz.www.apple.co.uk").domainComponent == "apple")
        
        #expect(DomainName("zzz.www.apple.co.uk").domainAndExtension == "apple.co.uk")
        #expect(DomainName("zzz.www.apple.co.uk")
            .domainAndExtensionComponents == ["apple", "co", "uk"]
        )
        
        #expect(DomainName("zzz.www.apple.co.uk").domainExtension == "co.uk")
        #expect(DomainName("zzz.www.apple.co.uk").domainExtensionComponents == ["co", "uk"])
    }
    
    // TODO: In future, a validation mechanism or property could determine if a domain name is formatted correctly or not.
    /// Just verify edge case behavior.
    @Test
    func initString_EdgeCases() throws {
        #expect(DomainName("").components == [])
        #expect(DomainName(" ").components == [" "])
        #expect(DomainName(".").components == [])
        #expect(DomainName(". ").components == [" "])
        #expect(DomainName(" . ").components == [" ", " "])
        #expect(DomainName("..").components == [])
        #expect(DomainName(".. ").components == [" "])
        #expect(DomainName(" ..").components == [" "])
        #expect(DomainName(" .. ").components == [" ", " "])
    }
}
