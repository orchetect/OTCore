//
//  Optional Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-16.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

// testOptionalType() declares

fileprivate protocol testStructProtocol { }

fileprivate extension Collection where Element: OptionalType,
									   Element.Wrapped: testStructProtocol {
	
	var foo: Int { return 2 }
	
}

class Extensions_Swift_Optional_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testOptionalType() {
		
		// basic test
		
		let num: Int? = 1
		
		XCTAssertEqual(num.optional, Optional(1))
		
		// extension test
		
		struct testStruct<T: BinaryInteger>: testStructProtocol {
			var value: T
		}
		
		let arr: [testStruct<UInt8>?] = [testStruct(value: UInt8(1)), nil]
		
		XCTAssertEqual(arr.foo, 2)	// ensure the extension works
		
	}
	
	func testDefault() {
		
		let val1: Int? = 1
		
		XCTAssertEqual(val1.ifNil(2), 1)
		
		let val2: Int? = nil
		
		XCTAssertEqual(val2.ifNil(2), 2)
		
	}
	
}

#endif
