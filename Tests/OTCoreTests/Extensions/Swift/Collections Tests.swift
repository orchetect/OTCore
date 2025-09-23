//
//  Collections Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import Testing

@Suite struct Extensions_Swift_Collections_Tests {
    // MARK: - Collection += Operator
    
    @Test
    func collection_Operator_PlusEquals_Element() {
        // [String]
                                                  
        var arr1: [String] = []
        arr1 += "test"
        #expect(arr1 == ["test"])
        
        // [Int]
        
        var arr2: [Int] = []
        arr2 += 2
        #expect(arr2 == [2])
        
        // Set<Int>
        
        var set: Set<Int> = [3]
        set += 1
        #expect(set == [1, 3])
        
        // tuple
        
        var arr3: [(Int, Int)] = []
        arr3 += (1, 2)
        #expect(arr3[0].0 == 1)
        #expect(arr3[0].1 == 2)
        
        // [[String]]
        
        var arr4: [[String]] = []
        arr4 += ["test"]
        #expect(arr4 == [["test"]])
    }
    
    @Test
    func set_Operator_Plus_Set() {
        var set: Set<Int> = [3]
        set = set + Set([1, 2])
        #expect(set == [1, 2, 3])
    }
    
    @Test
    func set_Operator_PlusEquals_Set() {
        var set: Set<Int> = [3]
        set += Set([1, 2])
        #expect(set == [1, 2, 3])
    }
    
    // MARK: - [safe: Index]
    
    @Test
    func subscript_Safe_Get() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        #expect(arr[safe: -1] == nil)
        #expect(arr[safe: 0] == 1)
        #expect(arr[safe: 1] == 2)
        #expect(arr[safe: 5] == 6)
        #expect(arr[safe: 6] == nil)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(4)
        #expect(slice[safe: -1] == nil)
        #expect(slice[safe: 0] == nil)
        #expect(slice[safe: 1] == nil)
        #expect(slice[safe: 2] == 3)
        #expect(slice[safe: 5] == 6)
        #expect(slice[safe: 6] == nil)
    }
    
    @Test
    func subscript_Safe_Get_EdgeCases() {
        // empty array
        #expect([Int]()[safe: -1] == nil)
        #expect([Int]()[safe:  0] == nil)
        #expect([Int]()[safe:  1] == nil)
        
        // single element array
        #expect([1][safe: -1] == nil)
        #expect([1][safe:  0] == 1)
        #expect([1][safe:  1] == nil)
        
        // [Int?]
        let arr: [Int?] = [nil, 2, 3, 4, 5, 6]
        #expect(arr[safe: -1] == nil)
        #expect(arr[safe: 0] == Int?(nil))
        #expect(arr[safe: 0] != nil)
        #expect(arr[safe: 1] == Int?(2))
        #expect(arr[safe: 5] == Int?(6))
        #expect(arr[safe: 6] == nil)
    }
    
    @Test
    func subscript_Safe_Set() {
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safe: 0] = 9        // succeeds
        arr[safe: 5] = 8        // succeeds
        
        #expect(arr == [9, 2, 3, 4, 5, 8])
        
        arr[safe: -1] = 0       // silently fails
        arr[safe: 6] = 7        // silently fails
        
        #expect(arr == [9, 2, 3, 4, 5, 8])
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        var slice = arr.suffix(4)
        
        slice[safe: 0] = 0        // silently fails
        #expect(slice == [3, 4, 5, 8])
        
        slice[safe: 1] = 0        // silently fails
        #expect(slice == [3, 4, 5, 8])
        
        slice[safe: 2] = 0        // succeeds
        #expect(slice == [0, 4, 5, 8])
        
        slice[safe: 5] = 0        // succeeds
        #expect(slice == [0, 4, 5, 0])
        
        slice[safe: 6] = 7        // silently fails
        #expect(slice == [0, 4, 5, 0])
    }
    
    @Test
    func subscript_Safe_Modify() {
        struct Foo {
            var value: Int = 0
        }
        
        // [Foo]
        var arr = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        arr[safe: 0]?.value = 9
        
        #expect(arr[0].value == 9)
    }
    
    @Test
    func subscript_Safe_Modify_OptionalElement() {
        struct Foo: Equatable {
            var value: Int = 0
        }
        
        // [Foo?]
        let arr: [Foo?] = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        // [Foo?].SubSequence a.k.a. ArraySlice<Foo?>
        var slice = arr[1...]
        
        // succeeds
        slice[safe: 1]??.value = 9
        #expect(slice == [Foo(value: 9), Foo(value: 2)])
        
        // fails silently
        slice[safe: 3]??.value = 8
        #expect(slice == [Foo(value: 9), Foo(value: 2)])
    }
    
    @Test
    func subscript_Safe_Set_EdgeCases() async throws {
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safe: -1] = nil       // silently fails
        arr[safe: 6] = nil        // silently fails
        
        // only occurs in debug builds. only testable with Xcode 26+.
        #if DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            var arr = [1, 2, 3, 4, 5, 6]
            arr[safe: 0] = nil    // throws precondition failure
        }
        #endif
        
        #expect(arr == [1, 2, 3, 4, 5, 6])
        
        // [Int?]
        var arr2: [Int?] = [1, 2, 3, 4, 5, 6]
        
        arr2[safe: -1] = nil       // silently fails
        arr2[safe: 0] = nil        // succeeds
        arr2[safe: 6] = nil        // silently fails
        
        #expect(arr2 == [nil, 2, 3, 4, 5, 6])
    }
    
    // MARK: - [safe: Index, defaultValue:]
    
    @Test
    func subscript_Safe_Get_DefaultValue() {
        // [Int]
        let arr = [1, 2, 3]
        
        #expect(arr[safe: -1, default: 99] == 99)
        #expect(arr[safe:  0, default: 99] == 1)
        #expect(arr[safe:  1, default: 99] == 2)
        #expect(arr[safe:  2, default: 99] == 3)
        #expect(arr[safe:  3, default: 99] == 99)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(2)
        
        #expect(slice[safe: -1, default: 99] == 99)
        #expect(slice[safe:  0, default: 99] == 99)
        #expect(slice[safe:  1, default: 99] == 2)
        #expect(slice[safe:  2, default: 99] == 3)
        #expect(slice[safe:  3, default: 99] == 99)
    }
    
    @Test
    func subscript_Safe_Get_DefaultValue_EdgeCases() {
        // empty array
        #expect([Int]()[safe: -1, default: 99] == 99)
        #expect([Int]()[safe:  0, default: 99] == 99)
        #expect([Int]()[safe:  1, default: 99] == 99)
        
        // single element array
        #expect([1][safe: -1, default: 99] == 99)
        #expect([1][safe:  0, default: 99] == 1)
        #expect([1][safe:  1, default: 99] == 99)
    }
    
    // MARK: - [safe: i...i]
    
    @Test
    func subscript_Safe_ClosedRange_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ... toIndex]
            #expect(slice == [1, 2, 3, 4])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: fromIndex ... toIndex]
            #expect(slice == [2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: fromIndex ... toIndex]
            #expect(slice == nil)
        }
    }
    
    @Test
    func subscript_Safe_ClosedRange_Index_EdgeCases() {
        // empty array
        do {
            let arr: [Int] = []
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ... toIndex]
            #expect(slice == nil)
        }
        
        // single element array
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ... toIndex]
            #expect(slice == nil)
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex ... toIndex]
            #expect(slice == [1])
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: -1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex ... toIndex]
            #expect(slice == nil)
        }
    }
    
    @Test
    func subscript_Safe_ClosedRange_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: 0 ... 3]
            #expect(slice == [1, 2, 3, 4])
        }
        
        do {
            let slice = arr[safe: 1 ... 5]
            #expect(slice == [2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 1 ... 6]
            #expect(slice == nil)
        }
        
        do {
            let slice = arr[safe: -1 ... 3]
            #expect(slice == nil)
        }
    }
    
    // MARK: - [safe: i..<i]
    
    @Test
    func subscript_Safe_Range_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == [1, 2, 3, 4, 5])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == [2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 7)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == nil)
        }
    }
    
    @Test
    func subscript_Safe_Range_Index_EdgeCases() {
        // empty array
        do {
            let arr: [Int] = []
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == nil)
        }
        
        // single element array
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 3)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == nil)
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == [])
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == [1])
        }
        
        do {
            let arr: [Int] = [1]
            
            let fromIndex = arr.index(arr.startIndex, offsetBy: -1)
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: fromIndex ..< toIndex]
            #expect(slice == nil)
        }
    }
    
    @Test
    func subscript_Safe_Range_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: 0 ..< 4]
            #expect(slice == [1, 2, 3, 4])
        }
        
        do {
            let slice = arr[safe: 1 ..< 6]
            #expect(slice == [2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 1 ..< 7]
            #expect(slice == nil)
        }
        
        do {
            let slice = arr[safe: -1 ..< 4]
            #expect(slice == nil)
        }
    }
    
    // MARK: - [safe: i...]
    
    @Test
    func subscript_Safe_PartialRangeFrom_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: -1)
            let slice = arr[safe: fromIndex...]
            #expect(slice == nil)
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: fromIndex...]
            #expect(slice == [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: fromIndex...]
            #expect(slice == [2, 3, 4, 5, 6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: fromIndex...]
            #expect(slice == [6])
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: fromIndex...]
            #expect(slice == []) // technically correct
        }
        
        do {
            let fromIndex = arr.index(arr.startIndex, offsetBy: 7)
            let slice = arr[safe: fromIndex...]
            #expect(slice == nil)
        }
    }
    
    @Test
    func subscript_Safe_PartialRangeFrom_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: (-1)...]
            #expect(slice == nil)
        }
        
        do {
            let slice = arr[safe: 0...]
            #expect(slice == [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 1...]
            #expect(slice == [2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: 5...]
            #expect(slice == [6])
        }
        
        do {
            let slice = arr[safe: 6...]
            #expect(slice == []) // technically correct
        }
        
        do {
            let slice = arr[safe: 7...]
            #expect(slice == nil)
        }
    }
    
    // MARK: - [safe: ...i]
    
    @Test
    func subscript_Safe_PartialRangeThrough_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: -1)
            let slice = arr[safe: ...toIndex]
            #expect(slice == nil)
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: ...toIndex]
            #expect(slice == [1])
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: ...toIndex]
            #expect(slice == [1, 2])
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: ...toIndex]
            #expect(slice == [1, 2, 3, 4, 5, 6])
        }

        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: ...toIndex]
            #expect(slice == nil)
        }
    }

    @Test
    func subscript_Safe_PartialRangeThrough_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]

        do {
            let slice = arr[safe: ...(-1)]
            #expect(slice == nil)
        }

        do {
            let slice = arr[safe: ...0]
            #expect(slice == [1])
        }

        do {
            let slice = arr[safe: ...1]
            #expect(slice == [1, 2])
        }

        do {
            let slice = arr[safe: ...5]
            #expect(slice == [1, 2, 3, 4, 5, 6])
        }

        do {
            let slice = arr[safe: ...6]
            #expect(slice == nil)
        }
    }
    
    // MARK: - [safe: ..<i]
    
    @Test
    func subscript_Safe_PartialRangeUpTo_Index() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: -1)
            let slice = arr[safe: ..<toIndex]
            #expect(slice == nil)
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 0)
            let slice = arr[safe: ..<toIndex]
            #expect(slice == [])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 1)
            let slice = arr[safe: ..<toIndex]
            #expect(slice == [1])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 5)
            let slice = arr[safe: ..<toIndex]
            #expect(slice == [1, 2, 3, 4, 5])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 6)
            let slice = arr[safe: ..<toIndex]
            #expect(slice == [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let toIndex = arr.index(arr.startIndex, offsetBy: 7)
            let slice = arr[safe: ..<toIndex]
            #expect(slice == nil)
        }
    }
    
    @Test
    func subscript_Safe_PartialRangeUpTo_IndexInt() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        do {
            let slice = arr[safe: ..<(-1)]
            #expect(slice == nil)
        }
        
        do {
            let slice = arr[safe: ..<0]
            #expect(slice == [])
        }
        
        do {
            let slice = arr[safe: ..<1]
            #expect(slice == [1])
        }
        
        do {
            let slice = arr[safe: ..<5]
            #expect(slice == [1, 2, 3, 4, 5])
        }
        
        do {
            let slice = arr[safe: ..<6]
            #expect(slice == [1, 2, 3, 4, 5, 6])
        }
        
        do {
            let slice = arr[safe: ..<7]
            #expect(slice == nil)
        }
    }
    
    // MARK: - [safePosition: Int]
    
    @Test
    func subscript_SafePosition_Get() {
        // [Int]
        let arr = [1, 2, 3, 4, 5, 6]
        
        #expect(arr[safePosition: -1] == nil)
        #expect(arr[safePosition: 0] == 1)
        #expect(arr[safePosition: 1] == 2)
        #expect(arr[safePosition: 5] == 6)
        #expect(arr[safePosition: 6] == nil)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(4)
        #expect(slice[safePosition: -1] == nil)
        #expect(slice[safePosition: 0] == 3)
        #expect(slice[safePosition: 1] == 4)
        #expect(slice[safePosition: 3] == 6)
        #expect(slice[safePosition: 4] == nil)
    }
    
    @Test
    func subscript_SafePosition_Get_EdgeCases() {
        // empty array
        #expect([Int]()[safePosition: -1] == nil)
        #expect([Int]()[safePosition:  0] == nil)
        #expect([Int]()[safePosition:  1] == nil)
        
        // single element array
        #expect([1][safePosition: -1] == nil)
        #expect([1][safePosition:  0] == 1)
        #expect([1][safePosition:  1] == nil)
        
        // [Int?]
        let arr: [Int?] = [nil, 2, 3, 4, 5, 6]
        #expect(arr[safePosition: -1] == nil)
        #expect(arr[safePosition: 0] == Int?(nil))
        #expect(arr[safePosition: 0] != nil)
        #expect(arr[safePosition: 1] == Int?(2))
        #expect(arr[safePosition: 5] == Int?(6))
        #expect(arr[safePosition: 6] == nil)
    }
    
    @Test
    func subscript_SafePosition_Set() {
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safePosition: 0] = 9        // succeeds
        arr[safePosition: 5] = 8        // succeeds
        
        #expect(arr == [9, 2, 3, 4, 5, 8])
        
        arr[safePosition: -1] = 0       // silently fails
        arr[safePosition: 6] = 7        // silently fails
        
        #expect(arr == [9, 2, 3, 4, 5, 8])
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        var slice = arr.suffix(4)
        
        slice[safePosition: 0] = 1      // succeeds
        slice[safePosition: 3] = 6      // succeeds
        
        #expect(slice == [1, 4, 5, 6])
        
        slice[safePosition: -1] = 0       // silently fails
        slice[safePosition: 4] = 7        // silently fails
        
        #expect(slice == [1, 4, 5, 6])
    }
    
    @Test
    func subscript_SafePosition_Set_EdgeCases() async throws {
        // [Int]
        var arr = [1, 2, 3, 4, 5, 6]
        
        arr[safePosition: -1] = nil       // silently fails, out of bounds
        arr[safePosition: 6] = nil        // silently fails, out of bounds
        
        // only occurs in debug builds. only testable with Xcode 26+.
        #if DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            var arr = [1, 2, 3, 4, 5, 6]
            arr[safePosition: 0] = nil    // throws precondition failure
        }
        #endif
        
        #expect(arr == [1, 2, 3, 4, 5, 6])
        
        // [Int?]
        var arr2: [Int?] = [1, 2, 3, 4, 5, 6]
        
        arr2[safePosition: -1] = nil       // silently fails
        arr2[safePosition: 0] = nil        // succeeds
        arr2[safePosition: 6] = nil        // silently fails
        
        #expect(arr2 == [nil, 2, 3, 4, 5, 6])
    }
    
    @Test
    func subscript_SafePosition_Modify() {
        struct Foo: Equatable {
            var value: Int = 0
        }
        
        // [Foo]
        let arr = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        // [Foo].SubSequence a.k.a. ArraySlice<Foo>
        var slice = arr[1...]
        
        slice[safePosition: 1]?.value = 9
        
        #expect(slice == [Foo(value: 1), Foo(value: 9)])
    }
    
    @Test
    func subscript_SafePosition_Modify_OptionalElement() {
        struct Foo: Equatable {
            var value: Int = 0
        }
        
        // [Foo?]
        let arr: [Foo?] = [Foo(value: 0), Foo(value: 1), Foo(value: 2)]
        
        // [Foo?].SubSequence a.k.a. ArraySlice<Foo?>
        var slice = arr[1...]
        
        // succeeds
        slice[safePosition: 1]??.value = 9
        #expect(slice == [Foo(value: 1), Foo(value: 9)])
        
        // fails silently
        slice[safePosition: 2]??.value = 8
        #expect(slice == [Foo(value: 1), Foo(value: 9)])
    }
    
    // MARK: - [safePosition: Index, defaultValue:]
    
    @Test
    func subscript_SafePosition_Get_DefaultValue() {
        // [Int]
        let arr = [1, 2, 3]
        
        #expect(arr[safePosition: -1, default: 99] == 99)
        #expect(arr[safePosition:  0, default: 99] == 1)
        #expect(arr[safePosition:  1, default: 99] == 2)
        #expect(arr[safePosition:  2, default: 99] == 3)
        #expect(arr[safePosition:  3, default: 99] == 99)
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = arr.suffix(2)
        
        #expect(slice[safePosition: -1, default: 99] == 99)
        #expect(slice[safePosition:  0, default: 99] == 2)
        #expect(slice[safePosition:  1, default: 99] == 3)
        #expect(slice[safePosition:  2, default: 99] == 99)
    }
    
    @Test
    func subscript_SafePosition_Get_DefaultValue_EdgeCases() {
        // empty array
        #expect([Int]()[safePosition: -1, default: 99] == 99)
        #expect([Int]()[safePosition:  0, default: 99] == 99)
        #expect([Int]()[safePosition:  1, default: 99] == 99)
        
        // single element array
        #expect([1][safePosition: -1, default: 99] == 99)
        #expect([1][safePosition:  0, default: 99] == 1)
        #expect([1][safePosition:  1, default: 99] == 99)
    }
    
    // MARK: - [safePosition: i...i]
    
    @Test
    func subscript_SafePosition_ClosedRange_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        do {
            #expect(slice[safePosition: (-1) ... (-1)] == nil)
            #expect(slice[safePosition: 0 ... 0] == [3])
            #expect(slice[safePosition: 1 ... 1] == [4])
            #expect(slice[safePosition: 3 ... 3] == [6])
            #expect(slice[safePosition: 4 ... 4] == nil)
        }
        
        do {
            let slice2 = slice[safePosition: 1 ... 3]
            #expect(slice2 == [4, 5, 6])
        }
        
        do {
            let slice2 = slice[safePosition: 1 ... 4]
            #expect(slice2 == nil)
        }
        
        do {
            let slice2 = slice[safePosition: -1 ... 3]
            #expect(slice2 == nil)
        }
    }
    
    // MARK: - [safePosition: i..<i]
    
    @Test
    func subscript_SafePosition_Range_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        do {
            #expect(slice[safePosition: (-1) ..< (-1)] == nil)
            #expect(slice[safePosition: 0 ..< 0] == [])
            #expect(slice[safePosition: 1 ..< 1] == [])
            #expect(slice[safePosition: 3 ..< 3] == [])
            #expect(slice[safePosition: 4 ..< 4] == []) // technically correct
            #expect(slice[safePosition: 5 ..< 5] == nil)
            
            #expect(slice[safePosition: (-1) ..< 0] == nil)
            #expect(slice[safePosition: 0 ..< 1] == [3])
            #expect(slice[safePosition: 1 ..< 2] == [4])
            #expect(slice[safePosition: 3 ..< 4] == [6])
            #expect(slice[safePosition: 4 ..< 5] == nil)
        }
        
        do {
            let slice2 = slice[safePosition: 1 ..< 4]
            #expect(slice2 == [4, 5, 6])
        }
        
        do {
            let slice2 = slice[safePosition: 1 ..< 5]
            #expect(slice2 == nil)
        }
        
        do {
            let slice2 = slice[safePosition: -1 ..< 4]
            #expect(slice2 == nil)
        }
    }
    
    // MARK: - [safePosition: i...]
    
    @Test
    func subscript_SafePosition_PartialRangeFrom_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        #expect(slice[safePosition: (-1)...] == nil)
        #expect(slice[safePosition: 0...] == [3, 4, 5, 6])
        #expect(slice[safePosition: 1...] == [4, 5, 6])
        #expect(slice[safePosition: 3...] == [6])
        #expect(slice[safePosition: 4...] == [])
        #expect(slice[safePosition: 5...] == nil)
    }
    
    // MARK: - [safePosition: ...i]
    
    @Test
    func subscript_SafePosition_PartialRangeThrough_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        #expect(slice[safePosition: ...(-1)] == nil)
        #expect(slice[safePosition: ...0] == [3])
        #expect(slice[safePosition: ...1] == [3, 4])
        #expect(slice[safePosition: ...3] == [3, 4, 5, 6])
        #expect(slice[safePosition: ...4] == nil)
    }
    
    // MARK: - [safePosition: ..<i]
    
    @Test
    func subscript_SafePosition_PartialRangeUpTo_Int() {
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        let slice = [1, 2, 3, 4, 5, 6][2...] // [3, 4, 5, 6]
        
        #expect(slice[safePosition: ..<(-1)] == nil)
        #expect(slice[safePosition: ..<0] == [])
        #expect(slice[safePosition: ..<1] == [3])
        #expect(slice[safePosition: ..<2] == [3, 4])
        #expect(slice[safePosition: ..<4] == [3, 4, 5, 6])
        #expect(slice[safePosition: ..<5] == nil)
    }
    
    // MARK: - .remove(safeAt:)
    
    @Test
    func arrayRemoveSafeAt() {
        // [Int]
        var arr = [1, 2, 3]
        
        #expect(arr.remove(safeAt: 0) == 1) // succeeds
        #expect(arr == [2, 3])
        
        #expect(arr.remove(safeAt: -1) == nil) // silently fails
        #expect(arr == [2, 3])
        
        #expect(arr.remove(safeAt: 2) == nil) // silently fails
        #expect(arr == [2, 3])
        
        #expect(arr.remove(safeAt: 0) == 2) // succeeds
        #expect(arr == [3])
    }
    
    @Test
    func arrayRemoveSafePositionAt() {
        // [Int]
        let arr = [0, 0, 1, 2, 3, 4, 5, 6]
        
        // [Int].SubSequence a.k.a. ArraySlice<Int>
        var slice = arr.suffix(6)
        
        #expect(slice.remove(safePositionAt: -1) == nil)
        
        #expect(slice.remove(safePositionAt: 0) == 1)
        #expect(slice == [2, 3, 4, 5, 6])
        
        #expect(slice.remove(safePositionAt: 0) == 2)
        #expect(slice == [3, 4, 5, 6])
        
        #expect(slice.remove(safePositionAt: 3) == 6)
        #expect(slice == [3, 4, 5])
        
        #expect(slice.remove(safePositionAt: 3) == nil)
        #expect(slice == [3, 4, 5])
    }
    
    // MARK: - Indexes
    
    @Test
    func startIndexOffsetBy() {
        // .startIndex(offsetBy:)
        
        let array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        
        #expect(
            array.startIndex(offsetBy: 0)
                == array.startIndex
        )
        
        #expect(
            array.startIndex(offsetBy: 1)
                == array.index(array.startIndex, offsetBy: 1)
        )
    }
    
    @Test
    func endIndexOffsetBy() {
        // .endIndex(offsetBy:)
        
        let array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        
        #expect(
            array.endIndex(offsetBy: 0)
                == array.endIndex
        )
        
        #expect(
            array.endIndex(offsetBy: -1)
                == array.index(array.endIndex, offsetBy: -1)
        )
    }
    
    // MARK: - [position: Int]
    
    @Test
    func subscriptPosition_OffsetIndex() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        #expect(array[position: 2] == "c")
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        #expect(slice[position: 2] == "2")
    }
    
    // MARK: - [position: i...i]
    
    @Test
    func subscriptPosition_ClosedRange() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        #expect(array[position: 1 ... 3] == ["b", "c", "1"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        #expect(slice[position: 1 ... 3] == ["1", "2", "3"])
    }
    
    // MARK: - [position: i..<i]
    
    @Test
    func subscriptPosition_Range() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        #expect(array[position: 1 ..< 3] == ["b", "c"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        #expect(slice[position: 1 ..< 3] == ["1", "2"])
    }
    
    // MARK: - [position: i...]
    
    @Test
    func subscriptPosition_PartialRangeFrom() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        #expect(array[position: 2...] == ["c", "1", "2", "3"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        #expect(slice[position: 2...] == ["2", "3"])
    }
    
    // MARK: - [position: ...i]
    
    @Test
    func subscriptPosition_PartialRangeThrough() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        #expect(array[position: ...3] == ["a", "b", "c", "1"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        #expect(slice[position: ...3] == ["c", "1", "2", "3"])
    }
    
    // MARK: - [position: ..<i]
    
    @Test
    func subscriptPosition_PartialRangeUpTo() {
        let array = ["a", "b", "c", "1", "2", "3"]
        
        // [String]
        #expect(array[position: ..<3] == ["a", "b", "c"])
        
        // [String].SubSequence a.k.a. ArraySlice<String>
        let slice = array.suffix(4)
        #expect(slice[position: ..<3] == ["c", "1", "2"])
    }
    
    // MARK: - [wrapping:]
    
    @Test
    func wrappingIndexSubscript() {
        let x = ["0", "1", "2", "3", "4"]
        
        #expect(x[wrapping:  0] == "0")
        #expect(x[wrapping:  1] == "1")
        #expect(x[wrapping:  2] == "2")
        #expect(x[wrapping:  3] == "3")
        #expect(x[wrapping:  4] == "4")
        #expect(x[wrapping:  5] == "0")
        #expect(x[wrapping:  6] == "1")
        #expect(x[wrapping: -1] == "4")
        #expect(x[wrapping: -4] == "1")
        #expect(x[wrapping: -5] == "0")
        #expect(x[wrapping: -6] == "4")
    }
    
    // MARK: - .count(of:)
    
    @Test
    func countOfElement() {
        let arr = [1, 1, 1, 2, 2, 3]
        
        #expect(arr.count(of: 1) == 3)
        #expect(arr.count(of: 3) == 1)
        #expect(arr.count(of: 4) == 0)
    }
    
    // MARK: - shortest() / shortestIndex()
    
    @Test
    func stringProtocol_Shortest() {
        #expect([String]().shortest() == nil)
        #expect([""].shortest() == "")
        #expect(["A"].shortest() == "A")
        #expect(["abc", "A", "1", "xy", ""].shortest() == "")
        #expect(["abc", "A", "1", "xy"].shortest() == "A")
        #expect(["abc", "1", "A", "xy"].shortest() == "1")
    }
    
    @Test
    func stringProtocol_ShortestIndex() {
        #expect([String]().shortestIndex() == nil)
        #expect([""].shortestIndex() == 0)
        #expect(["A"].shortestIndex() == 0)
        #expect(["abc", "A", "1", "xy", ""].shortestIndex() == 4)
        #expect(["abc", "A", "1", "xy"].shortestIndex() == 1)
        #expect(["abc", "1", "A", "xy"].shortestIndex() == 1)
    }
    
    // MARK: - longest() / longestIndex()
    
    @Test
    func stringProtocol_Longest() {
        #expect([String]().longest() == nil)
        #expect([""].longest() == "")
        #expect(["A"].longest() == "A")
        #expect(["A", "1", "xy", "", "abc"].longest() == "abc")
        #expect(["abc", "123", "A", "1", "xyz"].longest() == "abc")
        #expect(["123", "abc", "1", "A", "xyz"].longest() == "123")
    }
    
    @Test
    func stringProtocol_LongestIndex() {
        #expect([String]().longestIndex() == nil)
        #expect([""].longestIndex() == 0)
        #expect(["A"].longestIndex() == 0)
        #expect(["A", "1", "xy", "", "abc"].longestIndex() == 4)
        #expect(["abc", "123", "A", "1", "xyz"].longestIndex() == 0)
        #expect(["123", "abc", "1", "A", "xyz"].longestIndex() == 0)
    }
    
    // MARK: - .stringValueArrayLiteral
    
    @Test
    func stringValueArrayLiteral() {
        #expect([Int]().stringValueArrayLiteral == "[]")
        
        #expect([1, 2, 3].stringValueArrayLiteral == "[1, 2, 3]")
    }
    
    // MARK: - .firstGapValue()
    
    @Test
    func firstGapValue() {
        // default argument
        
        #expect([Int]().firstGapValue() == nil)
        #expect([1].firstGapValue() == nil)
        #expect([1, 2, 4, 6].firstGapValue() == 3)
        #expect([1, 2, 3, 4].firstGapValue() == nil)
        
        // .firstGapValue(after:)
        
        #expect([Int]().firstGapValue(after: 6) == nil)
        #expect([1].firstGapValue(after: 0) == nil)
        #expect([1, 2, 4, 6].firstGapValue(after: 1) == 3)
        #expect([1, 2, 3, 4].firstGapValue(after: 1) == nil)
        
        #expect([1, 3, 5, 7, 9].firstGapValue(after: -1) == 2)
        #expect([1, 3, 5, 7, 9].firstGapValue(after: 2) == 4)
        #expect([1, 3, 5, 7, 9].firstGapValue(after: 3) == 4)
        #expect([1, 3, 5, 7, 9].firstGapValue(after: 4) == 6)
    }
    
    // MARK: - Set union methods
    
    @Test
    func setUnion() {
        // .union
        
        var set: Set<FooEnum> = [.fooB(1), .one]
        
        let setA = set.union([.fooB(2), .two])
        #expect(setA == [.fooB(999), .one, .two]) // can't use this to check associated value
        for item in setA {
            switch item {
            case let .fooB(val): #expect(val == 1) // check associated value here
            default: break
            }
        }
        
        // .union(updating:)
        
        let setB = set.union(updating: [.fooB(2), .two])
        #expect(setB == [.fooB(999), .one, .two]) // can't use this to check associated value
        for item in setB {
            switch item {
            case let .fooB(val): #expect(val == 2) // check associated value here
            default: break
            }
        }
        
        // .formUnion(updating:)
        
        set.formUnion(updating: [.fooB(2), .two])
        #expect(set == [.fooB(999), .one, .two]) // can't use this to check associated value
        for item in set {
            switch item {
            case let .fooB(val): #expect(val == 2) // check associated value here
            default: break
            }
        }
    }
    
    // MARK: - .array constructor
    
    @Test
    func arraySlice_Array() {
        let sourceArray = ["A", "B", "C"]
        
        let slice = sourceArray.suffix(2)
        
        // as a precondition, assert that this is an ArraySlice and its indexing is as expected
        
        #expect("\(type(of: slice))" == "ArraySlice<String>") // brittle, but we'll test it
        #expect(slice.count == 2)
        #expect(slice == ["B", "C"])
        #expect(slice[1] == "B") // this slice's indexes start on 1
        #expect(slice[2] == "C")
        
        // test formation of array
        
        let array = slice.array
        
        #expect("\(type(of: array))" == "Array<String>") // brittle, but we'll test it
        #expect(array.count == 2)
        #expect(array == ["B", "C"])
        #expect(array[0] == "B") // reindexed back to start on 0
        #expect(array[1] == "C")
    }
    
    // MARK: - .grouping(by:)
    
    @Test
    func sequence_Grouping() {
        let ungrouped = ["Bob", "Billy", "Alex", "Kevin", "Adam"]
        
        let grouped = ungrouped.grouping(by: { $0.first! })
        
        #expect(
            grouped
                == [
                    "A": ["Alex", "Adam"],
                    "B": ["Bob", "Billy"],
                    "K": ["Kevin"],
                ]
        )
    }

    // MARK: - .split(every:backwards:)
    
    @Test
    func splitEvery() {
        let str = "1234567890"
        
        #expect(str.split(every: 1) == ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
        #expect(str.split(every: 2) == ["12", "34", "56", "78", "90"])
        #expect(str.split(every: 4) == ["1234", "5678", "90"])
        #expect(str.split(every: 4, backwards: true) == ["12", "3456", "7890"])
        
        // edge cases
        #expect(str.split(every: -1) == [])
        #expect(str.split(every: 0) == ["1234567890"])
        #expect(str.split(every: 0, backwards: true) == ["1234567890"])
    }
    
    // MARK: - .indices(splitEvery:)
    
    @Test
    func indicesSplitEvery() {
        let arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        #expect(arr.indices(splitEvery: -1) == [0 ... 10])
        #expect(arr.indices(splitEvery: 0) == [0 ... 10])
        #expect(
            arr.indices(splitEvery: 1)
                == [0 ... 0, 1 ... 1, 2 ... 2, 3 ... 3, 4 ... 4, 5 ... 5, 6 ... 6, 7 ... 7, 8 ... 8, 9 ... 9, 10 ... 10]
        )
        #expect(
            arr.indices(splitEvery: 2) == [0 ... 1, 2 ... 3, 4 ... 5, 6 ... 7, 8 ... 9, 10 ... 10]
        )
        #expect(arr.indices(splitEvery: 3) == [0 ... 2, 3 ... 5, 6 ... 8, 9 ... 10])
        #expect(arr.indices(splitEvery: 4) == [0 ... 3, 4 ... 7, 8 ... 10])
        #expect(arr.indices(splitEvery: 5) == [0 ... 4, 5 ... 9, 10 ... 10])
        #expect(arr.indices(splitEvery: 10) == [0 ... 9, 10 ... 10])
        #expect(arr.indices(splitEvery: 11) == [0 ... 10])
        #expect(arr.indices(splitEvery: 12) == [0 ... 10])
    }
    
    // MARK: - Duplicates
    
    @Test
    func removingDuplicates() {
        #expect(([] as [Int]).removingDuplicates() == [] )
        #expect([1, 2, 3, 4].removingDuplicates() == [1, 2, 3, 4])
        #expect([1, 2, 3, 2, 4].removingDuplicates() == [1, 2, 3, 4])
        #expect([1, 2, 2, 2, 2].removingDuplicates() == [1, 2])
    }
    
    @Test
    func removeDuplicates() {
        do {
            var arr = [] as [Int]
            arr.removeDuplicates()
            #expect(arr == [])
        }
        do {
            var arr = [1, 2, 3, 4]
            arr.removeDuplicates()
            #expect(arr == [1, 2, 3, 4])
        }
        do {
            var arr = [1, 2, 3, 2, 4]
            arr.removeDuplicates()
            #expect(arr == [1, 2, 3, 4])
        }
        do {
            var arr = [1, 2, 2, 2, 2]
            arr.removeDuplicates()
            #expect(arr == [1, 2])
        }
    }
    
    @Test
    func removingDuplicatesRandomOrdering() {
        #expect(([] as [Int]).removingDuplicatesRandomOrdering() == [])
        #expect(
            [1, 2, 3, 4].removingDuplicatesRandomOrdering()
                .elementsEqual(orderInsensitive: [1, 2, 3, 4])
        )
        #expect(
            [1, 2, 3, 2, 4].removingDuplicatesRandomOrdering()
                .elementsEqual(orderInsensitive: [1, 2, 3, 4])
        )
        #expect(
            [1, 2, 2, 2, 2].removingDuplicatesRandomOrdering()
                .elementsEqual(orderInsensitive: [1, 2])
        )
    }
    
    @Test
    func duplicateElements() {
        #expect(([] as [Int]).duplicateElements() == [])
        #expect([1, 2, 3, 4].duplicateElements() == [])
        #expect([1, 2, 3, 2, 4].duplicateElements() == [2])
        #expect([1, 2, 3, 2, 1, 4].duplicateElements() == [1, 2])
        #expect([1, 2, 2, 2, 2].duplicateElements() == [2])
    }
    
    @Test
    func duplicateElementIndices() {
        #expect(([] as [Int]).duplicateElementIndices(.firstOccurrences) == [])
        #expect(([] as [Int]).duplicateElementIndices(.afterFirstOccurrences) == [])
        #expect(([] as [Int]).duplicateElementIndices(.allOccurrences) == [])
        
        #expect([1].duplicateElementIndices(.firstOccurrences) == [])
        #expect([1].duplicateElementIndices(.afterFirstOccurrences) == [])
        #expect([1].duplicateElementIndices(.allOccurrences) == [])
        
        #expect([1, 2].duplicateElementIndices(.firstOccurrences) == [])
        #expect([1, 2].duplicateElementIndices(.afterFirstOccurrences) == [])
        #expect([1, 2].duplicateElementIndices(.allOccurrences) == [])
        
        #expect([1, 1].duplicateElementIndices(.firstOccurrences) == [0])
        #expect([1, 1].duplicateElementIndices(.afterFirstOccurrences) == [1])
        #expect([1, 1].duplicateElementIndices(.allOccurrences) == [0, 1])
        
        #expect([1, 2, 3, 4].duplicateElementIndices(.firstOccurrences) == [])
        #expect([1, 2, 3, 4].duplicateElementIndices(.afterFirstOccurrences) == [])
        #expect([1, 2, 3, 4].duplicateElementIndices(.allOccurrences) == [])
        
        #expect([1, 2, 3, 2, 4].duplicateElementIndices(.firstOccurrences) == [1])
        #expect([1, 2, 3, 2, 4].duplicateElementIndices(.afterFirstOccurrences) == [3])
        #expect([1, 2, 3, 2, 4].duplicateElementIndices(.allOccurrences) == [1, 3])
        
        #expect([1, 2, 2, 2].duplicateElementIndices(.firstOccurrences) == [1])
        #expect([1, 2, 2, 2].duplicateElementIndices(.afterFirstOccurrences) == [2, 3])
        #expect([1, 2, 2, 2].duplicateElementIndices(.allOccurrences) == [1, 2, 3])
        
        // unsorted
        #expect(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.firstOccurrences)
                == [1, 3]
        )
        #expect(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.afterFirstOccurrences)
                == [2, 4, 6, 5]
        )
        #expect(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.allOccurrences)
                == [1, 2, 4, 3, 6, 5]
        )
        
        // sorted
        #expect(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.firstOccurrences, sorted: true)
                == [1, 3]
        )
        #expect(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.afterFirstOccurrences, sorted: true)
                == [2, 4, 5, 6]
        )
        #expect(
            [1, 2, 2, 3, 2, 2, 3].duplicateElementIndices(.allOccurrences, sorted: true)
                == [1, 2, 3, 4, 5, 6]
        )
    }
    
    @Test
    func allElementsAreEqual() {
        #expect([Int]().allElementsAreEqual)
        #expect([1].allElementsAreEqual)
        #expect([1, 1].allElementsAreEqual)
        #expect([1, 1, 1].allElementsAreEqual)
        
        #expect(![1, 2].allElementsAreEqual)
        #expect(![1, 2, 1].allElementsAreEqual)
        #expect(![1, 1, 2].allElementsAreEqual)
    }
    
    @Test
    func elementsEqual_orderInsensitive() {
        #expect(([] as [Int]).elementsEqual(orderInsensitive: []))
        #expect(([1] as [Int]).elementsEqual(orderInsensitive: [1]))
        #expect(([1, 2] as [Int]).elementsEqual(orderInsensitive: [1, 2]))
        #expect(([1, 2] as [Int]).elementsEqual(orderInsensitive: [2, 1]))
        #expect(([1, 1] as [Int]).elementsEqual(orderInsensitive: [1, 1]))
        #expect(([1, 3, 2] as [Int]).elementsEqual(orderInsensitive: [3, 2, 1]))
        
        #expect(!([1] as [Int]).elementsEqual(orderInsensitive: []))
        #expect(!([] as [Int]).elementsEqual(orderInsensitive: [1]))
        
        #expect(!([1] as [Int]).elementsEqual(orderInsensitive: [2]))
        #expect(!([1, 2] as [Int]).elementsEqual(orderInsensitive: [1, 1]))
        #expect(!([1, 2] as [Int]).elementsEqual(orderInsensitive: [2, 2]))
    }
    
    // MARK: - Replace
    
    @Test
    func replacingElementsWithElement() {
        #expect([""].replacing(elementsIn: [], with: "") == [""])
        #expect(["a"].replacing(elementsIn: [], with: "z") == ["a"])
        #expect(["a"].replacing(elementsIn: ["a"], with: "z") == ["z"])
        #expect(["a"].replacing(elementsIn: ["b"], with: "z") == ["a"])
        #expect(["ä"].replacing(elementsIn: ["a"], with: "z") == ["ä"])
        #expect(["", ""].replacing(elementsIn: [], with: "") == ["", ""])
        #expect(["a", "b"].replacing(elementsIn: ["a"], with: "z") == ["z", "b"])
        #expect(["a", "b"].replacing(elementsIn: ["b"], with: "z") == ["a", "z"])
        #expect(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: "z") == ["A", "z", "a", "A", "B"])
        #expect(["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: "z") == ["A", "z", "a", "A", "z"])
        
        #expect(["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: "z") == ["z", "z", "a", "z", "B"])
        
        #expect(["Tester", "Hello"].replacing(elementsIn: [""], with: "z") == ["Tester", "Hello"])
        #expect(["Tester", "Hello"].replacing(elementsIn: ["e"], with: "z") == ["Tester", "Hello"])
        #expect(["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: "New") == ["New", "Hello", "New"])
        
        #expect("Tester".replacing(elementsIn: ["e"], with: "z") == "Tzstzr")
        #expect("Tester".replacing(elementsIn: ["e" as Character], with: "z") == "Tzstzr")
    }
    
    @Test
    func replacingElementsWithElements() {
        // replacing with empty collection
        
        #expect([""].replacing(elementsIn: [], with: []) == [""])
        #expect(["a"].replacing(elementsIn: [], with: []) == ["a"])
        #expect(["a"].replacing(elementsIn: ["a"], with: []) == [])
        #expect(["a"].replacing(elementsIn: ["b"], with: []) == ["a"])
        #expect(["ä"].replacing(elementsIn: ["a"], with: []) == ["ä"])
        #expect(["", ""].replacing(elementsIn: [], with: []) == ["", ""])
        #expect(["a", "b"].replacing(elementsIn: ["a"], with: []) == ["b"])
        #expect(["a", "b"].replacing(elementsIn: ["b"], with: []) == ["a"])
        #expect(
            ["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: [])
                == ["A", "a", "A", "B"]
        )
        #expect(
            ["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: [])
                == ["A", "a", "A"]
        )
        
        #expect(
            ["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: [])
                == ["a", "B"]
        )
        
        #expect(
            ["Tester", "Hello"].replacing(elementsIn: [""], with: [])
                == ["Tester", "Hello"]
        )
        #expect(
            ["Tester", "Hello"].replacing(elementsIn: ["e"], with: [])
                == ["Tester", "Hello"]
        )
        #expect(
            ["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: [])
                == ["Hello"]
        )
        
        #expect("Tester".replacing(elementsIn: ["e"], with: []) == "Tstr")
        #expect("Tester".replacing(elementsIn: ["e" as Character], with: []) == "Tstr")
        
        // replacing with single new element
        
        #expect([""].replacing(elementsIn: [], with: [""]) == [""])
        #expect(["a"].replacing(elementsIn: [], with: ["z"]) == ["a"])
        #expect(["a"].replacing(elementsIn: ["a"], with: ["z"]) == ["z"])
        #expect(["a"].replacing(elementsIn: ["b"], with: ["z"]) == ["a"])
        #expect(["ä"].replacing(elementsIn: ["a"], with: ["z"]) == ["ä"])
        #expect(["", ""].replacing(elementsIn: [], with: [""]) == ["", ""])
        #expect(["a", "b"].replacing(elementsIn: ["a"], with: ["z"]) == ["z", "b"])
        #expect(["a", "b"].replacing(elementsIn: ["b"], with: ["z"]) == ["a", "z"])
        #expect(
            ["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: ["z"])
                == ["A", "z", "a", "A", "B"]
        )
        #expect(
            ["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: ["z"])
                == ["A", "z", "a", "A", "z"]
        )
        
        #expect(
            ["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: ["z"])
                == ["z", "z", "a", "z", "B"]
        )
        
        #expect(
            ["Tester", "Hello"].replacing(elementsIn: [""], with: ["z"])
                == ["Tester", "Hello"]
        )
        #expect(
            ["Tester", "Hello"].replacing(elementsIn: ["e"], with: ["z"])
                == ["Tester", "Hello"]
        )
        #expect(
            ["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: ["New"])
                == ["New", "Hello", "New"]
        )
        
        #expect("Tester".replacing(elementsIn: ["e"], with: ["z"]) == "Tzstzr")
        #expect("Tester".replacing(elementsIn: ["e" as Character], with: ["z"]) == "Tzstzr")
        
        // replacing with multiple new elements
        
        #expect([""].replacing(elementsIn: [], with: ["", ""]) == [""])
        #expect(["a"].replacing(elementsIn: [], with: ["y", "z"]) == ["a"])
        #expect(["a"].replacing(elementsIn: ["a"], with: ["y", "z"]) == ["y", "z"])
        #expect(["a"].replacing(elementsIn: ["b"], with: ["y", "z"]) == ["a"])
        #expect(["ä"].replacing(elementsIn: ["a"], with: ["y", "z"]) == ["ä"])
        #expect(["", ""].replacing(elementsIn: [], with: ["", ""]) == ["", ""])
        #expect(["a", "b"].replacing(elementsIn: ["a"], with: ["y", "z"]) == ["y", "z", "b"])
        #expect(["a", "b"].replacing(elementsIn: ["b"], with: ["y", "z"]) == ["a", "y", "z"])
        #expect(
            ["A", "b", "a", "A", "B"].replacing(elementsIn: ["b"], with: ["y", "z"])
                == ["A", "y", "z", "a", "A", "B"]
        )
        #expect(
            ["A", "b", "a", "A", "b"].replacing(elementsIn: ["b"], with: ["y", "z"])
                == ["A", "y", "z", "a", "A", "y", "z"]
        )
        
        #expect(
            ["A", "b", "a", "A", "B"].replacing(elementsIn: ["b", "A"], with: ["y", "z"])
                == ["y", "z", "y", "z", "a", "y", "z", "B"]
        )
        
        #expect(
            ["Tester", "Hello"].replacing(elementsIn: [""], with: ["y", "z"])
                == ["Tester", "Hello"]
        )
        #expect(
            ["Tester", "Hello"].replacing(elementsIn: ["e"], with: ["y", "z"])
                == ["Tester", "Hello"]
        )
        #expect(
            ["Tester", "Hello", "Tester"].replacing(elementsIn: ["Tester"], with: ["New1", "New2"])
                == ["New1", "New2", "Hello", "New1", "New2"]
        )
        
        #expect("Tester".replacing(elementsIn: ["e"], with: ["y", "z"]) == "Tyzstyzr")
        #expect("Tester".replacing(elementsIn: ["e" as Character], with: ["y", "z"]) == "Tyzstyzr")
    }
    
    // MARK: - String Collection Duplicates
    
    @Test
    func stringCollection_caseInsensitiveRemovingDuplicates() {
        #expect(["", ""].caseInsensitiveRemovingDuplicates() == [""])
        #expect(["a", "a"].caseInsensitiveRemovingDuplicates() == ["a"])
        #expect(["a", "A"].caseInsensitiveRemovingDuplicates() == ["a"])
        #expect(["A", "a"].caseInsensitiveRemovingDuplicates() == ["A"])
        #expect(["A", "b", "a", "A", "B"].caseInsensitiveRemovingDuplicates() == ["A", "b"])
    }
    
    @Test(.enabled(ifLocaleIdentifierHasPrefix: "en"))
    func stringCollection_localizedRemovingDuplicates() throws {
        #expect(["", ""].localizedRemovingDuplicates() == [""])
        #expect(["a", "a"].localizedRemovingDuplicates() == ["a"])
        #expect(["a", "A"].localizedRemovingDuplicates() == ["a", "A"])
        #expect(["A", "a"].localizedRemovingDuplicates() == ["A", "a"])
        #expect(
            ["A", "b", "a", "A", "B"].localizedRemovingDuplicates()
                == ["A", "b", "a", "B"]
        )
    }
    
    @Test(.enabled(ifLocaleIdentifierHasPrefix: "en"))
    func stringCollection_localizedCaseInsensitiveRemovingDuplicates() throws {
        #expect(["", ""].localizedCaseInsensitiveRemovingDuplicates() == [""])
        #expect(["a", "a"].localizedCaseInsensitiveRemovingDuplicates() == ["a"])
        #expect(["a", "A"].localizedCaseInsensitiveRemovingDuplicates() == ["a"])
        #expect(["A", "a"].localizedCaseInsensitiveRemovingDuplicates() == ["A"])
        #expect(
            ["A", "b", "a", "A", "B"].localizedCaseInsensitiveRemovingDuplicates()
                == ["A", "b"]
        )
    }
    
    @Test(.enabled(ifLocaleIdentifierHasPrefix: "en"))
    func stringCollection_localizedStandardRemovingDuplicates() throws {
        #expect(["", ""].localizedStandardRemovingDuplicates() == [""])
        #expect(["a", "a"].localizedStandardRemovingDuplicates() == ["a"])
        #expect(["a", "A"].localizedStandardRemovingDuplicates() == ["a", "A"])
        #expect(["A", "a"].localizedStandardRemovingDuplicates() == ["A", "a"])
        #expect(
            ["A", "b", "a", "A", "B"].localizedStandardRemovingDuplicates()
                == ["A", "b", "a", "B"]
        )
    }
    
    // MARK: - .mapKeys
    
    @Test
    func dictionary_mapKeys_SameTypes() {
        let dict = [
            "One": 1,
            "Two": 2
        ]
        
        let mapped = dict.mapKeys {
            $0 + " Key"
        }
        
        #expect(
            mapped
                == [
                "One Key": 1,
                "Two Key": 2
            ]
        )
    }
    
    @Test
    func dictionary_mapKeys_DifferentTypes() {
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
        
        #expect(
            mapped
                == [
                MyKey(name: "One Key"): 1,
                MyKey(name: "Two Key"): 2
            ]
        )
    }
    
    // MARK: - .mapDictionary
    
    @Test
    func dictionary_mapDictionary_SameTypes() {
        let dict = [
            "One": 1,
            "Two": 2
        ]
        
        let mapped = dict.mapDictionary {
            ($0 + " plus Two", $1 + 2)
        }
        
        #expect(
            mapped
                == [
                "One plus Two": 3,
                "Two plus Two": 4
            ]
        )
    }
    
    @Test
    func dictionary_mapDictionary_DifferentTypes() {
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
            
            #expect(
                mapped
                    == [
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
            
            #expect(
                mapped
                    == [
                    MyKey(name: "One plus 2.5"): 3.5,
                    MyKey(name: "Two plus 2.5"): 4.5
                ]
            )
        }
    }
    
    // MARK: - .compactMapDictionary
    
    @Test
    func dictionary_compactMapDictionary_SameTypes() {
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
            
            #expect(
                mapped
                    == [
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
            
            #expect(
                mapped
                    == [
                    "One plus Two": 3,
                    "Three plus Two": 5
                ]
            )
        }
    }
    
    @Test
    func dictionary_compactMapDictionary_DifferentTypes() {
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
            
            #expect(
                mapped
                    == [
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
            
            #expect(
                mapped
                    == [
                    MyKey(name: "One plus 2.5"): 3.5,
                    MyKey(name: "Three plus 2.5"): 5.5
                ]
            )
        }
    }
    
    @Test
    func sequence_mapDictionary() {
        let array = [
            "1. One",
            "2. Two"
        ]
        
        let mapped = array.mapDictionary {
            (Int($0.prefix(1))!, $0.dropFirst(3))
        }
        
        #expect(
            mapped
                == [
                1: "One",
                2: "Two"
            ]
        )
    }
    
    @Test
    func sequence_compactMapDictionary() {
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
        
        #expect(
            mapped
                == [
                1: "One",
                3: "Three"
            ]
        )
    }
}
