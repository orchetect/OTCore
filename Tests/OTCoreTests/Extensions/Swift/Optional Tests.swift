//
//  Optional Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

// testOptionalType() declares

private protocol testStructProtocol { }

extension Collection where Element: OTCoreOptionalTyped, Element.Wrapped: testStructProtocol {
    fileprivate var foo: Int { 2 }
}

@Suite struct Extensions_Swift_Optional_Tests {
    @Test
    func optionalType() {
        // basic test
        
        let num: Int? = 1
        
        #expect(num.optional == Optional(1))
        
        // extension test
        
        struct testStruct<T: BinaryInteger>: testStructProtocol {
            var value: T
        }
        
        let arr: [testStruct<UInt8>?] = [testStruct(value: UInt8(1)), nil]
        
        #expect(arr.foo == 2) // ensure the extension works
    }
    
    @Test
    func ifNilDefault() {
        let val1: Int? = 1
        
        #expect(val1.ifNil(2) == 1)
        
        let val2: Int? = nil
        
        #expect(val2.ifNil(2) == 2)
    }
    
    @Test
    func optionalProperty() {
        var val: Int? = 1
        
        #expect(val.optional == 1)
        
        val.optional = 2
        
        #expect(val.optional == 2)
        
        val.optional = nil
        
        #expect(val.optional == nil)
    }
}
