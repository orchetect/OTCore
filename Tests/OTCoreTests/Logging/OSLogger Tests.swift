//
//  OSLogger Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
import OTCore
import OSLog

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
class Logging_Log_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testLogger_DefaultLog_NoEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, no emojis ----------")
        
        let logger = OSLogger(enabled: true,
                              useEmoji: .disabled)
        
        logger.debug  ("Test log.debug()"  , 123)
        logger.info   ("Test log.info()"   , 123)
        logger.default("Test log.default()", 123)
        logger.error  ("Test log.error()"  , 123)
        logger.fault  ("Test log.fault()"  , 123)
        
    }
    
    func testLogger_DefaultLog_OnlyErrorEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, only error emojis ----------")
        
        let logger = OSLogger(enabled: true,
                              useEmoji: .errorsOnly)
        
        logger.debug  ("Test log.debug()"  , 123)
        logger.info   ("Test log.info()"   , 123)
        logger.default("Test log.default()", 123)
        logger.error  ("Test log.error()"  , 123)
        logger.fault  ("Test log.fault()"  , 123)
        
    }
    
    func testLogger_DefaultLog_AllEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, all emojis ----------")
        
        let logger = OSLogger(enabled: true,
                              useEmoji: .all)
        
        logger.debug  ("Test log.debug()"  , 123)
        logger.info   ("Test log.info()"   , 123)
        logger.default("Test log.default()", 123)
        logger.error  ("Test log.error()"  , 123)
        logger.fault  ("Test log.fault()"  , 123)
        
    }
    
    func testLogger_CustomLog_AllEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- custom log, all emojis ----------")
        
        let logger = OSLogger(enabled: true,
                              defaultLog: .loggerTestLog, // <-- custom log
                              useEmoji: .all)
        
        logger.debug  ("Test log.debug()"  , 123)
        logger.info   ("Test log.info()"   , 123)
        logger.default("Test log.default()", 123)
        logger.error  ("Test log.error()"  , 123)
        logger.fault  ("Test log.fault()"  , 123)
        
    }
    
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testLogger_LogMethod() {
        
        // this test does not assert anything, it's just for diagnostic
        
        // default log
        
        print("---------- default log, OSLogType.x.log(), all emojis ----------")
        
        let logger = OSLogger(enabled: true,
                              useEmoji: .all)
        
        logger.log("Test log(... , level: .debug)"  , 123, level: .debug)
        logger.log("Test log(... , level: .info)"   , 123, level: .info)
        logger.log("Test log(... , level: .default)", 123, level: .default)
        logger.log("Test log(... , level: .error)"  , 123, level: .error)
        logger.log("Test log(... , level: .fault)"  , 123, level: .fault)
        
    }
    
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate extension OSLog {
    
    static let loggerTestLog = OSLog(subsystem: "com.orchetect.otcore.logtest",
                                     category: "General")
    
}

#endif
