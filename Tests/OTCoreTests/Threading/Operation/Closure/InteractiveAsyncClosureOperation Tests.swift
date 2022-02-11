//
//  InteractiveAsyncClosureOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_InteractiveAsyncClosureOperation_Tests: XCTestCase {
    
    func testOpRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let op = InteractiveAsyncClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            operation.completeOperation()
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
    
    func testOpNotRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        mainBlockExp.isInverted = true
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        let op = InteractiveAsyncClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            operation.completeOperation()
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
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let op = InteractiveAsyncClosureOperation(on: .global()) { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            
            operation.progress.totalUnitCount = 100
            
            for i in 1...100 { // finishes in 20 seconds
                operation.progress.completedUnitCount = Int64(i)
                
                sleep(0.2)
                
                // would call this once ore more throughout the operation
                if operation.mainShouldAbort() { return }
            }
            
            operation.completeOperation()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        sleep(0.1)
        op.cancel() // cancel the operation directly (since we are not using an OperationQueue)
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        // state
        XCTAssertTrue(op.isFinished)
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress
        XCTAssertFalse(op.progress.isFinished)
        XCTAssertTrue(op.progress.isCancelled)
        XCTAssertGreaterThan(op.progress.fractionCompleted, 0.0)
        XCTAssertLessThan(op.progress.fractionCompleted, 1.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testQueue() {
        
        let opQ = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let mainBlockFinishedExp = expectation(description: "Main Block Finished")
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let op = InteractiveAsyncClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            operation.completeOperation()
            mainBlockFinishedExp.fulfill()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // must manually increment for OperationQueue
        opQ.progress.totalUnitCount += 1
        // queue automatically starts the operation once it's added
        opQ.addOperation(op)
        
        wait(for: [mainBlockExp, mainBlockFinishedExp, completionBlockExp], timeout: 0.5)
        
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
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testQueue_Cancel() {
        
        let opQ = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        // main block does not finish because we return early from cancelling the operation
        let mainBlockFinishedExp = expectation(description: "Main Block Finished")
        
        // completion block still successfully fires because our early return from being cancelled marks the operation as isFinished == true
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let op = InteractiveAsyncClosureOperation { operation in
            mainBlockExp.fulfill()
            XCTAssertTrue(operation.isExecuting)
            
            defer { mainBlockFinishedExp.fulfill() }
            
            operation.progress.totalUnitCount = 100
            
            for i in 1...100 { // finishes in 20 seconds
                operation.progress.completedUnitCount = Int64(i)
                
                sleep(0.2)
                
                // would call this once ore more throughout the operation
                if operation.mainShouldAbort() { return }
            }
            
            operation.completeOperation()
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // must manually increment for OperationQueue
        opQ.progress.totalUnitCount += 1
        // queue automatically starts the operation once it's added
        opQ.addOperation(op)
        sleep(0.1)
        opQ.cancelAllOperations() // cancel the queue, not the operation. it cancels its operations.
        
        wait(for: [mainBlockExp, mainBlockFinishedExp, completionBlockExp], timeout: 0.5)
        
        // state
        XCTAssertEqual(opQ.operationCount, 0)
        XCTAssertTrue(op.isFinished)
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress - operation
        XCTAssertFalse(op.progress.isFinished)
        XCTAssertTrue(op.progress.isCancelled)
        XCTAssertGreaterThan(op.progress.fractionCompleted, 0.0)
        XCTAssertLessThan(op.progress.fractionCompleted, 1.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        // progress - queue
        XCTAssertTrue(opQ.progress.isFinished)
        XCTAssertFalse(opQ.progress.isCancelled)
        XCTAssertEqual(opQ.progress.fractionCompleted, 1.0)
        XCTAssertFalse(opQ.progress.isIndeterminate)
        
    }
    
}

#endif
