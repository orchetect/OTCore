//
//  CGFloat Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_CoreGraphics_CGFloat_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testTypeConversions_BinaryIntegerToCGFloat() {
		
		_ = Int(1).cgFloat
		_ = Int(1).cgFloatExactly
		_ = UInt(1).cgFloat
		_ = UInt(1).cgFloatExactly
		
		_ = Int8(1).cgFloat
		_ = Int8(1).cgFloatExactly
		_ = UInt8(1).cgFloat
		_ = UInt8(1).cgFloatExactly
		
		_ = Int16(1).cgFloat
		_ = Int16(1).cgFloatExactly
		_ = UInt16(1).cgFloat
		_ = UInt16(1).cgFloatExactly
		
		_ = Int32(1).cgFloat
		_ = Int32(1).cgFloatExactly
		_ = UInt32(1).cgFloat
		_ = UInt32(1).cgFloatExactly
		
		_ = Int64(1).cgFloat
		_ = Int64(1).cgFloatExactly
		_ = UInt64(1).cgFloat
		_ = UInt64(1).cgFloatExactly
		
		_ = Double(123.456).cgFloat
		_ = Double(123.456).cgFloatExactly
		
		_ = Float(123.456).cgFloat
		_ = Float(123.456).cgFloatExactly
		
		_ = Float32(123.456).cgFloat
		_ = Float32(123.456).cgFloatExactly
		
		#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
		_ = Float80(123.456).cgFloat
		_ = Float80(123.456).cgFloatExactly
		#endif
		
	}
	
	func testPower() {
		
		XCTAssertEqual(CGFloat(2.0).power(3), 8.0)
		
	}
	
	// StringProtocol.cgFloat is tested in "FloatingPoint Tests.swift"
	
}

#endif
