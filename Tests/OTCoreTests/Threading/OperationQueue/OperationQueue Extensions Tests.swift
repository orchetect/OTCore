//
//  OperationQueue Extensions Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_OperationQueueExtensions_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testWaitUntilAllOperationsAreFinished_Timeout_Success() {
        
        let oq = OperationQueue()
        oq.maxConcurrentOperationCount = 1 // serial
        oq.isSuspended = true
        
        var val = 0
        
        oq.addOperation {
            usleep(100_000) // 100 milliseconds
            val = 1
        }
        
        oq.isSuspended = false
        let timeoutResult = oq.waitUntilAllOperationsAreFinished(timeout: .seconds(5))
        
        XCTAssertEqual(timeoutResult, .success)
        XCTAssertEqual(oq.operationCount, 0)
        XCTAssertEqual(val, 1)
        
    }
    
    func testWaitUntilAllOperationsAreFinished_Timeout_TimedOut() {
        
        let oq = OperationQueue()
        oq.maxConcurrentOperationCount = 1 // serial
        oq.isSuspended = true
        
        var val = 0
        
        oq.addOperation {
            sleep(5) // 5 seconds
            val = 1
        }
        
        oq.isSuspended = false
        let timeoutResult = oq.waitUntilAllOperationsAreFinished(timeout: .milliseconds(500))
        
        XCTAssertEqual(timeoutResult, .timedOut)
        XCTAssertEqual(oq.operationCount, 1)
        XCTAssertEqual(val, 0)
        
    }
    
}

#endif
