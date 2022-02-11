//
//  BasicOperationQueue Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

@testable import OTCore
import XCTest

final class Threading_BasicOperationQueue_Tests: XCTestCase {
    
    /// Serial FIFO queue.
    func testOperationQueueType_serialFIFO() {
        
        let opQ = BasicOperationQueue(type: .serialFIFO)
        
        XCTAssertEqual(opQ.maxConcurrentOperationCount, 1)
        
    }
    
    /// Automatic concurrency.
    func testOperationQueueType_automatic() {
        
        let opQ = BasicOperationQueue(type: .concurrentAutomatic)
        
        print(opQ.maxConcurrentOperationCount)
        
        XCTAssertEqual(opQ.maxConcurrentOperationCount,
                       OperationQueue.defaultMaxConcurrentOperationCount)
        
    }
    
    /// Specific number of concurrent operations.
    func testOperationQueueType_specific() {
        
        let opQ = BasicOperationQueue(type: .concurrent(max: 2))
        
        print(opQ.maxConcurrentOperationCount)
        
        XCTAssertEqual(opQ.maxConcurrentOperationCount, 2)
        
    }
    
    func testLastAddedOperation() {
        
        let opQ = BasicOperationQueue(type: .serialFIFO)
        opQ.isSuspended = true
        XCTAssertEqual(opQ.lastAddedOperation, nil)
        
        var op: Operation? = Operation()
        opQ.addOperation(op!)
        XCTAssertEqual(opQ.lastAddedOperation, op)
        // just FYI: op.isFinished == false here
        // but we don't care since it doesn't affect this test
        
        op = nil
        opQ.isSuspended = false
        wait(for: opQ.lastAddedOperation == nil, timeout: 0.2)
        
    }
    
    func testStatus() {
        
        let opQ = BasicOperationQueue(type: .serialFIFO)
        
        opQ.statusHandler = { newStatus, oldStatus in
            print(oldStatus, newStatus)
        }
        
        XCTAssertEqual(opQ.status, .idle)
        
        let completionBlockExp = expectation(description: "Operation Completion")
        
        opQ.addOperation {
            sleep(0.1)
            completionBlockExp.fulfill()
        }
        
        switch opQ.status {
        case .inProgress(let fractionCompleted, let message):
            XCTAssertEqual(fractionCompleted, 0.0)
            _ = message // don't test message content, for now
        default:
            XCTFail()
        }
        
        wait(for: [completionBlockExp], timeout: 0.3)
        wait(for: opQ.operationCount == 0, timeout: 0.1)
        wait(for: opQ.progress.isFinished, timeout: 0.1)
        
        XCTAssertEqual(opQ.status, .idle)
        
        opQ.isSuspended = true
        
        XCTAssertEqual(opQ.status, .paused)
        
        opQ.isSuspended = false
        
        XCTAssertEqual(opQ.status, .idle)
        
    }
    
}

#endif
