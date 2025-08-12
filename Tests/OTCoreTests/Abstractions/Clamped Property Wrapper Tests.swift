//
//  Clamped Property Wrapper Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Abstractions_Clamped_Tests {
    @Test
    func clampedPropertyWrapper_ClosedRange() {
        struct SomeStruct {
            @Clamped(to: 5 ... 10) var value = 1
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 5) // default clamped
        
        someStruct.value = 2
        #expect(someStruct.value == 5)
        
        someStruct.value = 5
        #expect(someStruct.value == 5)
        
        someStruct.value = 10
        #expect(someStruct.value == 10)
        
        someStruct.value = 11
        #expect(someStruct.value == 10)
    }
    
    @Test
    func clampedPropertyWrapper_ClosedRange_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: 5 ... 5) var value = 1
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 5) // default clamped
        
        someStruct.value = 2
        #expect(someStruct.value == 5)
        
        someStruct.value = 5
        #expect(someStruct.value == 5)
        
        someStruct.value = 10
        #expect(someStruct.value == 5)
    }
    
    @Test
    func clampedPropertyWrapper_Range() {
        struct SomeStruct {
            @Clamped(to: 5 ..< 10) var value = 1
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 5) // default clamped
        
        someStruct.value = 2
        #expect(someStruct.value == 5)
        
        someStruct.value = 5
        #expect(someStruct.value == 5)
        
        someStruct.value = 9
        #expect(someStruct.value == 9)
        
        someStruct.value = 10
        #expect(someStruct.value == 9)
    }
    
    @Test
    func clampedPropertyWrapper_Range_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: 5 ..< 5) var value = 1
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 1) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 2
        #expect(someStruct.value == 2) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 5
        #expect(someStruct.value == 5) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 9
        #expect(someStruct.value == 9) // invalid range, doesn't clamp, just returns value
        
        someStruct.value = 10
        #expect(someStruct.value == 10) // invalid range, doesn't clamp, just returns value
    }
    
    @Test
    func clampedPropertyWrapper_PartialRangeUpTo() {
        struct SomeStruct {
            @Clamped(to: ..<10) var value = 15
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 9) // default clamped
        
        someStruct.value = 2
        #expect(someStruct.value == 2)
        
        someStruct.value = 5
        #expect(someStruct.value == 5)
        
        someStruct.value = 9
        #expect(someStruct.value == 9)
        
        someStruct.value = 10
        #expect(someStruct.value == 9)
    }
    
    @Test
    func clampedPropertyWrapper_PartialRangeUpTo_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: ..<Int.min) var value = 15
        }
        
        // this results in a crash, so we can't/shouldn't test it here
        
        // it should be the user's responsibility to check if the range is valid
    }
    
    @Test
    func clampedPropertyWrapper_PartialRangeThrough() {
        struct SomeStruct {
            @Clamped(to: ...10) var value = 15
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 10) // default clamped
        
        someStruct.value = 2
        #expect(someStruct.value == 2)
        
        someStruct.value = 5
        #expect(someStruct.value == 5)
        
        someStruct.value = 10
        #expect(someStruct.value == 10)
        
        someStruct.value = 11
        #expect(someStruct.value == 10)
    }
    
    @Test
    func clampedPropertyWrapper_PartialRangeThrough_EdgeCase1() {
        struct SomeStruct {
            @Clamped(to: ...Int.min) var value = 15
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == Int.min) // default clamped
        
        someStruct.value = 2
        #expect(someStruct.value == Int.min)
    }
    
    @Test
    func clampedPropertyWrapper_PartialRangeThrough_EdgeCase2() {
        struct SomeStruct {
            @Clamped(to: ...Int.max) var value = 15
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 15)
        
        someStruct.value = 2
        #expect(someStruct.value == 2)
        
        someStruct.value = Int.max
        #expect(someStruct.value == Int.max)
    }
    
    @Test
    func clampedPropertyWrapper_PartialRangeFrom() {
        struct SomeStruct {
            @Clamped(to: 10...) var value = 2
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == 10) // default clamped
        
        someStruct.value = 2
        #expect(someStruct.value == 10)
        
        someStruct.value = 10
        #expect(someStruct.value == 10)
        
        someStruct.value = 11
        #expect(someStruct.value == 11)
        
        someStruct.value = Int.max
        #expect(someStruct.value == Int.max)
    }
    
    @Test
    func clampedPropertyWrapper_PartialRangeFrom_EdgeCase() {
        struct SomeStruct {
            @Clamped(to: Int.max...) var value = 2
        }
        
        var someStruct = SomeStruct()
        #expect(someStruct.value == Int.max) // default clamped
        
        someStruct.value = 10
        #expect(someStruct.value == Int.max)
        
        someStruct.value = Int.max
        #expect(someStruct.value == Int.max)
    }
}
