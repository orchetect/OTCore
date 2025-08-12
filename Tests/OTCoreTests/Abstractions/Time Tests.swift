//
//  Time Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/* @testable */ import OTCore
import XCTest

final class Abstractions_Time_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testTime() {
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
        
        XCTAssertEqual(t.hours, hours)
        XCTAssertEqual(t.minutes, minutes)
        XCTAssertEqual(t.seconds, seconds)
        XCTAssertEqual(
            Double(t.milliseconds),
            Double(milliseconds),
            accuracy: 5.0
        ) // allow +/- 5ms variance
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTimeHMS() {
        // basic
        
        let t = Time(hours: 15, minutes: 46, seconds: 20)
        
        XCTAssertEqual(t.hours, 15)
        XCTAssertEqual(t.minutes, 46)
        XCTAssertEqual(t.seconds, 20)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTimeHMS_Negative() {
        // basic
        
        let t = Time(hours: 15, minutes: 46, seconds: 20, sign: .minus)
        
        XCTAssertEqual(t.hours, 15)
        XCTAssertEqual(t.minutes, 46)
        XCTAssertEqual(t.seconds, 20)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .minus)
    }
    
    func testTimeHMS_Overflow() {
        // no overflow by default; this could be modified in future to either truncate or roll up
        // values
        
        let t = Time(hours: 0, minutes: 0, seconds: 90)
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 90)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_SecondsA() {
        // basic
        
        let val: Int = 20
        let t = Time(seconds: val)
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 20)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_SecondsB() {
        let val: Int = (1 * 60) + 30
        let t = Time(seconds: val)
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_SecondsC() {
        let val: Int = (1 * 60 * 60) + (1 * 60) + 30
        let t = Time(seconds: val)
        
        XCTAssertEqual(t.hours, 1)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_SecondsD() {
        let val: Double = (1 * 60 * 60) + (1 * 60) + 30.125
        let t = Time(seconds: val)
        
        XCTAssertEqual(t.hours, 1)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 125)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_SecondsE() {
        let val: Double = (1 * 60 * 60) + (1 * 60) + 30.125
        let t = Time(seconds: -val)
        
        XCTAssertEqual(t.hours, 1)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 125)
        XCTAssertEqual(t.sign, .minus)
    }
    
    func testTime_MillisecondsA() {
        let val: Int = 20
        let t = Time(milliseconds: val)
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 0)
        XCTAssertEqual(t.milliseconds, 20)
        XCTAssertEqual(t.sign, .plus)
    }
        
    func testTime_MillisecondsB() {
        let val: Int = (((1 * 60) + 30) * 1000) + 200
        let t = Time(milliseconds: val)
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 200)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_MillisecondsC() {
        let val: Int = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200
        let t = Time(milliseconds: val)
        
        XCTAssertEqual(t.hours, 1)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 200)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_MillisecondsD() {
        let val: Double = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200.7
        let t = Time(milliseconds: val)
        
        XCTAssertEqual(t.hours, 1)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 200)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testTime_MillisecondsE() {
        let val: Double = (((1 * 60 * 60) + (1 * 60) + 30) * 1000) + 200.7
        let t = Time(milliseconds: -val)
        
        XCTAssertEqual(t.hours, 1)
        XCTAssertEqual(t.minutes, 1)
        XCTAssertEqual(t.seconds, 30)
        XCTAssertEqual(t.milliseconds, 200)
        XCTAssertEqual(t.sign, .minus)
    }
    
    /// default CustomStringConvertible
    func testTimeStringValue_Default() {
        let t = Time(hours: 5, minutes: 46, seconds: 20, milliseconds: 49)
        XCTAssertEqual("\(t)", "5:46:20")
    }
    
    func testInitString() {
        // main components
        XCTAssert(Time(string: "0") == Time(hours: 0, minutes: 0, seconds: 0))
        XCTAssert(Time(string: "00") == Time(hours: 0, minutes: 0, seconds: 0))
        XCTAssert(Time(string: "1") == Time(hours: 0, minutes: 0, seconds: 1))
        XCTAssert(Time(string: "10") == Time(hours: 0, minutes: 0, seconds: 10))
        XCTAssert(Time(string: "123") == Time(hours: 0, minutes: 0, seconds: 123))
        XCTAssert(Time(string: "0:00") == Time(hours: 0, minutes: 0, seconds: 0))
        XCTAssert(Time(string: "0:01") == Time(hours: 0, minutes: 0, seconds: 1))
        XCTAssert(Time(string: "1:00") == Time(hours: 0, minutes: 1, seconds: 0))
        XCTAssert(Time(string: "1:01") == Time(hours: 0, minutes: 1, seconds: 1))
        XCTAssert(Time(string: "01:00") == Time(hours: 0, minutes: 1, seconds: 0))
        XCTAssert(Time(string: "10:00") == Time(hours: 0, minutes: 10, seconds: 0))
        XCTAssert(Time(string: "12:34") == Time(hours: 0, minutes: 12, seconds: 34))
        XCTAssert(Time(string: "1:00:00") == Time(hours: 1, minutes: 0, seconds: 0))
        XCTAssert(Time(string: "01:00:00") == Time(hours: 1, minutes: 0, seconds: 0))
        XCTAssert(Time(string: "12:34:56") == Time(hours: 12, minutes: 34, seconds: 56))
        XCTAssert(Time(string: "123:45:56") == Time(hours: 123, minutes: 45, seconds: 56))
        
        // with milliseconds
        XCTAssert(Time(string: "0.000") == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 000))
        XCTAssert(Time(string: "00.000") == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 000))
        XCTAssert(Time(string: "1.123") == Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 123))
        XCTAssert(Time(string: "10.000") == Time(hours: 0, minutes: 0, seconds: 10, milliseconds: 000))
        XCTAssert(Time(string: "0:00.000") == Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 000))
        XCTAssert(Time(string: "0:01.123") == Time(hours: 0, minutes: 0, seconds: 1, milliseconds: 123))
        XCTAssert(Time(string: "1:00.000") == Time(hours: 0, minutes: 1, seconds: 0, milliseconds: 000))
        XCTAssert(Time(string: "1:01.123") == Time(hours: 0, minutes: 1, seconds: 1, milliseconds: 123))
        XCTAssert(Time(string: "01:00.000") == Time(hours: 0, minutes: 1, seconds: 0, milliseconds: 000))
        XCTAssert(Time(string: "10:00.123") == Time(hours: 0, minutes: 10, seconds: 0, milliseconds: 123))
        XCTAssert(Time(string: "12:34.123") == Time(hours: 0, minutes: 12, seconds: 34, milliseconds: 123))
        XCTAssert(Time(string: "1:00:00.000") == Time(hours: 1, minutes: 0, seconds: 0, milliseconds: 000))
        XCTAssert(Time(string: "01:00:00.000") == Time(hours: 1, minutes: 0, seconds: 0, milliseconds: 000))
        XCTAssert(Time(string: "12:34:56.123") == Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 123))
        XCTAssert(Time(string: "123:45:56.123") == Time(hours: 123, minutes: 45, seconds: 56, milliseconds: 123))
        
        // negative
        XCTAssert(Time(string: "-0:00") == Time(hours: 0, minutes: 0, seconds: 0, sign: .minus))
        XCTAssert(Time(string: "-0:01") == Time(hours: 0, minutes: 0, seconds: 1, sign: .minus))
        XCTAssert(Time(string: "-123:45:56") == Time(hours: 123, minutes: 45, seconds: 56, milliseconds: 000, sign: .minus))
        XCTAssert(Time(string: "-123:45:56.123") == Time(hours: 123, minutes: 45, seconds: 56, milliseconds: 123, sign: .minus))
        
        // invalid / edge cases
        XCTAssert(Time(string: "") == nil)
        XCTAssert(Time(string: ":") == nil)
        XCTAssert(Time(string: ".") == nil)
        XCTAssert(Time(string: ":.") == nil)
        XCTAssert(Time(string: "::") == nil)
        XCTAssert(Time(string: "::.") == nil)
        XCTAssert(Time(string: " ") == nil)
        XCTAssert(Time(string: "-") == nil)
        XCTAssert(Time(string: "-:") == nil)
        XCTAssert(Time(string: " 123:45:56.123") == nil)
        XCTAssert(Time(string: "123:45:56.123 ") == nil)
        XCTAssert(Time(string: " 123:45:56.123 ") == nil)
        XCTAssert(Time(string: "A") == nil)
        XCTAssert(Time(string: "A:BC") == nil)
        XCTAssert(Time(string: "-A") == nil)
        XCTAssert(Time(string: "-A:BC") == nil)
        XCTAssert(Time(string: "A.BCD") == nil)
        XCTAssert(Time(string: "A:BC.DEF") == nil)
        XCTAssert(Time(string: "--0:00") == nil)
        XCTAssert(Time(string: "0:00:00:000") == nil)
        XCTAssert(Time(string: "0.00.00.000") == nil)
        XCTAssert(Time(string: "0::00::00.000") == nil)
        XCTAssert(Time(string: "0::00::00..000") == nil)
        XCTAssert(Time(string: "0:00:00..000") == nil)
        
        // allowable edge cases
        XCTAssert(Time(string: "123") != nil)
        XCTAssert(Time(string: "123.456") != nil)
        XCTAssert(Time(string: "0:123") != nil)
        XCTAssert(Time(string: "0:123.456") != nil)
        XCTAssert(Time(string: "123:45") != nil)
        XCTAssert(Time(string: "123:45.456") != nil)
        XCTAssert(Time(string: "123:456") != nil)
        XCTAssert(Time(string: "123:456.789") != nil)
    }
    
    func testTimeStringValueA() {
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
            
            XCTAssertEqual(t.stringValue(format: fmt), str, "\(fmt)")
        }
    }
    
    func testTimeStringValueB() {
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
            
            XCTAssertEqual(t.stringValue(format: fmt), str, "\(fmt)")
        }
    }
    
    func testTimeStringValue_Zero() {
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
            
            XCTAssertEqual(t.stringValue(format: fmt), str, "\(fmt)")
        }
    }
    
    func testTimeStringValue_Negative() {
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
            
            XCTAssertEqual(t.stringValue(format: fmt), str, "\(fmt)")
        }
    }
    
    func testTimeStringValue_Shortest() {
        // shortest
        
        let t = Time(hours: 5, minutes: 6, seconds: 20)
        XCTAssertEqual(t.stringValue(format: .shortest), "5:06:20")
        
        let u = Time(hours: 0, minutes: 6, seconds: 20)
        XCTAssertEqual(u.stringValue(format: .shortest), "6:20")
        
        let v = Time(hours: 0, minutes: 0, seconds: 20)
        XCTAssertEqual(v.stringValue(format: .shortest), "0:20")
        
        let w = Time(hours: 0, minutes: 0, seconds: 00)
        XCTAssertEqual(w.stringValue(format: .shortest), "0:00")
    }
    
    func testIntervalGet() {
        XCTAssertEqual(
            Time(hours: 0, minutes: 0, seconds: 0).interval,
            0.0
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20).interval,
            18380.0
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5).interval,
            18380.005
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5, sign: .minus).interval,
            -18380.005
        )
    }
    
    func testMillisecondsIntervalGet() {
        XCTAssertEqual(
            Time(hours: 0, minutes: 0, seconds: 0).millisecondsInterval,
            0
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20).millisecondsInterval,
            18380000
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5).millisecondsInterval,
            18380005
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5, sign: .minus).millisecondsInterval,
            -18380005
        )
    }
    
    func testIntervalSetA() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = 50
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 50)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testIntervalSetB() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = 18380.005
        
        XCTAssertEqual(t.hours, 5)
        XCTAssertEqual(t.minutes, 6)
        XCTAssertEqual(t.seconds, 20)
        XCTAssertEqual(t.milliseconds, 5)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testIntervalSetC() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = 0.0
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 0)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testIntervalSetD() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.interval = -40.0
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 40)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .minus)
    }
    
    func testMillisecondsIntervalSetA() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = 50_000
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 50)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testMillisecondsIntervalSetB() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = 18_380_005
        
        XCTAssertEqual(t.hours, 5)
        XCTAssertEqual(t.minutes, 6)
        XCTAssertEqual(t.seconds, 20)
        XCTAssertEqual(t.milliseconds, 5)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testMillisecondsIntervalSetC() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = 0
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 0)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .plus)
    }
    
    func testMillisecondsIntervalSetD() {
        var t = Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4)
        
        t.millisecondsInterval = -40_000
        
        XCTAssertEqual(t.hours, 0)
        XCTAssertEqual(t.minutes, 0)
        XCTAssertEqual(t.seconds, 40)
        XCTAssertEqual(t.milliseconds, 0)
        XCTAssertEqual(t.sign, .minus)
    }
    
    func testValueOfComponent() {
        XCTAssertEqual(Time(seconds: 0).value(of: .hours), 0)
        XCTAssertEqual(Time(seconds: 0).value(of: .minutes), 0)
        XCTAssertEqual(Time(seconds: 0).value(of: .seconds), 0)
        XCTAssertEqual(Time(seconds: 0).value(of: .milliseconds), 0)
        
        XCTAssertEqual(Time(seconds: 4547.175).value(of: .hours), 1)
        XCTAssertEqual(Time(seconds: 4547.175).value(of: .minutes), 15)
        XCTAssertEqual(Time(seconds: 4547.175).value(of: .seconds), 47)
        XCTAssertEqual(Time(seconds: 4547.175).value(of: .milliseconds), 175)
        
        XCTAssertEqual(Time(seconds: -4547.175).value(of: .hours), 1)
        XCTAssertEqual(Time(seconds: -4547.175).value(of: .minutes), 15)
        XCTAssertEqual(Time(seconds: -4547.175).value(of: .seconds), 47)
        XCTAssertEqual(Time(seconds: -4547.175).value(of: .milliseconds), 175)
    }
    
    func testSetValueOfComponent() {
        var time = Time(seconds: 0)
        
        time.setValue(of: .hours, to: 2)
        XCTAssertEqual(time.value(of: .hours), 2)
        XCTAssertEqual(time.value(of: .minutes), 0)
        XCTAssertEqual(time.value(of: .seconds), 0)
        XCTAssertEqual(time.value(of: .milliseconds), 0)
        
        time.setValue(of: .minutes, to: 47)
        XCTAssertEqual(time.value(of: .hours), 2)
        XCTAssertEqual(time.value(of: .minutes), 47)
        XCTAssertEqual(time.value(of: .seconds), 0)
        XCTAssertEqual(time.value(of: .milliseconds), 0)
        
        time.setValue(of: .seconds, to: 15)
        XCTAssertEqual(time.value(of: .hours), 2)
        XCTAssertEqual(time.value(of: .minutes), 47)
        XCTAssertEqual(time.value(of: .seconds), 15)
        XCTAssertEqual(time.value(of: .milliseconds), 0)
        
        time.setValue(of: .milliseconds, to: 175)
        XCTAssertEqual(time.value(of: .hours), 2)
        XCTAssertEqual(time.value(of: .minutes), 47)
        XCTAssertEqual(time.value(of: .seconds), 15)
        XCTAssertEqual(time.value(of: .milliseconds), 175)
        
        time.setValue(of: .hours, to: 4)
        time.setValue(of: .minutes, to: 2)
        time.setValue(of: .seconds, to: 32)
        time.setValue(of: .milliseconds, to: 950)
        XCTAssertEqual(time.value(of: .hours), 4)
        XCTAssertEqual(time.value(of: .minutes), 2)
        XCTAssertEqual(time.value(of: .seconds), 32)
        XCTAssertEqual(time.value(of: .milliseconds), 950)
    }
    
    func testStringValueOfComponentPadded() {
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .hours, padded: false), "0")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .minutes, padded: false), "0")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .seconds, padded: false), "0")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .milliseconds, padded: false), "0")
        
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .hours, padded: true), "00")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .minutes, padded: true), "00")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .seconds, padded: true), "00")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .milliseconds, padded: true), "000")
        
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .hours, padded: false), "1")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .minutes, padded: false), "15")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .seconds, padded: false), "47")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .milliseconds, padded: false), "50")
        
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .hours, padded: true), "01")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .minutes, padded: true), "15")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .seconds, padded: true), "47")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .milliseconds, padded: true), "050")
    }
    
    func testStringValueOfComponentForFormat() {
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .hours, format: .shortest), "0")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .minutes, format: .shortest), "0")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .seconds, format: .shortest), "00")
        XCTAssertEqual(Time(seconds: 0).stringValue(of: .milliseconds, format: .shortest), "000")
        
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .hours, format: .h_mm_ss_sss), "1")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .minutes, format: .h_mm_ss_sss), "15")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .seconds, format: .h_mm_ss_sss), "47")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .milliseconds, format: .h_mm_ss_sss), "050")
        
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .hours, format: .hh_mm_ss_sss), "01")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .minutes, format: .hh_mm_ss_sss), "15")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .seconds, format: .hh_mm_ss_sss), "47")
        XCTAssertEqual(Time(seconds: 4547.050).stringValue(of: .milliseconds, format: .hh_mm_ss_sss), "050")
    }
    
    func testEquatable() {
        XCTAssertEqual(Time(seconds: 20), Time(seconds: 20))
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5),
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
        )
        XCTAssertEqual(
            Time(hours: 0, minutes: 0, seconds: 0, sign: .plus),
            Time(hours: 0, minutes: 0, seconds: 0, sign: .minus) // functionally equivalent
        )
        
        XCTAssertNotEqual(Time(seconds: 10), Time(seconds: 20))
        XCTAssertNotEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5),
            Time(hours: 4, minutes: 6, seconds: 20, milliseconds: 5)
        )
        XCTAssertNotEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5),
            Time(hours: 5, minutes: 5, seconds: 20, milliseconds: 5)
        )
        XCTAssertNotEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5),
            Time(hours: 5, minutes: 6, seconds: 10, milliseconds: 5)
        )
        XCTAssertNotEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5),
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 4)
        )
    }
    
    func testComparable() {
        XCTAssertTrue(Time(seconds: 20) > Time(seconds: 10))
        XCTAssertFalse(Time(seconds: 10) > Time(seconds: 20))
        
        XCTAssertFalse(Time(seconds: 20) < Time(seconds: 10))
        XCTAssertTrue(Time(seconds: 10) < Time(seconds: 20))
        
        XCTAssertFalse(Time(seconds: 20) > Time(seconds: 20))
        XCTAssertFalse(Time(seconds: 20) < Time(seconds: 20))
    }
    
    func testAdd() {
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                + Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4),
            Time(hours: 6, minutes: 8, seconds: 23, milliseconds: 9)
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                + Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4 + 1000),
            Time(hours: 6, minutes: 8, seconds: 23 + 1, milliseconds: 9)
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                + Time.zero,
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
        )
        
        XCTAssertEqual(
            Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
                + Time(milliseconds: 1),
            Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
                + Time(milliseconds: -1),
            Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        )
        
        XCTAssertEqual(
            Time.zero
                + Time(milliseconds: -1),
            Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 1, sign: .minus)
        )
    }
    
    func testAddAssign() {
        var time = Time.zero
        
        time += .zero
        XCTAssertEqual(time, .zero)
        
        time += Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        XCTAssertEqual(time, Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
        
        time += Time(milliseconds: 1)
        XCTAssertEqual(time, Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0))
        
        time += Time(milliseconds: -1)
        XCTAssertEqual(time, Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
    }
    
    func testSubtract() {
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                - Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4),
            Time(hours: 4, minutes: 4, seconds: 17, milliseconds: 1)
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                - Time(hours: 1, minutes: 2, seconds: 3, milliseconds: 4 + 1000),
            Time(hours: 4, minutes: 4, seconds: 16, milliseconds: 1)
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
                - Time.zero,
            Time(hours: 5, minutes: 6, seconds: 20, milliseconds: 5)
        )
        
        XCTAssertEqual(
            Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
                - Time(milliseconds: 1),
            Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        )
        
        XCTAssertEqual(
            Time.zero
                - Time(milliseconds: 1),
            Time(hours: 0, minutes: 0, seconds: 0, milliseconds: 1, sign: .minus)
        )
    }
    
    func testSubtrackAssign() {
        var time = Time.zero
        
        time -= .zero
        XCTAssertEqual(time, .zero)
        
        time = Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0)
        time -= Time(milliseconds: 1)
        XCTAssertEqual(time, Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
        
        time -= Time(milliseconds: -1)
        XCTAssertEqual(time, Time(hours: 5, minutes: 0, seconds: 00, milliseconds: 0))
    }
    
    func testMultiplyAssign() {
        var time = Time.zero
        
        time *= 0 // int
        XCTAssertEqual(time, .zero)
        
        time *= 0.0 // floating-point
        XCTAssertEqual(time, .zero)
        
        time = Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999)
        time *= 2 // int
        XCTAssertEqual(time, Time(hours: 9, minutes: 59, seconds: 59, milliseconds: 998))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time *= 2.5 // floating-point
        XCTAssertEqual(time, Time(hours: 3, minutes: 45, seconds: 00, milliseconds: 0))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time *= 0.5 // floating-point
        XCTAssertEqual(time, Time(hours: 0, minutes: 45, seconds: 00, milliseconds: 0))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time *= -0.5 // floating-point
        XCTAssertEqual(time, Time(hours: 0, minutes: 45, seconds: 00, milliseconds: 0, sign: .minus))
    }
    
    func testDivideAssign() {
        var time = Time.zero
        
        time = Time(hours: 9, minutes: 59, seconds: 59, milliseconds: 998)
        time /= 2 // int
        XCTAssertEqual(time, Time(hours: 4, minutes: 59, seconds: 59, milliseconds: 999))
        
        time = Time(hours: 3, minutes: 45, seconds: 00, milliseconds: 0)
        time /= 2.5 // floating-point
        XCTAssertEqual(time, Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0))
        
        time = Time(hours: 0, minutes: 45, seconds: 00, milliseconds: 0)
        time /= 0.5 // floating-point
        XCTAssertEqual(time, Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0))
        
        time = Time(hours: 1, minutes: 30, seconds: 0, milliseconds: 0)
        time /= -0.5 // floating-point
        XCTAssertEqual(time, Time(hours: 3, minutes: 0, seconds: 00, milliseconds: 0, sign: .minus))
    }
}
