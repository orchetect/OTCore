//
//  AtomicBlockOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

@testable import OTCore
import XCTest

final class Threading_AtomicBlockOperation_Tests: XCTestCase {
    
    /// Standalone operation, serial FIFO queue mode. Run it.
    func testOp_serialFIFO_Run() {
        
        let op = AtomicBlockOperation(type: .serialFIFO,
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
        
        let op = AtomicBlockOperation(type: .concurrentAutomatic,
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
        
        XCTAssertEqual(op.value.count, 100)
        XCTAssert(Array(1...100).allSatisfy(op.value.contains))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test as a standalone operation. Do not run it.
    func testOp_concurrentAutomatic_NotRun() {
        
        let op = AtomicBlockOperation(type: .concurrentAutomatic,
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
        
        let op = AtomicBlockOperation(type: .concurrent(max: 10),
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
        
        XCTAssertEqual(op.value.count, 100)
        XCTAssert(Array(1...100).allSatisfy(op.value.contains))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testOp_concurrentAutomatic_Queue() {
        
        let oq = OperationQueue()
                
        let op = AtomicBlockOperation(type: .concurrentAutomatic,
                                      initialMutableValue: [Int]())
        
        // test default qualityOfService to check baseline state
        XCTAssertEqual(op.qualityOfService, .default)
        
        op.qualityOfService = .utility
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 {
            op.addOperation { sharedMutableValue in
                // QoS should be inherited from the AtomicBlockOperation QoS
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
        
        let op = AtomicBlockOperation(type: .serialFIFO,
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
        XCTAssertEqual(op.value, Array(1...100))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
        wait(for: [completionBlockExp], timeout: 2)
        
    }
    
}

#endif