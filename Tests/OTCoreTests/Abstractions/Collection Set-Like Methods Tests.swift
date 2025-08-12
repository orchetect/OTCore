//
//  Collection Set-Like Methods Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Abstractions_CollectionSetLikeMethods_Tests {
    @Test
    func arraySetFunctionality_Insert() {
        // .insert
        
        var arr = [1, 2, 3]
        
        arr.insert(1)
        #expect(arr == [1, 2, 3])
        
        arr.insert(4) // position: default
        #expect(arr == [1, 2, 3, 4])
        
        arr.insert(5, position: .end)
        #expect(arr == [1, 2, 3, 4, 5])
        
        arr.insert(0, position: .start)
        #expect(arr == [0, 1, 2, 3, 4, 5])
    }
    
    @Test
    func arraySetFunctionality_Update_UniqueAssociatedValues() {
        // .update
        
        var arr: [FooEnum] = [.foo(1), .foo(2), .foo(3)]
        
        arr.update(with: .foo(1))
        #expect(arr == [.foo(1), .foo(2), .foo(3)])
        
        arr.update(with: .foo(4)) // position: default
        #expect(arr == [.foo(1), .foo(2), .foo(3), .foo(4)])
        
        arr.update(with: .foo(5), position: .end)
        #expect(arr == [.foo(1), .foo(2), .foo(3), .foo(4), .foo(5)])
        
        arr.update(with: .foo(0), position: .start)
        #expect(arr == [.foo(0), .foo(1), .foo(2), .foo(3), .foo(4), .foo(5)])
        
        arr.update(with: .foo(3), position: .start) // reorder existing
        #expect(arr == [.foo(3), .foo(0), .foo(1), .foo(2), .foo(4), .foo(5)])
        
        arr.update(with: .foo(3), position: .end)   // reorder existing
        #expect(arr == [.foo(0), .foo(1), .foo(2), .foo(4), .foo(5), .foo(3)])
    }
    
    @Test
    func arraySetFunctionality_Update_NonUniqueAssociatedValues() {
        // .update
        
        var arr: [FooEnum] = [.foo(1), .fooB(1), .one]
        
        arr.update(with: .fooB(1))
        #expect(arr == [.foo(1), .fooB(999), .one]) // can't use this to check associated value
        for item in arr {
            switch item {
            case let .fooB(val): #expect(val == 1) // check associated value here
            default: break
            }
        }
        
        arr.update(with: .fooB(4)) // position: default
        #expect(arr == [.foo(1), .fooB(999), .one]) // can't use this to check associated value
        for item in arr {
            switch item {
            case let .fooB(val): #expect(val == 4) // check associated value here
            default: break
            }
        }
        
        arr.update(with: .fooB(5), position: .end)
        #expect(arr == [.foo(1), .one, .fooB(999)]) // can't use this to check associated value
        for item in arr {
            switch item {
            case let .fooB(val): #expect(val == 5) // check associated value here
            default: break
            }
        }
        
        arr.update(with: .fooB(0), position: .start)
        #expect(arr == [.fooB(999), .foo(1), .one]) // can't use this to check associated value
        for item in arr {
            switch item {
            case let .fooB(val): #expect(val == 0) // check associated value here
            default: break
            }
        }
        
        arr.update(with: .fooB(3), position: .start) // reorder existing
        #expect(arr == [.fooB(999), .foo(1), .one]) // can't use this to check associated value
        for item in arr {
            switch item {
            case let .fooB(val): #expect(val == 3) // check associated value here
            default: break
            }
        }
        
        arr.update(with: .fooB(3), position: .end) // reorder existing
        #expect(arr == [.foo(1), .one, .fooB(999)]) // can't use this to check associated value
        for item in arr {
            switch item {
            case let .fooB(val): #expect(val == 3) // check associated value here
            default: break
            }
        }
    }
    
    @Test
    func arraySetFunctionality_RemoveAll() {
        // .removeAll
        
        var arr = [1, 1, 2, 2, 3, 3]
        
        arr.removeAll(2)
        #expect(arr == [1, 1, 3, 3])
    }
    
    @Test
    func arraySetFunctionality_Union() {
        // .union
        
        var arr1: [FooEnum] = []
        
        arr1 = [.foo(1), .one]
        var arr2 = arr1.union([.foo(2), .one, .two, .three])
        #expect(arr2 == [.foo(1), .one, .foo(2), .two, .three])
        
        arr1 = [.foo(1), .one]
        arr1.formUnion([.foo(2), .one, .two, .three])
        #expect(arr1 == [.foo(1), .one, .foo(2), .two, .three])
        
        arr1 = [.foo(1), .one]
        arr2 = arr1.union(updating: [.one, .two, .three, .foo(1)])
        #expect(arr2 == [.foo(1), .one, .two, .three])
        
        // .formUnion
        
        arr1 = [.foo(1), .one]
        arr1.formUnion(updating: [.one, .two, .three, .foo(1)])
        #expect(arr1 == [.foo(1), .one, .two, .three])
    }
}
