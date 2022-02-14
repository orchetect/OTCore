//
//  BlockOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore
import OTAtomics

final class BlockOperation_Tests: XCTestCase {
    
    @OTAtomicsThreadSafe fileprivate var arr: [Int] = []
    
    /// This does not test a feature of OTCore. Rather, it tests the behavior of Foundation's built-in `BlockOperation` object.
    func testBlockOperation() {
        
        let op = BlockOperation()
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        for val in 1...100 { // will multi-thread
            op.addExecutionBlock {
                sleep(0.1)
                self.arr.append(val)
            }
        }
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        // check that all operations executed.
        // sort them first because BlockOperation execution blocks run concurrently and may be out-of-sequence
        XCTAssertEqual(arr.sorted(), Array(1...100))
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
        wait(for: [completionBlockExp], timeout: 2)
        
    }
    
}

#endif
