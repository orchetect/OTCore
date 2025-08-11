//
//  DateComponents from String.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - .init?(string:)

extension DateComponents {
    /// **OTCore:**
    /// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
    ///
    /// Only produces day, month and year components.
    ///
    /// Acceptable formats include:
    ///
    /// - "10-21-20" (or "10/21/20")
    /// - "21-10-20" (or "21/10/20")
    ///
    /// - "2020-10-21" (or "2020/10/21")
    /// - "2020-21-10" (or "2020/21/10")
    /// - "10-21-2020" (or "10/21/2020")
    /// - "21-10-2020" (or "21/10/2020")
    ///
    /// - "2020-Oct-21" (or "2020/Oct/21")
    /// - "2020-21-Oct" (or "2020/21/Oct")
    ///
    /// - "Oct 21 2020"
    /// - "October 21 2020"
    /// - "Oct 21, 2020"
    /// - "October 21, 2020"
    /// - "21 Oct 2020"
    /// - "21 October 2020"
    ///
    /// - "21Oct2020"
    /// - "2020Oct21"
    ///
    /// > Note:
    /// >
    /// > A ParseStrategy is also available using the same text parsing algorithm.
    /// >
    /// > ```swift
    /// > let components = try DateComponents("Oct 21 2020", strategy: .fuzzyDate)
    /// > ```
    public init?<S: StringProtocol>(fuzzy string: S) {
        self.init()
        
        var year = 0
        var month = 0
        var day = 0
        
        let prepped = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: " ")
            .replacingOccurrences(of: ".", with: " ")
            .replacingOccurrences(of: "/", with: " ")
            .replacingOccurrences(of: "\\", with: " ")
            .replacingOccurrences(of: "-", with: " ")
        
        var split = prepped.split(separator: " ")
        
        if split.count < 2 {
            // string seemingly did not contain separators,
            // so attempt to parse as "2020Jun16" / "16Jun2020" format
            
            let trySplit = prepped.split(intoSequencesOf: .letters, .decimalDigits)
            
            // only overwrite previously split values if this split succeeded
            if trySplit.count > 2 {
                split = trySplit
            }
        }
        
        // year - four digit
        for idx in split.indices {
            if let getValue = Int(split[idx]) {
                if getValue > 1000 {
                    year = getValue
                    split.remove(at: idx)
                    break
                }
            }
        }
        
        // year - two digit (assume it's either the first or last component)
        // rollover year is arbitrarily set here to 1940
        
        // check if year is first component and not possible to be a month or day
        if split.count == 3,
           let getValue = Int(split[0]),
           (32 ... 99).contains(getValue)
        {
            if getValue < 40 {
                year = 2000 + getValue
            } else {
                year = 1900 + getValue
            }
            split.remove(at: 0)
        }
        // otherwise, check last component
        else if split.count == 3,
                let getValue = Int(split[2]),
                (0 ... 99).contains(getValue)
        {
            if getValue < 40 {
                year = 2000 + getValue
            } else {
                year = 1900 + getValue
            }
            split.remove(at: 2)
        }
        
        // named month (not numerical month)
        for idx in split.startIndex ..< split.endIndex {
            let getValue = String(split[idx]).trimmingCharacters(in: .whitespacesAndNewlines)
            
            // long month names
            if let getMatchIndex = Self
                .getUCMatchIndex(for: getValue, in: Calendar.current.monthSymbols)
            {
                month = getMatchIndex + 1
                split.remove(at: idx)
                break
            }
            
            // short month names
            else if let getMatchIndex = Self
                .getUCMatchIndex(for: getValue, in: Calendar.current.shortMonthSymbols)
            {
                month = getMatchIndex + 1
                split.remove(at: idx)
                break
            }
        }
        
        // process remaining values as numbers only
        
        var remaining = split.compactMap { Int($0) }
        
        // if remaining components aren't all numbers (convertible to Int), original input string is not as expected
        guard split.count == remaining.count else { return nil }
        split = []
        
        // day > 12 (obvious)
        
        for idx in remaining.startIndex ..< remaining.endIndex {
            let getValue = remaining[idx]
            
            if (13 ... 31).contains(getValue) {
                day = getValue
                remaining.remove(at: idx)
                break
            }
        }
        
        switch remaining.count {
        case 1:
            // this is likely the month, or the day 12 or under
            if month == 0, (1 ... 12).contains(remaining[0]) {
                month = remaining[0]
                remaining.remove(at: 0)
            } else if day == 0, (1 ... 31).contains(remaining[0]) {
                day = remaining[0]
                remaining.remove(at: 0)
            }
        case 2:
            guard month == 0, day == 0 else { return nil }
            
            // assume M,D order (US-based, more common?)
            
            month = remaining[0]
            day = remaining[1]
            remaining.remove(at: 1)
            remaining.remove(at: 0)
            
        default: break
        }
        
        // finally, if there was no year, then assume the year is the current year
        if year == 0 { year = Calendar.current.component(.year, from: Date()) }
        
        // if there are components remaining, something went wrong
        guard remaining.isEmpty else { return nil }
        guard year > 0 else { return nil }
        guard month > 0 else { return nil }
        guard day > 0 else { return nil }
        
        self.year = year
        self.month = month
        self.day = day
    }
    
    /// Internal use.
    fileprivate static func getUCMatchIndex(for findStr: String, in array: [String]) -> Int? {
        let UCArray = array.map { $0.uppercased() }
        let UCFind = findStr.uppercased()
        
        return UCArray.firstIndex(of: UCFind)
    }
}

extension String {
    /// **OTCore:**
    /// Attempts to parse Year, Month and Day components from an unformatted date string using simple heuristics.
    @_disfavoredOverload
    public var dateComponents: DateComponents? {
        DateComponents(fuzzy: self)
    }
}

// MARK: - FuzzyDateComponentsStringParseStrategy

/// **OTCore:**
/// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
///
/// Only produces day, month and year components.
///
/// Acceptable formats include:
///
/// - "10-21-20" (or "10/21/20")
/// - "21-10-20" (or "21/10/20")
///
/// - "2020-10-21" (or "2020/10/21")
/// - "2020-21-10" (or "2020/21/10")
/// - "10-21-2020" (or "10/21/2020")
/// - "21-10-2020" (or "21/10/2020")
///
/// - "2020-Oct-21" (or "2020/Oct/21")
/// - "2020-21-Oct" (or "2020/21/Oct")
///
/// - "Oct 21 2020"
/// - "October 21 2020"
/// - "Oct 21, 2020"
/// - "October 21, 2020"
/// - "21 Oct 2020"
/// - "21 October 2020"
///
/// - "21Oct2020"
/// - "2020Oct21"
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct FuzzyDateComponentsStringParseStrategy<ParseInput>: ParseStrategy, Sendable where ParseInput: StringProtocol {
    public func parse(_ value: ParseInput) throws -> DateComponents {
        guard let dc = DateComponents(fuzzy: value) else {
            throw ParseError.parseFailed
        }
        return dc
    }
    
    public init() { }
    
    public enum ParseError: Error {
        case parseFailed
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension ParseStrategy where ParseOutput == DateComponents,
                              Self == FuzzyDateComponentsStringParseStrategy<String>
{
    /// **OTCore:**
    /// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
    public static var fuzzyDate: FuzzyDateComponentsStringParseStrategy<ParseInput> {
        FuzzyDateComponentsStringParseStrategy()
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension ParseStrategy where ParseOutput == DateComponents,
                              Self == FuzzyDateComponentsStringParseStrategy<Substring>
{
    /// **OTCore:**
    /// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
    public static var fuzzyDate: FuzzyDateComponentsStringParseStrategy<ParseInput> {
        FuzzyDateComponentsStringParseStrategy()
    }
}

// MARK: - fuzzyDateParseStrategy

/// **OTCore:**
/// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
///
/// Only produces day, month and year components.
///
/// Acceptable formats include:
///
/// - "10-21-20" (or "10/21/20")
/// - "21-10-20" (or "21/10/20")
///
/// - "2020-10-21" (or "2020/10/21")
/// - "2020-21-10" (or "2020/21/10")
/// - "10-21-2020" (or "10/21/2020")
/// - "21-10-2020" (or "21/10/2020")
///
/// - "2020-Oct-21" (or "2020/Oct/21")
/// - "2020-21-Oct" (or "2020/21/Oct")
///
/// - "Oct 21 2020"
/// - "October 21 2020"
/// - "Oct 21, 2020"
/// - "October 21, 2020"
/// - "21 Oct 2020"
/// - "21 October 2020"
///
/// - "21Oct2020"
/// - "2020Oct21"
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct FuzzyDateParseStrategy<ParseInput>: ParseStrategy, Sendable where ParseInput: StringProtocol {
    public var calendar: Calendar
    public var timeZone: TimeZone
    
    public func parse(_ value: ParseInput) throws -> Date {
        guard var dc = DateComponents(fuzzy: value)
        else {
            throw ParseError.parseFailed
        }
        dc.calendar = calendar
        dc.timeZone = timeZone
        
        guard let date = dc.date
        else {
            throw ParseError.dateConversionFailed
        }
        return date
    }
    
    public init(
        calendar: Calendar = .current,
        timeZone: TimeZone = .current
    ) {
        self.calendar = calendar
        self.timeZone = timeZone
    }
    
    public enum ParseError: Error {
        case parseFailed
        case dateConversionFailed
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension ParseStrategy where ParseOutput == Date,
                              Self == FuzzyDateParseStrategy<String>
{
    /// **OTCore:**
    /// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
    public static func fuzzyDate(
        calendar: Calendar = .current,
        timeZone: TimeZone = .current
    ) -> FuzzyDateParseStrategy<ParseInput> {
        FuzzyDateParseStrategy(calendar: calendar, timeZone: timeZone)
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension ParseStrategy where ParseOutput == Date,
                              Self == FuzzyDateParseStrategy<Substring>
{
    /// **OTCore:**
    /// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
    public static func fuzzyDate(
        calendar: Calendar = .current,
        timeZone: TimeZone = .current
    ) -> FuzzyDateParseStrategy<ParseInput> {
        FuzzyDateParseStrategy(calendar: calendar, timeZone: timeZone)
    }
}

// MARK: - .string(withMask:)

extension DateComponents {
    /// **OTCore:**
    /// Date string mask.
    /// (Currently only supports `YYYYMMDD` but will support more basic formats in the future.)
    public enum StringMask: Sendable {
        case YYYYMMDD
    }
    
    /// **OTCore:**
    /// Returns `DateComponents` as a flat YYYYMMDD date string.
    /// Values default to 0 if `nil`.
    public func string(withMask: StringMask) -> String {
        switch withMask {
        case .YYYYMMDD:
            let paddedYear = "0000\(year ?? 0)".suffix(4)
            let paddedMonth = "00\(month ?? 0)".suffix(2)
            let paddedDay = "00\(day ?? 0)".suffix(2)
            
            return "\(paddedYear)\(paddedMonth)\(paddedDay)"
        }
    }
}

#endif
