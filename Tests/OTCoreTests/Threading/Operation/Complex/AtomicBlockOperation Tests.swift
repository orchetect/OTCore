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
        
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        
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
        
        // state
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        
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
        
        // state
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        
    }
    
    /// Test as a standalone operation. Do not run it.
    func testOp_concurrentAutomatic_NotRun() {
        
        let op = AtomicBlockOperation(type: .concurrentAutomatic,
                                      initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        let dataVerificationExp = expectation(description: "Data Verification")
        dataVerificationExp.isInverted = true
        
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
        
        wait(for: [completionBlockExp, dataVerificationExp], timeout: 1)
        
        // state
        XCTAssertFalse(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        
    }
    
    /// Standalone operation, concurrent threading queue mode. Run it.
    func testOp_concurrentSpecificMax_Run() {
        
        let op = AtomicBlockOperation(type: .concurrent(max: 10),
                                      initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let dataVerificationExp = expectation(description: "Data Verification")
        
        let atomicBlockCompletedExp = expectation(description: "AtomicBlockOperation Completed")
        
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
        
        DispatchQueue.global().async {
            op.start()
            atomicBlockCompletedExp.fulfill()
        }
        
        wait(for: [completionBlockExp, dataVerificationExp, atomicBlockCompletedExp], timeout: 1)
        
        XCTAssertEqual(op.value.count, 100)
        XCTAssert(Array(1...100).allSatisfy(op.value.contains))
        
        // state
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testOp_concurrentAutomatic_Queue() {
        
        let opQ = OperationQueue()
                
        let op = AtomicBlockOperation(type: .concurrentAutomatic,
                                      initialMutableValue: [Int]())
        
        // test default qualityOfService to check baseline state
        XCTAssertEqual(op.qualityOfService, .default)
        
        op.qualityOfService = .userInitiated
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        let dataVerificationExp = expectation(description: "Data Verification")
        
        for val in 1...100 {
            op.addOperation { v in
                // QoS should be inherited from the AtomicBlockOperation QoS
                XCTAssertEqual(Thread.current.qualityOfService, .userInitiated)
                
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
        
        // must manually increment for OperationQueue
        opQ.progress.totalUnitCount += 1
        // queue automatically starts the operation once it's added
        opQ.addOperation(op)
        
        wait(for: [completionBlockExp, dataVerificationExp], timeout: 1)
        
        // state
        XCTAssertEqual(opQ.operationCount, 0)
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        
    }
    
    /// Standalone operation, serial FIFO queue mode. Test that start() runs synchronously. Run it.
    func testOp_serialFIFO_SynchronousTest_Run() {
        
        let op = AtomicBlockOperation(type: .serialFIFO,
                                      initialMutableValue: [Int]())
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 { // will take 1 second to complete
            op.addOperation { v in
                sleep(0.01)
                v.mutate { $0.append(val) }
            }
        }
        
        op.setCompletionBlock { _ in
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        // check that all operations executed and they are in serial FIFO order
        XCTAssertEqual(op.value, Array(1...100))
        
        // state
        XCTAssertTrue(op.isFinished)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        
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
        
        wait(for: [completionBlockExp], timeout: 5)
        
        // state
        XCTAssertTrue(mainOp.isFinished)
        XCTAssertFalse(mainOp.isCancelled)
        XCTAssertFalse(mainOp.isExecuting)
        
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
                let ref = subOp.addInteractiveOperation { op, v in
                    if op.mainShouldAbort() { return }
                    sleep(0.2)
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
        
        // must run start() async in order to cancel it, since
        // the operation is synchronous and will complete before we
        // can call cancel() if start() is run in-thread
        DispatchQueue.global().async {
            mainOp.start()
        }
        sleep(0.1)
        mainOp.cancel()
        
        wait(for: [completionBlockExp], timeout: 1)
        
        //XCTAssertEqual(mainOp.operationQueue.operationCount, 0)
        
        // state
        XCTAssertTrue(mainOp.isFinished)
        XCTAssertTrue(mainOp.isCancelled)
        XCTAssertFalse(mainOp.isExecuting) // TODO: technically this should be true, but it gets set to false when the completion method gets called even if async code is still running
        
        let expectedArray = (1...10).reduce(into: [Int: [Int]]()) {
            $0[$1] = Array(1...200)
        }
        XCTAssertNotEqual(mainVal, expectedArray)
        
    }
    
    /// Ensure that nested progress objects successfully result in the topmost queue calling statusHandler at every increment of all progress children at every level.
    func testProgress() {
        
        class OpQProgressTest {
            var statuses: [OperationQueueStatus] = []
            
            let mainOp = AtomicOperationQueue(type: .serialFIFO,
                                              qualityOfService: .default,
                                              initiallySuspended: true,
                                              resetProgressWhenFinished: true,
                                              initialMutableValue: 0)
            
            init() {
                mainOp.statusHandler = { newStatus, oldStatus in
                    if self.statuses.isEmpty {
                        self.statuses.append(oldStatus)
                        print("-", oldStatus)
                    }
                    self.statuses.append(newStatus)
                    print("-", newStatus)
                }
            }
        }
        
        let ppQProgressTest = OpQProgressTest()
        
        func runTest() {
            // 5 ops, each with 2 ops, each with 2 units of progress.
            // should equate to 20 total main progress updates 5% apart
            for _ in 1...5 {
                let subOp = AtomicBlockOperation(type: .serialFIFO,
                                                 initialMutableValue: 0)
                
                for _ in 1...2 {
                    subOp.addInteractiveOperation { operation, atomicValue in
                        operation.progress.totalUnitCount = 2
                        
                        operation.progress.completedUnitCount = 1
                        operation.progress.completedUnitCount = 2
                    }
                }
                
                ppQProgressTest.mainOp.addOperation(subOp)
            }
            
            ppQProgressTest.mainOp.isSuspended = false
            
            wait(for: ppQProgressTest.mainOp.status == .idle, timeout: 2.0)
        }
        
        let runExp = expectation(description: "Test Run")
        DispatchQueue.global().async {
            runTest()
            runExp.fulfill()
        }
        wait(for: [runExp], timeout: 5.0)
        
        XCTAssertEqual(ppQProgressTest.statuses, [
            .idle,
            .paused,
            .inProgress(fractionCompleted: 0.00, message: "0% completed"),
            .inProgress(fractionCompleted: 0.05, message: "5% completed"),
            .inProgress(fractionCompleted: 0.10, message: "10% completed"),
            .inProgress(fractionCompleted: 0.15, message: "15% completed"),
            .inProgress(fractionCompleted: 0.20, message: "20% completed"),
            .inProgress(fractionCompleted: 0.25, message: "25% completed"),
            .inProgress(fractionCompleted: 0.30, message: "30% completed"),
            .inProgress(fractionCompleted: 0.35, message: "35% completed"),
            .inProgress(fractionCompleted: 0.40, message: "40% completed"),
            .inProgress(fractionCompleted: 0.45, message: "45% completed"),
            .inProgress(fractionCompleted: 0.50, message: "50% completed"),
            .inProgress(fractionCompleted: 0.55, message: "55% completed"),
            .inProgress(fractionCompleted: 0.60, message: "60% completed"),
            .inProgress(fractionCompleted: 0.65, message: "65% completed"),
            .inProgress(fractionCompleted: 0.70, message: "70% completed"),
            .inProgress(fractionCompleted: 0.75, message: "75% completed"),
            .inProgress(fractionCompleted: 0.80, message: "80% completed"),
            .inProgress(fractionCompleted: 0.85, message: "85% completed"),
            .inProgress(fractionCompleted: 0.90, message: "90% completed"),
            .inProgress(fractionCompleted: 0.95, message: "95% completed"),
            .idle
        ])
        
    }
    
}

#endif
