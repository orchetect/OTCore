//
//  IPAddress.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// IP Address Format Validation.
public struct IPAddress {
    /// **OTCore:**
    /// IP Address.
    public var address: String = ""
	
    /// **OTCore:**
    /// Validated IP address format.
    public var version: Version
    
    /// **OTCore:**
    /// IP Address Format Validation.
    /// If initialization succeeds, it means the IP address is of a valid format.
    /// The ``format`` property will contain the specific IP address format.
    public init?(_ address: String) {
        self.address = address
        
        guard let validatedFormat = try? Self.validate(address: address) else {
            return nil
        }
        
        version = validatedFormat
    }
}

extension IPAddress: Identifiable {
    public var id: String { address }
}

extension IPAddress: Sendable { }

// MARK: - Validation

extension IPAddress {
    /// Internal:
    /// IPv4 IP Address Validation Pattern.
    private static let IPv4Pattern =
        #"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"#
    
    // as suggested from: http://nbviewer.jupyter.org/github/rasbt/python_reference/blob/master/tutorials/useful_regex.ipynb#Checking-for-IP-addresses
    /// Internal:
    /// IPv6 IP Address Validation Pattern.
    private static let IPv6Pattern =
        #"^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$"#
    
    /// Internal:
    /// Performs validation on the IP address.
    static func validate(address: String) throws -> Version {
        // first test for IPv4
        if try NSRegularExpression(pattern: Self.IPv4Pattern, options: [])
            .matches(
                in: address,
                options: .anchored,
                range: NSRange(
                    location: 0,
                    length: address.distance(
                        from: address.startIndex,
                        to: address.endIndex
                    )
                )
            )
            .count == 1
        {
            return .ipV4
        }
        
        // secondly, test for IPv6
        if try NSRegularExpression(pattern: Self.IPv6Pattern, options: [])
            .matches(
                in: address,
                options: .anchored,
                range: NSRange(
                    location: 0,
                    length: address.distance(
                        from: address.startIndex,
                        to: address.endIndex
                    )
                )
            )
            .count == 1
        {
            return .ipV6
        }
        
        // if all tests failed, return invalid - does not match any known IP address format
        throw ValidationError.invalid
    }
}

// MARK: - Version

extension IPAddress {
    /// **OTCore:**
    /// IP Address validation result returned by ``IPAddress``.
    public enum Version: Sendable {
        /// **OTCore:**
        /// Valid IPv4 address.
        case ipV4
        
        /// **OTCore:**
        /// Valid IPv6 address.
        case ipV6
    }
    
    /// **OTCore:**
    /// IP Address validation error.
    public enum ValidationError: Error {
        case invalid
    }
}

extension IPAddress.Version: Identifiable {
    public var id: Self { self }
}

#endif
