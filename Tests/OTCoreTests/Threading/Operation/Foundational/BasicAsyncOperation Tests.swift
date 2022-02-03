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
            guard mainStartOperation() else { return }
            
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
        
        override func main() {
            
            print("Starting main()")
            guard mainStartOperation() else { return }
            
            XCTAssertTrue(isExecuting)
            
            // run a simple non-blocking loop that can frequently check for cancellation
            
            DispatchQueue.global().async {
                for _ in 1...100 { // finishes in 20 seconds
                    usleep(200_000) // 200 milliseconds
                    // it's good to call this once or more throughout the operation
                    // so we can return early if the operation is cancelled
                    if self.mainShouldAbort() { return }
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
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
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
        
        XCTAssertTrue(op.isReady)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertFalse(op.isFinished)
        
    }
    
    /// Test as a standalone operation. Run it. Cancel before it finishes.
    func testOpRun_Cancel() {
        
        let op = TestLongRunningBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        usleep(100_000) // 100 milliseconds
        op.cancel() // cancel the operation directly (since we are not using an OperationQueue)
        
        wait(for: [completionBlockExp], timeout: 0.5)
        
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testQueue() {
        
        let oq = OperationQueue()
        
        let op = TestBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        wait(for: [completionBlockExp], timeout: 0.5)
        
        XCTAssertEqual(oq.operationCount, 0)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit. Cancel before it finishes.
    func testQueue_Cancel() {
        
        let oq = OperationQueue()
        
        let op = TestLongRunningBasicAsyncOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        usleep(100_000) // 100 milliseconds
        oq.cancelAllOperations() // cancel the queue, not the operation. it cancels its operations.
        
        wait(for: [completionBlockExp], timeout: 0.5)
        
        XCTAssertEqual(oq.operationCount, 0)
        
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
}

#endif
