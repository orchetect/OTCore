//
//  Optional Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

// testOptionalType() declares

fileprivate protocol testStructProtocol { }

extension Collection where Element: OTCoreOptionalTyped,
Element.Wrapped: testStructProtocol {
    fileprivate var foo: Int { 2 }
}

class Extensions_Swift_Optional_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testOptionalType() {
        // basic test
        
        let num: Int? = 1
        
        XCTAssertEqual(num.optional, Optional(1))
        
        // extension test
        
        struct testStruct<T: BinaryInteger>: testStructProtocol {
            var value: T
        }
        
        let arr: [testStruct<UInt8>?] = [testStruct(value: UInt8(1)), nil]
        
        XCTAssertEqual(arr.foo, 2) // ensure the extension works
    }
    
    func testDefault() {
        let val1: Int? = 1
        
        XCTAssertEqual(val1.ifNil(2), 1)
        
        let val2: Int? = nil
        
        XCTAssertEqual(val2.ifNil(2), 2)
    }
    
    func testOptionalProperty() {
        var val: Int? = 1
        
        XCTAssertEqual(val.optional, 1)
        
        val.optional = 2
        
        XCTAssertEqual(val.optional, 2)
        
        val.optional = nil
        
        XCTAssertEqual(val.optional, nil)
    }
}

#endif
