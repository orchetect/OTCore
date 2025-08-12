//
//  Collection BinarySearch Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import XCTest
import XCTestUtils

class Algorithms_CollectionBinarySearch_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testBinarySearch() {
        // basic checks
        
        XCTAssertNil([Int]().binarySearch(forValue: 1))
        
        XCTAssertEqual([1].binarySearch(forValue: 1), 0 ... 0)
        XCTAssertEqual([1, 2, 3].binarySearch(forValue: 1), 0 ... 0)
        XCTAssertEqual([1, 2, 3].binarySearch(forValue: 2), 1 ... 1)
        XCTAssertEqual([1, 2, 3].binarySearch(forValue: 3), 2 ... 2)
        XCTAssertNil([1, 2, 3].binarySearch(forValue: 0))
        XCTAssertNil([1, 2, 3].binarySearch(forValue: 4))
        
        // test guaranteed returns (non-nil, x...x where x is one number)
        
        let maxArraySize = 0 ... 500
        var sp = SegmentedProgress(maxArraySize, segments: 20, roundedToPlaces: 0)
        
        print("Guaranteed return test: ", terminator: "")
        
        for arraySize in maxArraySize {
            let array = Array(maxArraySize.lowerBound ... arraySize)
            
            // test all searchValues wihin range
            for searchValue in array {
                let search = array.binarySearch(forValue: searchValue)
                XCTAssertEqual(search!.count, 1) // should find exact match in array
            }
            
            if let spResult = sp
                .progress(value: arraySize) { print(spResult + " ", terminator: "") }
        }
        print("")
        
        // test non-contiguous array
        
        var arr = [01,  03, 04,  06, 07,  09,  11, 12, 13] // odd count
        XCTAssertEqual(arr.binarySearch(forValue: -1), nil)
        XCTAssertEqual(arr.binarySearch(forValue: 0),  nil)
        XCTAssertEqual(arr.binarySearch(forValue: 1),  0 ... 0)
        XCTAssertEqual(arr.binarySearch(forValue: 2),  0 ... 1)
        XCTAssertEqual(arr.binarySearch(forValue: 3),  1 ... 1)
        XCTAssertEqual(arr.binarySearch(forValue: 4),  2 ... 2)
        XCTAssertEqual(arr.binarySearch(forValue: 5),  2 ... 3)
        XCTAssertEqual(arr.binarySearch(forValue: 6),  3 ... 3)
        XCTAssertEqual(arr.binarySearch(forValue: 7),  4 ... 4)
        XCTAssertEqual(arr.binarySearch(forValue: 8),  4 ... 5)
        XCTAssertEqual(arr.binarySearch(forValue: 9),  5 ... 5)
        XCTAssertEqual(arr.binarySearch(forValue: 10), 5 ... 6)
        XCTAssertEqual(arr.binarySearch(forValue: 11), 6 ... 6)
        XCTAssertEqual(arr.binarySearch(forValue: 12), 7 ... 7)
        XCTAssertEqual(arr.binarySearch(forValue: 13), 8 ... 8)
        XCTAssertEqual(arr.binarySearch(forValue: 14), nil)
        
        arr = [01,  03, 04,  06, 07,  09,  11, 12]        // even count
        XCTAssertEqual(arr.binarySearch(forValue: -1), nil)
        XCTAssertEqual(arr.binarySearch(forValue: 0),  nil)
        XCTAssertEqual(arr.binarySearch(forValue: 1),  0 ... 0)
        XCTAssertEqual(arr.binarySearch(forValue: 2),  0 ... 1)
        XCTAssertEqual(arr.binarySearch(forValue: 3),  1 ... 1)
        XCTAssertEqual(arr.binarySearch(forValue: 4),  2 ... 2)
        XCTAssertEqual(arr.binarySearch(forValue: 5),  2 ... 3)
        XCTAssertEqual(arr.binarySearch(forValue: 6),  3 ... 3)
        XCTAssertEqual(arr.binarySearch(forValue: 7),  4 ... 4)
        XCTAssertEqual(arr.binarySearch(forValue: 8),  4 ... 5)
        XCTAssertEqual(arr.binarySearch(forValue: 9),  5 ... 5)
        XCTAssertEqual(arr.binarySearch(forValue: 10), 5 ... 6)
        XCTAssertEqual(arr.binarySearch(forValue: 11), 6 ... 6)
        XCTAssertEqual(arr.binarySearch(forValue: 12), 7 ... 7)
        XCTAssertEqual(arr.binarySearch(forValue: 13), nil)
        
        // negative numbers, edge cases, etc.
        
        XCTAssertEqual([-4, -3, -2, 3, 4, 6].binarySearch(forValue: -1), 2 ... 3)
        XCTAssertEqual([-4, -3, -2, 3, 4, 6].binarySearch(forValue: -4), 0 ... 0)
        XCTAssertEqual([-4, -3, -2, 3, 4, 6].binarySearch(forValue: 6), 5 ... 5)
    }
}
