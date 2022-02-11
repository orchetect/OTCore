//
//  OTCoreTests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest

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
    
    func testWaitForCondition_False() {
        
        XCTExpectFailure()
        wait(for: false, timeout: 0.1)
        
    }
    
    func testWaitForCondition() {
        
        var someString = "default string"
        
        DispatchQueue.global().async {
            usleep(20_000) // 20 milliseconds
            someString = "new string"
        }
        
        wait(for: someString == "new string", timeout: 0.1) // 100ms
        
    }
    
}

#endif
