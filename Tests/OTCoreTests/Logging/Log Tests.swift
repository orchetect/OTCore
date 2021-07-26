//
//  Log Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore
import OSLog

class Logging_Log_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testLog() {
        
        // this test does not assert anything, it's just for diagnostic
        
        // default log
        
        print("---------- default log, no emojis ----------")
        
        Log.setup(enabled: true,
                  defaultLog: nil,
                  defaultSubsystem: "com.orchetect.otcore.logtest",
                  useEmoji: .disabled)
        
        Log.debug  ("Test log.debug()"  , 123)
        Log.info   ("Test log.info()"   , 123)
        Log.default("Test log.default()", 123)
        Log.error  ("Test log.error()"  , 123)
        Log.fault  ("Test log.fault()"  , 123)
        
        // default log
        
        print("---------- default log, only error emojis ----------")
        
        Log.setup(enabled: true,
                  defaultLog: nil,
                  defaultSubsystem: "com.orchetect.otcore.logtest",
                  useEmoji: .errorsOnly)
        
        Log.debug  ("Test log.debug()"  , 123)
        Log.info   ("Test log.info()"   , 123)
        Log.default("Test log.default()", 123)
        Log.error  ("Test log.error()"  , 123)
        Log.fault  ("Test log.fault()"  , 123)
        
        // default log
        
        print("---------- default log, all emojis ----------")
        
        Log.setup(enabled: true,
                  defaultLog: nil,
                  defaultSubsystem: "com.orchetect.otcore.logtest",
                  useEmoji: .all)
        
        Log.debug  ("Test log.debug()"  , 123)
        Log.info   ("Test log.info()"   , 123)
        Log.default("Test log.default()", 123)
        Log.error  ("Test log.error()"  , 123)
        Log.fault  ("Test log.fault()"  , 123)
        
        // custom log
        
        print("---------- custom log, all emojis ----------")
        
        Log.setup(enabled: true,
                  defaultLog: .custom, // <-- custom log
                  defaultSubsystem: "com.orchetect.otcore.logtest",
                  useEmoji: .all)
        
        Log.debug  ("Test log.debug()"  , 123)
        Log.info   ("Test log.info()"   , 123)
        Log.default("Test log.default()", 123)
        Log.error  ("Test log.error()"  , 123)
        Log.fault  ("Test log.fault()"  , 123)
        
    }
    
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testOSLogType_Log() {
        
        // default log
        
        print("---------- default log, OSLogType.x.log(), all emojis ----------")
        
        Log.setup(enabled: true,
                  defaultLog: nil,
                  defaultSubsystem: "com.orchetect.otcore.logtest",
                  useEmoji: .all)
        
        OSLogType.debug  .log("Test log.debug()"  , 123)
        OSLogType.info   .log("Test log.info()"   , 123)
        OSLogType.default.log("Test log.default()", 123)
        OSLogType.error  .log("Test log.error()"  , 123)
        OSLogType.fault  .log("Test log.fault()"  , 123)
        
    }
    
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate extension OSLog {
    
    static let custom = OSLog(subsystem: "com.orchetect.otcore.logtest",
                              category: "General")
    
}

#endif
