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
    
    func testSyncReturnValue() {
        
        let returnValue = DispatchGroup.sync { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                g.leave(withValue: 1)
            }
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
    
    func testNesting() {
        
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
    
}

#endif
