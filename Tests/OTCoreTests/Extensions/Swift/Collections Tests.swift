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
import SegmentedProgress

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
	
	func testNSArray_SafeIndexSubscript() {
		
		// get
		
		let nsArr = [1,2,3] as NSArray
		
		XCTAssertEqual(nsArr[safe: -1] as? Int, nil)
		XCTAssertEqual(nsArr[safe:  0] as? Int, 1)
		XCTAssertEqual(nsArr[safe:  1] as? Int, 2)
		XCTAssertEqual(nsArr[safe:  2] as? Int, 3)
		XCTAssertEqual(nsArr[safe:  3] as? Int, nil)
		
		// edge cases
		
		// empty array
		let nsArr2 = [] as NSArray
		XCTAssertEqual(nsArr2[safe: -1] as? Int, nil)
		XCTAssertEqual(nsArr2[safe:  0] as? Int, nil)
		XCTAssertEqual(nsArr2[safe:  1] as? Int, nil)
		
		// single element array
		let nsArr3 = [1] as NSArray
		XCTAssertEqual(nsArr3[safe: -1] as? Int, nil)
		XCTAssertEqual(nsArr3[safe:  0] as? Int, 1)
		XCTAssertEqual(nsArr3[safe:  1] as? Int, nil)
		
	}
	
	func testNSMutableArray_SafeIndexSubscript() {
		
		// get
		
		let nsArr = [1,2,3] as NSMutableArray
		
		XCTAssertEqual(nsArr[safe: -1] as? Int, nil)
		XCTAssertEqual(nsArr[safe:  0] as? Int, 1)
		XCTAssertEqual(nsArr[safe:  1] as? Int, 2)
		XCTAssertEqual(nsArr[safe:  2] as? Int, 3)
		XCTAssertEqual(nsArr[safe:  3] as? Int, nil)
		
		// edge cases
		
		// empty array
		let nsArr2 = [] as NSMutableArray
		XCTAssertEqual(nsArr2[safe: -1] as? Int, nil)
		XCTAssertEqual(nsArr2[safe:  0] as? Int, nil)
		XCTAssertEqual(nsArr2[safe:  1] as? Int, nil)
		
		// single element array
		let nsArr3 = [1] as NSMutableArray
		XCTAssertEqual(nsArr3[safe: -1] as? Int, nil)
		XCTAssertEqual(nsArr3[safe:  0] as? Int, 1)
		XCTAssertEqual(nsArr3[safe:  1] as? Int, nil)
		
	}
	
	func testNSMutableArray_SafeMutableIndexSubscript() {
		
		// get
		
		let nsArr = [1,2,3] as NSMutableArray
		
		XCTAssertEqual(nsArr[safeMutable: -1] as? Int, nil)
		XCTAssertEqual(nsArr[safeMutable:  0] as? Int, 1)
		XCTAssertEqual(nsArr[safeMutable:  1] as? Int, 2)
		XCTAssertEqual(nsArr[safeMutable:  2] as? Int, 3)
		XCTAssertEqual(nsArr[safeMutable:  3] as? Int, nil)
		
		// set
		
		let nsArr2 = [1,2,3] as NSMutableArray
		
		nsArr2[safeMutable: -1] = 4 // fails silently, no value stored
		nsArr2[safeMutable: 0] = 5
		nsArr2[safeMutable: 1] = 6
		nsArr2[safeMutable: 2] = 7
		nsArr2[safeMutable: 3] = 8 // fails silently, no value stored
		
		XCTAssertEqual(nsArr2, [5,6,7])
		
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
	
	func testCountOf() {
		
		let arr = [1,1,1,2,2,3]
		
		XCTAssertEqual(arr.count(of: 1), 3)
		XCTAssertEqual(arr.count(of: 3), 1)
		XCTAssertEqual(arr.count(of: 4), 0)
		
	}
	
	func teststringValueArrayLiteral() {
		
		XCTAssertEqual([1,2,3].stringValueArrayLiteral, "[1, 2, 3]")
		
	}
	
	func testBinarySearch() {
		
		// basic checks
		
		XCTAssertNil(  [Int]().binarySearch(forValue: 1))
		
		XCTAssertEqual(    [1].binarySearch(forValue: 1), 0...0)
		XCTAssertEqual([1,2,3].binarySearch(forValue: 1), 0...0)
		XCTAssertEqual([1,2,3].binarySearch(forValue: 2), 1...1)
		XCTAssertEqual([1,2,3].binarySearch(forValue: 3), 2...2)
		XCTAssertNil(  [1,2,3].binarySearch(forValue: 0))
		XCTAssertNil(  [1,2,3].binarySearch(forValue: 4))
		
		// test guaranteed returns (non-nil, x...x where x is one number)
		
		let maxArraySize = 0...500
		var sp = SegmentedProgress(maxArraySize, segments: 20, roundedToPlaces: 0)
		
		print("Guaranteed return test: ", terminator: "")
		
		for arraySize in maxArraySize {
			let array = Array(maxArraySize.lowerBound...arraySize)
			
			// test all searchValues wihin range
			for searchValue in array {
				let search = array.binarySearch(forValue: searchValue)
				XCTAssertEqual(search!.count, 1)	// should find exact match in array
			}
			
			if let spResult = sp.progress(value: arraySize) { print(spResult + " ", terminator: "") }
		}
		print("")
		
		// test non-contiguous array
		
		var arr = [01,  03,04,  06,07,  09,  11,12,13]	// odd count
		XCTAssertEqual(arr.binarySearch(forValue: -1), nil)
		XCTAssertEqual(arr.binarySearch(forValue: 0),  nil)
		XCTAssertEqual(arr.binarySearch(forValue: 1),  0...0)
		XCTAssertEqual(arr.binarySearch(forValue: 2),  0...1)
		XCTAssertEqual(arr.binarySearch(forValue: 3),  1...1)
		XCTAssertEqual(arr.binarySearch(forValue: 4),  2...2)
		XCTAssertEqual(arr.binarySearch(forValue: 5),  2...3)
		XCTAssertEqual(arr.binarySearch(forValue: 6),  3...3)
		XCTAssertEqual(arr.binarySearch(forValue: 7),  4...4)
		XCTAssertEqual(arr.binarySearch(forValue: 8),  4...5)
		XCTAssertEqual(arr.binarySearch(forValue: 9),  5...5)
		XCTAssertEqual(arr.binarySearch(forValue: 10), 5...6)
		XCTAssertEqual(arr.binarySearch(forValue: 11), 6...6)
		XCTAssertEqual(arr.binarySearch(forValue: 12), 7...7)
		XCTAssertEqual(arr.binarySearch(forValue: 13), 8...8)
		XCTAssertEqual(arr.binarySearch(forValue: 14), nil)
		
		arr = [01,  03,04,  06,07,  09,  11,12] 		// even count
		XCTAssertEqual(arr.binarySearch(forValue: -1), nil)
		XCTAssertEqual(arr.binarySearch(forValue: 0),  nil)
		XCTAssertEqual(arr.binarySearch(forValue: 1),  0...0)
		XCTAssertEqual(arr.binarySearch(forValue: 2),  0...1)
		XCTAssertEqual(arr.binarySearch(forValue: 3),  1...1)
		XCTAssertEqual(arr.binarySearch(forValue: 4),  2...2)
		XCTAssertEqual(arr.binarySearch(forValue: 5),  2...3)
		XCTAssertEqual(arr.binarySearch(forValue: 6),  3...3)
		XCTAssertEqual(arr.binarySearch(forValue: 7),  4...4)
		XCTAssertEqual(arr.binarySearch(forValue: 8),  4...5)
		XCTAssertEqual(arr.binarySearch(forValue: 9),  5...5)
		XCTAssertEqual(arr.binarySearch(forValue: 10), 5...6)
		XCTAssertEqual(arr.binarySearch(forValue: 11), 6...6)
		XCTAssertEqual(arr.binarySearch(forValue: 12), 7...7)
		XCTAssertEqual(arr.binarySearch(forValue: 13), nil)
		
		// negative numbers, edge cases, etc.
		
		XCTAssertEqual([-4,-3,-2,3,4,6].binarySearch(forValue: -1), 2...3)
		XCTAssertEqual([-4,-3,-2,3,4,6].binarySearch(forValue: -4), 0...0)
		XCTAssertEqual([-4,-3,-2,3,4,6].binarySearch(forValue: 6), 5...5)
		
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
	
	/// Test harness enum
	enum fooEnum: Hashable, CustomStringConvertible {
		case foo(Int)							// each Int has a different hash
		case fooB(Int)							// identical hash regardless of Int
		case one
		case two
		case three
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(internalHash)
		}
		
		var internalHash: Int {
			switch self {
			case .foo(let val): return val << 5	// each Int has different hash
			case .fooB(_):		return 0b01000	// identical hash regardless of Int
			case .one:	 		return 0b00010
			case .two:	 		return 0b00100
			case .three: 		return 0b01000
			}
		}
		
		var description: String {
			switch self {
			case .foo(let val): return ".foo(\(val))"
			case .fooB(let val): return ".fooB(\(val))"
			case .one:	  return ".one"
			case .two:	  return ".two"
			case .three:  return ".three"
			}
		}
		
		static func ==(lhs: Self, rhs: Self) -> Bool {
			lhs.internalHash == rhs.internalHash
		}
	}
			
	func testArraySetFunctionality_Insert() {
		
		// .insert
		
		var arr = [1,2,3]
		
		arr.insert(1)
		XCTAssertEqual(arr, [1,2,3])
		
		arr.insert(4) // position: default
		XCTAssertEqual(arr, [1,2,3,4])
		
		arr.insert(5, position: .end)
		XCTAssertEqual(arr, [1,2,3,4,5])
		
		arr.insert(0, position: .start)
		XCTAssertEqual(arr, [0,1,2,3,4,5])
		
	}
	
	func testArraySetFunctionality_Update_UniqueAssociatedValues() {
		
		// .update
		
		var arr: [fooEnum] = [.foo(1), .foo(2), .foo(3)]
		
		arr.update(with: .foo(1))
		XCTAssertEqual(arr, [.foo(1), .foo(2), .foo(3)])
		
		arr.update(with: .foo(4))	// position: default
		XCTAssertEqual(arr, [.foo(1), .foo(2), .foo(3), .foo(4)])
		
		arr.update(with: .foo(5), position: .end)
		XCTAssertEqual(arr, [.foo(1), .foo(2), .foo(3), .foo(4), .foo(5)])
		
		arr.update(with: .foo(0), position: .start)
		XCTAssertEqual(arr, [.foo(0), .foo(1), .foo(2), .foo(3), .foo(4), .foo(5)])
		
		arr.update(with: .foo(3), position: .start)	// reorder existing
		XCTAssertEqual(arr, [.foo(3), .foo(0), .foo(1), .foo(2), .foo(4), .foo(5)])
		
		arr.update(with: .foo(3), position: .end)		// reorder existing
		XCTAssertEqual(arr, [.foo(0), .foo(1), .foo(2), .foo(4), .foo(5), .foo(3)])
		
	}
	
	func testArraySetFunctionality_Update_NonUniqueAssociatedValues() {

		// .update

		var arr: [fooEnum] = [.foo(1), .fooB(1), .one]

		arr.update(with: .fooB(1))
		XCTAssertEqual(arr, [.foo(1), .fooB(999), .one])	// can't use this to check associated value
		arr.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 1)		// check associated value here
			default: break
			}
		}
		
		arr.update(with: .fooB(4))	// position: default
		XCTAssertEqual(arr, [.foo(1), .fooB(999), .one])	// can't use this to check associated value
		arr.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 4)		// check associated value here
			default: break
			}
		}

		arr.update(with: .fooB(5), position: .end)
		XCTAssertEqual(arr, [.foo(1), .one, .fooB(999)])	// can't use this to check associated value
		arr.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 5)		// check associated value here
			default: break
			}
		}
		
		arr.update(with: .fooB(0), position: .start)
		XCTAssertEqual(arr, [.fooB(999), .foo(1), .one])	// can't use this to check associated value
		arr.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 0)		// check associated value here
			default: break
			}
		}
		
		arr.update(with: .fooB(3), position: .start)		// reorder existing
		XCTAssertEqual(arr, [.fooB(999), .foo(1), .one])	// can't use this to check associated value
		arr.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 3)		// check associated value here
			default: break
			}
		}
		
		arr.update(with: .fooB(3), position: .end)			// reorder existing
		XCTAssertEqual(arr, [.foo(1), .one, .fooB(999)])	// can't use this to check associated value
		arr.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 3)		// check associated value here
			default: break
			}
		}
		
	}
	
	func testArraySetFunctionality_RemoveAll() {
	
		// .removeAll
		
		var arr = [1,1,2,2,3,3]
		
		arr.removeAll(2)
		XCTAssertEqual(arr, [1,1,3,3])
		
	}
	
	func testArraySetFunctionality_Union() {
		
		// .union / .formUnion
		
		var arr1: [fooEnum] = []
		
		arr1 = [.foo(1), .one]
		var arr2 = arr1.union([.foo(2), .one, .two, .three])
		XCTAssertEqual(arr2, [.foo(1), .one, .foo(2), .two, .three])
		
		arr1 = [.foo(1), .one]
		arr1.formUnion([.foo(2), .one, .two, .three])
		XCTAssertEqual(arr1, [.foo(1), .one, .foo(2), .two, .three])
		
		arr1 = [.foo(1), .one]
		arr2 = arr1.union(updating: [.one, .two, .three, .foo(1)])
		XCTAssertEqual(arr2, [.foo(1), .one, .two, .three])
		
		arr1 = [.foo(1), .one]
		arr1.formUnion(updating: [.one, .two, .three, .foo(1)])
		XCTAssertEqual(arr1, [.foo(1), .one, .two, .three])
		
	}
	
	func testSetUnion() {
		
		// .unison
		
		var set: Set<fooEnum> = [.fooB(1), .one]
		
		let setA = set.union([.fooB(2), .two])
		XCTAssertEqual(setA, [.fooB(999), .one, .two])		// can't use this to check associated value
		setA.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 1)		// check associated value here
			default: break
			}
		}
		
		
		// .unison(updating:)
		
		let setB = set.union(updating: [.fooB(2), .two])
		XCTAssertEqual(setB, [.fooB(999), .one, .two])		// can't use this to check associated value
		setB.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 2)		// check associated value here
			default: break
			}
		}
		
		
		// .formUnison(updating:)
		
		set.formUnion(updating: [.fooB(2), .two])
		XCTAssertEqual(set, [.fooB(999), .one, .two])		// can't use this to check associated value
		set.forEach {
			switch $0 {
			case .fooB(let val): XCTAssertEqual(val, 2)		// check associated value here
			default: break
			}
		}
		
	}
	
}

#endif
