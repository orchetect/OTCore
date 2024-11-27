//
//  ReverseDomainName.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A type representing a domain name in reverse-notation (ie: `com.apple`, `com.apple.www`, `com.apple.www.zzz`).
public struct ReverseDomainName {
    /// Individual domain name components (domain name split by period (`.`) characters).
    public let components: [String]
    
    /// The number of domain extension components included in the domain extension.
    ///
    /// For example:
    /// - `"com.apple.www"` would have `1` component (`"com"`).
    /// - `"uk.co.apple.www"` would have `2` components (`"uk"` and `"co"`).
    public let extensionComponentCount: Int
    
    /// Initialize a new instance from a reverse-notation domain name string.
    public init(_ verbatim: String) {
        components = verbatim.split(separator: ".").map(String.init)
        
        extensionComponentCount = DomainName
            .extensionComponentCount(inDomainComponents: components.reversed())
    }
    
    /// Initialize a new instance from reverse-notation domain name components (domain name split by period (`.`)
    /// characters).
    public init(components: [String]) {
        self.components = components
        
        extensionComponentCount = DomainName
            .extensionComponentCount(inDomainComponents: components.reversed())
    }
}

extension ReverseDomainName: Equatable { }

extension ReverseDomainName: Hashable { }

extension ReverseDomainName: Identifiable {
    public var id: String { string }
}

extension ReverseDomainName: CustomStringConvertible {
    public var description: String {
        string
    }
}

extension ReverseDomainName {
    /// Returns the full reverse-notation domain name string including all components.
    public var string: String {
        components.joined(separator: ".")
    }
    
    /// Returns the prefix components of the reverse-notation domain name, if any are present.
    ///
    /// For example:
    /// - `"com.apple"` or `"uk.co.apple"` returns `""`
    /// - `"com.apple.www"` or `"uk.co.apple.www"` returns `"www"`
    /// - `"com.apple.www.zzz"` returns `"www.zzz"`
    public var prefix: String {
        prefixComponents.joined(separator: ".")
    }
    
    /// Returns the prefix components of the domain name, if any are present.
    ///
    /// For example:
    /// - `"com.apple"` or `"uk.co.apple"` returns `[]`
    /// - `"com.apple.www"` or `"uk.co.apple.www"` returns `["www"]`
    /// - `"com.apple.www.zzz"` returns `["www", "zzz"]`
    public var prefixComponents: [String] {
        let prefixCount = max(0, components.count - (extensionComponentCount + 1))
        return Array(components.suffix(prefixCount))
    }
    
    /// Returns the domain component of the domain name.
    ///
    /// For example:
    /// - `"com.apple"` or `"com.apple.www"` returns `"apple"`
    /// - `"uk.co.apple"` or `"uk.co.apple.www"` returns `"apple"`
    public var domainComponent: String {
        components.dropFirst(extensionComponentCount).first ?? ""
    }
    
    /// Returns the domain and extension of the domain name.
    ///
    /// For example:
    /// - `"com.apple"` or `"com.apple.www"` returns `"com.apple"`
    /// - `"uk.co.apple"` or `"uk.co.apple.www"` returns `"uk.co.apple"`
    public var domainAndExtension: String {
        domainAndExtensionComponents.joined(separator: ".")
    }
    
    /// Returns the domain and extension of the domain name.
    ///
    /// For example:
    /// - `"com.apple"` or `"com.apple.www"` returns `["com", "apple"]`
    /// - `"uk.co.apple"` or `"uk.co.apple.www"` returns `["uk", "co", "apple"]`
    public var domainAndExtensionComponents: [String] {
        Array(components.prefix(extensionComponentCount + 1))
    }
    
    /// Returns the extension for the domain name.
    ///
    /// For example:
    /// - `"com.apple"` or `"com.apple.www"` returns `"com"`
    /// - `"uk.co.apple"` or `"uk.co.apple.www"` returns `"uk.co"`
    public var domainExtension: String {
        domainExtensionComponents.joined(separator: ".")
    }
    
    /// Returns the extension for the domain name.
    ///
    /// For example:
    /// - `"com.apple"` or `"com.apple.www"` returns `["com"]`
    /// - `"uk.co.apple"` or `"uk.co.apple.www"` returns `["uk", "co"]`
    public var domainExtensionComponents: [String] {
        Array(components.prefix(extensionComponentCount))
    }
}
