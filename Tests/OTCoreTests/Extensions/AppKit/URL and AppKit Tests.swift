//
//  URL and AppKit Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-12-11.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if os(macOS)

import XCTest
@testable import OTCore
import AppKit

class Extensions_AppKit_URLAndAppKit_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testURLIcon() {
		
		// on most, if not all, systems this should produce a value
		
		let url = URL(fileURLWithPath: "/")
		let fileIcon = url.icon
		XCTAssertNotNil(fileIcon)
		
	}
	
}

#endif
