//
//  AsyncClosureOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_AsyncClosureOperation_Tests: XCTestCase {
    
    func testOpRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = AsyncClosureOperation { _ in }
        
        // have to define this after AsyncClosureOperation is initialized, since it can't reference itself in its own initializer closure
        op.mainBlock = { operation in
            DispatchQueue.global().async {
                mainBlockExp.fulfill()
                XCTAssertTrue(op.isExecuting)
                op.completeOperation()
            }
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
        
        let op = AsyncClosureOperation { _ in }
        
        // have to define this after AsyncClosureOperation is initialized, since it can't reference itself in its own initializer closure
        op.mainBlock = { operation in
            DispatchQueue.global().async {
                mainBlockExp.fulfill()
                XCTAssertTrue(op.isExecuting)
                op.completeOperation()
            }
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertTrue(op.isReady)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertFalse(op.isFinished)
        
    }
    
    /// Test as a standalone operation. Run it. Cancel before it finishes.
    func testOpRun_Cancel() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = AsyncClosureOperation { _ in }
        
        // have to define this after AsyncClosureOperation is initialized, since it can't reference itself in its own initializer closure
        op.mainBlock = { operation in
            DispatchQueue.global().async {
                mainBlockExp.fulfill()
                XCTAssertTrue(op.isExecuting)
                
                for _ in 1...100 { // finishes in 20 seconds
                    usleep(200_000) // 200 milliseconds
                    // would call this once ore more throughout the operation
                    if operation.mainShouldAbort() { return }
                }
                
                operation.completeOperation()
            }
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        usleep(100_000) // 100 milliseconds
        op.cancel() // cancel the operation directly (since we are not using an OperationQueue)
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testQueue() {
        
        let oq = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = AsyncClosureOperation { _ in }
        
        // have to define this after AsyncClosureOperation is initialized, since it can't reference itself in its own initializer closure
        op.mainBlock = { operation in
            DispatchQueue.global().async {
                mainBlockExp.fulfill()
                XCTAssertTrue(op.isExecuting)
                operation.completeOperation()
            }
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
    
    /// Test in the context of an OperationQueue. Run is implicit. Cancel before it finishes.
    func testQueue_Cancel() {
        
        let oq = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = AsyncClosureOperation { _ in }
        
        // have to define this after AsyncClosureOperation is initialized, since it can't reference itself in its own initializer closure
        op.mainBlock = { operation in
            DispatchQueue.global().async {
                mainBlockExp.fulfill()
                XCTAssertTrue(op.isExecuting)
                
                for _ in 1...100 { // finishes in 20 seconds
                    usleep(200_000) // 200 milliseconds
                    // would call this once ore more throughout the operation
                    if operation.mainShouldAbort() { return }
                }
                
                operation.completeOperation()
            }
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        usleep(100_000) // 100 milliseconds
        oq.cancelAllOperations() // cancel the queue, not the operation. it cancels its operations.
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertEqual(oq.operationCount, 0)
        
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
}

#endif
