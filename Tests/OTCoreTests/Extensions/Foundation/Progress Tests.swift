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
    
    func testParent_Memory() {
        class Foo {
            weak var master: Progress?
            weak var child1: Progress?
            weak var child2: Progress?
        }
        
        let foo = Foo()
        
        autoreleasepool {
            let strongMaster = Progress(totalUnitCount: 20)
            foo.master = strongMaster
            
            let child1 = Progress(totalUnitCount: 10, parent: strongMaster, pendingUnitCount: 10)
            foo.child1 = child1
            
            let child2 = Progress(totalUnitCount: 10, parent: strongMaster, pendingUnitCount: 10)
            foo.child2 = child2
            
            // just access the parent, we want to check that it doesn't create memory issues
            _ = child1.parent
            
            // complete the children
            child1.completedUnitCount = child1.totalUnitCount
            child2.completedUnitCount = child2.totalUnitCount
        }
        
        // ensure parent deallocates and has no strong references remaining in memory
        
        XCTAssertNil(foo.master)
        XCTAssertNil(foo.child1)
        XCTAssertNil(foo.child1?.parent)
        XCTAssertNil(foo.child2)
        XCTAssertNil(foo.child2?.parent)
    }
    
    func testChildren_Memory() {
        class Foo {
            var master: Progress!
            weak var child1: Progress?
            weak var child2: Progress?
        }
        
        var foo: Foo!
        weak var masterRef: Progress?
        
        autoreleasepool {
            foo = Foo()
            
            do {
                foo.master = Progress(totalUnitCount: 20)
                
                let child1 = Progress(totalUnitCount: 10, parent: foo.master, pendingUnitCount: 10)
                foo.child1 = child1
                
                let child2 = Progress(totalUnitCount: 10, parent: foo.master, pendingUnitCount: 10)
                foo.child2 = child2
            }
            
            // just access children, we want to check that it doesn't create memory issues
            _ = foo.master!.children
            
            // complete the children
            foo.child1!.completedUnitCount = foo.child1!.totalUnitCount
            foo.child2!.completedUnitCount = foo.child2!.totalUnitCount
            
            // ensure parent deallocates and has no strong references remaining in memory
            
            XCTAssertNil(foo.child1)
            XCTAssertNil(foo.child1?.parent)
            XCTAssertNil(foo.child2)
            XCTAssertNil(foo.child2?.parent)
            
            masterRef = foo.master
            foo = nil
        }
        
        XCTAssertNil(masterRef)
    }
}

#endif
