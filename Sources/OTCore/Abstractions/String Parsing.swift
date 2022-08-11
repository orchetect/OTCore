//
//  String Parsing.swift
//  OTCore • https://github.com/orchetect/OTCore
//

import Foundation

extension String {
    /// **OTCore:**
    /// Returns true if the string is a valid email address.
    @_disfavoredOverload
    public var isValidEmailAddress: Bool {
        // prefix@domain.TLD
        
        // Prefix (a.k.a. username / local-part)
        // An email prefix can only be up to 64 characters long. The characters can be a combination of any of the 26 letters of the English alphabet, the numbers 0–9, and special characters limited to an exclamation point (!), the sharp symbol (#), a dollar sign ($), the percentage symbol (%), an ampersand (&), an apostrophe (’), an asterisk (*), the plus sign (+), a hyphen (–), an open slash mark (/), the equal sign (=), a question mark (?), a circumflex or caret (^), an underscore (_), a period (.), brackets ({ or }), a vertical bar (|), or a tilde mark (~). Note, however, that a period can only be used once in an email prefix. It can’t appear as the first or last character as well.
        
        // Hostname (domain.TLD)
        // The hostname is subject to stricter guidelines. It can’t be more than 255 characters in length, and must adhere to the following specifications:
        // It must match the requirements for a hostname (the name of a device connected to a computer network)
        // Names must be fewer than 63 characters long and can contain Latin letters, the numbers 0 through 9, and hyphens.
        // The first and last character cannot be hyphens.
        // Top-level domains (TLD) cannot be all numeric.
        
        let emailRegEx =
            #"^([a-zA-Z0-9!#$%&'*+-/=?^_.{}|~]{1,64})@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,63})$"#
        
        let groups = regexMatches(captureGroupsFromPattern: emailRegEx)
        
        // first array element is the entire match, then capture groups follow
        guard groups.count == 2 + 1 else { return false }
        
        guard let prefix = groups[1],
              let hostname = groups[2] else { return false }
        
        guard hostname.count <= 255 else { return false }
        
        let hostnameComponents = hostname.split(separator: ".")
        let domainComponents = hostnameComponents.prefix(upTo: hostnameComponents.endIndex)
        guard let tld = hostnameComponents.last else { return false }
        
        // prefix validation
        guard prefix.first != ".",
              prefix.last != ".",
              !prefix.contains("..") else { return false }
        
        // domain validation
        guard domainComponents.count >= 2,
              domainComponents.allSatisfy({ (1 ... 63).contains($0.count) }),
              domainComponents.allSatisfy({ $0.first != "-" }),
              domainComponents.allSatisfy({ $0.last != "-" })
        else { return false }
        
        // TLD validation
        guard (2 ... 63).contains(tld.count),
              !tld.isOnly(.decimalDigits)
        else { return false }
        
        return true
    }
}
