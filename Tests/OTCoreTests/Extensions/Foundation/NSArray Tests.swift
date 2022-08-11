//
//  NSArray Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_NSArray_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testNSArray_SafeIndexSubscript_Get() {
        let nsArr = [1, 2, 3] as NSArray
        
        XCTAssertEqual(nsArr[safe: -1] as? Int, nil)
        XCTAssertEqual(nsArr[safe:  0] as? Int, 1)
        XCTAssertEqual(nsArr[safe:  1] as? Int, 2)
        XCTAssertEqual(nsArr[safe:  2] as? Int, 3)
        XCTAssertEqual(nsArr[safe:  3] as? Int, nil)
        
        // edge cases
        
        // empty array
        let nsArr2 = [] as NSArray
        XCTAssertEqual(nsArr2[safe: -1] as? Int, nil)
        XCTAssertEqual(nsArr2[safe:  0] as? Int, nil)
        XCTAssertEqual(nsArr2[safe:  1] as? Int, nil)
        
        // single element array
        let nsArr3 = [1] as NSArray
        XCTAssertEqual(nsArr3[safe: -1] as? Int, nil)
        XCTAssertEqual(nsArr3[safe:  0] as? Int, 1)
        XCTAssertEqual(nsArr3[safe:  1] as? Int, nil)
    }
    
    func testNSMutableArray_SafeIndexSubscript_Get() {
        let nsArr = [1, 2, 3] as NSMutableArray
        
        XCTAssertEqual(nsArr[safe: -1] as? Int, nil)
        XCTAssertEqual(nsArr[safe:  0] as? Int, 1)
        XCTAssertEqual(nsArr[safe:  1] as? Int, 2)
        XCTAssertEqual(nsArr[safe:  2] as? Int, 3)
        XCTAssertEqual(nsArr[safe:  3] as? Int, nil)
        
        // edge cases
        
        // empty array
        let nsArr2 = [] as NSMutableArray
        XCTAssertEqual(nsArr2[safe: -1] as? Int, nil)
        XCTAssertEqual(nsArr2[safe:  0] as? Int, nil)
        XCTAssertEqual(nsArr2[safe:  1] as? Int, nil)
        
        // single element array
        let nsArr3 = [1] as NSMutableArray
        XCTAssertEqual(nsArr3[safe: -1] as? Int, nil)
        XCTAssertEqual(nsArr3[safe:  0] as? Int, 1)
        XCTAssertEqual(nsArr3[safe:  1] as? Int, nil)
    }
    
    func testNSMutableArray_SafeMutableIndexSubscript() {
        // get
        
        let nsArr = [1, 2, 3] as NSMutableArray
        
        XCTAssertEqual(nsArr[safeMutable: -1] as? Int, nil)
        XCTAssertEqual(nsArr[safeMutable:  0] as? Int, 1)
        XCTAssertEqual(nsArr[safeMutable:  1] as? Int, 2)
        XCTAssertEqual(nsArr[safeMutable:  2] as? Int, 3)
        XCTAssertEqual(nsArr[safeMutable:  3] as? Int, nil)
        
        // set
        
        let nsArr2 = [1, 2, 3] as NSMutableArray
        
        nsArr2[safeMutable: -1] = 4 // fails silently, no value stored
        nsArr2[safeMutable: 0] = 5
        nsArr2[safeMutable: 1] = 6
        nsArr2[safeMutable: 2] = 7
        nsArr2[safeMutable: 3] = 8 // fails silently, no value stored
        
        XCTAssertEqual(nsArr2, [5, 6, 7])
    }
    
    func testNSMutableArray_SafeIndexSubscript_Modify() {
        struct Foo {
            var value: Int = 0
        }
        
        // NSMutableArray
        let arr: NSMutableArray = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        _ = arr
        
        // this is not testable (or even usable) because
        // NSMutableArray seems to only support get and
        // set by assignment, not inline mutability.
        
//        // we would want this to succeed
//        (arr[safeMutable: 1] as! Foo).value = 9
//        XCTAssertEqual(arr.count, 3)
//        XCTAssertEqual((arr[0] as? Foo)?.value, 0)
//        XCTAssertEqual((arr[1] as? Foo)?.value, 9)
//        XCTAssertEqual((arr[2] as? Foo)?.value, 2)
//
//        // fails silently
//        (arr[safeMutable: 3] as? Foo)?.value = 8
//        XCTAssertEqual(arr.count, 3)
//        XCTAssertEqual((arr[0] as? Foo)?.value, 0)
//        XCTAssertEqual((arr[1] as? Foo)?.value, 9)
//        XCTAssertEqual((arr[2] as? Foo)?.value, 2)
    }
}

#endif
