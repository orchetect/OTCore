//
//  Pasteboard Tests.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-17.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

// no meaningful tests can be devised here

#if os(macOS)

import XCTest
@testable import OTCore

class Extensions_AppKit_Pasteboard_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testFileURLBackCompat() {
		
		// no meaningful tests can be devised here
		
		_ = NSPasteboard.PasteboardType.fileURLBackCompat
		
	}
	
}

#endif
