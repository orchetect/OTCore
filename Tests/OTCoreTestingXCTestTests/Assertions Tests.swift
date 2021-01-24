//
//  OTCoreTestingTests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-23.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCoreTestingXCTest

class Assertions_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testAssert() {
		
		expectAssert {
			assert(1 == 2)
		}
		
	}
	
	func testAssertionFailure() {
		
		expectAssertionFailure {
			assertionFailure("Test assertionFailure")
		}
		
	}
	
	func testPrecondition() {
		
		expectPrecondition {
			precondition(false)
		}
		
	}
	
	func testPreconditionFailure() {
		
		expectPreconditionFailure {
			preconditionFailure("Test preconditionFailure")
		}
		
	}
	
	func testFatalError() {
		
		expectFatalError {
			fatalError("Test fatalError")
		}
		
	}
	
}

#endif
