//
//  DispatchGroup Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
@testable import OTCore

class Extensions_Foundation_DispatchGroup_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSync() {
        let exp = expectation(description: "")
        
        DispatchGroup.sync { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                exp.fulfill()
                g.leave()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSyncOnQueue() {
        let exp = expectation(description: "")
        
        DispatchGroup.sync(asyncOn: .global()) { g in
            sleep(0.1)
            
            exp.fulfill()
            g.leave()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSyncTimeout_timedOut() {
        let exp = expectation(description: "")
        exp.isInverted = true
        
        let result = DispatchGroup.sync(timeout: .milliseconds(100)) { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                exp.fulfill()
                g.leave()
            }
        }
        
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(result, .timedOut)
    }
    
    func testSyncTimeout_success() {
        let exp = expectation(description: "")
        
        let result = DispatchGroup.sync(timeout: .seconds(1)) { g in
            DispatchQueue.global().async() {
                exp.fulfill()
                g.leave()
            }
        }
        
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(result, .success)
    }
    
    func testSyncOnQueueTimeout_timedOut() {
        let exp = expectation(description: "")
        exp.isInverted = true
        
        let result = DispatchGroup.sync(
            asyncOn: .global(),
            timeout: .milliseconds(100)
        ) { g in
            sleep(1) // 1 second
            exp.fulfill()
            g.leave()
        }
        
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(result, .timedOut)
    }
    
    func testSyncOnQueueTimeout_success() {
        let exp = expectation(description: "")
        
        let result = DispatchGroup.sync(
            asyncOn: .global(),
            timeout: .seconds(1)
        ) { g in
            exp.fulfill()
            g.leave()
        }
        
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(result, .success)
    }
    
    func testSyncReturnValue() {
        let returnValue = DispatchGroup.sync { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                g.leave(withValue: 1)
            }
        }
        
        XCTAssertEqual(returnValue, 1)
    }
    
    func testSyncReturnValueOnQueue() {
        let returnValue: Int = DispatchGroup.sync(asyncOn: .global()) { g in
            sleep(0.1)
            g.leave(withValue: 1)
        }
        
        XCTAssertEqual(returnValue, 1)
    }
    
    func testSyncReturnValueTimeout_timedOut() {
        let result = DispatchGroup.sync(timeout: .milliseconds(100)) { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                g.leave(withValue: 1)
            }
        }
        
        switch result {
        case .success:
            XCTFail()
        case .timedOut:
            // correct
            break
        }
    }
    
    func testSyncReturnValueTimeout_success() {
        let result = DispatchGroup.sync(timeout: .milliseconds(100)) { g in
            DispatchQueue.global().async() {
                g.leave(withValue: 1)
            }
        }
        
        switch result {
        case let .success(value):
            // correct
            XCTAssertEqual(value, 1)
        case .timedOut:
            XCTFail()
        }
    }
    
    func testSyncReturnValueOnQueueTimeout_timedOut() {
        let result: DispatchSyncTimeoutResult<Int> =
            DispatchGroup.sync(
                asyncOn: .global(),
                timeout: .milliseconds(100)
            ) { g in
                sleep(1) // 1 second
                g.leave(withValue: 1)
            }
        
        switch result {
        case .success:
            XCTFail()
        case .timedOut:
            // correct
            break
        }
    }
    
    func testSyncReturnValueOnQueueTimeout_success() {
        let result: DispatchSyncTimeoutResult<Int> =
            DispatchGroup.sync(
                asyncOn: .global(),
                timeout: .seconds(1)
            ) { g in
                g.leave(withValue: 1)
            }
        
        switch result {
        case let .success(value):
            // correct
            XCTAssertEqual(value, 1)
        case .timedOut:
            XCTFail()
        }
    }
    
    func testNesting2() {
        var val = 0
        
        var to1: DispatchTimeoutResult?
        var to2: DispatchTimeoutResult?
        
        to1 = DispatchGroup.sync(timeout: .seconds(1)) { g in
            to2 = DispatchGroup.sync(timeout: .milliseconds(500)) { g in
                val = 1
                g.leave()
            }
            g.leave()
        }
        
        XCTAssertEqual(to1, .success)
        XCTAssertEqual(to2, .success)
        XCTAssertEqual(val, 1)
    }
}
