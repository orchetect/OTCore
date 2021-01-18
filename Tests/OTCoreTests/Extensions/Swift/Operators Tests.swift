//
//  Operators Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-16.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_Operators_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testModulo() {
		
		// Double, Float, Float80
		
		XCTAssertEqual(        43.0  % 10.0, 3.0)
		XCTAssertEqual(  Float(43.0) % 10.0, 3.0)
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		XCTAssertEqual(Float80(43.0) % 10.0, 3.0)
		#endif
		
		// CGFloat
		
		// % is built-in for CGFloat:
		 _ = (43.0 as CGFloat) % 10.0
		
		// Decimal
		
		//_ = (43.0 as Decimal) % (10.0 as Decimal)					// doesn't work
		//_ = (43.0 as NSDecimalNumber) % (10.0 as NSDecimalNumber)	// doesn't work
		
		// .truncatingRemainder(dividingBy:) and fmod() are not usable with Decimal
		
	}
	
}

#endif
