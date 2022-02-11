//
//  OTCoreTests.swift
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
        polling: DispatchTimeInterval = .milliseconds(10)
    ) {
        
        let inTime = Date()
        let timeoutTime = inTime + timeout
        let pollingPeriodMicroseconds = UInt32(polling.microseconds)
        
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
            XCTFail("Timed out.")
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
        
        DispatchQueue.global().async {
            sleep(0.02)
            someString = "new string"
        }
        
        wait(for: someString == "new string", timeout: 0.1) // 100ms
        
    }
    
}

#endif
