//
//  String and NSRegularExpression.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - RegEx

extension StringProtocol {
    /// **OTCore:**
    /// Returns an array of RegEx matches
    @_disfavoredOverload
    public func regexMatches(
        pattern: String,
        options: NSRegularExpression.Options = [],
        matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) -> [String] {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: options
            )
            
            func runRegEx(in source: String) -> [NSTextCheckingResult] {
                regex.matches(
                    in: source,
                    options: matchesOptions,
                    range: NSMakeRange(0, nsString.length)
                )
            }
            
            let nsString: NSString
            let results: [NSTextCheckingResult]
            
            switch self {
            case let _self as String:
                nsString = _self as NSString
                results = runRegEx(in: _self)
                
            case let _self as Substring:
                let stringSelf = String(_self)
                nsString = stringSelf as NSString
                results = runRegEx(in: stringSelf)
                
            default:
                return []
            }
            
            return results.map { nsString.substring(with: $0.range) }
            
        } catch {
            return []
        }
    }
    
    /// **OTCore:**
    /// Returns a string from a tokenized string of RegEx matches
    @_disfavoredOverload
    public func regexMatches(
        pattern: String,
        replacementTemplate: String,
        options: NSRegularExpression.Options = [],
        matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds],
        replacingOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) -> String? {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: options
            )
            
            func runRegEx(in source: String) -> String {
                regex.stringByReplacingMatches(
                    in: source,
                    options: replacingOptions,
                    range: NSMakeRange(0, source.count),
                    withTemplate: replacementTemplate
                )
            }
            
            let result: String
            
            switch self {
            case let _self as String:
                result = runRegEx(in: _self)
                
            case let _self as Substring:
                let stringSelf = String(_self)
                result = runRegEx(in: stringSelf)
                
            default:
                return nil
            }
            
            return result
            
        } catch {
            return nil
        }
    }
    
    /// **OTCore:**
    /// Returns capture groups from regex matches. If any capture group is not matched it will be `nil`.
    @_disfavoredOverload
    public func regexMatches(
        captureGroupsFromPattern: String,
        options: NSRegularExpression.Options = [],
        matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) -> [String?] {
        do {
            let regex = try NSRegularExpression(
                pattern: captureGroupsFromPattern,
                options: options
            )
            
            let result: [String?]
            
            func runRegEx(in source: String) -> [String?] {
                let results = regex.matches(
                    in: source,
                    options: matchesOptions,
                    range: NSMakeRange(0, source.count)
                )
                
                let nsString = source as NSString
                
                var matches: [String?] = []
                
                for result in results {
                    for i in 0 ..< result.numberOfRanges {
                        let range = result.range(at: i)
                        
                        if range.location == NSNotFound {
                            matches.append(nil)
                        } else {
                            matches.append(nsString.substring(with: range))
                        }
                    }
                }
                
                return matches
            }
            
            switch self {
            case let _self as String:
                result = runRegEx(in: _self)
                
            case let _self as Substring:
                let stringSelf = String(_self)
                result = runRegEx(in: stringSelf)
                
            default:
                return []
            }
            
            return result
            
        } catch {
            return []
        }
    }
}

#endif
