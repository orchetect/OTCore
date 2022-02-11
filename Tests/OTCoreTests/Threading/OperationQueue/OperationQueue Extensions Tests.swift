//
//  OperationQueue Extensions Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_OperationQueueExtensions_Success_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    @Atomic fileprivate var val = 0
    
    func testWaitUntilAllOperationsAreFinished_Timeout_Success() {
        
        let opQ = OperationQueue()
        opQ.maxConcurrentOperationCount = 1 // serial
        opQ.isSuspended = true
        
        val = 0
        
        opQ.addOperation {
            sleep(0.1)
            self.val = 1
        }
        
        opQ.isSuspended = false
        let timeoutResult = opQ.waitUntilAllOperationsAreFinished(timeout: .milliseconds(500))
        
        XCTAssertEqual(timeoutResult, .success)
        XCTAssertEqual(opQ.operationCount, 0)
        XCTAssertEqual(val, 1)
        
    }
    
}

final class Threading_OperationQueueExtensions_TimedOut_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    @Atomic fileprivate var val = 0
    
    func testWaitUntilAllOperationsAreFinished_Timeout_TimedOut() {
        
        let opQ = OperationQueue()
        opQ.maxConcurrentOperationCount = 1 // serial
        opQ.isSuspended = true
        
        val = 0
        
        opQ.addOperation {
            sleep(1)
            self.val = 1
        }
        
        opQ.isSuspended = false
        let timeoutResult = opQ.waitUntilAllOperationsAreFinished(timeout: .milliseconds(500))
        
        XCTAssertEqual(timeoutResult, .timedOut)
        XCTAssertEqual(opQ.operationCount, 1)
        XCTAssertEqual(val, 0)
        
    }
    
}

#endif
