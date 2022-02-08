//
//  BasicOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import OTCore
import XCTest

final class Threading_BasicOperation_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Classes
    
    /// `BasicOperation` is designed to be subclassed.
    /// This is a simple subclass to test.
    private class TestBasicOperation: BasicOperation {
        
        override func main() {
            
            print("Starting main()")
            guard mainStartOperation() else { return }
            
            XCTAssertTrue(isExecuting)
            
            // it's good to call this once or more throughout the operation
            // but it does nothing here since we're not asking this class to cancel
            if mainShouldAbort() { return }
            
            completeOperation()
            
        }
        
    }
    
    /// `BasicOperation` is designed to be subclassed.
    /// This is a simple subclass to test.
    private class TestDelayedMutatingBasicOperation: BasicOperation {
        
        public var val: Int
        private var valChangeTo: Int
        
        public init(initial: Int, changeTo: Int) {
            val = initial
            valChangeTo = changeTo
        }
        
        override func main() {
            
            print("Starting main()")
            guard mainStartOperation() else { return }
            
            XCTAssertTrue(isExecuting)
            
            // it's good to call this once or more throughout the operation
            // but it does nothing here since we're not asking this class to cancel
            if mainShouldAbort() { return }
            
            usleep(500_000) // 500 milliseconds
            val = valChangeTo
            
            completeOperation()
            
        }
        
    }
    
    // MARK: - Tests
    
    /// Test as a standalone operation. Run it.
    func testOpRun() {
        
        let op = TestBasicOperation()
        
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
        
        let op = TestBasicOperation()
        
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
    
    /// Test as a standalone operation. Do not run it. Cancel it before it runs.
    func testOpNotRun_Cancel() {
        
        let op = TestBasicOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.cancel()
        op.start() // in an OperationQueue, all operations must start even if they're already cancelled
        
        wait(for: [completionBlockExp], timeout: 0.3)
        
        XCTAssertTrue(op.isReady)
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testQueue() {
        
        let oq = OperationQueue()
        
        let op = TestBasicOperation()
        
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
    
    /// Test that start() runs synchronously. Run it.
    func testOp_SynchronousTest_Run() {
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        // after start(), will mutate self after 500ms then finish
        let op = TestDelayedMutatingBasicOperation(initial: 0, changeTo: 1)
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        XCTAssertEqual(op.val, 1)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
        wait(for: [completionBlockExp], timeout: 2)
        
    }
    
}

#endif
