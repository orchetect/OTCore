//
//  Globals Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-12.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Global_Globals_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testBundle() {
		
		XCTAssertEqual(Globals.bundle.name, "xctest")
		
		XCTAssertEqual(Globals.bundle.bundleID, "com.apple.dt.xctest.tool")
		
		_ = Globals.bundle.versionShort // XCTest doesn't return a value
		
		XCTAssertEqual(Globals.bundle.versionMajor, 0) // XCTest doesn't return a value
		
		XCTAssertTrue(Globals.bundle.versionBuildNumber != "")
		
	}
	
	func testSystem() {
		
		// values cannot be tested explicitly since they vary by system
		
		XCTAssertTrue(Globals.system.name != "")
		
		#if os(macOS)
		XCTAssertNotNil(Globals.system.serialNumber)
		
		XCTAssertNotNil(Globals.system.hardwareUUID)
		#endif
		
	}
	
}

#endif
