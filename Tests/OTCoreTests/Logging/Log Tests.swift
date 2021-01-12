//
//  File.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-12.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OTCore
import OSLog

class Logging_Log_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testLog() {
		
		// this test does not assert anything, it's just for diagnostic
		
		// default log
		
		Log.setup(enabled: true,
				  defaultLog: nil,
				  defaultSubsystem: "com.orchetect.otcore.logtest",
				  useEmoji: .disabled)
		
		Log.debug("Test log: debug", 123)
		Log.info("Test log: info", 123)
		Log.default("Test log: default", 123)
		Log.error("Test log: error", 123)
		Log.fault("Test log: fault", 123)
		
		// default log
		
		Log.setup(enabled: true,
				  defaultLog: nil,
				  defaultSubsystem: "com.orchetect.otcore.logtest",
				  useEmoji: .all)
		
		Log.debug("Test log: debug", 123)
		Log.info("Test log: info", 123)
		Log.default("Test log: default", 123)
		Log.error("Test log: error", 123)
		Log.fault("Test log: fault", 123)
		
		// custom log
		
		Log.setup(enabled: true,
				  defaultLog: .custom,
				  defaultSubsystem: "com.orchetect.otcore.logtest",
				  useEmoji: .all)
		
		Log.debug("Test log: debug", 123)
		Log.info("Test log: info", 123)
		Log.default("Test log: default", 123)
		Log.error("Test log: error", 123)
		Log.fault("Test log: fault", 123)
		
	}
	
}

fileprivate extension OSLog {
	static let custom = OSLog(subsystem: "com.orchetect.otcore.logtest",
							  category: "General")
}

#endif
