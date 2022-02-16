//
//  Utilities.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

extension XCTestCase {
    
    /// **OTCore:**
    /// Wait for a condition to be true, with a timeout period.
    /// Polling defaults to every 10 milliseconds, but can be overridden.
    public func wait(
        for condition: @autoclosure () -> Bool,
        timeout: TimeInterval,
        polling: TimeInterval = 0.010,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        let inTime = Date()
        let timeoutTime = inTime + timeout
        let pollingPeriodMicroseconds = UInt32(polling * 1_000_000)
        
        var continueLooping = true
        var timedOut = false
        
        while continueLooping {
            if Date() >= timeoutTime {
                continueLooping = false
                timedOut = true
                continue
            }
            
            let conditionResult = condition()
            continueLooping = !conditionResult
            if !continueLooping { continue }
            
            usleep(pollingPeriodMicroseconds)
        }
        
        if timedOut {
            var msg = message()
            msg = msg.isEmpty ? "" : ": \(msg)"
            
            XCTFail("wait timed out\(msg)",
                    file: file,
                    line: line)
            return
        }
        
    }
    
}

class Utilities_WaitForConditionTests: XCTestCase {
    
    func testWaitForCondition_True() {
        
        wait(for: true, timeout: 0.1)
        
    }
    
    #if swift(>=5.4)
    /// `XCTExpectFailure()` is only available in Xcode 12.5 or later. Swift 5.4 shipped in Xcode 12.5.
    func testWaitForCondition_False() {
        
        XCTExpectFailure()
        
        wait(for: false, timeout: 0.1)
        
    }
    #endif
    
    func testWaitForCondition() {
        
        var someString = "default string"
        
        // note: this will throw a thread sanitizer warning but it's safe to ignore for this test
        DispatchQueue.global().async {
            usleep(20_000)
            someString = "new string"
        }
        
        wait(for: someString == "new string",
             timeout: 0.3,
             "Check someString == 'new string'")
        
    }
    
}

#endif
