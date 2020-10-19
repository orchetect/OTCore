//
//  Result Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-05-26.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Result_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testResult() {
		
		enum PasswordError: Error {
			case short
			case obvious
			case simple
		}
		
		func doStuff(_ trigger: Bool) -> Result<String, PasswordError> {
			return trigger ? .success("we succeeded") : .failure(.short)
		}
		
		XCTAssertEqual(doStuff(true).successValue, "we succeeded")
		
	}
	
}

#endif
