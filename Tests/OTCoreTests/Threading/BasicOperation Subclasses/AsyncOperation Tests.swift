//
//  AsyncOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

import OTCore
import XCTest

final class Threading_AsyncOperation_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    private class TestOp: AsyncOperation {
        
        override func main() {
            
            print("Starting main()")
            guard mainStartOperation() else { return }
            
            XCTAssertTrue(isExecuting)
            
            // run a simple non-blocking loop that can frequently check for cancellation
            
            DispatchQueue.global().async {
                for _ in 1...100 { // finishes in 20 seconds
                    usleep(200_000) // 200 milliseconds
                    // would call this once ore more throughout the operation
                    if self.mainShouldAbort() { return }
                }
                
                self.completeOperation()
            }
        }
        
    }
    
    /// Test as a standalone operation. Run it. Cancel before it finishes.
    func testOpRun_Cancel() {
        
        let op = TestOp()
        
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
    
    /// Test in the context of an OperationQueue. Run is implicit. Cancel before it finishes.
    func testQueue_Cancel() {
        
        let oq = OperationQueue()
        
        let op = TestOp()
        
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
