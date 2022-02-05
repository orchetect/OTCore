//
//  CancellableClosureOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_CancellableClosureOperation_Tests: XCTestCase {
    
    func testOpRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = CancellableClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            
            // do some work...
            if operation.mainShouldAbort() { return }
            // do some work...
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    func testOpNotRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        mainBlockExp.isInverted = true
        
        let op = CancellableClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            
            // do some work...
            if operation.mainShouldAbort() { return }
            // do some work...
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.3)
        
        XCTAssertTrue(op.isReady)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertFalse(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testQueue() {
        
        let oq = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = CancellableClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            
            // do some work...
            if operation.mainShouldAbort() { return }
            // do some work...
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertEqual(oq.operationCount, 0)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test that start() runs synchronously. Run it.
    func testOp_SynchronousTest_Run() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        var val = 0
        
        let op = CancellableClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            usleep(500_000) // 500 milliseconds
            val = 1
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        XCTAssertEqual(val, 1)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 2)
        
    }
    
}

#endif
