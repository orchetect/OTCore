//
//  Time Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Numerics
/* @testable */ import OTCore
import Testing
import TestingExtensions

@Suite struct Abstractions_Time_Tests {
    @Test
    func time() {
        // current system time
        //
        // milliseconds will never match exactly because the time is being captured twice,
        // once in the test function and then again inside the Time() struct.
        // it is also possible that the difference between these two captures will happen
        // across a unit rollover and trigger a failed test, but this is very rare.
        
        let date = Date()
        let t = Time()
        
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let milliseconds = calendar.component(.nanosecond, from: date) / 1_000_000
        
        #expect(t.hours == hours)
        #expect(t.minutes == minutes)
        #expect(t.seconds == seconds)
        #expect(
            Double(t.milliseconds)
                .isApproximatelyEqual(to: Double(milliseconds), absoluteTolerance: 5.0) // allow +/- 5ms variance
        )
        #expect(t.sign == .plus)
    }
    
    @Test
    func timeHMS() {
        // basic
        
        let t = Time(hours: 15, minutes: 46, seconds: 20)
        
        #expect(t.hours == 15)
        #expect(t.minutes == 46)
        #expect(t.seconds == 20)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func timeHMS_Negative() {
        // basic
        
        let t = Time(hours: 15, minutes: 46, seconds: 20, sign: .minus)
        
        #expect(t.hours == 15)
        #expect(t.minutes == 46)
        #expect(t.seconds == 20)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .minus)
    }
    
    @Test
    func timeHMS_Overflow() {
        // no overflow by default; this could be modified in future to either truncate or roll up
        // values
        
        let t = Time(hours: 0, minutes: 0, seconds: 90)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 90)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_SecondsA() {
        // basic
        
        let val: Int = 20
        let t = Time(seconds: val)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 20)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_SecondsB() {
        let val: Int = (1 * 60) + 30
        let t = Time(seconds: val)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_SecondsC() {
        let val: Int = (1 * 60 * 60) + (1 * 60) + 30
        let t = Time(seconds: val)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_SecondsD() {
        let val: Double = (1 * 60 * 60) + (1 * 60) + 30.125
        let t = Time(seconds: val)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 125)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_SecondsE() {
        let val: Double = (1 * 60 * 60) + (1 * 60) + 30.125
        let t = Time(seconds: -val)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 125)
        #expect(t.sign == .minus)
    }
    
    @Test
    func time_MillisecondsA() {
        let val: Int = 20
        let t = Time(milliseconds: val)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 0)
        #expect(t.milliseconds == 20)
        #expect(t.sign == .plus)
    }
        
    @Test
    func time_MillisecondsB() {
        let val: Int = (((1 * 60) + 30) * 1000) + 200
        let t = Time(milliseconds: val)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_MillisecondsC() {
        let val: Int = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200
        let t = Time(milliseconds: val)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_MillisecondsD() {
        let val: Double = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200.7
        let t = Time(milliseconds: val)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .plus)
    }
    
    @Test
    func time_MillisecondsE() {
        let val: Double = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200.7
        let t = Time(milliseconds: -val)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .minus)
    }
    
    #if !(arch(arm) || arch(arm64_32) || arch(i386))
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func time_DurationA() {
        let duration: Duration = .milliseconds(20)
        let t = Time(duration: duration)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 0)
        #expect(t.milliseconds == 20)
        #expect(t.sign == .plus)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func time_DurationB() {
        let ms = (((1 * 60) + 30) * 1000) + 200
        let duration: Duration = .milliseconds(ms)
        let t = Time(duration: duration)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .plus)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func time_DurationC() {
        let ms = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200
        let duration: Duration = .milliseconds(ms)
        let t = Time(duration: duration)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .plus)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func time_DurationD() {
        let ms: Double = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200.7
        let duration: Duration = .milliseconds(ms)
        let t = Time(duration: duration)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .plus)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func time_DurationE() {
        let ms = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200
        let duration: Duration = .milliseconds(-ms)
        let t = Time(duration: duration)
        
        #expect(t.hours == 1)
        #expect(t.minutes == 1)
        #expect(t.seconds == 30)
        #expect(t.milliseconds == 200)
        #expect(t.sign == .minus)
    }
    
    #endif
    
    /// default CustomStringConvertible
    @Test
    func timeStringValue_Default() {
        let t = Time(hours: 5, minutes: 46, seconds: 20, milliseconds: 49)
        #expect("\(t)" == "5:46:20")
    }
    
    @Test
    func initString() {
        // main components
        #expect(Time(string: "0") == Time(hours: 0, minutes: 0, seconds: 0))
        #expect(Time(string: "00") == Time(hours: 0, minutes: 0, seconds: 0))
        #expect(Time(string: "1") == Time(hours: 0, minutes: 0, seconds: 1))
        #expect(Time(string: "10") == Time(hours: 0, minutes: 0, seconds: 10))
        #expect(Time(string: "123") == Time(hours: 0, minutes: 0, seconds: 123))
        #expect(Time(string: "0:00") == Time(hours: 0, minutes: 0, seconds: 0))
        #expect(Time(string: "0:01") == Time(hours: 0, minutes: 0, seconds: 1))
        #expect(Time(string: "1:00") == Time(hours: 0, minutes: 1, seconds: 0))
        #expect(Time(string: "1:01") == Time(hours: 0, minutes: 1, seconds: 1))
        #expect(Time(string: "01:00") == Time(hours: 0, minutes: 1, seconds: 0))
        #expect(Time(string: "10:00") == Time(hours: 0, minutes: 10, seconds: 0))
        #expect(Time(string: "12:34") == Time(hours: 0, minutes: 12, seconds: 34))
        #expect(Time(string: "1:00:00") == Time(hours: 1, minutes: 0, seconds: 0))
        #expect(Time(string: "01:00:00") == Time(hours: 1, minutes: 0, seconds: 0))
        #expect(Time(string: "12:34:56") == Time(hours: 12, minutes: 34, seconds: 56))
        #expect(Time(string: "123:45:56") == Time(hours: 123, minutes: 45, seconds: 56))
        
        // with milliseconds
        #expect(Time(string: "0.000") == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 000))
        #expect(Time(string: "00.000") == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 000))
        #expect(Time(string: "1.123") == Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 123))
        #expect(Time(string: "10.000") == Time(hours: 0, minutes: 0, seconds: 10, milliseconds: 000))
        #expect(Time(string: "0:00.000") == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 000))
        #expect(Time(string: "0:01.123") == Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 123))
        #expect(Time(string: "1:00.000") == Time(hours: 0, minutes: 1, seconds: 0, milliseconds: 000))
        #expect(Time(string: "1:01.123") == Time(hours: 0, minutes: 1, seconds: 1, milliseconds: 123))
        #expect(Time(string: "01:00.000") == Time(hours: 0, minutes: 1, seconds: 0, milliseconds: 000))
        #expect(Time(string: "10:00.123") == Time(hours: 0, minutes: 10, seconds: 0, milliseconds: 123))
        #expect(Time(string: "12:34.123") == Time(hours: 0, minutes: 12, seconds: 34, milliseconds: 123))
        #expect(Time(string: "1:00:00.000") == Time(hours: 1, minutes: 0, seconds: 0, milliseconds: 000))
        #expect(Time(string: "01:00:00.000") == Time(hours: 1, minutes: 0, seconds: 0, milliseconds: 000))
        #expect(Time(string: "12:34:56.123") == Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 123))
        #expect(Time(string: "123:45:56.123") == Time(hours: 123, minutes: 45, seconds: 56, milliseconds: 123))
        
        // negative
        #expect(Time(string: "-0:00") == Time(hours: 0, minutes: 0, seconds: 0, sign: .minus))
        #expect(Time(string: "-0:01") == Time(hours: 0, minutes: 0, seconds: 1, sign: .minus))
        #expect(Time(string: "-123:45:56") == Time(hours: 123, minutes: 45, seconds: 56, milliseconds: 000, sign: .minus))
        #expect(Time(string: "-123:45:56.123") == Time(hours: 123, minutes: 45, seconds: 56, milliseconds: 123, sign: .minus))
        
        // invalid / edge cases
        #expect(Time(string: "") == nil)
        #expect(Time(string: ":") == nil)
        #expect(Time(string: ".") == nil)
        #expect(Time(string: ":.") == nil)
        #expect(Time(string: "::") == nil)
        #expect(Time(string: "::.") == nil)
        #expect(Time(string: " ") == nil)
        #expect(Time(string: "-") == nil)
        #expect(Time(string: "-:") == nil)
        #expect(Time(string: " 123:45:56.123") == nil)
        #expect(Time(string: "123:45:56.123 ") == nil)
        #expect(Time(string: " 123:45:56.123 ") == nil)
        #expect(Time(string: "A") == nil)
        #expect(Time(string: "A:BC") == nil)
        #expect(Time(string: "-A") == nil)
        #expect(Time(string: "-A:BC") == nil)
        #expect(Time(string: "A.BCD") == nil)
        #expect(Time(string: "A:BC.DEF") == nil)
        #expect(Time(string: "--0:00") == nil)
        #expect(Time(string: "0:00:00:000") == nil)
        #expect(Time(string: "0.00.00.000") == nil)
        #expect(Time(string: "0::00::00.000") == nil)
        #expect(Time(string: "0::00::00..000") == nil)
        #expect(Time(string: "0:00:00..000") == nil)
        
        // allowable edge cases
        #expect(Time(string: "123") != nil)
        #expect(Time(string: "123.456") != nil)
        #expect(Time(string: "0:123") != nil)
        #expect(Time(string: "0:123.456") != nil)
        #expect(Time(string: "123:45") != nil)
        #expect(Time(string: "123:45.456") != nil)
        #expect(Time(string: "123:456") != nil)
        #expect(Time(string: "123:456.789") != nil)
    }
    
    @Test
    func timeStringValueA() {
        let t = Time(hours: 15, minutes: 46, seconds: 20, milliseconds: 49)
        
        for fmt in Time.Format.allCases {
            let str: String = {
                switch fmt {
                case .shortest:     return "15:46:20"
                case .hh_mm_ss:     return "15:46:20"
                case .h_mm_ss:      return "15:46:20"
                case .mm_ss:        return "946:20"
                case .m_ss:         return "946:20"
                case .ss:           return "56780"
                case .s:            return "56780"
                case .hh_mm_ss_sss: return "15:46:20.049"
                case .h_mm_ss_sss:  return "15:46:20.049"
                case .mm_ss_sss:    return "946:20.049"
                case .m_ss_sss:     return "946:20.049"
                case .ss_sss:       return "56780.049"
                case .s_sss:        return "56780.049"
                }
            }()
            
            #expect(t.stringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test
    func timeStringValueB() {
        let t = Time(hours: 5, minutes: 6, seconds: 20)
        
        for fmt in Time.Format.allCases {
            let str: String = {
                switch fmt {
                case .shortest:     return "5:06:20"
                case .hh_mm_ss:     return "05:06:20"
                case .h_mm_ss:      return "5:06:20"
                case .mm_ss:        return "306:20"
                case .m_ss:         return "306:20"
                case .ss:           return "18380"
                case .s:            return "18380"
                case .hh_mm_ss_sss: return "05:06:20.000"
                case .h_mm_ss_sss:  return "5:06:20.000"
                case .mm_ss_sss:    return "306:20.000"
                case .m_ss_sss:     return "306:20.000"
                case .ss_sss:       return "18380.000"
                case .s_sss:        return "18380.000"
                }
            }()
            
            #expect(t.stringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test
    func timeStringValue_Zero() {
        let t = Time(hours: 0, minutes: 0, seconds: 0)
        
        for fmt in Time.Format.allCases {
            let str: String = {
                switch fmt {
                case .shortest:     return "0:00"
                case .hh_mm_ss:     return "00:00:00"
                case .h_mm_ss:      return "0:00:00"
                case .mm_ss:        return "00:00"
                case .m_ss:         return "0:00"
                case .ss:           return "00"
                case .s:            return "0"
                case .hh_mm_ss_sss: return "00:00:00.000"
                case .h_mm_ss_sss:  return "0:00:00.000"
                case .mm_ss_sss:    return "00:00.000"
                case .m_ss_sss:     return "0:00.000"
                case .ss_sss:       return "00.000"
                case .s_sss:        return "0.000"
                }
            }()
            
            #expect(t.stringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test
    func timeStringValue_Negative() {
        let t = Time(hours: 0, minutes: 0, seconds: 20, sign: .minus)
        
        for fmt in Time.Format.allCases {
            let str: String = {
                switch fmt {
                case .shortest:     return "-0:20"
                case .hh_mm_ss:     return "-00:00:20"
                case .h_mm_ss:      return "-0:00:20"
                case .mm_ss:        return "-00:20"
                case .m_ss:         return "-0:20"
                case .ss:           return "-20"
                case .s:            return "-20"
                case .hh_mm_ss_sss: return "-00:00:20.000"
                case .h_mm_ss_sss:  return "-0:00:20.000"
                case .mm_ss_sss:    return "-00:20.000"
                case .m_ss_sss:     return "-0:20.000"
                case .ss_sss:       return "-20.000"
                case .s_sss:        return "-20.000"
                }
            }()
            
            #expect(t.stringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test
    func timeStringValue_Shortest() {
        // shortest
        
        let t = Time(hours: 5, minutes: 6, seconds: 20)
        #expect(t.stringValue(format: .shortest) == "5:06:20")
        
        let u = Time(hours: 0, minutes: 6, seconds: 20)
        #expect(u.stringValue(format: .shortest) == "6:20")
        
        let v = Time(hours: 0, minutes: 0, seconds: 20)
        #expect(v.stringValue(format: .shortest) == "0:20")
        
        let w = Time(hours: 0, minutes: 0, seconds: 00)
        #expect(w.stringValue(format: .shortest) == "0:00")
    }
    
    #if !(arch(arm) || arch(arm64_32) || arch(i386))
    
    @Test(.enabled(ifLocaleLanguageCode: .english))
    func timeLocalizedStringValueA() {
        let t = Time(hours: 15, minutes: 46, seconds: 20, milliseconds: 49)
        
        for fmt in Time.Format.allCases {
            let str: String = switch fmt {
            case .shortest:     "15:46:20"
            case .hh_mm_ss:     "15:46:20"
            case .h_mm_ss:      "15:46:20"
            case .mm_ss:        "946:20"
            case .m_ss:         "946:20"
            case .ss:           "56780"
            case .s:            "56780"
            case .hh_mm_ss_sss: "15:46:20.049"
            case .h_mm_ss_sss:  "15:46:20.049"
            case .mm_ss_sss:    "946:20.049"
            case .m_ss_sss:     "946:20.049"
            case .ss_sss:       "56780.049"
            case .s_sss:        "56780.049"
            }
            
            #expect(t.localizedStringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test(.enabled(ifLocaleLanguageCode: .english))
    func timeLocalizedStringValueB() {
        let t = Time(hours: 5, minutes: 6, seconds: 20)
        
        for fmt in Time.Format.allCases {
            let str: String = switch fmt {
            case .shortest:     "5:06:20"
            case .hh_mm_ss:     "05:06:20"
            case .h_mm_ss:      "5:06:20"
            case .mm_ss:        "306:20"
            case .m_ss:         "306:20"
            case .ss:           "18380"
            case .s:            "18380"
            case .hh_mm_ss_sss: "05:06:20.000"
            case .h_mm_ss_sss:  "5:06:20.000"
            case .mm_ss_sss:    "306:20.000"
            case .m_ss_sss:     "306:20.000"
            case .ss_sss:       "18380.000"
            case .s_sss:        "18380.000"
            }
            
            #expect(t.localizedStringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test(.enabled(ifLocaleLanguageCode: .english))
    func timeLocalizedStringValue_Zero() {
        let t = Time(hours: 0, minutes: 0, seconds: 0)
        
        for fmt in Time.Format.allCases {
            let str: String = switch fmt {
            case .shortest:     "0:00"
            case .hh_mm_ss:     "00:00:00"
            case .h_mm_ss:      "0:00:00"
            case .mm_ss:        "00:00"
            case .m_ss:         "0:00"
            case .ss:           "00"
            case .s:            "0"
            case .hh_mm_ss_sss: "00:00:00.000"
            case .h_mm_ss_sss:  "0:00:00.000"
            case .mm_ss_sss:    "00:00.000"
            case .m_ss_sss:     "0:00.000"
            case .ss_sss:       "00.000"
            case .s_sss:        "0.000"
            }
            
            #expect(t.localizedStringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test(.enabled(ifLocaleLanguageCode: .english))
    func timeLocalizedStringValue_Negative() {
        let t = Time(hours: 0, minutes: 0, seconds: 20, sign: .minus)
        
        for fmt in Time.Format.allCases {
            let str: String = switch fmt {
            case .shortest:     "-0:20"
            case .hh_mm_ss:     "-00:00:20"
            case .h_mm_ss:      "-0:00:20"
            case .mm_ss:        "-00:20"
            case .m_ss:         "-0:20"
            case .ss:           "-20"
            case .s:            "-20"
            case .hh_mm_ss_sss: "-00:00:20.000"
            case .h_mm_ss_sss:  "-0:00:20.000"
            case .mm_ss_sss:    "-00:20.000"
            case .m_ss_sss:     "-0:20.000"
            case .ss_sss:       "-20.000"
            case .s_sss:        "-20.000"
            }
            
            #expect(t.localizedStringValue(format: fmt) == str, "\(fmt)")
        }
    }
    
    @Test(.enabled(ifLocaleLanguageCode: .english))
    func timeLocalizedStringValue_Shortest() {
        // shortest
        
        let t = Time(hours: 5, minutes: 6, seconds: 20)
        #expect(t.stringValue(format: .shortest) == "5:06:20")
        
        let u = Time(hours: 0, minutes: 6, seconds: 20)
        #expect(u.stringValue(format: .shortest) == "6:20")
        
        let v = Time(hours: 0, minutes: 0, seconds: 20)
        #expect(v.stringValue(format: .shortest) == "0:20")
        
        let w = Time(hours: 0, minutes: 0, seconds: 00)
        #expect(w.stringValue(format: .shortest) == "0:00")
    }
    
    /// Spot-check a handful of locales and formats to ensure formats are localized.
    @Test
    func timeLocalizedStringValue_VariousLocales() {
        // German / Germany
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .s, locale: .init(identifier: "de_DE")) == "3723")
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .s_sss, locale: .init(identifier: "de_DE")) == "3723,000")
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .h_mm_ss, locale: .init(identifier: "de_DE")) == "1:02:03")
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .h_mm_ss_sss, locale: .init(identifier: "de_DE")) == "1:02:03,000")
        
        // Finnish / Finland
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .s, locale: .init(identifier: "fi_FI")) == "3723")
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .s_sss, locale: .init(identifier: "fi_FI")) == "3723,000")
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .h_mm_ss, locale: .init(identifier: "fi_FI")) == "1.02.03")
        #expect(Time(hours: 1, minutes: 2, seconds: 3).localizedStringValue(format: .h_mm_ss_sss, locale: .init(identifier: "fi_FI")) == "1.02.03,000")
    }
    
    #endif
    
    @Test
    func intervalGet() {
        #expect(
            Time(hours: 0, minutes: 0, seconds: 0).interval
                == 0.0
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20).interval
                == 18380.0
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5).interval
                == 18380.005
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5, sign: .minus).interval
                == -18380.005
        )
    }
    
    @Test
    func millisecondsIntervalGet() {
        #expect(
            Time(hours: 0, minutes: 0, seconds: 0).millisecondsInterval
                == 0
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20).millisecondsInterval
                == 18380000
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5).millisecondsInterval
                == 18380005
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5, sign: .minus).millisecondsInterval
                == -18380005
        )
    }
    
    #if !(arch(arm) || arch(arm64_32) || arch(i386))
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func durationIntervalGet() {
        #expect(
            Time(hours: 0, minutes: 0, seconds: 0).durationInterval
                == .milliseconds(0)
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20).durationInterval
                == .milliseconds(18380000)
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5).durationInterval
                == .milliseconds(18380005)
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5, sign: .minus).durationInterval
                == .milliseconds(-18380005)
        )
    }
    #endif
    
    @Test
    func intervalSetA() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = 50
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 50)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func intervalSetB() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = 18380.005
        
        #expect(t.hours == 5)
        #expect(t.minutes == 6)
        #expect(t.seconds == 20)
        #expect(t.milliseconds == 5)
        #expect(t.sign == .plus)
    }
    
    @Test
    func intervalSetC() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = 0.0
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 0)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func intervalSetD() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = -40.0
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 40)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .minus)
    }
    
    @Test
    func millisecondsIntervalSetA() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = 50_000
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 50)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func millisecondsIntervalSetB() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = 18_380_005
        
        #expect(t.hours == 5)
        #expect(t.minutes == 6)
        #expect(t.seconds == 20)
        #expect(t.milliseconds == 5)
        #expect(t.sign == .plus)
    }
    
    @Test
    func millisecondsIntervalSetC() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = 0
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 0)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @Test
    func millisecondsIntervalSetD() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = -40_000
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 40)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .minus)
    }
    
    #if !(arch(arm) || arch(arm64_32) || arch(i386))
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func durationIntervalSetA() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.durationInterval = .milliseconds(50_000)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 50)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func durationIntervalSetB() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.durationInterval = .milliseconds(18_380_005)
        
        #expect(t.hours == 5)
        #expect(t.minutes == 6)
        #expect(t.seconds == 20)
        #expect(t.milliseconds == 5)
        #expect(t.sign == .plus)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func durationIntervalSetC() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.durationInterval = .milliseconds(0)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 0)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .plus)
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func durationIntervalSetD() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.durationInterval = .milliseconds(-40_000)
        
        #expect(t.hours == 0)
        #expect(t.minutes == 0)
        #expect(t.seconds == 40)
        #expect(t.milliseconds == 0)
        #expect(t.sign == .minus)
    }
    #endif
    
    @Test
    func valueOfComponent() {
        #expect(Time(seconds: 0).value(of: .hours) == 0)
        #expect(Time(seconds: 0).value(of: .minutes) == 0)
        #expect(Time(seconds: 0).value(of: .seconds) == 0)
        #expect(Time(seconds: 0).value(of: .milliseconds) == 0)
        
        #expect(Time(seconds: 4547.175).value(of: .hours) == 1)
        #expect(Time(seconds: 4547.175).value(of: .minutes) == 15)
        #expect(Time(seconds: 4547.175).value(of: .seconds) == 47)
        #expect(Time(seconds: 4547.175).value(of: .milliseconds) == 175)
        
        #expect(Time(seconds: -4547.175).value(of: .hours) == 1)
        #expect(Time(seconds: -4547.175).value(of: .minutes) == 15)
        #expect(Time(seconds: -4547.175).value(of: .seconds) == 47)
        #expect(Time(seconds: -4547.175).value(of: .milliseconds) == 175)
    }
    
    @Test
    func setValueOfComponent() {
        var time = Time(seconds: 0)
        
        time.setValue(of: .hours, to: 2)
        #expect(time.value(of: .hours) == 2)
        #expect(time.value(of: .minutes) == 0)
        #expect(time.value(of: .seconds) == 0)
        #expect(time.value(of: .milliseconds) == 0)
        
        time.setValue(of: .minutes, to: 47)
        #expect(time.value(of: .hours) == 2)
        #expect(time.value(of: .minutes) == 47)
        #expect(time.value(of: .seconds) == 0)
        #expect(time.value(of: .milliseconds) == 0)
        
        time.setValue(of: .seconds, to: 15)
        #expect(time.value(of: .hours) == 2)
        #expect(time.value(of: .minutes) == 47)
        #expect(time.value(of: .seconds) == 15)
        #expect(time.value(of: .milliseconds) == 0)
        
        time.setValue(of: .milliseconds, to: 175)
        #expect(time.value(of: .hours) == 2)
        #expect(time.value(of: .minutes) == 47)
        #expect(time.value(of: .seconds) == 15)
        #expect(time.value(of: .milliseconds) == 175)
        
        time.setValue(of: .hours, to: 4)
        time.setValue(of: .minutes, to: 2)
        time.setValue(of: .seconds, to: 32)
        time.setValue(of: .milliseconds, to: 950)
        #expect(time.value(of: .hours) == 4)
        #expect(time.value(of: .minutes) == 2)
        #expect(time.value(of: .seconds) == 32)
        #expect(time.value(of: .milliseconds) == 950)
    }
    
    @Test
    func stringValueOfComponentPadded() {
        #expect(Time(seconds: 0).stringValue(of: .hours, padded: false) == "0")
        #expect(Time(seconds: 0).stringValue(of: .minutes, padded: false) == "0")
        #expect(Time(seconds: 0).stringValue(of: .seconds, padded: false) == "0")
        #expect(Time(seconds: 0).stringValue(of: .milliseconds, padded: false) == "0")
        
        #expect(Time(seconds: 0).stringValue(of: .hours, padded: true) == "00")
        #expect(Time(seconds: 0).stringValue(of: .minutes, padded: true) == "00")
        #expect(Time(seconds: 0).stringValue(of: .seconds, padded: true) == "00")
        #expect(Time(seconds: 0).stringValue(of: .milliseconds, padded: true) == "000")
        
        #expect(Time(seconds: 4547.050).stringValue(of: .hours, padded: false) == "1")
        #expect(Time(seconds: 4547.050).stringValue(of: .minutes, padded: false) == "15")
        #expect(Time(seconds: 4547.050).stringValue(of: .seconds, padded: false) == "47")
        #expect(Time(seconds: 4547.050).stringValue(of: .milliseconds, padded: false) == "50")
        
        #expect(Time(seconds: 4547.050).stringValue(of: .hours, padded: true) == "01")
        #expect(Time(seconds: 4547.050).stringValue(of: .minutes, padded: true) == "15")
        #expect(Time(seconds: 4547.050).stringValue(of: .seconds, padded: true) == "47")
        #expect(Time(seconds: 4547.050).stringValue(of: .milliseconds, padded: true) == "050")
    }
    
    @Test
    func stringValueOfComponentForFormat() {
        #expect(Time(seconds: 0).stringValue(of: .hours, format: .shortest) == "0")
        #expect(Time(seconds: 0).stringValue(of: .minutes, format: .shortest) == "0")
        #expect(Time(seconds: 0).stringValue(of: .seconds, format: .shortest) == "00")
        #expect(Time(seconds: 0).stringValue(of: .milliseconds, format: .shortest) == "000")
        
        #expect(Time(seconds: 4547.050).stringValue(of: .hours, format: .h_mm_ss_sss) == "1")
        #expect(Time(seconds: 4547.050).stringValue(of: .minutes, format: .h_mm_ss_sss) == "15")
        #expect(Time(seconds: 4547.050).stringValue(of: .seconds, format: .h_mm_ss_sss) == "47")
        #expect(Time(seconds: 4547.050).stringValue(of: .milliseconds, format: .h_mm_ss_sss) == "050")
        
        #expect(Time(seconds: 4547.050).stringValue(of: .hours, format: .hh_mm_ss_sss) == "01")
        #expect(Time(seconds: 4547.050).stringValue(of: .minutes, format: .hh_mm_ss_sss) == "15")
        #expect(Time(seconds: 4547.050).stringValue(of: .seconds, format: .hh_mm_ss_sss) == "47")
        #expect(Time(seconds: 4547.050).stringValue(of: .milliseconds, format: .hh_mm_ss_sss) == "050")
    }
    
    @Test
    func equatable() {
        #expect(Time(seconds: 20) == Time(seconds: 20))
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                == Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
        )
        #expect(
            Time(hours: 0, minutes: 0, seconds: 0, sign: .plus)
                == Time(hours: 0, minutes: 0, seconds: 0, sign: .minus) // functionally equivalent
        )
        
        #expect(Time(seconds: 10) != Time(seconds: 20))
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                != Time(hours: 4, minutes: 6, seconds: 20, milliseconds: 5)
        )
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                != Time(hours: 5, minutes: 5, seconds: 20, milliseconds: 5)
        )
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                != Time(hours: 5, minutes: 6, seconds: 10, milliseconds: 5)
        )
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                != Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 4)
        )
    }
    
    @Test
    func comparable() {
        #expect(Time(seconds: 20) > Time(seconds: 10))
        #expect(!(Time(seconds: 10) > Time(seconds: 20)))
        
        #expect(!(Time(seconds: 20) < Time(seconds: 10)))
        #expect(Time(seconds: 10) < Time(seconds: 20))
        
        #expect(!(Time(seconds: 20) > Time(seconds: 20)))
        #expect(!(Time(seconds: 20) < Time(seconds: 20)))
    }
    
    @Test
    func add() {
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                + Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
                == Time(hours: 6, minutes: 8, seconds: 23, milliseconds: 9)
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                + Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4 + 1000)
                == Time(hours: 6, minutes: 8, seconds: 23 + 1, milliseconds: 9)
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                + Time.zero
                == Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
        )
        
        #expect(
            Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
                + Time(milliseconds: 1)
                == Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
        )
        
        #expect(
            Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
                + Time(milliseconds: -1)
                == Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        )
        
        #expect(
            Time.zero
                + Time(milliseconds: -1)
                == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 1, sign: .minus)
        )
    }
    
    @Test
    func addAssign() {
        var time = Time.zero
        
        time += .zero
        #expect(time == .zero)
        
        time += Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        #expect(time == Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
        
        time += Time(milliseconds: 1)
        #expect(time == Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0))
        
        time += Time(milliseconds: -1)
        #expect(time == Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
    }
    
    @Test
    func subtract() {
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                - Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
                == Time(hours: 4, minutes: 4, seconds: 17, milliseconds: 1)
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                - Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4 + 1000)
                == Time(hours: 4, minutes: 4, seconds: 16, milliseconds: 1)
        )
        
        #expect(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                - Time.zero
                == Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
        )
        
        #expect(
            Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
                - Time(milliseconds: 1)
                == Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        )
        
        #expect(
            Time.zero
                - Time(milliseconds: 1)
                == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 1, sign: .minus)
        )
    }
    
    @Test
    func subtractAssign() {
        var time = Time.zero
        
        time -= .zero
        #expect(time == .zero)
        
        time = Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
        time -= Time(milliseconds: 1)
        #expect(time == Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
        
        time -= Time(milliseconds: -1)
        #expect(time == Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0))
    }
    
    @Test
    func multiplyAssign() {
        var time = Time.zero
        
        time *= 0 // int
        #expect(time == .zero)
        
        time *= 0.0 // floating-point
        #expect(time == .zero)
        
        time = Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        time *= 2 // int
        #expect(time == Time(hours: 9, minutes: 59, seconds: 59, milliseconds: 998))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time *= 2.5 // floating-point
        #expect(time == Time(hours: 3, minutes: 45, seconds: 00, milliseconds: 0))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time *= 0.5 // floating-point
        #expect(time == Time(hours: 0, minutes: 45, seconds: 00, milliseconds: 0))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time *= -0.5 // floating-point
        #expect(time == Time(hours: 0, minutes: 45, seconds: 00, milliseconds: 0, sign: .minus))
    }
    
    @Test
    func divideAssign() {
        var time = Time.zero
        
        time = Time(hours: 9, minutes: 59, seconds: 59, milliseconds: 998)
        time /= 2 // int
        #expect(time == Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
        
        time = Time(hours: 3, minutes: 45, seconds: 00, milliseconds: 0)
        time /= 2.5 // floating-point
        #expect(time == Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0))
        
        time = Time(hours: 0, minutes: 45, seconds: 00, milliseconds: 0)
        time /= 0.5 // floating-point
        #expect(time == Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time /= -0.5 // floating-point
        #expect(time == Time(hours: 3, minutes: 0, seconds: 00, milliseconds: 0, sign: .minus))
    }
}
