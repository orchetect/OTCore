//
//  DispatchGroup Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

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
    
}

#endif
