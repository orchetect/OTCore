//
//  BasicAsyncOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_BasicAsyncOperation_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Classes
    
    /// `BasicAsyncOperation` is designed to be subclassed.
    /// This is a simple subclass to test.
    private class TestBasicAsyncOperation: BasicAsyncOperation {
        
        override func main() {
            
            print("Starting main()")
            guard mainShouldStart() else { return }
            
            XCTAssertTrue(isExecuting)
            
            // run a simple non-blocking loop that can frequently check for cancellation
            
            DispatchQueue.global().async {
                // it's good to call this once or more throughout the operation
                // so we can return early if the operation is cancelled
                if self.mainShouldAbort() { return }
                
                self.completeOperation()
            }
            
        }
        
    }
    
    /// `BasicAsyncOperation` is designed to be subclassed.
    /// This is a simple subclass to test.
    private class TestLongRunningBasicAsyncOperation: BasicAsyncOperation {
        
        private let totalOpCount = 100
        
        override init() {
            super.init()   
            progress.totalUnitCount = Int64(totalOpCount)
        }
        
        override func main() {
            
            print("Starting main()")
            guard mainShouldStart() else { return }
            
            XCTAssertTrue(isExecuting)
            
            // run a simple non-blocking loop that can frequently check for cancellation
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                for opNum in 1...self.totalOpCount { // finishes in 20 seconds
                    // it's good to call this once or more throughout the operation
                    // so we can return early if the operation is cancelled
                    if self.mainShouldAbort() { return }
                    
                    self.progress.completedUnitCount = Int64(opNum)
                    
                    sleep(0.2)
                }
                
                self.completeOperation()
            }
            
        }
        
    }
    
    // MARK: - Tests
    
    /// Test as a standalone operation. Run it.
    func testOpRun() {
        
        let op = TestBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        wait(for: [completionBlockExp], timeout: 0.5)
        
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
        
        let op = TestBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        wait(for: [completionBlockExp], timeout: 0.3)
        
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
        
        let op = TestLongRunningBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        sleep(0.1)
        op.cancel() // cancel the operation directly (since we are not using an OperationQueue)
        
        wait(for: [completionBlockExp], timeout: 0.5)
        
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
        
        let op = TestBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // must manually increment for OperationQueue
        opQ.progress.totalUnitCount += 1
        // queue automatically starts the operation once it's added
        opQ.addOperation(op)
        
        wait(for: [completionBlockExp], timeout: 0.5)
        
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
        
        let op = TestLongRunningBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // must manually increment for OperationQueue
        opQ.progress.totalUnitCount += 1
        // queue automatically starts the operation once it's added
        opQ.addOperation(op)
        sleep(0.1)
        opQ.cancelAllOperations() // cancel the queue, not the operation. it cancels its operations.
        
        wait(for: [completionBlockExp], timeout: 0.5)
        
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
