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
        
        let oq = BasicOperationQueue(type: .serialFIFO)
        
        XCTAssertEqual(oq.maxConcurrentOperationCount, 1)
        
    }
    
    /// Automatic concurrency.
    func testOperationQueueType_automatic() {
        
        let oq = BasicOperationQueue(type: .concurrentAutomatic)
        
        print(oq.maxConcurrentOperationCount)
        
        XCTAssertEqual(oq.maxConcurrentOperationCount,
                       OperationQueue.defaultMaxConcurrentOperationCount)
        
    }
    
    /// Specific number of concurrent operations.
    func testOperationQueueType_specific() {
        
        let oq = BasicOperationQueue(type: .concurrent(max: 2))
        
        print(oq.maxConcurrentOperationCount)
        
        XCTAssertEqual(oq.maxConcurrentOperationCount, 2)
        
    }
    
    func testLastAddedOperation() {
        
        let oq = BasicOperationQueue(type: .serialFIFO)
        oq.isSuspended = true
        XCTAssertEqual(oq.lastAddedOperation, nil)
        
        var op: Operation? = Operation()
        oq.addOperation(op!)
        XCTAssertEqual(oq.lastAddedOperation, op)
        
        op = nil
        oq.isSuspended = false
        oq.waitUntilAllOperationsAreFinished(timeout: .seconds(1))
        XCTAssertEqual(oq.lastAddedOperation, nil)
        
    }
    
}

#endif
