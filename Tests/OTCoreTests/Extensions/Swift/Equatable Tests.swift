//
//  Equatable Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_Equatable_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testIf_ThenValue() {
        
        // emitting same type as self
        
        XCTAssertEqual (
            123.if({ $0 > 100 }, then: 50),
            50
        )
        
        XCTAssertEqual (
            123.if({ $0 < 100 }, then: 50),
            nil
        )
        
        // emitting different type than self
        
        XCTAssertEqual (
            123.if({ $0 > 100 }, then: "yes"),
            "yes"
        )
        
        XCTAssertEqual (
            123.if({ $0 < 100 }, then: "yes"),
            nil
        )
        
    }
    
    func testIf_ThenClosure() {
        
        // emitting same type as self
        
        XCTAssertEqual (
            123.if({ $0 > 100 }, then: { $0 * 2 }),
            246
        )
        
        XCTAssertEqual (
            123.if({ $0 < 100 }, then: { $0 * 2 }),
            nil
        )
        
        // emitting different type than self
        
        XCTAssertEqual (
            123.if({ $0 > 100 }, then: { "\($0 * 2)" }),
            "246"
        )
        
        XCTAssertEqual (
            123.if({ $0 < 100 }, then: { "\($0 * 2)" }),
            nil
        )
        
    }
    
    func testIf_ThenValue_ElseValue() {
        
        // emitting same type as self
        
        XCTAssertEqual (
            123.if({ $0 > 100 }, then: 50, else: 200),
            50
        )
        
        XCTAssertEqual (
            123.if({ $0 < 100 }, then: 50, else: 200),
            200
        )
        
        // emitting different type than self
        
        XCTAssertEqual (
            123.if({ $0 > 100 }, then: "yes", else: "no"),
            "yes"
        )
        
        XCTAssertEqual (
            123.if({ $0 < 100 }, then: "yes", else: "no"),
            "no"
        )
        
    }
    
    func testIf_ThenClosure_ElseClosure() {
        
        // emitting same type as self
        
        XCTAssertEqual (
            123.if({ $0 > 100 },
                   then: { $0 + 2 },
                   else: { $0 - 2 }),
            125)
        
        XCTAssertEqual (
            123.if({ $0 < 100 },
                   then: { $0 + 2 },
                   else: { $0 - 2 }),
            121)
        
        // emitting different type than self
        
        XCTAssertEqual (
            123.if({ $0 > 100 },
                   then: { "yes \($0)" },
                   else: { "no \($0)" }),
            "yes 123"
        )
        
        XCTAssertEqual (
            123.if({ $0 < 100 },
                   then: { "yes \($0)" },
                   else: { "no \($0)" }),
            "no 123"
        )
        
    }
    
}

#endif
