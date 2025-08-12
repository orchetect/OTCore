//
//  Clamped Property Wrapper Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import XCTest

class Abstractions_Clamped_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testClampedPropertyWrapper_ClosedRange() {
        struct SomeStruct {
            @Clamped(to: 5 ... 10) var value = 1
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 5) // default clamped
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 5
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 10)
        
        someStruct.value = 11
        XCTAssertEqual(someStruct.value, 10)
    }
    
    func testClampedPropertyWrapper_ClosedRange_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: 5 ... 5) var value = 1
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 5) // default clamped
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 5
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 5)
    }
    
    func testClampedPropertyWrapper_Range() {
        struct SomeStruct {
            @Clamped(to: 5 ..< 10) var value = 1
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 5) // default clamped
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 5
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 9
        XCTAssertEqual(someStruct.value, 9)
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 9)
    }
    
    func testClampedPropertyWrapper_Range_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: 5 ..< 5) var value = 1
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 1) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 2) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 5
        XCTAssertEqual(someStruct.value, 5) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 9
        XCTAssertEqual(someStruct.value, 9) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 10) // invalid range, doesn't clamp, just returns value
    }
    
    func testClampedPropertyWrapper_PartialRangeUpTo() {
        struct SomeStruct {
            @Clamped(to: ..<10) var value = 15
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 9) // default clamped
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 2)
        
        someStruct.value = 5
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 9
        XCTAssertEqual(someStruct.value, 9)
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 9)
    }
    
    func testClampedPropertyWrapper_PartialRangeUpTo_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: ..<Int.min) var value = 15
        }
        
        // this results in a crash, so we can't/shouldn't test it here
        
        // it should be the user's responsibility to check if the range is valid
    }
    
    func testClampedPropertyWrapper_PartialRangeThrough() {
        struct SomeStruct {
            @Clamped(to: ...10) var value = 15
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 10) // default clamped
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 2)
        
        someStruct.value = 5
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 10)
        
        someStruct.value = 11
        XCTAssertEqual(someStruct.value, 10)
    }
    
    func testClampedPropertyWrapper_PartialRangeThrough_EdgeCase1() {
        struct SomeStruct {
            @Clamped(to: ...Int.min) var value = 15
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, Int.min) // default clamped
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, Int.min)
    }
    
    func testClampedPropertyWrapper_PartialRangeThrough_EdgeCase2() {
        struct SomeStruct {
            @Clamped(to: ...Int.max) var value = 15
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 15)
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 2)
        
        someStruct.value = Int.max
        XCTAssertEqual(someStruct.value, Int.max)
    }
    
    func testClampedPropertyWrapper_PartialRangeFrom() {
        struct SomeStruct {
            @Clamped(to: 10...) var value = 2
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, 10) // default clamped
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 10)
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 10)
        
        someStruct.value = 11
        XCTAssertEqual(someStruct.value, 11)
        
        someStruct.value = Int.max
        XCTAssertEqual(someStruct.value, Int.max)
    }
    
    func testClampedPropertyWrapper_PartialRangeFrom_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: Int.max...) var value = 2
        }
        
        var someStruct = SomeStruct()
        XCTAssertEqual(someStruct.value, Int.max) // default clamped
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, Int.max)
        
        someStruct.value = Int.max
        XCTAssertEqual(someStruct.value, Int.max)
    }
}
