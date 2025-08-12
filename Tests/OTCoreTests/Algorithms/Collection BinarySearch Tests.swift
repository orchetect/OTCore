//
//  Collection BinarySearch Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Algorithms_CollectionBinarySearch_Tests {
    @Test
    func binarySearch() {
        // basic checks
        
        #expect([Int]().binarySearch(forValue: 1) == nil)
        
        #expect([1].binarySearch(forValue: 1) == 0 ... 0)
        #expect([1, 2, 3].binarySearch(forValue: 1) == 0 ... 0)
        #expect([1, 2, 3].binarySearch(forValue: 2) == 1 ... 1)
        #expect([1, 2, 3].binarySearch(forValue: 3) == 2 ... 2)
        #expect([1, 2, 3].binarySearch(forValue: 0) == nil)
        #expect([1, 2, 3].binarySearch(forValue: 4) == nil)
        
        // test guaranteed returns (non-nil, x...x where x is one number)
        
        let maxArraySize = 0 ... 500
        var sp = SegmentedProgress(maxArraySize, segments: 20, roundedToPlaces: 0)
        
        print("Guaranteed return test: ", terminator: "")
        
        for arraySize in maxArraySize {
            let array = Array(maxArraySize.lowerBound ... arraySize)
            
            // test all searchValues within range
            for searchValue in array {
                let search = array.binarySearch(forValue: searchValue)
                #expect(search!.count == 1) // should find exact match in array
            }
            
            if let spResult = sp
                .progress(value: arraySize) { print(spResult + " ", terminator: "") }
        }
        print("")
        
        // test non-contiguous array
        
        var arr = [01,  03, 04,  06, 07,  09,  11, 12, 13] // odd count
        #expect(arr.binarySearch(forValue: -1) == nil)
        #expect(arr.binarySearch(forValue: 0) ==  nil)
        #expect(arr.binarySearch(forValue: 1) ==  0 ... 0)
        #expect(arr.binarySearch(forValue: 2) ==  0 ... 1)
        #expect(arr.binarySearch(forValue: 3) ==  1 ... 1)
        #expect(arr.binarySearch(forValue: 4) ==  2 ... 2)
        #expect(arr.binarySearch(forValue: 5) ==  2 ... 3)
        #expect(arr.binarySearch(forValue: 6) ==  3 ... 3)
        #expect(arr.binarySearch(forValue: 7) ==  4 ... 4)
        #expect(arr.binarySearch(forValue: 8) ==  4 ... 5)
        #expect(arr.binarySearch(forValue: 9) ==  5 ... 5)
        #expect(arr.binarySearch(forValue: 10) == 5 ... 6)
        #expect(arr.binarySearch(forValue: 11) == 6 ... 6)
        #expect(arr.binarySearch(forValue: 12) == 7 ... 7)
        #expect(arr.binarySearch(forValue: 13) == 8 ... 8)
        #expect(arr.binarySearch(forValue: 14) == nil)
        
        arr = [01,  03, 04,  06, 07,  09,  11, 12]        // even count
        #expect(arr.binarySearch(forValue: -1) == nil)
        #expect(arr.binarySearch(forValue: 0) ==  nil)
        #expect(arr.binarySearch(forValue: 1) ==  0 ... 0)
        #expect(arr.binarySearch(forValue: 2) ==  0 ... 1)
        #expect(arr.binarySearch(forValue: 3) ==  1 ... 1)
        #expect(arr.binarySearch(forValue: 4) ==  2 ... 2)
        #expect(arr.binarySearch(forValue: 5) ==  2 ... 3)
        #expect(arr.binarySearch(forValue: 6) ==  3 ... 3)
        #expect(arr.binarySearch(forValue: 7) ==  4 ... 4)
        #expect(arr.binarySearch(forValue: 8) ==  4 ... 5)
        #expect(arr.binarySearch(forValue: 9) ==  5 ... 5)
        #expect(arr.binarySearch(forValue: 10) == 5 ... 6)
        #expect(arr.binarySearch(forValue: 11) == 6 ... 6)
        #expect(arr.binarySearch(forValue: 12) == 7 ... 7)
        #expect(arr.binarySearch(forValue: 13) == nil)
        
        // negative numbers, edge cases, etc.
        
        #expect([-4, -3, -2, 3, 4, 6].binarySearch(forValue: -1) == 2 ... 3)
        #expect([-4, -3, -2, 3, 4, 6].binarySearch(forValue: -4) == 0 ... 0)
        #expect([-4, -3, -2, 3, 4, 6].binarySearch(forValue: 6) == 5 ... 5)
    }
}
