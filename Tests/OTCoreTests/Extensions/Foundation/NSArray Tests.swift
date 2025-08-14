//
//  NSArray Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_NSArray_Tests {
    @Test
    func nsArray_SafeIndexSubscript_Get() {
        let nsArr = [1, 2, 3] as NSArray
        
        #expect(nsArr[safe: -1] as? Int == nil)
        #expect(nsArr[safe:  0] as? Int == 1)
        #expect(nsArr[safe:  1] as? Int == 2)
        #expect(nsArr[safe:  2] as? Int == 3)
        #expect(nsArr[safe:  3] as? Int == nil)
        
        // edge cases
        
        // empty array
        let nsArr2 = [] as NSArray
        #expect(nsArr2[safe: -1] as? Int == nil)
        #expect(nsArr2[safe:  0] as? Int == nil)
        #expect(nsArr2[safe:  1] as? Int == nil)
        
        // single element array
        let nsArr3 = [1] as NSArray
        #expect(nsArr3[safe: -1] as? Int == nil)
        #expect(nsArr3[safe:  0] as? Int == 1)
        #expect(nsArr3[safe:  1] as? Int == nil)
    }
    
    @Test
    func nsMutableArray_SafeIndexSubscript_Get() {
        let nsArr = [1, 2, 3] as NSMutableArray
        
        #expect(nsArr[safe: -1] as? Int == nil)
        #expect(nsArr[safe:  0] as? Int == 1)
        #expect(nsArr[safe:  1] as? Int == 2)
        #expect(nsArr[safe:  2] as? Int == 3)
        #expect(nsArr[safe:  3] as? Int == nil)
        
        // edge cases
        
        // empty array
        let nsArr2 = [] as NSMutableArray
        #expect(nsArr2[safe: -1] as? Int == nil)
        #expect(nsArr2[safe:  0] as? Int == nil)
        #expect(nsArr2[safe:  1] as? Int == nil)
        
        // single element array
        let nsArr3 = [1] as NSMutableArray
        #expect(nsArr3[safe: -1] as? Int == nil)
        #expect(nsArr3[safe:  0] as? Int == 1)
        #expect(nsArr3[safe:  1] as? Int == nil)
    }
    
    @Test
    func nsMutableArray_SafeMutableIndexSubscript() {
        // get
        
        let nsArr = [1, 2, 3] as NSMutableArray
        
        #expect(nsArr[safeMutable: -1] as? Int == nil)
        #expect(nsArr[safeMutable:  0] as? Int == 1)
        #expect(nsArr[safeMutable:  1] as? Int == 2)
        #expect(nsArr[safeMutable:  2] as? Int == 3)
        #expect(nsArr[safeMutable:  3] as? Int == nil)
        
        // set
        
        let nsArr2 = [1, 2, 3] as NSMutableArray
        
        nsArr2[safeMutable: -1] = 4 // fails silently, no value stored
        nsArr2[safeMutable: 0] = 5
        nsArr2[safeMutable: 1] = 6
        nsArr2[safeMutable: 2] = 7
        nsArr2[safeMutable: 3] = 8 // fails silently, no value stored
        
        #expect(nsArr2 == [5, 6, 7])
    }
    
    @Test
    func nsMutableArray_SafeIndexSubscript_Modify() {
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
//        #expect(arr.count == 3)
//        #expect((arr[0] as? Foo)?.value == 0)
//        #expect((arr[1] as? Foo)?.value == 9)
//        #expect((arr[2] as? Foo)?.value == 2)
//
//        // fails silently
//        (arr[safeMutable: 3] as? Foo)?.value = 8
//        #expect(arr.count == 3)
//        #expect((arr[0] as? Foo)?.value == 0)
//        #expect((arr[1] as? Foo)?.value == 9)
//        #expect((arr[2] as? Foo)?.value == 2)
    }
}

#endif
