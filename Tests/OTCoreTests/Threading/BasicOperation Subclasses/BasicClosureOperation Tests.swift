//
//  BasicClosureOperation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

import OTCore
import XCTest

final class Threading_BasicClosureOperation_Tests: XCTestCase {
    
    override func setUp() async throws {
        mainCheck = { }
    }
    
    private var mainCheck: () -> Void = { }
    
    func testOpRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = BasicClosureOperation {
            self.mainCheck()
        }
         
        // have to define this after BasicClosureOperation is initialized, since it can't reference itself in its own initializer closure
        mainCheck = {
            mainBlockExp.fulfill()
            XCTAssertTrue(op.isExecuting)
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        op.start()
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
    func testOpNotRun() {
        
        let mainBlockExp = expectation(description: "Main Block Called")
        mainBlockExp.isInverted = true
        
        let op = BasicClosureOperation {
            self.mainCheck()
        }
        
        // have to define this after BasicClosureOperation is initialized, since it can't reference itself in its own initializer closure
        mainCheck = {
            mainBlockExp.fulfill()
            XCTAssertTrue(op.isExecuting)
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        completionBlockExp.isInverted = true
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertTrue(op.isReady)
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertFalse(op.isFinished)
        
    }
    
    /// Test in the context of an OperationQueue. Run is implicit.
    func testQueue() {
        
        let oq = OperationQueue()
        
        let mainBlockExp = expectation(description: "Main Block Called")
        
        let op = BasicClosureOperation {
            self.mainCheck()
        }
        
        // have to define this after BasicClosureOperation is initialized, since it can't reference itself in its own initializer closure
        mainCheck = {
            mainBlockExp.fulfill()
            XCTAssertTrue(op.isExecuting)
        }
        
        let completionBlockExp = expectation(description: "Completion Block Called")
        
        op.completionBlock = {
            completionBlockExp.fulfill()
        }
        
        // queue automatically starts the operation once it's added
        oq.addOperation(op)
        
        wait(for: [mainBlockExp, completionBlockExp], timeout: 0.5)
        
        XCTAssertEqual(oq.operationCount, 0)
        
        XCTAssertFalse(op.isCancelled)
        XCTAssertFalse(op.isExecuting)
        XCTAssertTrue(op.isFinished)
        
    }
    
}
