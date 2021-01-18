//
//  Collection Set-Like Methods Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Abstractions_CollectionSetLikeMethods_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
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
		
		// .union
		
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
		
		// .formUnion
		
		arr1 = [.foo(1), .one]
		arr1.formUnion(updating: [.one, .two, .three, .foo(1)])
		XCTAssertEqual(arr1, [.foo(1), .one, .two, .three])
		
	}
	
}

#endif
