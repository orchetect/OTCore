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
            guard mainShouldStart() else { return }
            
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
        
        public init(initial: Int,
                    changeTo: Int) {
            
            val = initial
            valChangeTo = changeTo
            super.init()
            
        }
        
        override func main() {
            
            print("Starting main()")
            guard mainShouldStart() else { return }
            
            XCTAssertTrue(isExecuting)
            
            // it's good to call this once or more throughout the operation
            // but it does nothing here since we're not asking this class to cancel
            if mainShouldAbort() { return }
            
            sleep(0.5)
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
        
        let op = TestBasicOperation()
        
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
    
    /// Test as a standalone operation. Cancel it before it runs.
    func testOpCancelBeforeRun() {
        
        let op = TestBasicOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.cancel()
        op.start() // in an OperationQueue, all operations must start even if they're already cancelled
        
        wait(for: [completionBlockExp], timeout: 0.3)
        
        // state
        XCTAssertTrue(op.isReady)
        XCTAssertTrue(op.isFinished)
        XCTAssertTrue(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress
        XCTAssertFalse(op.progress.isFinished)
        XCTAssertTrue(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 0.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testQueue() {
        
        let opQ = OperationQueue()
        
        let op = TestBasicOperation()
        
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
    
    /// Test that start() runs synchronously. Run it.
    func testOp_SynchronousTest_Run() {
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        // after start(), will mutate self after 500ms then finish
        let op = TestDelayedMutatingBasicOperation(initial: 0,
                                                   changeTo: 1)
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        XCTAssertEqual(op.val, 1)
        
        // state
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        // progress
        XCTAssertTrue(op.progress.isFinished)
        XCTAssertFalse(op.progress.isCancelled)
        XCTAssertEqual(op.progress.fractionCompleted, 1.0)
        XCTAssertFalse(op.progress.isIndeterminate)
        
        wait(for: [completionBlockExp], timeout: 2)
        
    }
    
}

#endif
