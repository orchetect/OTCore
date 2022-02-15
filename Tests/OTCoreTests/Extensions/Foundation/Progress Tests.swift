//
//  Progress Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_Progress_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testProgressParent_Nil() {
        
        let empty = Progress()
        
        XCTAssertNil(empty.parent)
        
    }
    
    func testProgressParent() {
        
        let master = Progress()
        let child1 = Progress(totalUnitCount: 10, parent: master, pendingUnitCount: 10)
        let child2 = Progress(totalUnitCount: 10, parent: master, pendingUnitCount: 10)
        
        XCTAssertEqual(child1.parent, master)
        XCTAssertEqual(child2.parent, master)
        
    }
    
    func testProgressChildren_Empty() {
        
        let empty = Progress()
        
        XCTAssertEqual(empty.children, [])
        
    }
    
    func testProgressChildren() {
        
        let master = Progress()
        let child1 = Progress(totalUnitCount: 10, parent: master, pendingUnitCount: 10)
        let child2 = Progress(totalUnitCount: 10, parent: master, pendingUnitCount: 10)
        
        XCTAssertEqual(master.children, [child1, child2])
        
    }
    
}

#endif
