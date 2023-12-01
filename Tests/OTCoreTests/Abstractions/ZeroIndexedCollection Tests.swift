//
//  ZeroIndexedCollection Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Abstractions_ZeroIndexedCollection_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testZeroIndexedCollection() {
        let arr = ["A", "B", "C"]
        let filtered = arr.lazy.filter { $0 != "A" }
        
        let coll = ZeroIndexedCollection(filtered)
        
        XCTAssertEqual(coll.isEmpty, false)
        XCTAssertEqual(coll.count, 2)
        XCTAssertEqual(coll[0], "B")
        XCTAssertEqual(coll[1], "C")
    }
    
    func testZeroIndexedMutableCollection() {
        var coll = ZeroIndexedMutableCollection(["A", "B", "C"][1...])
        
        XCTAssertEqual(coll.isEmpty, false)
        XCTAssertEqual(coll.count, 2)
        
        XCTAssertEqual(coll.first, "B")
        XCTAssertEqual(coll[0], "B")
        XCTAssertEqual(coll[1], "C")
        
        // mutate
        
        coll[0] = "X"
        XCTAssertEqual(coll[0], "X")
        XCTAssertEqual(coll[1], "C")
        
        coll[1] = "Y"
        XCTAssertEqual(coll[0], "X")
        XCTAssertEqual(coll[1], "Y")
        
        coll.swapAt(0, 1)
        XCTAssertEqual(coll[0], "Y")
        XCTAssertEqual(coll[1], "X")
        
        XCTAssertEqual(coll.first, "Y")
        XCTAssertEqual(coll.firstRange(of: ["Y", "X"]), 0 ..< 2)
    }
    
    func testZeroIndexedRangeReplaceableCollection() {
        var coll = ZeroIndexedRangeReplaceableCollection(["A", "B", "C", "D", "E"][1...])
        
        XCTAssertEqual(coll.isEmpty, false)
        XCTAssertEqual(coll.count, 4)
        
        XCTAssertEqual(coll.first, "B")
        XCTAssertEqual(coll[0], "B")
        XCTAssertEqual(coll[1], "C")
        XCTAssertEqual(coll[2], "D")
        XCTAssertEqual(coll[3], "E")
        
        // mutate
        
        coll.replaceSubrange(1 ..< 3, with: ["X", "Y"])
        XCTAssertEqual(coll.count, 4)
        XCTAssertEqual(coll[0], "B")
        XCTAssertEqual(coll[1], "X")
        XCTAssertEqual(coll[2], "Y")
        XCTAssertEqual(coll[3], "E")
        
        coll.replaceSubrange(1 ..< 3, with: ["J", "K", "L"])
        XCTAssertEqual(coll.count, 5)
        XCTAssertEqual(coll[0], "B")
        XCTAssertEqual(coll[1], "J")
        XCTAssertEqual(coll[2], "K")
        XCTAssertEqual(coll[3], "L")
        XCTAssertEqual(coll[4], "E")
    }
}

#endif
