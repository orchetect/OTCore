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
        
        // state
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress
        XCTAssertTrue(op.progress.isFinished)
        XCTAssertFalse(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 1.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        
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
        
        // state
        XCTAssertTrue(op.isReady)
        XCTAssertFalse(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress
        XCTAssertFalse(op.progress.isFinished)
        XCTAssertFalse(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 0.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        
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
        
        // state
        XCTAssertFalse(op.isFinished)
        XCTAssertTrue(op.isCancelled)
        XCTAssertTrue(op.isExecuting)
        // progress
        XCTAssertFalse(op.progress.isFinished)
        XCTAssertTrue(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 0.0)
        XCTAssertLessThan(op.progress.fractionCompleted, 1.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testQueue() {
        
        let opQ = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let op = AsyncClosureOperation {
            mainBlockExp.fulfill()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // must manually increment for OperationQueue
        opQ.progress.totalUnitCount += 1
        // queue automatically starts the operation once it's added
        opQ.addOperation(op)
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        // state
        XCTAssertEqual(opQ.operationCount, 0)
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress - operation
        XCTAssertTrue(op.progress.isFinished)
        XCTAssertFalse(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 1.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        // progress - queue
        XCTAssertTrue(opQ.progress.isFinished)
        XCTAssertFalse(opQ.progress.isCancelled)
        XCTAssertEqual(opQ.progress.fractionCompleted, 1.0)
        XCTAssertFalse(opQ.progress.isIndeterminate)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit. Cancel before it finishes.
    func testQueue_Cancel() {

        let opQ = OperationQueue()

        let mainBlockExp = expectation(description: "Main Block Called")
        
        // the operation's main block does finish eventually but won't finish in time for our timeout because there's no opportunity to return early from cancelling the operation
        let mainBlockFinishedExp = expectation(description: "Main Block Finished")
        
        // the operation's completion block does not fire in time because there's no opportunity to return early from cancelling the operation
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        let op = AsyncClosureOperation(on: .global()) {
            mainBlockExp.fulfill()
            sleep(1) // seconds
            mainBlockFinishedExp.fulfill()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // must manually increment for OperationQueue
        opQ.progress.totalUnitCount += 1
        
        XCTAssertEqual(op.progress.totalUnitCount, 1)
        XCTAssertEqual(opQ.progress.totalUnitCount, 1)
        
        // queue automatically starts the operation once it's added
        opQ.addOperation(op)
        
        usleep(100_000) // 100 milliseconds
        opQ.cancelAllOperations() // cancel the queue, not the operation. it cancels its operations.
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.4)
        
        // state
        // the operation is still running because it cannot return early from being cancelled
        XCTAssertEqual(opQ.operationCount, 1)
        XCTAssertFalse(op.isFinished)
        XCTAssertTrue(op.isCancelled)
        XCTAssertTrue(op.isExecuting) // still executing
        // progress - operation
        XCTAssertFalse(op.progress.isFinished)
        XCTAssertTrue(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 0.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        // progress - queue
        XCTAssertTrue(opQ.progress.isFinished) // even if the async op is still running, this will be true now
        XCTAssertFalse(opQ.progress.isCancelled)
        XCTAssertEqual(opQ.progress.fractionCompleted, 1.0)
        XCTAssertFalse(opQ.progress.isIndeterminate)
        
        wait(for: [mainBlockFinishedExp], timeout: 0.7)
        usleep(100_000) // 100 milliseconds
        
        // state
        XCTAssertEqual(opQ.operationCount, 0)
        XCTAssertTrue(op.isFinished)
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress - operation
        XCTAssertFalse(op.progress.isFinished)
        XCTAssertTrue(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 0.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        // progress - queue
        XCTAssertTrue(opQ.progress.isFinished)
        XCTAssertFalse(opQ.progress.isCancelled)
        XCTAssertEqual(opQ.progress.fractionCompleted, 1.0)
        XCTAssertFalse(opQ.progress.isIndeterminate)
        
    }
    
}

#endif
