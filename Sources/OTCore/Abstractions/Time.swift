//
//  Time.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// **OTCore:**
/// Value type offering basic convenience methods related to manipulating time and formatting time strings.
public struct Time {
    /// Hours component.
    public var hours = 0
    
    /// Minutes component.
    public var minutes = 0
    
    /// Seconds component.
    public var seconds = 0
    
    /// Milliseconds component.
    public var milliseconds = 0
    
    public var sign: FloatingPointSign = .plus
    
    /// Initialize with current system time.
    public init() {
        let date = Date()
        let calendar = Calendar.current
        
        hours = calendar.component(.hour, from: date)
        minutes = calendar.component(.minute, from: date)
        seconds = calendar.component(.second, from: date)
        milliseconds = calendar.component(.nanosecond, from: date) / 1_000_000
    }
    
    /// Initialize with discrete time component values.
    /// Note: negative values may cause undefined behavior.
    public init(
        hours: Int,
        minutes: Int,
        seconds: Int,
        milliseconds: Int = 0,
        sign: FloatingPointSign = .plus
    ) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
        self.sign = sign
    }
    
    /// Initialize from a time interval in seconds.
    public init(seconds: Int, milliseconds: Int = 0) {
        sign = seconds < 0 ? .minus : .plus
        
        let seconds = abs(seconds)
        
        if seconds < 60 { // early return for added performance
            self.seconds = seconds
        } else {
            hours = (seconds / 60 / 60)
            minutes = (seconds / 60) % 60
            self.seconds = seconds % 60
        }
        
        self.milliseconds = milliseconds
    }
    
    /// Initialize from a time interval in seconds.
    @_disfavoredOverload
    public init(seconds: TimeInterval) {
        let absSeconds = abs(seconds)
        let truncSeconds = Int(seconds)
        let absTruncSeconds = abs(truncSeconds)
        
        self.init(seconds: truncSeconds)
        milliseconds = Int((absSeconds - Double(absTruncSeconds)) * 1000)
    }
    
    /// Initialize from a time interval in milliseconds.
    public init(milliseconds: Int) {
        sign = milliseconds < 0 ? .minus : .plus
        
        let milliseconds = abs(milliseconds)
        
        if milliseconds < 1000 { // early return for added performance
            self.milliseconds = milliseconds
        } else {
            hours = (milliseconds / 60 / 60 / 1000) // % 24
            minutes = (milliseconds / 60 / 1000) % 60
            seconds = (milliseconds / 1000) % 60
            self.milliseconds = milliseconds % 1000
        }
    }
	
    /// Initialize from a time interval in milliseconds.
    @_disfavoredOverload
    public init(milliseconds: Double) {
        self.init(milliseconds: Int(milliseconds))
    }
}

extension Time: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.interval == rhs.interval
    }
}

extension Time: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.interval < rhs.interval
    }
}

extension Time: Hashable { }

extension Time: Identifiable {
    public var id: Self { self }
}

extension Time: Sendable { }

extension Time {
    /// Initialize from a time interval string.
    public init?(string: String) {
        // "00:00:00.000" is 12 characters
        guard string.count <= 20 else { return nil }
        
        var string = string
        
        if string.first == "-" {
            string = String(string.dropFirst())
            sign = .minus
        }
        
        var mainComponents: [String] = [""]
        var ms: String?
        
        for char in string {
            if CharacterSet.decimalDigits.contains(char) {
                if ms != nil {
                    ms?.append(char)
                } else if mainComponents.count <= 3 {
                    let lastIndex = mainComponents.endIndex.advanced(by: -1)
                    mainComponents[lastIndex].append(char)
                } else {
                    return nil
                }
            } else if char == ":", mainComponents.count < 3, ms == nil {
                mainComponents += ""
            } else if char == ".", ms == nil {
                ms = ""
            } else {
                return nil
            }
        }
        
        // process main components
        
        guard mainComponents.allSatisfy({ !$0.isEmpty }) else { return nil }
        guard (1 ... 3).contains(mainComponents.count) else { return nil }
        
        switch mainComponents.count {
        case 1: // S
            seconds = Int(mainComponents[0]) ?? 0
        case 2: // M:SS
            minutes = Int(mainComponents[0]) ?? 0
            seconds = Int(mainComponents[1]) ?? 0
        case 3: // H:MM:SS
            hours = Int(mainComponents[0]) ?? 0
            minutes = Int(mainComponents[1]) ?? 0
            seconds = Int(mainComponents[2]) ?? 0
        default:
            // should never happen
            return nil
        }
        
        // process milliseconds
        
        if let ms {
            guard !ms.isEmpty else { return nil }
            milliseconds = Int(ms) ?? 0
        }
    }
    
    /// **OTCore:**
    /// Returns the time as a formatted string.
    public func stringValue(format: Format = .shortest) -> String {
        let absStr = absStringValue(format: format)
        
        switch sign {
        case .plus: return absStr
        case .minus: return "-" + absStr
        }
    }
    
    /// Returns the absolute time (without sign) as a formatted string.
    private func absStringValue(format: Format = .shortest) -> String {
        switch format {
        case .shortest:
            return hours > 0
                ? absStringValue(format: .h_mm_ss)
                : absStringValue(format: .m_ss)
            
        case .hh_mm_ss:
            return "\(hPadded):\(mPadded):\(sPadded)"
            
        case .h_mm_ss:
            return "\(hours):\(mPadded):\(sPadded)"
            
        case .mm_ss:
            return "\(totalMinutesPadded):\(sPadded)"
            
        case .m_ss:
            return "\(totalMinutes):\(sPadded)"
            
        case .ss:
            return totalSecondsPadded
            
        case .s:
            return "\(totalSeconds)"
            
        case .hh_mm_ss_sss:
            return "\(hPadded):\(mPadded):\(sPadded).\(msPadded)"
            
        case .h_mm_ss_sss:
            return "\(hours):\(mPadded):\(sPadded).\(msPadded)"
            
        case .mm_ss_sss:
            return "\(totalMinutesPadded):\(sPadded).\(msPadded)"
            
        case .m_ss_sss:
            return "\(totalMinutes):\(sPadded).\(msPadded)"
            
        case .ss_sss:
            return "\(totalSecondsPadded).\(msPadded)"
            
        case .s_sss:
            return "\(totalSeconds).\(msPadded)"
        }
    }
    
    private var totalSeconds: Int { (totalMinutes * 60) + seconds }
    private var totalSecondsPadded: String { totalSeconds.string(paddedTo: 2) }
    private var totalMinutes: Int { (hours * 60) + minutes }
    private var totalMinutesPadded: String { totalMinutes.string(paddedTo: 2) }
    private var hPadded: String { hours.string(paddedTo: 2) }
    private var mPadded: String { minutes.string(paddedTo: 2) }
    private var sPadded: String { seconds.string(paddedTo: 2) }
    private var msPadded: String { milliseconds.string(paddedTo: 3) }
}

extension Time {
    /// Get or set the time interval in seconds.
    public var interval: TimeInterval {
        get {
            let s = TimeInterval(totalMinutes * 60)
                + TimeInterval(seconds)
                + (TimeInterval(milliseconds) / 1000)
            return sign == .plus ? s : -s
        }
        set {
            self = Time(seconds: newValue)
        }
    }
    
    /// Get or set the time interval in milliseconds.
    public var millisecondsInterval: Int {
        get {
            let ms = (totalMinutes * 60 * 1000)
                + (seconds * 1000)
                + milliseconds
            return sign == .plus ? ms : -ms
        }
        set {
            self = Time(milliseconds: newValue)
        }
    }
}

extension Time {
    /// Returns the value of the given time component.
    public func value(of component: Component) -> Int {
        switch component {
        case .hours: hours
        case .minutes: minutes
        case .seconds: seconds
        case .milliseconds: milliseconds
        }
    }
    
    /// Sets the value of the given time component.
    public mutating func setValue(of component: Component, to newValue: Int) {
        switch component {
        case .hours: hours = newValue
        case .minutes: minutes = newValue
        case .seconds: seconds = newValue
        case .milliseconds: milliseconds = newValue
        }
    }
    
    /// Returns the string value of the given time component, optionally applying standard padding.
    public func stringValue(of component: Component, padded: Bool = false) -> String {
        switch component {
        case .hours: padded ? hPadded : "\(hours)"
        case .minutes: padded ? mPadded : "\(minutes)"
        case .seconds: padded ? sPadded : "\(seconds)"
        case .milliseconds: padded ? msPadded : "\(milliseconds)"
        }
    }
    
    /// Returns the string value of the given time component, formatted for the given time string ``Format``.
    public func stringValue(of component: Component, format: Format) -> String {
        let isPadded = format.isPadded(for: component)
        return stringValue(of: component, padded: isPadded)
    }
}

// MARK: - CustomStringConvertible

extension Time: CustomStringConvertible {
    public var description: String {
        stringValue()
    }
}

// MARK: - Static Constructors {

extension Time {
    /// Current system time.
    public static var now: Time { Time() }
    
    /// Zero time (`0:00`).
    public static let zero = Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 0, sign: .plus)
}

// MARK: - Component

extension Time {
    public enum Component {
        case hours
        case minutes
        case seconds
        case milliseconds
    }
}

extension Time.Component: Equatable { }

extension Time.Component: Hashable { }

extension Time.Component: CaseIterable { }

extension Time.Component: Sendable { }

// MARK: - Format

extension Time {
    /// **OTCore:**
    /// Enum describing a time string format.
    public enum Format: CaseIterable {
        /// Uses the shortest format that will fit the time, omitting hours if hours == 0.
        case shortest
        
        /// HH:MM:SS
        case hh_mm_ss
        
        /// H:MM:SS
        case h_mm_ss
        
        /// MM:SS
        case mm_ss
        
        /// M:SS
        case m_ss
        
        /// SS
        case ss
        
        /// S
        case s
        
        /// HH:MM:SS.sss
        case hh_mm_ss_sss
        
        /// H:MM:SS.sss
        case h_mm_ss_sss
        
        /// MM:SS.sss
        case mm_ss_sss
        
        /// M:SS.sss
        case m_ss_sss
        
        /// SS.sss
        case ss_sss
        
        /// S.sss
        case s_sss
    }
}

extension Time.Format: Identifiable {
    public var id: Self { self }
}

extension Time.Format: Sendable { }

extension Time.Format {
    func isPadded(for component: Time.Component) -> Bool {
        switch self {
        case .shortest:
            switch component {
            case .hours: false
            case .minutes: false
            case .seconds: true
            case .milliseconds: true
            }
        case .hh_mm_ss:
            switch component {
            case .hours: true
            case .minutes: true
            case .seconds: true
            case .milliseconds: true
            }
        case .h_mm_ss:
            switch component {
            case .hours: false
            case .minutes: true
            case .seconds: true
            case .milliseconds: true
            }
        case .mm_ss:
            switch component {
            case .hours: false
            case .minutes: true
            case .seconds: true
            case .milliseconds: true
            }
        case .m_ss:
            switch component {
            case .hours: false
            case .minutes: false
            case .seconds: true
            case .milliseconds: true
            }
        case .ss:
            switch component {
            case .hours: false
            case .minutes: false
            case .seconds: true
            case .milliseconds: true
            }
        case .s:
            switch component {
            case .hours: false
            case .minutes: false
            case .seconds: false
            case .milliseconds: true
            }
        case .hh_mm_ss_sss:
            switch component {
            case .hours: true
            case .minutes: true
            case .seconds: true
            case .milliseconds: true
            }
        case .h_mm_ss_sss:
            switch component {
            case .hours: false
            case .minutes: true
            case .seconds: true
            case .milliseconds: true
            }
        case .mm_ss_sss:
            switch component {
            case .hours: false
            case .minutes: true
            case .seconds: true
            case .milliseconds: true
            }
        case .m_ss_sss:
            switch component {
            case .hours: false
            case .minutes: false
            case .seconds: true
            case .milliseconds: true
            }
        case .ss_sss:
            switch component {
            case .hours: false
            case .minutes: false
            case .seconds: true
            case .milliseconds: true
            }
        case .s_sss:
            switch component {
            case .hours: false
            case .minutes: false
            case .seconds: false
            case .milliseconds: true
            }
        }
    }
}

// MARK: Math

extension Time {
    public static func + (lhs: Self, rhs: Time) -> Time {
        let ms = lhs.millisecondsInterval + rhs.millisecondsInterval
        return Time(milliseconds: ms)
    }
    
    public static func += (lhs: inout Self, rhs: Time) {
        lhs = lhs + rhs
    }
    
    public static func - (lhs: Self, rhs: Time) -> Time {
        let ms = lhs.millisecondsInterval - rhs.millisecondsInterval
        return Time(milliseconds: ms)
    }
    
    public static func -= (lhs: inout Self, rhs: Time) {
        lhs = lhs - rhs
    }
}
