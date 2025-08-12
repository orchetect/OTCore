//
//  ReverseDomainName Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct ReverseDomainNameTests {
    @Test
    func initString_OneTLDComponent_NoPrefix() throws {
        #expect(ReverseDomainName("com.apple").components == ["com", "apple"])
        #expect(ReverseDomainName("com.apple").string == "com.apple")
        
        #expect(ReverseDomainName("com.apple").prefix == "")
        #expect(ReverseDomainName("com.apple").prefixComponents == [])
        
        #expect(ReverseDomainName("com.apple").domainComponent == "apple")
        
        #expect(ReverseDomainName("com.apple").domainAndExtension == "com.apple")
        #expect(ReverseDomainName("com.apple").domainAndExtensionComponents == ["com", "apple"])
        
        #expect(ReverseDomainName("com.apple").domainExtension == "com")
        #expect(ReverseDomainName("com.apple").domainExtensionComponents == ["com"])
    }
    
    @Test
    func initString_OneTLDComponent_OnePrefix() throws {
        #expect(ReverseDomainName("com.apple.www").components == ["com", "apple", "www"])
        #expect(ReverseDomainName("com.apple.www").string == "com.apple.www")
        
        #expect(ReverseDomainName("com.apple.www").prefix == "www")
        #expect(ReverseDomainName("com.apple.www").prefixComponents == ["www"])
        
        #expect(ReverseDomainName("com.apple.www").domainComponent == "apple")
        
        #expect(ReverseDomainName("com.apple.www").domainAndExtension == "com.apple")
        #expect(ReverseDomainName("com.apple.www").domainAndExtensionComponents == ["com", "apple"])
        
        #expect(ReverseDomainName("com.apple.www").domainExtension == "com")
        #expect(ReverseDomainName("com.apple.www").domainExtensionComponents == ["com"])
    }
    
    @Test
    func initString_OneTLDComponent_TwoPrefixes() throws {
        #expect(ReverseDomainName("com.apple.www.zzz").components == ["com", "apple", "www", "zzz"])
        #expect(ReverseDomainName("com.apple.www.zzz").string == "com.apple.www.zzz")
        
        #expect(ReverseDomainName("com.apple.www.zzz").prefix == "www.zzz")
        #expect(ReverseDomainName("com.apple.www.zzz").prefixComponents == ["www", "zzz"])
        
        #expect(ReverseDomainName("com.apple.www.zzz").domainComponent == "apple")
        
        #expect(ReverseDomainName("com.apple.www.zzz").domainAndExtension == "com.apple")
        #expect(ReverseDomainName("com.apple.www.zzz")
            .domainAndExtensionComponents == ["com", "apple"]
        )
        
        #expect(ReverseDomainName("com.apple.www.zzz").domainExtension == "com")
        #expect(ReverseDomainName("com.apple.www.zzz").domainExtensionComponents == ["com"])
    }
    
    @Test
    func initString_TwoTLDComponents_NoPrefix() throws {
        #expect(ReverseDomainName("uk.co.apple").components == ["uk", "co", "apple"])
        #expect(ReverseDomainName("uk.co.apple").string == "uk.co.apple")
        
        #expect(ReverseDomainName("uk.co.apple").prefix == "")
        #expect(ReverseDomainName("uk.co.apple").prefixComponents == [])
        
        #expect(ReverseDomainName("uk.co.apple").domainComponent == "apple")
        
        #expect(ReverseDomainName("uk.co.apple").domainAndExtension == "uk.co.apple")
        #expect(ReverseDomainName("uk.co.apple")
            .domainAndExtensionComponents == ["uk", "co", "apple"]
        )
        
        #expect(ReverseDomainName("uk.co.apple").domainExtension == "uk.co")
        #expect(ReverseDomainName("uk.co.apple").domainExtensionComponents == ["uk", "co"])
    }
    
    @Test
    func initString_TwoTLDComponents_OnePrefix() throws {
        #expect(ReverseDomainName("uk.co.apple.www").components == ["uk", "co", "apple", "www"])
        #expect(ReverseDomainName("uk.co.apple.www").string == "uk.co.apple.www")
        
        #expect(ReverseDomainName("uk.co.apple.www").prefix == "www")
        #expect(ReverseDomainName("uk.co.apple.www").prefixComponents == ["www"])
        
        #expect(ReverseDomainName("uk.co.apple.www").domainComponent == "apple")
        
        #expect(ReverseDomainName("uk.co.apple.www").domainAndExtension == "uk.co.apple")
        #expect(ReverseDomainName("uk.co.apple.www")
            .domainAndExtensionComponents == ["uk", "co", "apple"]
        )
        
        #expect(ReverseDomainName("uk.co.apple.www").domainExtension == "uk.co")
        #expect(ReverseDomainName("uk.co.apple.www").domainExtensionComponents == ["uk", "co"])
    }
    
    @Test
    func initString_TwoTLDComponents_TwoPrefixes() throws {
        #expect(ReverseDomainName("uk.co.apple.www.zzz")
            .components == ["uk", "co", "apple", "www", "zzz"]
        )
        #expect(ReverseDomainName("uk.co.apple.www.zzz").string == "uk.co.apple.www.zzz")
        
        #expect(ReverseDomainName("uk.co.apple.www.zzz").prefix == "www.zzz")
        #expect(ReverseDomainName("uk.co.apple.www.zzz").prefixComponents == ["www", "zzz"])
        
        #expect(ReverseDomainName("uk.co.apple.www.zzz").domainComponent == "apple")
        
        #expect(ReverseDomainName("uk.co.apple.www.zzz").domainAndExtension == "uk.co.apple")
        #expect(ReverseDomainName("uk.co.apple.www.zzz")
            .domainAndExtensionComponents == ["uk", "co", "apple"]
        )
        
        #expect(ReverseDomainName("uk.co.apple.www.zzz").domainExtension == "uk.co")
        #expect(ReverseDomainName("uk.co.apple.www.zzz").domainExtensionComponents == ["uk", "co"])
    }
    
    // TODO: In future, a validation mechanism or property could determine if a domain name is formatted correctly or not.
    /// Just verify edge case behavior.
    @Test
    func initString_EdgeCases() throws {
        #expect(ReverseDomainName("").components == [])
        #expect(ReverseDomainName(" ").components == [" "])
        #expect(ReverseDomainName(".").components == [])
        #expect(ReverseDomainName(". ").components == [" "])
        #expect(ReverseDomainName(" . ").components == [" ", " "])
        #expect(ReverseDomainName("..").components == [])
        #expect(ReverseDomainName(".. ").components == [" "])
        #expect(ReverseDomainName(" ..").components == [" "])
        #expect(ReverseDomainName(" .. ").components == [" ", " "])
    }
}
