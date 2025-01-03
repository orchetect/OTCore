//
//  Collections Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OTCore

class Extensions_Swift_Collections_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Collection += Operator
    
    func testCollection_Operator_PlusEquals_Element() {
        // [String]
                                                  
        var arr1: [String] = []
        arr1 += "test"
        XCTAssertEqual(arr1, ["test"])
        
        // [Int]
        
        var arr2: [Int] = []
        arr2 += 2
        XCTAssertEqual(arr2, [2])
        
        // Set<Int>
        
        var set: Set<Int> = [3]
        set += 1
        XCTAssertEqual(set, [1, 3])
        
        // tuple
        
        var arr3: [(Int, Int)] = []
        arr3 += (1, 2)
        XCTAssertEqual(arr3[0].0, 1)
        XCTAssertEqual(arr3[0].1, 2)
        
        // [[String]]
        
        var arr4: [[String]] = []
        arr4 += ["test"]
        XCTAssertEqual(arr4, [["test"]])
    }
    
    func testSet_Operator_Plus_Set() {
        var set: Set<Int> = [3]
        set = set + Set([1, 2])
        XCTAssertEqual(set, [1, 2, 3])
    }
    
    func testSet_Operator_PlusEquals_Set() {
        var set: Set<Int> = [3]
        set += Set([1, 2])
        XCTAssertEqual(set, [1, 2, 3])
    }
    
    // MARK: - [safe: Index]
    
    func testSubscript_Safe_Get() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        XCTAssertEqual(arr[safe: -1], nil)
        XCTAssertEqual(arr[safe: 0], 1)
        XCTAssertEqual(arr[safe: 1], 2)
        XCTAssertEqual(arr[safe: 5], 6)
        XCTAssertEqual(arr[safe: 6], nil)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(4)
        XCTAssertEqual(slice[safe: -1], nil)
        XCTAssertEqual(slice[safe: 0], nil)
        XCTAssertEqual(slice[safe: 1], nil)
        XCTAssertEqual(slice[safe: 2], 3)
        XCTAssertEqual(slice[safe: 5], 6)
        XCTAssertEqual(slice[safe: 6], nil)
    }
    
    func testSubscript_Safe_Get_EdgeCases() {
        // empty array
        XCTAssertEqual([Int]()[safe: -1], nil)
        XCTAssertEqual([Int]()[safe:  0], nil)
        XCTAssertEqual([Int]()[safe:  1], nil)
        
        // single element array
        XCTAssertEqual([1][safe: -1], nil)
        XCTAssertEqual([1][safe:  0], 1)
        XCTAssertEqual([1][safe:  1], nil)
        
        // [Int?]
        let arr: [Int?] = [nil, 2, 3, 4, 5, 6]
        XCTAssertEqual(arr[safe: -1], nil)
        XCTAssertEqual(arr[safe: 0], Int?(nil))
        XCTAssertNotEqual(arr[safe: 0], nil)
        XCTAssertEqual(arr[safe: 1], Int?(2))
        XCTAssertEqual(arr[safe: 5], Int?(6))
        XCTAssertEqual(arr[safe: 6], nil)
    }
    
    func testSubscript_Safe_Set() {
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safe: 0] = 9        // succeeds
        arr[safe: 5] = 8        // succeeds
        
        XCTAssertEqual(arr, [9, 2, 3, 4, 5, 8])
        
        arr[safe: -1] = 0       // silently fails
        arr[safe: 6] = 7        // silently fails
        
        XCTAssertEqual(arr, [9, 2, 3, 4, 5, 8])
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        var slice = arr.suffix(4)
        
        slice[safe: 0] = 0        // silently fails
        XCTAssertEqual(slice, [3, 4, 5, 8])
        
        slice[safe: 1] = 0        // silently fails
        XCTAssertEqual(slice, [3, 4, 5, 8])
        
        slice[safe: 2] = 0        // succeeds
        XCTAssertEqual(slice, [0, 4, 5, 8])
        
        slice[safe: 5] = 0        // succeeds
        XCTAssertEqual(slice, [0, 4, 5, 0])
        
        slice[safe: 6] = 7        // silently fails
        XCTAssertEqual(slice, [0, 4, 5, 0])
    }
    
    func testSubscript_Safe_Modify() {
        struct Foo {
            var value: Int = 0
        }
        
        // [Foo]
        var arr = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        arr[safe: 0]?.value = 9
        
        XCTAssertEqual(arr[0].value, 9)
    }
    
    func testSubscript_Safe_Modify_OptionalElement() {
        struct Foo: Equatable {
            var value: Int = 0
        }
        
        // [Foo?]
        let arr: [Foo?] = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        // [Foo?].SubSequence a.k.a. ArraySlice<Foo?>
        var slice = arr[1...]
        
        // succeeds
        slice[safe: 1]??.value = 9
        XCTAssertEqual(slice, [Foo(value: 9), Foo(value: 2)])
        
        // fails silently
        slice[safe: 3]??.value = 8
        XCTAssertEqual(slice, [Foo(value: 9), Foo(value: 2)])
    }
    
    func testSubscript_Safe_Set_EdgeCases() throws {
        // setting an existing element to nil currently
        // throws a preconditionFailure that we can't catch
        // in unit tests without it halting all tests execution,
        // so that can't explicitly be tested here
        
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safe: -1] = nil       // silently fails
        // arr[safe: 0] = nil        // throws precondition failure
        arr[safe: 6] = nil        // silently fails
        
        XCTAssertEqual(arr, [1, 2, 3, 4, 5, 6])
        
        // [Int?]
        var arr2: [Int?] = [1, 2, 3, 4, 5, 6]
        
        arr2[safe: -1] = nil       // silently fails
        arr2[safe: 0] = nil        // succeeds
        arr2[safe: 6] = nil        // silently fails
        
        XCTAssertEqual(arr2, [nil, 2, 3, 4, 5, 6])
    }
    
    // MARK: - [safe: Index, defaultValue:]
    
    func testSubscript_Safe_Get_DefaultValue() {
        // [Int]
        let arr = [1, 2, 3]
        
        XCTAssertEqual(arr[safe: -1, default: 99], 99)
        XCTAssertEqual(arr[safe:  0, default: 99], 1)
        XCTAssertEqual(arr[safe:  1, default: 99], 2)
        XCTAssertEqual(arr[safe:  2, default: 99], 3)
        XCTAssertEqual(arr[safe:  3, default: 99], 99)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(2)
        
        XCTAssertEqual(slice[safe: -1, default: 99], 99)
        XCTAssertEqual(slice[safe:  0, default: 99], 99)
        XCTAssertEqual(slice[safe:  1, default: 99], 2)
        XCTAssertEqual(slice[safe:  2, default: 99], 3)
        XCTAssertEqual(slice[safe:  3, default: 99], 99)
    }
    
    func testSubscript_Safe_Get_DefaultValue_EdgeCases() {
        // empty array
        XCTAssertEqual([Int]()[safe: -1, default: 99], 99)
        XCTAssertEqual([Int]()[safe:  0, default: 99], 99)
        XCTAssertEqual([Int]()[safe:  1, default: 99], 99)
        
        // single element array
        XCTAssertEqual([1][safe: -1, default: 99], 99)
        XCTAssertEqual([1][safe:  0, default: 99], 1)
        XCTAssertEqual([1][safe:  1, default: 99], 99)
    }
    
    // MARK: - [safe: i...i]
    
    func testSubscript_Safe_ClosedRange_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ... toIndex]
            XCTAssertEqual(slice, [1, 2, 3, 4])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: fromIndex ... toIndex]
            XCTAssertEqual(slice, [2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: fromIndex ... toIndex]
            XCTAssertEqual(slice, nil)
        }
    }
    
    func testSubscript_Safe_ClosedRange_Index_EdgeCases() {
        // empty array
        do {
            let arr: [Int] = []
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ... toIndex]
            XCTAssertEqual(slice, nil)
        }
        
        // single element array
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ... toIndex]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex ... toIndex]
            XCTAssertEqual(slice, [1])
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: -1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex ... toIndex]
            XCTAssertEqual(slice, nil)
        }
    }
    
    func testSubscript_Safe_ClosedRange_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: 0 ... 3]
            XCTAssertEqual(slice, [1, 2, 3, 4])
        }
        
        do {
            let slice = arr[safe: 1 ... 5]
            XCTAssertEqual(slice, [2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 1 ... 6]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let slice = arr[safe: -1 ... 3]
            XCTAssertEqual(slice, nil)
        }
    }
    
    // MARK: - [safe: i..<i]
    
    func testSubscript_Safe_Range_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, [2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 7)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, nil)
        }
    }
    
    func testSubscript_Safe_Range_Index_EdgeCases() {
        // empty array
        do {
            let arr: [Int] = []
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, nil)
        }
        
        // single element array
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, [])
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, [1])
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: -1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: fromIndex ..< toIndex]
            XCTAssertEqual(slice, nil)
        }
    }
    
    func testSubscript_Safe_Range_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: 0 ..< 4]
            XCTAssertEqual(slice, [1, 2, 3, 4])
        }
        
        do {
            let slice = arr[safe: 1 ..< 6]
            XCTAssertEqual(slice, [2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 1 ..< 7]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let slice = arr[safe: -1 ..< 4]
            XCTAssertEqual(slice, nil)
        }
    }
    
    // MARK: - [safe: i...]
    
    func testSubscript_Safe_PartialRangeFrom_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: -1)
            let slice = arr[safe: fromIndex...]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex...]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: fromIndex...]
            XCTAssertEqual(slice, [2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: fromIndex...]
            XCTAssertEqual(slice, [6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: fromIndex...]
            XCTAssertEqual(slice, []) // technically correct
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 7)
            let slice = arr[safe: fromIndex...]
            XCTAssertEqual(slice, nil)
        }
    }
    
    func testSubscript_Safe_PartialRangeFrom_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: (-1)...]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let slice = arr[safe: 0...]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 1...]
            XCTAssertEqual(slice, [2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 5...]
            XCTAssertEqual(slice, [6])
        }
        
        do {
            let slice = arr[safe: 6...]
            XCTAssertEqual(slice, []) // technically correct
        }
        
        do {
            let slice = arr[safe: 7...]
            XCTAssertEqual(slice, nil)
        }
    }
    
    // MARK: - [safe: ...i]

    func testSubscript_Safe_PartialRangeThrough_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: -1)
            let slice = arr[safe: ...toIndex]
            XCTAssertEqual(slice, nil)
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: ...toIndex]
            XCTAssertEqual(slice, [1])
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: ...toIndex]
            XCTAssertEqual(slice, [1, 2])
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: ...toIndex]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5, 6])
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: ...toIndex]
            XCTAssertEqual(slice, nil)
        }
    }

    func testSubscript_Safe_PartialRangeThrough_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]

        do {
            let slice = arr[safe: ...(-1)]
            XCTAssertEqual(slice, nil)
        }

        do {
            let slice = arr[safe: ...0]
            XCTAssertEqual(slice, [1])
        }

        do {
            let slice = arr[safe: ...1]
            XCTAssertEqual(slice, [1, 2])
        }

        do {
            let slice = arr[safe: ...5]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5, 6])
        }

        do {
            let slice = arr[safe: ...6]
            XCTAssertEqual(slice, nil)
        }
    }
    
    // MARK: - [safe: ..<i]
    
    func testSubscript_Safe_PartialRangeUpTo_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: -1)
            let slice = arr[safe: ..<toIndex]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: ..<toIndex]
            XCTAssertEqual(slice, [])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: ..<toIndex]
            XCTAssertEqual(slice, [1])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: ..<toIndex]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: ..<toIndex]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 7)
            let slice = arr[safe: ..<toIndex]
            XCTAssertEqual(slice, nil)
        }
    }
    
    func testSubscript_Safe_PartialRangeUpTo_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: ..<(-1)]
            XCTAssertEqual(slice, nil)
        }
        
        do {
            let slice = arr[safe: ..<0]
            XCTAssertEqual(slice, [])
        }
        
        do {
            let slice = arr[safe: ..<1]
            XCTAssertEqual(slice, [1])
        }
        
        do {
            let slice = arr[safe: ..<5]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5])
        }
        
        do {
            let slice = arr[safe: ..<6]
            XCTAssertEqual(slice, [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: ..<7]
            XCTAssertEqual(slice, nil)
        }
    }
    
    // MARK: - [safePosition: Int]
    
    func testSubscript_SafePosition_Get() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        XCTAssertEqual(arr[safePosition: -1], nil)
        XCTAssertEqual(arr[safePosition: 0], 1)
        XCTAssertEqual(arr[safePosition: 1], 2)
        XCTAssertEqual(arr[safePosition: 5], 6)
        XCTAssertEqual(arr[safePosition: 6], nil)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(4)
        XCTAssertEqual(slice[safePosition: -1], nil)
        XCTAssertEqual(slice[safePosition: 0], 3)
        XCTAssertEqual(slice[safePosition: 1], 4)
        XCTAssertEqual(slice[safePosition: 3], 6)
        XCTAssertEqual(slice[safePosition: 4], nil)
    }
    
    func testSubscript_SafePosition_Get_EdgeCases() {
        // empty array
        XCTAssertEqual([Int]()[safePosition: -1], nil)
        XCTAssertEqual([Int]()[safePosition:  0], nil)
        XCTAssertEqual([Int]()[safePosition:  1], nil)
        
        // single element array
        XCTAssertEqual([1][safePosition: -1], nil)
        XCTAssertEqual([1][safePosition:  0], 1)
        XCTAssertEqual([1][safePosition:  1], nil)
        
        // [Int?]
        let arr: [Int?] = [nil, 2, 3, 4, 5, 6]
        XCTAssertEqual(arr[safePosition: -1], nil)
        XCTAssertEqual(arr[safePosition: 0], Int?(nil))
        XCTAssertNotEqual(arr[safePosition: 0], nil)
        XCTAssertEqual(arr[safePosition: 1], Int?(2))
        XCTAssertEqual(arr[safePosition: 5], Int?(6))
        XCTAssertEqual(arr[safePosition: 6], nil)
    }
    
    func testSubscript_SafePosition_Set() {
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safePosition: 0] = 9        // succeeds
        arr[safePosition: 5] = 8        // succeeds
        
        XCTAssertEqual(arr, [9, 2, 3, 4, 5, 8])
        
        arr[safePosition: -1] = 0       // silently fails
        arr[safePosition: 6] = 7        // silently fails
        
        XCTAssertEqual(arr, [9, 2, 3, 4, 5, 8])
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        var slice = arr.suffix(4)
        
        slice[safePosition: 0] = 1      // succeeds
        slice[safePosition: 3] = 6      // succeeds
        
        XCTAssertEqual(slice, [1, 4, 5, 6])
        
        slice[safePosition: -1] = 0       // silently fails
        slice[safePosition: 4] = 7        // silently fails
        
        XCTAssertEqual(slice, [1, 4, 5, 6])
    }
    
    func testSubscript_SafePosition_Set_EdgeCases() throws {
        // setting an existing element to nil currently
        // throws a preconditionFailure that we can't catch
        // in unit tests without it halting all tests execution,
        // so that can't explicitly be tested here
        
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safePosition: -1] = nil       // silently fails, out of bounds
        // arr[safePosition: 0] = nil        // throws precondition failure
        arr[safePosition: 6] = nil        // silently fails, out of bounds
        
        XCTAssertEqual(arr, [1, 2, 3, 4, 5, 6])
        
        // [Int?]
        var arr2: [Int?] = [1, 2, 3, 4, 5, 6]
        
        arr2[safePosition: -1] = nil       // silently fails
        arr2[safePosition: 0] = nil        // succeeds
        arr2[safePosition: 6] = nil        // silently fails
        
        XCTAssertEqual(arr2, [nil, 2, 3, 4, 5, 6])
    }
    
    func testSubscript_SafePosition_Modify() {
        struct Foo: Equatable {
            var value: Int = 0
        }
        
        // [Foo]
        let arr = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        // [Foo].SubSequence a.k.a. ArraySlice<Foo>
        var slice = arr[1...]
        
        slice[safePosition: 1]?.value = 9
        
        XCTAssertEqual(slice, [Foo(value: 1), Foo(value: 9)])
    }
    
    func testSubscript_SafePosition_Modify_OptionalElement() {
        struct Foo: Equatable {
            var value: Int = 0
        }
        
        // [Foo?]
        let arr: [Foo?] = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        // [Foo?].SubSequence a.k.a. ArraySlice<Foo?>
        var slice = arr[1...]
        
        // succeeds
        slice[safePosition: 1]??.value = 9
        XCTAssertEqual(slice, [Foo(value: 1), Foo(value: 9)])
        
        // fails silently
        slice[safePosition: 2]??.value = 8
        XCTAssertEqual(slice, [Foo(value: 1), Foo(value: 9)])
    }
    
    // MARK: - [safePosition: Index, defaultValue:]
    
    func testSubscript_SafePosition_Get_DefaultValue() {
        // [Int]
        let arr = [1, 2, 3]
        
        XCTAssertEqual(arr[safePosition: -1, default: 99], 99)
        XCTAssertEqual(arr[safePosition:  0, default: 99], 1)
        XCTAssertEqual(arr[safePosition:  1, default: 99], 2)
        XCTAssertEqual(arr[safePosition:  2, default: 99], 3)
        XCTAssertEqual(arr[safePosition:  3, default: 99], 99)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(2)
        
        XCTAssertEqual(slice[safePosition: -1, default: 99], 99)
        XCTAssertEqual(slice[safePosition:  0, default: 99], 2)
        XCTAssertEqual(slice[safePosition:  1, default: 99], 3)
        XCTAssertEqual(slice[safePosition:  2, default: 99], 99)
    }
    
    func testSubscript_SafePosition_Get_DefaultValue_EdgeCases() {
        // empty array
        XCTAssertEqual([Int]()[safePosition: -1, default: 99], 99)
        XCTAssertEqual([Int]()[safePosition:  0, default: 99], 99)
        XCTAssertEqual([Int]()[safePosition:  1, default: 99], 99)
        
        // single element array
        XCTAssertEqual([1][safePosition: -1, default: 99], 99)
        XCTAssertEqual([1][safePosition:  0, default: 99], 1)
        XCTAssertEqual([1][safePosition:  1, default: 99], 99)
    }
    
    // MARK: - [safePosition: i...i]
    
    func testSubscript_SafePosition_ClosedRange_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        do {
            XCTAssertEqual(slice[safePosition: (-1) ... (-1)], nil)
            XCTAssertEqual(slice[safePosition: 0 ... 0], [3])
            XCTAssertEqual(slice[safePosition: 1 ... 1], [4])
            XCTAssertEqual(slice[safePosition: 3 ... 3], [6])
            XCTAssertEqual(slice[safePosition: 4 ... 4], nil)
        }
        
        do {
            let slice2 = slice[safePosition: 1 ... 3]
            XCTAssertEqual(slice2, [4, 5, 6])
        }
        
        do {
            let slice2 = slice[safePosition: 1 ... 4]
            XCTAssertEqual(slice2, nil)
        }
        
        do {
            let slice2 = slice[safePosition: -1 ... 3]
            XCTAssertEqual(slice2, nil)
        }
    }
    
    // MARK: - [safePosition: i..<i]
    
    func testSubscript_SafePosition_Range_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        do {
            XCTAssertEqual(slice[safePosition: (-1) ..< (-1)], nil)
            XCTAssertEqual(slice[safePosition: 0 ..< 0], [])
            XCTAssertEqual(slice[safePosition: 1 ..< 1], [])
            XCTAssertEqual(slice[safePosition: 3 ..< 3], [])
            XCTAssertEqual(slice[safePosition: 4 ..< 4], []) // technically correct
            XCTAssertEqual(slice[safePosition: 5 ..< 5], nil)
            
            XCTAssertEqual(slice[safePosition: (-1) ..< 0], nil)
            XCTAssertEqual(slice[safePosition: 0 ..< 1], [3])
            XCTAssertEqual(slice[safePosition: 1 ..< 2], [4])
            XCTAssertEqual(slice[safePosition: 3 ..< 4], [6])
            XCTAssertEqual(slice[safePosition: 4 ..< 5], nil)
        }
        
        do {
            let slice2 = slice[safePosition: 1 ..< 4]
            XCTAssertEqual(slice2, [4, 5, 6])
        }
        
        do {
            let slice2 = slice[safePosition: 1 ..< 5]
            XCTAssertEqual(slice2, nil)
        }
        
        do {
            let slice2 = slice[safePosition: -1 ..< 4]
            XCTAssertEqual(slice2, nil)
        }
    }
    
    // MARK: - [safePosition: i...]
    
    func testSubscript_SafePosition_PartialRangeFrom_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        XCTAssertEqual(slice[safePosition: (-1)...], nil)
        XCTAssertEqual(slice[safePosition: 0...], [3, 4, 5, 6])
        XCTAssertEqual(slice[safePosition: 1...], [4, 5, 6])
        XCTAssertEqual(slice[safePosition: 3...], [6])
        XCTAssertEqual(slice[safePosition: 4...], [])
        XCTAssertEqual(slice[safePosition: 5...], nil)
    }
    
    // MARK: - [safePosition: ...i]
    
    func testSubscript_SafePosition_PartialRangeThrough_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        XCTAssertEqual(slice[safePosition: ...(-1)], nil)
        XCTAssertEqual(slice[safePosition: ...0], [3])
        XCTAssertEqual(slice[safePosition: ...1], [3, 4])
        XCTAssertEqual(slice[safePosition: ...3], [3, 4, 5, 6])
        XCTAssertEqual(slice[safePosition: ...4], nil)
    }
    
    // MARK: - [safePosition: ..<i]
    
    func testSubscript_SafePosition_PartialRangeUpTo_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        XCTAssertEqual(slice[safePosition: ..<(-1)], nil)
        XCTAssertEqual(slice[safePosition: ..<0], [])
        XCTAssertEqual(slice[safePosition: ..<1], [3])
        XCTAssertEqual(slice[safePosition: ..<2], [3, 4])
        XCTAssertEqual(slice[safePosition: ..<4], [3, 4, 5, 6])
        XCTAssertEqual(slice[safePosition: ..<5], nil)
    }
    
    // MARK: - .remove(safeAt:)
    
    func testArrayRemoveSafeAt() {
        // [Int]
        var arr = [1, 2, 3]
        
        XCTAssertEqual(arr.remove(safeAt: 0), 1)    // succeeds
        XCTAssertEqual(arr, [2, 3])
        
        XCTAssertEqual(arr.remove(safeAt: -1), nil) // silently fails
        XCTAssertEqual(arr, [2, 3])
        
        XCTAssertEqual(arr.remove(safeAt: 2), nil)  // silently fails
        XCTAssertEqual(arr, [2, 3])
        
        XCTAssertEqual(arr.remove(safeAt: 0), 2)    // succeeds
        XCTAssertEqual(arr, [3])
    }
    
    func testArrayRemoveSafePositionAt() {
        // [Int]
        let arr = [0, 0, 1, 2, 3, 4, 5, 6]
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        var slice = arr.suffix(6)
        
        XCTAssertEqual(slice.remove(safePositionAt: -1), nil)
        
        XCTAssertEqual(slice.remove(safePositionAt: 0), 1)
        XCTAssertEqual(slice, [2, 3, 4, 5, 6])
        
        XCTAssertEqual(slice.remove(safePositionAt: 0), 2)
        XCTAssertEqual(slice, [3, 4, 5, 6])
        
        XCTAssertEqual(slice.remove(safePositionAt: 3), 6)
        XCTAssertEqual(slice, [3, 4, 5])
        
        XCTAssertEqual(slice.remove(safePositionAt: 3), nil)
        XCTAssertEqual(slice, [3, 4, 5])
    }
    
    // MARK: - Indexes
    
    func testStartIndexOffsetBy() {
        // .startIndex(offsetBy:)
        
        let array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        
        XCTAssertEqual(
            array.startIndex(offsetBy: 0),
            array.startIndex
        )
        
        XCTAssertEqual(
            array.startIndex(offsetBy: 1),
            array.index(array.startIndex, offsetBy: 1)
        )
    }
    
    func testEndIndexOffsetBy() {
        // .endIndex(offsetBy:)
        
        let array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        
        XCTAssertEqual(
            array.endIndex(offsetBy: 0),
            array.endIndex
        )
        
        XCTAssertEqual(
            array.endIndex(offsetBy: -1),
            array.index(array.endIndex, offsetBy: -1)
        )
    }
    
    // MARK: - [position: Int]
    
    func testSubscriptPosition_OffsetIndex() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        XCTAssertEqual(array[position: 2], "c")
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        XCTAssertEqual(slice[position: 2], "2")
    }
    
    // MARK: - [position: i...i]
    
    func testSubscriptPosition_ClosedRange() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        XCTAssertEqual(array[position: 1 ... 3], ["b", "c", "1"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        XCTAssertEqual(slice[position: 1 ... 3], ["1", "2", "3"])
    }
    
    // MARK: - [position: i..<i]
    
    func testSubscriptPosition_Range() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        XCTAssertEqual(array[position: 1 ..< 3], ["b", "c"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        XCTAssertEqual(slice[position: 1 ..< 3], ["1", "2"])
    }
    
    // MARK: - [position: i...]
    
    func testSubscriptPosition_PartialRangeFrom() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        XCTAssertEqual(array[position: 2...], ["c", "1", "2", "3"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        XCTAssertEqual(slice[position: 2...], ["2", "3"])
    }
    
    // MARK: - [position: ...i]
    
    func testSubscriptPosition_PartialRangeThrough() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        XCTAssertEqual(array[position: ...3], ["a", "b", "c", "1"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        XCTAssertEqual(slice[position: ...3], ["c", "1", "2", "3"])
    }
    
    // MARK: - [position: ..<i]
    
    func testSubscriptPosition_PartialRangeUpTo() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        XCTAssertEqual(array[position: ..<3], ["a", "b", "c"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        XCTAssertEqual(slice[position: ..<3], ["c", "1", "2"])
    }
    
    // MARK: - [wrapping:]
    
    func testWrappingIndexSubscript() {
        let x = ["0", "1", "2", "3", "4"]
        
        XCTAssertEqual(x[wrapping:  0], "0")
        XCTAssertEqual(x[wrapping:  1], "1")
        XCTAssertEqual(x[wrapping:  2], "2")
        XCTAssertEqual(x[wrapping:  3], "3")
        XCTAssertEqual(x[wrapping:  4], "4")
        XCTAssertEqual(x[wrapping:  5], "0")
        XCTAssertEqual(x[wrapping:  6], "1")
        XCTAssertEqual(x[wrapping: -1], "4")
        XCTAssertEqual(x[wrapping: -4], "1")
        XCTAssertEqual(x[wrapping: -5], "0")
        XCTAssertEqual(x[wrapping: -6], "4")
    }
    
    // MARK: - .count(of:)
    
    func testCountOfElement() {
        let arr = [1, 1, 1, 2, 2, 3]
        
        XCTAssertEqual(arr.count(of: 1), 3)
        XCTAssertEqual(arr.count(of: 3), 1)
        XCTAssertEqual(arr.count(of: 4), 0)
    }
    
    // MARK: - shortest() / shortestIndex()
    
    func testStringProtocol_Shortest() {
        XCTAssertEqual([String]().shortest(), nil)
        XCTAssertEqual([""].shortest(), "")
        XCTAssertEqual(["A"].shortest(), "A")
        XCTAssertEqual(["abc", "A", "1", "xy", ""].shortest(), "")
        XCTAssertEqual(["abc", "A", "1", "xy"].shortest(), "A")
        XCTAssertEqual(["abc", "1", "A", "xy"].shortest(), "1")
    }
    
    func testStringProtocol_ShortestIndex() {
        XCTAssertEqual([String]().shortestIndex(), nil)
        XCTAssertEqual([""].shortestIndex(), 0)
        XCTAssertEqual(["A"].shortestIndex(), 0)
        XCTAssertEqual(["abc", "A", "1", "xy", ""].shortestIndex(), 4)
        XCTAssertEqual(["abc", "A", "1", "xy"].shortestIndex(), 1)
        XCTAssertEqual(["abc", "1", "A", "xy"].shortestIndex(), 1)
    }
    
    // MARK: - longest() / longestIndex()
    
    func testStringProtocol_Longest() {
        XCTAssertEqual([String]().longest(), nil)
        XCTAssertEqual([""].longest(), "")
        XCTAssertEqual(["A"].longest(), "A")
        XCTAssertEqual(["A", "1", "xy", "", "abc"].longest(), "abc")
        XCTAssertEqual(["abc", "123", "A", "1", "xyz"].longest(), "abc")
        XCTAssertEqual(["123", "abc", "1", "A", "xyz"].longest(), "123")
    }
    
    func testStringProtocol_LongestIndex() {
        XCTAssertEqual([String]().longestIndex(), nil)
        XCTAssertEqual([""].longestIndex(), 0)
        XCTAssertEqual(["A"].longestIndex(), 0)
        XCTAssertEqual(["A", "1", "xy", "", "abc"].longestIndex(), 4)
        XCTAssertEqual(["abc", "123", "A", "1", "xyz"].longestIndex(), 0)
        XCTAssertEqual(["123", "abc", "1", "A", "xyz"].longestIndex(), 0)
    }
    
    // MARK: - .stringValueArrayLiteral
    
    func teststringValueArrayLiteral() {
        XCTAssertEqual([Int]().stringValueArrayLiteral, "[]")
        
        XCTAssertEqual([1, 2, 3].stringValueArrayLiteral, "[1, 2, 3]")
    }
    
    // MARK: - .firstGapValue()
    
    func testFirstGapValue() {
        // default argument
        
        XCTAssertEqual([Int]().firstGapValue(), nil)
        XCTAssertEqual([1].firstGapValue(), nil)
        XCTAssertEqual([1, 2, 4, 6].firstGapValue(), 3)
        XCTAssertEqual([1, 2, 3, 4].firstGapValue(), nil)
        
        // .firstGapValue(after:)
        
        XCTAssertEqual([Int]().firstGapValue(after: 6), nil)
        XCTAssertEqual([1].firstGapValue(after: 0), nil)
        XCTAssertEqual([1, 2, 4, 6].firstGapValue(after: 1), 3)
        XCTAssertEqual([1, 2, 3, 4].firstGapValue(after: 1), nil)
        
        XCTAssertEqual([1, 3, 5, 7, 9].firstGapValue(after: -1), 2)
        XCTAssertEqual([1, 3, 5, 7, 9].firstGapValue(after: 2), 4)
        XCTAssertEqual([1, 3, 5, 7, 9].firstGapValue(after: 3), 4)
        XCTAssertEqual([1, 3, 5, 7, 9].firstGapValue(after: 4), 6)
    }
    
    // MARK: - Set union methods
    
    func testSetUnion() {
        // .union
        
        var set: Set<FooEnum> = [.fooB(1), .one]
        
        let setA = set.union([.fooB(2), .two])
        XCTAssertEqual(
            setA,
            [.fooB(999), .one, .two]
        )      // can't use this to check associated value
        setA.forEach {
            switch $0 {
            case let .fooB(val): XCTAssertEqual(val, 1)     // check associated value here
            default: break
            }
        }
        
        // .union(updating:)
        
        let setB = set.union(updating: [.fooB(2), .two])
        XCTAssertEqual(
            setB,
            [.fooB(999), .one, .two]
        )      // can't use this to check associated value
        setB.forEach {
            switch $0 {
            case let .fooB(val): XCTAssertEqual(val, 2)     // check associated value here
            default: break
            }
        }
        
        // .formUnion(updating:)
        
        set.formUnion(updating: [.fooB(2), .two])
        XCTAssertEqual(
            set,
            [.fooB(999), .one, .two]
        )       // can't use this to check associated value
        set.forEach {
            switch $0 {
            case let .fooB(val): XCTAssertEqual(val, 2)     // check associated value here
            default: break
            }
        }
    }
    
    // MARK: - .array constructor
    
    func testArraySlice_Array() {
        let sourceArray = ["A", "B", "C"]
        
        let slice = sourceArray.suffix(2)
        
        // as a precondition, assert that this is an ArraySlice and its indexing is as expected
        
        XCTAssertEqual("\(type(of: slice))", "ArraySlice<String>") // brittle, but we'll test it
        XCTAssertEqual(slice.count, 2)
        XCTAssertEqual(slice, ["B", "C"])
        XCTAssertEqual(slice[1], "B") // this slice's indexes start on 1
        XCTAssertEqual(slice[2], "C")
        
        // test formation of array
        
        let array = slice.array
        
        XCTAssertEqual("\(type(of: array))", "Array<String>") // brittle, but we'll test it
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array, ["B", "C"])
        XCTAssertEqual(array[0], "B") // reindexed back to start on 0
        XCTAssertEqual(array[1], "C")
    }
    
    // MARK: - .grouping(by:)
    
    func testSequence_Grouping() {
        let ungrouped = ["Bob", "Billy", "Alex", "Kevin", "Adam"]
        
        let grouped = ungrouped.grouping(by: { $0.first! })
        
        XCTAssertEqual(
            grouped,
            [
                "A": ["Alex", "Adam"],
                "B": ["Bob", "Billy"],
                "K": ["Kevin"]
            ]
        )
    }
    
    // MARK: - .split(every:backwards:)
    
    func testSplitEvery() {
        let str = "1234567890"
        
        XCTAssertEqual(str.split(every: 1), ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
        XCTAssertEqual(str.split(every: 2), ["12", "34", "56", "78", "90"])
        XCTAssertEqual(str.split(every: 4), ["1234", "5678", "90"])
        XCTAssertEqual(str.split(every: 4, backwards: true), ["12", "3456", "7890"])
        
        // edge cases
        XCTAssertEqual(str.split(every: -1), [])
        XCTAssertEqual(str.split(every: 0), ["1234567890"])
        XCTAssertEqual(str.split(every: 0, backwards: true), ["1234567890"])
    }
    
    // MARK: - .indices(splitEvery:)
    
    func testIndicesSplitEvery() {
        let arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        XCTAssertEqual(arr.indices(splitEvery: -1), [0 ... 10])
        XCTAssertEqual(arr.indices(splitEvery:  0), [0 ... 10])
        XCTAssertEqual(arr.indices(splitEvery:  1), [
            0 ... 0,
            1 ... 1,
            2 ... 2,
            3 ... 3,
            4 ... 4,
            5 ... 5,
            6 ... 6,
            7 ... 7,
            8 ... 8,
            9 ... 9,
            10 ... 10
        ])
        XCTAssertEqual(arr.indices(splitEvery:  2), [
            0 ... 1,
            2 ... 3,
            4 ... 5,
            6 ... 7,
            8 ... 9,
            10 ... 10
        ])
        XCTAssertEqual(arr.indices(splitEvery:  3), [0 ... 2, 3 ... 5, 6 ... 8, 9 ... 10])
        XCTAssertEqual(arr.indices(splitEvery:  4), [0 ... 3, 4 ... 7, 8 ... 10])
        XCTAssertEqual(arr.indices(splitEvery:  5), [0 ... 4, 5 ... 9, 10 ... 10])
        XCTAssertEqual(arr.indices(splitEvery: 10), [0 ... 9, 10 ... 10])
        XCTAssertEqual(arr.indices(splitEvery: 11), [0 ... 10])
        XCTAssertEqual(arr.indices(splitEvery: 12), [0 ... 10])
    }
    
    // MARK: - Duplicates
    
    func testRemovingDuplicates() {
        XCTAssertEqual([].removingDuplicates(), [] as [Int])
        XCTAssertEqual([1, 2, 3, 4].removingDuplicates(), [1, 2, 3, 4])
        XCTAssertEqual([1, 2, 3, 2, 4].removingDuplicates(), [1, 2, 3, 4])
        XCTAssertEqual([1, 2, 2, 2, 2].removingDuplicates(), [1, 2])
    }
    
    func testRemoveDuplicates() {
        do {
            var arr = [] as [Int]
            arr.removeDuplicates()
            XCTAssertEqual(arr, [])
        }
        do {
            var arr = [1, 2, 3, 4]
            arr.removeDuplicates()
            XCTAssertEqual(arr, [1, 2, 3, 4])
        }
        do {
            var arr = [1, 2, 3, 2, 4]
            arr.removeDuplicates()
            XCTAssertEqual(arr, [1, 2, 3, 4])
        }
        do {
            var arr = [1, 2, 2, 2, 2]
            arr.removeDuplicates()
            XCTAssertEqual(arr, [1, 2])
        }
    }
    
    func testRemovingDuplicatesRandomOrdering() {
        XCTAssertEqual([].removingDuplicatesRandomOrdering(), [] as [Int])
        XCTAssertTrue(
            [1, 2, 3, 4].removingDuplicatesRandomOrdering()
                .elementsEqual(orderInsensitive: [1, 2, 3, 4])
        )
        XCTAssertTrue(
            [1, 2, 3, 2, 4].removingDuplicatesRandomOrdering()
                .elementsEqual(orderInsensitive: [1, 2, 3, 4])
        )
        XCTAssertTrue(
            [1, 2, 2, 2, 2].removingDuplicatesRandomOrdering()
                .elementsEqual(orderInsensitive: [1, 2])
        )
    }
    
    func testDuplicateElements() {
        XCTAssertEqual([].duplicateElements(), [] as [Int])
        XCTAssertEqual([1, 2, 3, 4].duplicateElements(), [])
        XCTAssertEqual([1, 2, 3, 2, 4].duplicateElements(), [2])
        XCTAssertEqual([1, 2, 3, 2, 1, 4].duplicateElements(), [1, 2])
        XCTAssertEqual([1, 2, 2, 2, 2].duplicateElements(), [2])
    }
    
    func testDuplicateElementIndices() {
        XCTAssertEqual(([] as [Int]).duplicateElementIndices(.firstOccurrences), [])
        XCTAssertEqual(([] as [Int]).duplicateElementIndices(.afterFirstOccurrences), [])
        XCTAssertEqual(([] as [Int]).duplicateElementIndices(.allOccurrences), [])
        
        XCTAssertEqual([1].duplicateElementIndices(.firstOccurrences), [])
        XCTAssertEqual([1].duplicateElementIndices(.afterFirstOccurrences), [])
        XCTAssertEqual([1].duplicateElementIndices(.allOccurrences), [])
        
        XCTAssertEqual([1, 2].duplicateElementIndices(.firstOccurrences), [])
        XCTAssertEqual([1, 2].duplicateElementIndices(.afterFirstOccurrences), [])
        XCTAssertEqual([1, 2].duplicateElementIndices(.allOccurrences), [])
        
        XCTAssertEqual([1, 1].duplicateElementIndices(.firstOccurrences), [0])
        XCTAssertEqual([1, 1].duplicateElementIndices(.afterFirstOccurrences), [1])
        XCTAssertEqual([1, 1].duplicateElementIndices(.allOccurrences), [0, 1])
        
        XCTAssertEqual([1, 2, 3, 4].duplicateElementIndices(.firstOccurrences), [])
        XCTAssertEqual([1, 2, 3, 4].duplicateElementIndices(.afterFirstOccurrences), [])
        XCTAssertEqual([1, 2, 3, 4].duplicateElementIndices(.allOccurrences), [])
        
        XCTAssertEqual([1, 2, 3, 2, 4].duplicateElementIndices(.firstOccurrences), [1])
        XCTAssertEqual([1, 2, 3, 2, 4].duplicateElementIndices(.afterFirstOccurrences), [3])
        XCTAssertEqual([1, 2, 3, 2, 4].duplicateElementIndices(.allOccurrences), [1, 3])
        
        XCTAssertEqual([1, 2, 2, 2].duplicateElementIndices(.firstOccurrences), [1])
        XCTAssertEqual([1, 2, 2, 2].duplicateElementIndices(.afterFirstOccurrences), [2, 3])
        XCTAssertEqual([1, 2, 2, 2].duplicateElementIndices(.allOccurrences), [1, 2, 3])
        
        // unsorted
        XCTAssertEqual(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.firstOccurrences),
            [1, 3]
        )
        XCTAssertEqual(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.afterFirstOccurrences),
            [2, 4, 6, 5]
        )
        XCTAssertEqual(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.allOccurrences),
            [1, 2, 4, 3, 6, 5]
        )
        
        // sorted
        XCTAssertEqual(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.firstOccurrences, sorted: true),
            [1, 3]
        )
        XCTAssertEqual(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.afterFirstOccurrences, sorted: true),
            [2, 4, 5, 6]
        )
        XCTAssertEqual(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.allOccurrences, sorted: true),
            [1, 2, 3, 4, 5, 6]
        )
    }
    
    func testAllElementsAreEqual() {
        XCTAssertTrue([Int]().allElementsAreEqual)
        XCTAssertTrue([1].allElementsAreEqual)
        XCTAssertTrue([1, 1].allElementsAreEqual)
        XCTAssertTrue([1, 1, 1].allElementsAreEqual)
        
        XCTAssertFalse([1, 2].allElementsAreEqual)
        XCTAssertFalse([1, 2, 1].allElementsAreEqual)
        XCTAssertFalse([1, 1, 2].allElementsAreEqual)
    }
    
    func testElementsEqual_orderInsensitive() {
        XCTAssertTrue(([] as [Int]).elementsEqual(orderInsensitive: []))
        XCTAssertTrue(([1] as [Int]).elementsEqual(orderInsensitive: [1]))
        XCTAssertTrue(([1, 2] as [Int]).elementsEqual(orderInsensitive: [1, 2]))
        XCTAssertTrue(([1, 2] as [Int]).elementsEqual(orderInsensitive: [2, 1]))
        XCTAssertTrue(([1, 1] as [Int]).elementsEqual(orderInsensitive: [1, 1]))
        XCTAssertTrue(([1, 3, 2] as [Int]).elementsEqual(orderInsensitive: [3, 2, 1]))
        
        XCTAssertFalse(([1] as [Int]).elementsEqual(orderInsensitive: []))
        XCTAssertFalse(([] as [Int]).elementsEqual(orderInsensitive: [1]))
        
        XCTAssertFalse(([1] as [Int]).elementsEqual(orderInsensitive: [2]))
        XCTAssertFalse(([1, 2] as [Int]).elementsEqual(orderInsensitive: [1, 1]))
        XCTAssertFalse(([1, 2] as [Int]).elementsEqual(orderInsensitive: [2, 2]))
    }
    
    // MARK: - Replace
    
    func testReplacingElementsWithElement() {
        XCTAssertEqual([""].replacing(elementsIn: [], with: ""), [""])
        XCTAssertEqual(["a"].replacing(elementsIn: [], with: "z"), ["a"])
        XCTAssertEqual(["a"].replacing(elementsIn: ["a"], with: "z"), ["z"])
        XCTAssertEqual(["a"].replacing(elementsIn: ["b"], with: "z"), ["a"])
        XCTAssertEqual(["ä"].replacing(elementsIn: ["a"], with: "z"), ["ä"])
        XCTAssertEqual(["", ""].replacing(elementsIn: [], with: ""), ["", ""])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["a"], with: "z"), ["z", "b"])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["b"], with: "z"), ["a", "z"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: "z"), ["A", "z", "a", "A", "B"])
        XCTAssertEqual(["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: "z"), ["A", "z", "a", "A", "z"])
        
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: "z"), ["z", "z", "a", "z", "B"])
        
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: [""], with: "z"), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: ["e"], with: "z"), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: "New"), ["New", "Hello", "New"])
        
        XCTAssertEqual("Tester".replacing(elementsIn: ["e"], with: "z"), "Tzstzr")
        XCTAssertEqual("Tester".replacing(elementsIn: ["e" as Character], with: "z"), "Tzstzr")
    }
    
    func testReplacingElementsWithElements() {
        // replacing with empty collection
        
        XCTAssertEqual([""].replacing(elementsIn: [], with: []), [""])
        XCTAssertEqual(["a"].replacing(elementsIn: [], with: []), ["a"])
        XCTAssertEqual(["a"].replacing(elementsIn: ["a"], with: []), [])
        XCTAssertEqual(["a"].replacing(elementsIn: ["b"], with: []), ["a"])
        XCTAssertEqual(["ä"].replacing(elementsIn: ["a"], with: []), ["ä"])
        XCTAssertEqual(["", ""].replacing(elementsIn: [], with: []), ["", ""])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["a"], with: []), ["b"])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["b"], with: []), ["a"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: []), ["A", "a", "A", "B"])
        XCTAssertEqual(["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: []), ["A", "a", "A"])
        
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: []), ["a", "B"])
        
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: [""], with: []), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: ["e"], with: []), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: []), ["Hello"])
        
        XCTAssertEqual("Tester".replacing(elementsIn: ["e"], with: []), "Tstr")
        XCTAssertEqual("Tester".replacing(elementsIn: ["e" as Character], with: []), "Tstr")
        
        // replacing with single new element
        
        XCTAssertEqual([""].replacing(elementsIn: [], with: [""]), [""])
        XCTAssertEqual(["a"].replacing(elementsIn: [], with: ["z"]), ["a"])
        XCTAssertEqual(["a"].replacing(elementsIn: ["a"], with: ["z"]), ["z"])
        XCTAssertEqual(["a"].replacing(elementsIn: ["b"], with: ["z"]), ["a"])
        XCTAssertEqual(["ä"].replacing(elementsIn: ["a"], with: ["z"]), ["ä"])
        XCTAssertEqual(["", ""].replacing(elementsIn: [], with: [""]), ["", ""])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["a"], with: ["z"]), ["z", "b"])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["b"], with: ["z"]), ["a", "z"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: ["z"]), ["A", "z", "a", "A", "B"])
        XCTAssertEqual(["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: ["z"]), ["A", "z", "a", "A", "z"])
        
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: ["z"]), ["z", "z", "a", "z", "B"])
        
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: [""], with: ["z"]), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: ["e"], with: ["z"]), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: ["New"]), ["New", "Hello", "New"])
        
        XCTAssertEqual("Tester".replacing(elementsIn: ["e"], with: ["z"]), "Tzstzr")
        XCTAssertEqual("Tester".replacing(elementsIn: ["e" as Character], with: ["z"]), "Tzstzr")
        
        // replacing with multiple new elements
        
        XCTAssertEqual([""].replacing(elementsIn: [], with: ["", ""]), [""])
        XCTAssertEqual(["a"].replacing(elementsIn: [], with: ["y", "z"]), ["a"])
        XCTAssertEqual(["a"].replacing(elementsIn: ["a"], with: ["y", "z"]), ["y", "z"])
        XCTAssertEqual(["a"].replacing(elementsIn: ["b"], with: ["y", "z"]), ["a"])
        XCTAssertEqual(["ä"].replacing(elementsIn: ["a"], with: ["y", "z"]), ["ä"])
        XCTAssertEqual(["", ""].replacing(elementsIn: [], with: ["", ""]), ["", ""])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["a"], with: ["y", "z"]), ["y", "z", "b"])
        XCTAssertEqual(["a", "b"].replacing(elementsIn: ["b"], with: ["y", "z"]), ["a", "y", "z"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: ["y", "z"]), ["A", "y", "z", "a", "A", "B"])
        XCTAssertEqual(["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: ["y", "z"]), ["A", "y", "z", "a", "A", "y", "z"])
        
        XCTAssertEqual(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: ["y", "z"]), ["y", "z", "y", "z", "a", "y", "z", "B"])
        
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: [""], with: ["y", "z"]), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello"].replacing(elementsIn: ["e"], with: ["y", "z"]), ["Tester", "Hello"])
        XCTAssertEqual(["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: ["New1", "New2"]), ["New1", "New2", "Hello", "New1", "New2"])
        
        XCTAssertEqual("Tester".replacing(elementsIn: ["e"], with: ["y", "z"]), "Tyzstyzr")
        XCTAssertEqual("Tester".replacing(elementsIn: ["e" as Character], with: ["y", "z"]), "Tyzstyzr")
    }
    
    // MARK: - String Collection Duplicates
    
    func testStringCollection_caseInsensitiveRemovingDuplicates() {
        XCTAssertEqual(["", ""].caseInsensitiveRemovingDuplicates(), [""])
        XCTAssertEqual(["a", "a"].caseInsensitiveRemovingDuplicates(), ["a"])
        XCTAssertEqual(["a", "A"].caseInsensitiveRemovingDuplicates(), ["a"])
        XCTAssertEqual(["A", "a"].caseInsensitiveRemovingDuplicates(), ["A"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].caseInsensitiveRemovingDuplicates(), ["A", "b"])
    }
    
    func testStringCollection_localizedRemovingDuplicates() throws {
        guard Locale.current.identifier.starts(with: "en_") else {
            throw XCTSkip("Test can only run for English locale.")
        }
        
        XCTAssertEqual(["", ""].localizedRemovingDuplicates(), [""])
        XCTAssertEqual(["a", "a"].localizedRemovingDuplicates(), ["a"])
        XCTAssertEqual(["a", "A"].localizedRemovingDuplicates(), ["a", "A"])
        XCTAssertEqual(["A", "a"].localizedRemovingDuplicates(), ["A", "a"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].localizedRemovingDuplicates(), ["A", "b", "a", "B"])
    }
    
    func testStringCollection_localizedCaseInsensitiveRemovingDuplicates() throws {
        guard Locale.current.identifier.starts(with: "en_") else {
            throw XCTSkip("Test can only run for English locale.")
        }
        
        XCTAssertEqual(["", ""].localizedCaseInsensitiveRemovingDuplicates(), [""])
        XCTAssertEqual(["a", "a"].localizedCaseInsensitiveRemovingDuplicates(), ["a"])
        XCTAssertEqual(["a", "A"].localizedCaseInsensitiveRemovingDuplicates(), ["a"])
        XCTAssertEqual(["A", "a"].localizedCaseInsensitiveRemovingDuplicates(), ["A"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].localizedCaseInsensitiveRemovingDuplicates(), ["A", "b"])
    }
    
    func testStringCollection_localizedStandardRemovingDuplicates() throws {
        guard Locale.current.identifier.starts(with: "en_") else {
            throw XCTSkip("Test can only run for English locale.")
        }
        
        XCTAssertEqual(["", ""].localizedStandardRemovingDuplicates(), [""])
        XCTAssertEqual(["a", "a"].localizedStandardRemovingDuplicates(), ["a"])
        XCTAssertEqual(["a", "A"].localizedStandardRemovingDuplicates(), ["a", "A"])
        XCTAssertEqual(["A", "a"].localizedStandardRemovingDuplicates(), ["A", "a"])
        XCTAssertEqual(["A", "b", "a", "A", "B"].localizedStandardRemovingDuplicates(), ["A", "b", "a", "B"])
    }
    
    // MARK: - .mapKeys
    
    func testDictionary_mapKeys_SameTypes() {
        let dict = [
            "One": 1,
            "Two": 2
        ]
        
        let mapped = dict.mapKeys {
            $0 + " Key"
        }
        
        XCTAssertEqual(
            mapped,
            [
                "One Key": 1,
                "Two Key": 2
            ]
        )
    }
    
    func testDictionary_mapKeys_DifferentTypes() {
        struct MyKey: Equatable, Hashable {
            var name: String
        }
        
        let dict = [
            "One": 1,
            "Two": 2
        ]
        
        let mapped = dict.mapKeys {
            MyKey(name: $0 + " Key")
        }
        
        XCTAssertEqual(
            mapped,
            [
                MyKey(name: "One Key"): 1,
                MyKey(name: "Two Key"): 2
            ]
        )
    }
    
    // MARK: - .mapDictionary
    
    func testDictionary_mapDictionary_SameTypes() {
        let dict = [
            "One": 1,
            "Two": 2
        ]
        
        let mapped = dict.mapDictionary {
            ($0 + " plus Two", $1 + 2)
        }
        
        XCTAssertEqual(
            mapped,
            [
                "One plus Two": 3,
                "Two plus Two": 4
            ]
        )
    }
    
    func testDictionary_mapDictionary_DifferentTypes() {
        struct MyKey: Equatable, Hashable {
            var name: String
        }
        
        let dict = [
            "One": 1,
            "Two": 2
        ]
        
        // with parameter tokens
        do {
            let mapped = dict.mapDictionary {
                (MyKey(name: $0 + " plus 2.5"), Double($1) + 2.5)
            }
            
            XCTAssertEqual(
                mapped,
                [
                    MyKey(name: "One plus 2.5"): 3.5,
                    MyKey(name: "Two plus 2.5"): 4.5
                ]
            )
        }
        
        // with explicit closure signature
        do {
            let mapped = dict.mapDictionary { key, value in
                (MyKey(name: key + " plus 2.5"), Double(value) + 2.5)
            }
            
            XCTAssertEqual(
                mapped,
                [
                    MyKey(name: "One plus 2.5"): 3.5,
                    MyKey(name: "Two plus 2.5"): 4.5
                ]
            )
        }
    }
    
    // MARK: - .compactMapDictionary
    
    func testDictionary_compactMapDictionary_SameTypes() {
        let dict = [
            "One": 1,
            "Two": 2,
            "Three": 3
        ]
        
        // with parameter tokens
        do {
            let mapped: [String: Int] = dict.compactMapDictionary {
                if $0 == "Two" { return nil }
                return ($0 + " plus Two", $1 + 2)
            }
            
            XCTAssertEqual(
                mapped,
                [
                    "One plus Two": 3,
                    "Three plus Two": 5
                ]
            )
        }
        
        // with explicit closure signature
        do {
            let mapped = dict.compactMapDictionary { (key, value) in
                key != "Two"
                    ? (key + " plus Two", value + 2)
                    : nil
            }
            
            XCTAssertEqual(
                mapped,
                [
                    "One plus Two": 3,
                    "Three plus Two": 5
                ]
            )
        }
    }
    
    func testDictionary_compactMapDictionary_DifferentTypes() {
        struct MyKey: Equatable, Hashable {
            var name: String
        }
        
        let dict = [
            "One": 1,
            "Two": 2,
            "Three": 3
        ]
        
        // with parameter tokens
        do {
            let mapped = dict.compactMapDictionary {
                $0 != "Two"
                    ? (MyKey(name: $0 + " plus 2.5"), Double($1) + 2.5)
                    : nil
            }
            
            XCTAssertEqual(
                mapped,
                [
                    MyKey(name: "One plus 2.5"): 3.5,
                    MyKey(name: "Three plus 2.5"): 5.5
                ]
            )
        }
        
        // with explicit closure signature
        do {
            let mapped = dict.compactMapDictionary { (key, value) in
                key != "Two"
                    ? (MyKey(name: key + " plus 2.5"), Double(value) + 2.5)
                    : nil
            }
            
            XCTAssertEqual(
                mapped,
                [
                    MyKey(name: "One plus 2.5"): 3.5,
                    MyKey(name: "Three plus 2.5"): 5.5
                ]
            )
        }
    }
    
    func testSequence_mapDictionary() {
        let array = [
            "1. One",
            "2. Two"
        ]
        
        let mapped = array.mapDictionary {
            (Int($0.prefix(1))!, $0.dropFirst(3))
        }
        
        XCTAssertEqual(
            mapped,
            [
                1: "One",
                2: "Two"
            ]
        )
    }
    
    func testSequence_compactMapDictionary() {
        let array = [
            "1. One",
            "2. Two",
            "3. Three"
        ]
        
        let mapped: [Int: String] = array.compactMapDictionary {
            let ref = Int($0.prefix(1))!
            guard ref % 2 != 0 else { return nil }
            return (Int($0.prefix(1))!, String($0.dropFirst(3)))
        }
        
        XCTAssertEqual(
            mapped,
            [
                1: "One",
                3: "Three"
            ]
        )
    }
}
