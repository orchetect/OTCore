//
//  Validated Property Wrapper Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Abstractions_Validated_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testValidated() {
        
        struct SomeStruct {
            @Validated({
                $0.clamped(to: 5...10)
            }) var value = 1
        }
        
        var someStruct = SomeStruct()
        
        XCTAssertEqual(someStruct.value, 5) // default value validated
        
        someStruct.value = 2
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 5
        XCTAssertEqual(someStruct.value, 5)
        
        someStruct.value = 10
        XCTAssertEqual(someStruct.value, 10)
        
        someStruct.value = 11
        XCTAssertEqual(someStruct.value, 10)
        
    }
    
}

#endif
