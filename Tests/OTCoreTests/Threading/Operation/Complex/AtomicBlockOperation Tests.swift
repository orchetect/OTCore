//
//  AtomicBlockOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

@testable import OTCore
import XCTest

final class Threading_AtomicBlockOperation_Tests: XCTestCase {
    
    func testEmpty() {
        
        let op = AtomicBlockOperation(type: .concurrentAutomatic,
                                      initialMutableValue: [Int : [Int]]())
        
        op.start()
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Standalone operation, serial FIFO queue mode. Run it.
    func testOp_serialFIFO_Run() {
        
        let op = AtomicBlockOperation(type: .serialFIFO,
                                      initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let dataVerificationExp = expectation(description: "Data Verification")
        
        for val in 1...100 {
            op.addOperation { $0.mutate { $0.append(val) } }
        }
        
        op.setCompletionBlock { v in
            completionBlockExp.fulfill()
            
            // check that all operations executed and they are in serial FIFO order
            v.mutate { value in
                XCTAssertEqual(value, Array(1...100))
                dataVerificationExp.fulfill()
            }
        }
        
        op.start()
        
        wait(for: [completionBlockExp, dataVerificationExp], timeout: 1)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Standalone operation, concurrent threading queue mode. Run it.
    func testOp_concurrentAutomatic_Run() {
        
        let op = AtomicBlockOperation(type: .concurrentAutomatic,
                                      initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let dataVerificationExp = expectation(description: "Data Verification")
        
        for val in 1...100 {
            op.addOperation { $0.mutate { $0.append(val) } }
        }
        
        op.setCompletionBlock { v in
            completionBlockExp.fulfill()
            
            v.mutate { value in
                // check that all operations executed
                XCTAssertEqual(value.count, 100)
                
                // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
                XCTAssert(Array(1...100).allSatisfy(value.contains))
                
                dataVerificationExp.fulfill()
            }
        }
        
        op.start()
        
        wait(for: [completionBlockExp, dataVerificationExp], timeout: 1)
        
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
        
        let dataVerificationExp = expectation(description: "Data Verification")
        
        for val in 1...100 {
            op.addOperation { $0.mutate { $0.append(val) } }
        }
        
        op.setCompletionBlock { v in
            completionBlockExp.fulfill()
            
            v.mutate { value in
                // check that all operations executed
                XCTAssertEqual(value.count, 100)
                
                // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
                XCTAssert(Array(1...100).allSatisfy(value.contains))
                
                dataVerificationExp.fulfill()
            }
        }
        
        op.start()
        
        wait(for: [completionBlockExp, dataVerificationExp], timeout: 1)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    /// Standalone operation, concurrent threading queue mode. Run it.
    func testOp_concurrentSpecificMax_Run() {
        
        let op = AtomicBlockOperation(type: .concurrent(max: 10),
                                      initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let dataVerificationExp = expectation(description: "Data Verification")
        
        for val in 1...100 {
            op.addOperation { $0.mutate { $0.append(val) } }
        }
        
        op.setCompletionBlock { v in
            completionBlockExp.fulfill()
            
            v.mutate { value in
                // check that all operations executed
                XCTAssertEqual(value.count, 100)
                
                // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
                XCTAssert(Array(1...100).allSatisfy(value.contains))
                
                dataVerificationExp.fulfill()
            }
        }
        
        op.start()
        
        wait(for: [completionBlockExp, dataVerificationExp], timeout: 1)
        
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
        
        let dataVerificationExp = expectation(description: "Data Verification")
        
        for val in 1...100 {
            op.addOperation { v in
                // QoS should be inherited from the AtomicBlockOperation QoS
                XCTAssertEqual(Thread.current.qualityOfService, .utility)
                
                // add value to array
                v.mutate { $0.append(val) }
            }
        }
        
        op.setCompletionBlock { v in
            completionBlockExp.fulfill()
            
            v.mutate { value in
                // check that all operations executed
                XCTAssertEqual(value.count, 100)
                
                // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
                XCTAssert(Array(1...100).allSatisfy(value.contains))
                
                dataVerificationExp.fulfill()
            }
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        wait(for: [completionBlockExp, dataVerificationExp], timeout: 1)
        
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
            op.addOperation { v in
                usleep(10_000) // milliseconds
                v.mutate { $0.append(val) }
            }
        }
        
        op.setCompletionBlock { _ in
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
    
    /// Test a `AtomicBlockOperation` that enqueues multiple `AtomicBlockOperation`s and ensure data mutability works as expected.
    func testNested() {
        
        let mainOp = AtomicBlockOperation(type: .concurrentAutomatic,
                                          initialMutableValue: [Int : [Int]]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        var mainVal: [Int : [Int]] = [:]
        
        for keyNum in 1...10 {
            mainOp.addOperation { v in
                let subOp = AtomicBlockOperation(type: .concurrentAutomatic,
                                                 initialMutableValue: [Int]())
                subOp.addOperation { v in
                    v.mutate { value in
                        for valueNum in 1...200 {
                            value.append(valueNum)
                        }
                    }
                }
                
                subOp.start()
                
                v.mutate { value in
                    value[keyNum] = subOp.value
                }
            }
        }
        
        mainOp.setCompletionBlock { v in
            v.mutate { value in
                mainVal = value
            }
            
            completionBlockExp.fulfill()
        }
        
        mainOp.start()
        
        wait(for: [completionBlockExp], timeout: 10)
        
        XCTAssertFalse(mainOp.isCancelled)
        XCTAssertFalse(mainOp.isExecuting)
        XCTAssertTrue(mainOp.isFinished)
        
        XCTAssertEqual(mainVal.count, 10)
        XCTAssertEqual(mainVal.keys.sorted(), Array(1...10))
        XCTAssert(mainVal.values.allSatisfy({ $0.sorted() == Array(1...200)}))
        
    }
    
    func testNested_Cancel() {
        
        let mainOp = AtomicBlockOperation(type: .concurrentAutomatic,
                                          initialMutableValue: [Int : [Int]]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        var mainVal: [Int : [Int]] = [:]
        
        for keyNum in 1...10 {
            let subOp = AtomicBlockOperation(type: .concurrentAutomatic,
                                             initialMutableValue: [Int]())
            var refs: [Operation] = []
            for valueNum in 1...20 {
                let ref = subOp.addCancellableOperation { op, v in
                    if op.mainShouldAbort() { return }
                    usleep(200_000)
                    v.mutate { value in
                        value.append(valueNum)
                    }
                }
                refs.append(ref)
            }
            
            subOp.addOperation { [weak mainOp] v in
                var getVal: [Int] = []
                v.mutate { value in
                    getVal = value
                }
                mainOp?.mutateValue { mainValue in
                    mainValue[keyNum] = getVal
                }
            }
            
            mainOp.addOperation(subOp)
        }
        
        mainOp.setCompletionBlock { v in
            v.mutate { value in
                mainVal = value
            }
            
            completionBlockExp.fulfill()
        }
        
        DispatchQueue.global().async {
            mainOp.start()
        }
        usleep(100_000) // 100 milliseconds
        mainOp.cancel()
        
        wait(for: [completionBlockExp], timeout: 5)
        
        //XCTAssertEqual(mainOp.operationQueue.operationCount, 0)
        
        XCTAssertTrue(mainOp.isCancelled)
        XCTAssertFalse(mainOp.isExecuting)
        XCTAssertTrue(mainOp.isFinished)
        
        XCTAssert(!mainVal.values.allSatisfy({ $0.sorted() == Array(1...200)}))
        
        dump(mainOp)
        
    }
    
}

#endif
