//
//  AtomicOperationQueue Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

@testable import OTCore
import XCTest

final class Threading_AtomicOperationQueue_Tests: XCTestCase {
    
    /// Serial FIFO queue.
    func testOp_serialFIFO_Run() {
        
        let oq = AtomicOperationQueue(type: .serialFIFO,
                                      initialMutableValue: [Int]())
        
        for val in 1...100 {
            oq.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        let timeoutResult = oq.waitUntilAllOperationsAreFinished(timeout: .seconds(1))
        XCTAssertEqual(timeoutResult, .success)
        
        XCTAssertEqual(oq.sharedMutableValue.count, 100)
        XCTAssert(Array(1...100).allSatisfy(oq.sharedMutableValue.contains))
        
        XCTAssertEqual(oq.operationCount, 0)
        XCTAssertFalse(oq.isSuspended)
        
    }
    
    /// Concurrent automatic threading. Run it.
    func testOp_concurrentAutomatic_Run() {

        let oq = AtomicOperationQueue(type: .concurrentAutomatic,
                                      initialMutableValue: [Int]())
        
        for val in 1...100 {
            oq.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        let timeoutResult = oq.waitUntilAllOperationsAreFinished(timeout: .seconds(1))
        XCTAssertEqual(timeoutResult, .success)

        XCTAssertEqual(oq.sharedMutableValue.count, 100)
        // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
        XCTAssert(Array(1...100).allSatisfy(oq.sharedMutableValue.contains))

        XCTAssertEqual(oq.operationCount, 0)
        XCTAssertFalse(oq.isSuspended)

    }

    /// Concurrent automatic threading. Do not run it.
    func testOp_concurrentAutomatic_NotRun() {

        let oq = AtomicOperationQueue(type: .concurrentAutomatic,
                                      initialMutableValue: [Int]())
        
        oq.isSuspended = true
        
        for val in 1...100 {
            oq.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        let timeoutResult = oq.waitUntilAllOperationsAreFinished(timeout: .seconds(1))
        XCTAssertEqual(timeoutResult, .timedOut)

        XCTAssertEqual(oq.sharedMutableValue, [])
        XCTAssertEqual(oq.operationCount, 100)
        XCTAssertTrue(oq.isSuspended)

    }
    
    /// Concurrent automatic threading. Run it.
    func testOp_concurrentSpecific_Run() {
        
        let oq = AtomicOperationQueue(type: .concurrent(max: 10),
                                      initialMutableValue: [Int]())
        
        for val in 1...100 {
            oq.addOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
        }
        
        let timeoutResult = oq.waitUntilAllOperationsAreFinished(timeout: .seconds(1))
        XCTAssertEqual(timeoutResult, .success)
        
        XCTAssertEqual(oq.sharedMutableValue.count, 100)
        // this happens to be in serial order even though we are using concurrent threads and no operation dependencies are being used
        XCTAssert(Array(1...100).allSatisfy(oq.sharedMutableValue.contains))
        
        XCTAssertEqual(oq.operationCount, 0)
        XCTAssertFalse(oq.isSuspended)
        
    }
    
    /// Serial FIFO queue.
    /// Test the behavior of `addOperations()`. It should add operations in array order.
    func testOp_serialFIFO_AddOperations_Run() {
        
        let oq = AtomicOperationQueue(type: .serialFIFO,
                                      initialMutableValue: [Int]())
        var ops: [Operation] = []
        
        // first generate operation objects
        for val in 1...50 {
            let op = oq.createOperation { sharedMutableValue in
                sharedMutableValue.append(val)
            }
            ops.append(op)
        }
        for val in 51...100 {
            let op = oq.createCancellableOperation { _, sharedMutableValue in
                sharedMutableValue.append(val)
            }
            ops.append(op)
        }
        
        // then addOperations() with all 100 operations
        oq.addOperations(ops, waitUntilFinished: false)
        
        let timeoutResult = oq.waitUntilAllOperationsAreFinished(timeout: .seconds(1))
        XCTAssertEqual(timeoutResult, .success)
        
        XCTAssertEqual(oq.sharedMutableValue.count, 100)
        XCTAssert(Array(1...100).allSatisfy(oq.sharedMutableValue.contains))
        
        XCTAssertEqual(oq.operationCount, 0)
        XCTAssertFalse(oq.isSuspended)
        
    }
    
}

#endif
