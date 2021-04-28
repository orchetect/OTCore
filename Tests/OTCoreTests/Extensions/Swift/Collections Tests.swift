//
//  Collections Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-13.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_Collections_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testOperator_PlusEquals() {
		
		// [String]
		
		var arr1: [String] = []
		arr1 += "test"
		XCTAssertEqual(arr1, ["test"])
		
		// [Int]
		
		var arr2: [Int] = []
		arr2 += 2
		XCTAssertEqual(arr2, [2])
		
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
	
	func testSafeIndexSubscript() {
		
		// [Int]
		
		var arr = [1, 2, 3]
		
		// get
		
		XCTAssertNotNil(arr[safe:  0])
		XCTAssertNil(   arr[safe: -1])
		XCTAssertNil(   arr[safe:  3])
		
		// set
		
		arr[safe: 0] = 4		// succeeds
		
		XCTAssertEqual(arr, [4,2,3])
		
		arr[safe: 3] = 4		// silently fails
		
		XCTAssertEqual(arr, [4,2,3])
		
		// edge cases
		
		// empty array
		XCTAssertEqual([Int]()[safe: -1], nil)
		XCTAssertEqual([Int]()[safe:  0], nil)
		XCTAssertEqual([Int]()[safe:  1], nil)
		
		// single element array
		XCTAssertEqual([1][safe: -1], nil)
		XCTAssertEqual([1][safe:  0], 1)
		XCTAssertEqual([1][safe:  1], nil)
		
	}
	
	func testSafeIndexSubscriptDefaultValue() {
		
		// [Int]
		
		let arr = [1,2,3]
		
		// get
		
		XCTAssertEqual(arr[safe: -1, default: 99], 99)
		XCTAssertEqual(arr[safe:  0, default: 99], 1)
		XCTAssertEqual(arr[safe:  1, default: 99], 2)
		XCTAssertEqual(arr[safe:  2, default: 99], 3)
		XCTAssertEqual(arr[safe:  3, default: 99], 99)
		
		// edge cases
		
		// empty array
		XCTAssertEqual([Int]()[safe: -1, default: 99], 99)
		XCTAssertEqual([Int]()[safe:  0, default: 99], 99)
		XCTAssertEqual([Int]()[safe:  1, default: 99], 99)
		
		// single element array
		XCTAssertEqual([1][safe: -1, default: 99], 99)
		XCTAssertEqual([1][safe:  0, default: 99], 1)
		XCTAssertEqual([1][safe:  1, default: 99], 99)
		
	}
	
	func testArrayRemoveSafeAt() {
		
		// Array
		
		var arr = [1,2,3]
		
		XCTAssertEqual(arr.remove(safeAt: 0), 1)	// succeeds
		
		XCTAssertEqual(arr, [2,3])
		
		XCTAssertEqual(arr.remove(safeAt: -1), nil)	// silently fails
		
		XCTAssertEqual(arr, [2,3])
		
		XCTAssertEqual(arr.remove(safeAt: 2), nil)	// silently fails
		
		XCTAssertEqual(arr, [2,3])
		
		XCTAssertEqual(arr.remove(safeAt: 0), 2)	// succeeds
		
		XCTAssertEqual(arr, [3])
		
		// ArraySlice
		
		var arrSlice = ArraySlice(repeating: 1, count: 4)
		
		XCTAssertEqual(arrSlice.remove(safeAt: 0), 1)	// succeeds
		
		XCTAssertEqual(arrSlice, [1,1,1])
		
		XCTAssertEqual(arrSlice.remove(safeAt: 3), nil)	// silently fails
		
		// ContiguousArray
		
		var arrCont = ContiguousArray(repeating: 1, count: 4)
		
		XCTAssertEqual(arrCont.remove(safeAt: 0), 1)	// succeeds
		
		XCTAssertEqual(arrCont, [1,1,1])
		
		XCTAssertEqual(arrCont.remove(safeAt: 3), nil)	// silently fails
	}
	
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
	
	func testCountOfElement() {
		
		let arr = [1,1,1,2,2,3]
		
		XCTAssertEqual(arr.count(of: 1), 3)
		XCTAssertEqual(arr.count(of: 3), 1)
		XCTAssertEqual(arr.count(of: 4), 0)
		
	}
	
	func teststringValueArrayLiteral() {
		
		XCTAssertEqual([Int]().stringValueArrayLiteral, "[]")
		
		XCTAssertEqual([1,2,3].stringValueArrayLiteral, "[1, 2, 3]")
		
	}
	
	func testFirstGapValue() {
		
		// default argument
		
		XCTAssertEqual([Int]()	.firstGapValue(), nil)
		XCTAssertEqual([1]		.firstGapValue(), nil)
		XCTAssertEqual([1,2,4,6].firstGapValue(), 3  )
		XCTAssertEqual([1,2,3,4].firstGapValue(), nil)
		
		// .firstGapValue(after:)
		
		XCTAssertEqual([Int]()	.firstGapValue(after: 6), nil)
		XCTAssertEqual([1]		.firstGapValue(after: 0), nil)
		XCTAssertEqual([1,2,4,6].firstGapValue(after: 1), 3  )
		XCTAssertEqual([1,2,3,4].firstGapValue(after: 1), nil)
		
		XCTAssertEqual([1,3,5,7,9].firstGapValue(after: -1), 2)
		XCTAssertEqual([1,3,5,7,9].firstGapValue(after: 2), 4)
		XCTAssertEqual([1,3,5,7,9].firstGapValue(after: 3), 4)
		XCTAssertEqual([1,3,5,7,9].firstGapValue(after: 4), 6)
		
	}
	
	func testSetUnion() {
		
		// .union
		
		var set: Set<fooEnum> = [.fooB(1), .one]
		
		let setA = set.union([.fooB(2), .two])
		XCTAssertEqual(setA, [.fooB(999), .one, .two])		// can't use this to check associated value
		setA.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 1)		// check associated value here
			default: break
			}
		}
		
		
		// .union(updating:)
		
		let setB = set.union(updating: [.fooB(2), .two])
		XCTAssertEqual(setB, [.fooB(999), .one, .two])		// can't use this to check associated value
		setB.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 2)		// check associated value here
			default: break
			}
		}
		
		
		// .formUnion(updating:)
		
		set.formUnion(updating: [.fooB(2), .two])
		XCTAssertEqual(set, [.fooB(999), .one, .two])		// can't use this to check associated value
		set.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 2)		// check associated value here
			default: break
			}
		}
		
	}
	
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
	
}

#endif
