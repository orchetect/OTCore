//
//  NSArray Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_NSArray_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
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
	
}

#endif
