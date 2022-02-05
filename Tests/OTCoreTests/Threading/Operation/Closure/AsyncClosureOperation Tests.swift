//
//  AsyncClosureOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_AsyncClosureOperation_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    /// Test as a standalone operation. Run it.
    func testOpRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let op = AsyncClosureOperation {
            mainBlockExp.fulfill()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test as a standalone operation. Do not run it.
    func testOpNotRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        mainBlockExp.isInverted = true
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        let op = AsyncClosureOperation {
            mainBlockExp.fulfill()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.3)
        
        XCTAssertTrue(op.isReady)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertFalse(op.isFinished)
        
    }
    
    /// Test as a standalone operation. Run it. Cancel before it finishes.
    func testOpRun_Cancel() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        // the operation's main block does finish eventually but won't finish in time for our timeout because there's no opportunity to return early from cancelling the operation
        let mainBlockFinishedExp = expectation(description: "Main Block Finished")
        mainBlockFinishedExp.isInverted = true
        
        // the operation's completion block does not fire in time because there's no opportunity to return early from cancelling the operation
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        let op = AsyncClosureOperation(on: .global()) {
            mainBlockExp.fulfill()
            sleep(4) // seconds
            mainBlockFinishedExp.fulfill()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        usleep(100_000) // 100 milliseconds
        op.cancel() // cancel the operation directly (since we are not using an OperationQueue)
        
        wait(for: [mainBlockExp, mainBlockFinishedExp, completionBlockExp], timeout: 0.5)
        
        usleep(200_000) // give a little time for cleanup
        
        XCTAssertTrue(op.isCancelled)
        XCTAssertTrue(op.isExecuting)
        XCTAssertFalse(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testQueue() {
        
        let oq = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let op = AsyncClosureOperation {
            mainBlockExp.fulfill()
        }
        
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
        
        // the operation's main block does finish eventually but won't finish in time for our timeout because there's no opportunity to return early from cancelling the operation
        let mainBlockFinishedExp = expectation(description: "Main Block Finished")
        mainBlockFinishedExp.isInverted = true
        
        // the operation's completion block does not fire in time because there's no opportunity to return early from cancelling the operation
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        let op = AsyncClosureOperation(on: .global()) {
            mainBlockExp.fulfill()
            sleep(4) // seconds
            mainBlockFinishedExp.fulfill()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        usleep(100_000) // 100 milliseconds
        oq.cancelAllOperations() // cancel the queue, not the operation. it cancels its operations.
        
        wait(for: [mainBlockExp, mainBlockFinishedExp, completionBlockExp], timeout: 0.5)

        usleep(200_000) // give a little time for cleanup
        
        // the operation is still running because it cannot return early from being cancelled
        XCTAssertEqual(oq.operationCount, 1)

        XCTAssertTrue(op.isCancelled)
        XCTAssertTrue(op.isExecuting) // still executing
        XCTAssertFalse(op.isFinished) // not yet finished

    }
    
}

#endif
