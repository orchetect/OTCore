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
    ) -> [SubSequence] {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: options
            )
            
            func runRegEx(in source: String) -> [NSTextCheckingResult] {
                regex.matches(
                    in: source,
                    options: matchesOptions,
                    range: NSMakeRange(0, (nsString as String).utf16.count)
                )
            }
            
            let nsString: NSString
            let results: [NSTextCheckingResult]
            
            switch self {
            case let _self as String:
                nsString = _self as NSString
                results = runRegEx(in: _self)
                
            default:
                let stringSelf = String(self)
                nsString = stringSelf as NSString
                results = runRegEx(in: stringSelf)
            }
            
            return results.map {
                let lb = self.utf16.index(self.startIndex, offsetBy: $0.range.lowerBound)
                let ub = self.utf16.index(self.startIndex, offsetBy: $0.range.upperBound)
                
                let subString = self[lb ..< ub]
                return subString
            }
            
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
                    range: NSMakeRange(0, source.utf16.count),
                    withTemplate: replacementTemplate
                )
            }
            
            let result: String
            
            switch self {
            case let _self as String:
                result = runRegEx(in: _self)
                
            default:
                let stringSelf = String(self)
                result = runRegEx(in: stringSelf)
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
    ) -> [SubSequence?] {
        do {
            let regex = try NSRegularExpression(
                pattern: captureGroupsFromPattern,
                options: options
            )
            
            let result: [SubSequence?]
            
            func runRegEx(in source: String) -> [SubSequence?] {
                let results = regex.matches(
                    in: source,
                    options: matchesOptions,
                    range: NSMakeRange(0, source.utf16.count)
                )
                
                var matches: [SubSequence?] = []
                
                for result in results {
                    for i in 0 ..< result.numberOfRanges {
                        let nsRange = result.range(at: i)
                        
                        if nsRange.location == NSNotFound {
                            matches.append(nil)
                        } else {
                            let lb = self.utf16.index(source.startIndex, offsetBy: nsRange.lowerBound)
                            let ub = self.utf16.index(source.startIndex, offsetBy: nsRange.upperBound)
                            
                            let subString = self[lb ..< ub]
                            matches.append(subString)
                        }
                    }
                }
                
                return matches
            }
            
            switch self {
            case let _self as String:
                result = runRegEx(in: _self)
                
            default:
                let stringSelf = String(self)
                result = runRegEx(in: stringSelf)
            }
            
            return result
            
        } catch {
            return []
        }
    }
}

#endif
