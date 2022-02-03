//
//  ReducerBlockOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

@testable import OTCore
import XCTest

final class Threading_ReducerBlockOperation_Tests: XCTestCase {
    
    /// Standalone operation, serial FIFO queue mode. Run it.
    func testOp_serialFIFO_Run() {
        
        let op = ReducerBlockOperation(.serialFIFO,
                                       initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 {
            op.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        op.setCompletionBlock { sharedMutableValue in
            completionBlockExp.fulfill()
            // check that all operations executed and they are in serial FIFO order
            XCTAssertEqual(sharedMutableValue, Array(1...100))
        }
        
        op.start()
        
        wait(for: [completionBlockExp], timeout: 1)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Standalone operation, concurrent threading queue mode. Run it.
    func testOp_concurrentAutomatic_Run() {
        
        let op = ReducerBlockOperation(.concurrentAutomatic,
                                       initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 {
            op.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        op.setCompletionBlock { sharedMutableValue in
            completionBlockExp.fulfill()
            
            // check that all operations executed
            XCTAssertEqual(sharedMutableValue.count, 100)
            
            // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
            XCTAssert(Array(1...100).allSatisfy(sharedMutableValue.contains))
        }
        
        op.start()
        
        wait(for: [completionBlockExp], timeout: 1)
        
        XCTAssertEqual(op.sharedMutableValue.count, 100)
        XCTAssert(Array(1...100).allSatisfy(op.sharedMutableValue.contains))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test as a standalone operation. Do not run it.
    func testOp_concurrentAutomatic_NotRun() {
        
        let op = ReducerBlockOperation(.concurrentAutomatic,
                                       initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 {
            op.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        op.setCompletionBlock { sharedMutableValue in
            completionBlockExp.fulfill()
            
            // check that all operations executed
            XCTAssertEqual(sharedMutableValue.count, 100)
            
            // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
            XCTAssert(Array(1...100).allSatisfy(sharedMutableValue.contains))
        }
        
        op.start()
        
        wait(for: [completionBlockExp], timeout: 1)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Standalone operation, concurrent threading queue mode. Run it.
    func testOp_concurrentSpecificMax_Run() {
        
        let op = ReducerBlockOperation(.concurrent(max: 10),
                                       initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 {
            op.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        op.setCompletionBlock { sharedMutableValue in
            completionBlockExp.fulfill()
            
            // check that all operations executed
            XCTAssertEqual(sharedMutableValue.count, 100)
            
            // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
            XCTAssert(Array(1...100).allSatisfy(sharedMutableValue.contains))
        }
        
        op.start()
        
        wait(for: [completionBlockExp], timeout: 1)
        
        XCTAssertEqual(op.sharedMutableValue.count, 100)
        XCTAssert(Array(1...100).allSatisfy(op.sharedMutableValue.contains))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testOp_concurrentAutomatic_Queue() {
        
        let oq = OperationQueue()
                
        let op = ReducerBlockOperation(.concurrentAutomatic, initialMutableValue: [Int]())
        
        // test default qualityOfService to check baseline state
        XCTAssertEqual(op.qualityOfService, .default)
        
        op.qualityOfService = .utility
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 {
            op.addOperation { sharedMutableValue in
                // QoS should be inherited from the ReducerBlockOperation QoS
                XCTAssertEqual(Thread.current.qualityOfService, .utility)
                
                // add value to array
                sharedMutableValue.append(val)
            }
        }
        
        op.setCompletionBlock { sharedMutableValue in
            completionBlockExp.fulfill()
            
            // check that all operations executed
            XCTAssertEqual(sharedMutableValue.count, 100)
            
            // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
            XCTAssert(Array(1...100).allSatisfy(sharedMutableValue.contains))
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        wait(for: [completionBlockExp], timeout: 1)
        
        XCTAssertEqual(oq.operationCount, 0)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Standalone operation, serial FIFO queue mode. Test that start() runs synchronously. Run it.
    func testOp_serialFIFO_SynchronousTest_Run() {
        
        let op = ReducerBlockOperation(.serialFIFO,
                                       initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 { // will take 1 second to complete
            op.addOperation { sharedMutableValue in
                usleep(10_000) // milliseconds
                sharedMutableValue.append(val)
            }
        }
        
        op.setCompletionBlock { sharedMutableValue in
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        // check that all operations executed and they are in serial FIFO order
        XCTAssertEqual(op.sharedMutableValue, Array(1...100))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
        wait(for: [completionBlockExp], timeout: 2)
        
    }
    
    @Atomic fileprivate var arr: [Int] = []
    /// This does not test a feature of OTCore. Rather, it tests the behavior of Foundation's built-in `BlockOperation` object.
    func testBlockOperation() {
        
        let op = BlockOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 { // will multi-thread
            op.addExecutionBlock {
                usleep(100_000) // milliseconds
                self.arr.append(val)
            }
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        // check that all operations executed.
        // sort them first because BlockOperation execution blocks run concurrently and may be out-of-seqeunce
        XCTAssertEqual(arr.sorted(), Array(1...100))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
        wait(for: [completionBlockExp], timeout: 2)
        
    }
    
}

#endif
