//
//  DispatchGroup Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_DispatchGroup_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSync() {
        
        var val = 0
        
        DispatchGroup.sync { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                val = 1
                g.leave()
            }
        }
        
        XCTAssertEqual(val, 1)
        
    }
    
    func testSyncOnQueue() {
        
        var val = 0
        
        DispatchGroup.sync(asyncOn: .global()) { g in
            usleep(100_000) // 100 milliseconds
            val = 1
            g.leave()
        }
        
        XCTAssertEqual(val, 1)
        
    }
    
    func testSyncTimeout_timedOut() {
        
        var val = 0
        
        let result = DispatchGroup.sync(timeout: .milliseconds(100)) { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                val = 1
                g.leave()
            }
        }
        
        XCTAssertEqual(val, 0)
        XCTAssertEqual(result, .timedOut)
        
    }
    
    func testSyncTimeout_success() {
        
        var val = 0
        
        let result = DispatchGroup.sync(timeout: .seconds(1)) { g in
            DispatchQueue.global().async() {
                val = 1
                g.leave()
            }
        }
        
        XCTAssertEqual(val, 1)
        XCTAssertEqual(result, .success)
        
    }
    
    func testSyncOnQueueTimeout_timedOut() {
        
        var val = 0
        
        let result = DispatchGroup.sync(asyncOn: .global(),
                                        timeout: .milliseconds(100)) { g in
            sleep(1) // 1 second
            val = 1
            g.leave()
        }
        
        XCTAssertEqual(val, 0)
        XCTAssertEqual(result, .timedOut)
        
    }
    
    func testSyncOnQueueTimeout_success() {
        
        var val = 0
        
        let result = DispatchGroup.sync(asyncOn: .global(),
                                        timeout: .seconds(1)) { g in
            val = 1
            g.leave()
        }
        
        XCTAssertEqual(val, 1)
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
            usleep(100_000) // 100 milliseconds
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
        case .success(_):
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
        case .success(let value):
            // correct
            XCTAssertEqual(value, 1)
        case .timedOut:
            XCTFail()
        }
        
    }
    
    func testSyncReturnValueOnQueueTimeout_timedOut() {
        
        let result: DispatchSyncTimeoutResult<Int> =
        DispatchGroup.sync(asyncOn: .global(),
                           timeout: .milliseconds(100)) { g in
            sleep(1) // 1 second
            g.leave(withValue: 1)
        }
        
        switch result {
        case .success(_):
            XCTFail()
        case .timedOut:
            // correct
            break
        }
        
    }
    
    func testSyncReturnValueOnQueueTimeout_success() {
        
        let result: DispatchSyncTimeoutResult<Int> =
        DispatchGroup.sync(asyncOn: .global(),
                           timeout: .seconds(1)) { g in
            g.leave(withValue: 1)
        }
        
        switch result {
        case .success(let value):
            // correct
            XCTAssertEqual(value, 1)
        case .timedOut:
            XCTFail()
        }
        
    }
    
    func testNesting1() {
        
        let exp = expectation(description: "Inner sync reached")
        var result = 0
        
        DispatchGroup.sync { g1 in
            DispatchQueue.global().async {
                DispatchGroup.sync { g2 in
                    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                        result = DispatchGroup.sync { g3 in
                            usleep(100_000) // 100 milliseconds
                            exp.fulfill()
                            g3.leave(withValue: 2)
                        }
                        g2.leave()
                    }
                }
            }
            g1.leave()
        }
        
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(result, 2)
        
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

#endif
