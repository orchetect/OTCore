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
    
    func testLoggerObjects() {
        
        // this test does not assert anything, it's just to test access levels
        
        _ = [.message] as OSLogger.LogTemplate
        
        _ = OSLogger.Config()
        
        var config = OSLogger.Config(defaultLog: .default,
                                     defaultTemplate: .withEmoji())
        config.defaultLog = .default
        
        _ = OSLogger.Config(defaultLog: .default,
                            defaultTemplate: .default(),
                            coerceInfoAndDebugToDefault: true,
                            debug: nil,
                            info: nil,
                            default: nil,
                            error: nil,
                            fault: nil)
        
        _ = OSLogger.LogToken.function
        
        let logger = OSLogger {
            $0.coerceInfoAndDebugToDefault = true
        }
        logger.enabled = true
        
    }
    
    /// This test is only useful with Thread Sanitizer on.
    func testThreading() {
        
        let completionTimeout = expectation(description: "Test Completion Timeout")
        
        let group1 = DispatchGroup()
        let group2 = DispatchGroup()
        
        let iterations = 2000
        
        // log operations
        
        let logger = OSLogger { $0.coerceInfoAndDebugToDefault = false }
        
        for index in 0..<iterations {
            group1.enter()
            DispatchQueue.global().async {
                logger.debug("Log thread 1 test # \(index)")
                
                // it's useful to note that os_log output to
                // Xcode's console when called rapidly
                // can sometimes produce jumbled messages
                //os_log("%{public}@",
                //       log: .default,
                //       type: .debug,
                //       "Log thread 1 test # \(index)")
                
                group1.leave()
            }
            group2.enter()
            DispatchQueue.global().async {
                logger.debug("Log thread 2 test # \(index)")
                
                // it's useful to note that os_log output to
                // Xcode's console when called rapidly
                // can sometimes produce jumbled messages
                //os_log("%{public}@",
                //       log: .default,
                //       type: .debug,
                //       "Log thread 2 test # \(index)")
                
                group2.leave()
            }
        }
        
        DispatchQueue.global().async {
            group1.wait()
            group2.wait()
            completionTimeout.fulfill()
        }
        
        wait(for: [completionTimeout], timeout: 10)
        
    }
    
    func testLogger() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default config, coerceInfoAndDebugToDefault:true ----------")
        
        let logger = OSLogger { $0.coerceInfoAndDebugToDefault = true }
        
        logger.debug  ("Test Log.debug()"  , 123)
        logger.info   ("Test Log.info()"   , 123)
        logger.default("Test Log.default()", 123)
        logger.error  ("Test Log.error()"  , 123)
        logger.fault  ("Test Log.fault()"  , 123)
        
        logger.log    ("Test Log.log(.debug)"   , 123, level: .debug)
        logger.log    ("Test Log.log(.info)"    , 123, level: .info)
        logger.log    ("Test Log.log(.default)" , 123, level: .default)
        logger.log    ("Test Log.log(.error)"   , 123, level: .error)
        logger.log    ("Test Log.log(.fault)"   , 123, level: .fault)
        
        logger.debug  ("Test Log.debug() in loggerTestLog", 123,
                       log: .loggerTestLog)
        logger.log    ("Test Log.log(.debug) in loggerTestLog", 123,
                       level: .debug, log: .loggerTestLog)
        
        logger.error  ("Test Log.error() in loggerTestLog", 123,
                       log: .loggerTestLog)
        logger.log    ("Test Log.log(.error) in loggerTestLog", 123,
                       level: .error, log: .loggerTestLog)
    }
    
    func testLogger_DefaultLog_NoEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, no emojis ----------")
        
        let logger = OSLogger()
        
        logger.debug  ("Test logger.debug()"  , 123)
        logger.info   ("Test logger.info()"   , 123)
        logger.default("Test logger.default()", 123)
        logger.error  ("Test logger.error()"  , 123)
        logger.fault  ("Test logger.fault()"  , 123)
        
    }
    
    func testLogger_DefaultLog_OnlyErrorEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, only error emojis ----------")
        
        let logger = OSLogger {
            $0.defaultTemplate = .withEmoji()
            
            $0.levelDebug.emoji = nil
            $0.levelInfo.emoji = nil
            $0.levelDefault.emoji = nil
        }
        
        logger.debug  ("Test logger.debug()"  , 123)
        logger.info   ("Test logger.info()"   , 123)
        logger.default("Test logger.default()", 123)
        logger.error  ("Test logger.error()"  , 123)
        logger.fault  ("Test logger.fault()"  , 123)
        
    }
    
    func testLogger_DefaultLog_AllEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, all emojis ----------")
        
        let logger = OSLogger { $0.defaultTemplate = .withEmoji() }
        
        logger.debug  ("Test logger.debug()"  , 123)
        logger.info   ("Test logger.info()"   , 123)
        logger.default("Test logger.default()", 123)
        logger.error  ("Test logger.error()"  , 123)
        logger.fault  ("Test logger.fault()"  , 123)
        
    }
    
    func testLogger_CustomLog_AllEmojis() {
        
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- custom log, all emojis ----------")
        
        let logger = OSLogger {
            $0.defaultLog = .loggerTestLog // custom log
            $0.defaultTemplate = .withEmoji()
        }
        
        logger.debug  ("Test logger.debug()"  , 123)
        logger.info   ("Test logger.info()"   , 123)
        logger.default("Test logger.default()", 123)
        logger.error  ("Test logger.error()"  , 123)
        logger.fault  ("Test logger.fault()"  , 123)
        
    }
    
    func testLogger_LogMethod() {
        
        // this test does not assert anything, it's just for diagnostic
        
        // default log
        
        print("---------- default log, .log(), all emojis ----------")
        
        let logger = OSLogger { $0.defaultTemplate = .withEmoji() }
        
        logger.log("Test logger.log(... , level: .debug)"  , 123, level: .debug)
        logger.log("Test logger.log(... , level: .info)"   , 123, level: .info)
        logger.log("Test logger.log(... , level: .default)", 123, level: .default)
        logger.log("Test logger.log(... , level: .error)"  , 123, level: .error)
        logger.log("Test logger.log(... , level: .fault)"  , 123, level: .fault)
        
    }
    
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate extension OSLog {
    
    static let loggerTestLog = OSLog(subsystem: "com.orchetect.otcore.logtest",
                                     category: "General")
    
}

#endif
