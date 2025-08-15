//
//  OSLogger Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OSLog
import OTCore
import Testing
import TestingExtensions

// @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
@Suite struct Logging_Log_Tests {
    @Test
    func loggerObjects() {
        // this test does not assert anything, it's just to test access levels
        
        _ = [.message] as OSLogger.LogTemplate
        
        _ = OSLogger.Config()
        
        var config = OSLogger.Config(
            defaultLog: .default,
            defaultTemplate: .withEmoji()
        )
        config.defaultLog = .default
        
        _ = OSLogger.Config(
            defaultLog: .default,
            defaultTemplate: .default(),
            coerceInfoAndDebugToDefault: true,
            debug: nil,
            info: nil,
            default: nil,
            error: nil,
            fault: nil
        )
        
        _ = OSLogger.LogToken.function
        
        let logger = OSLogger {
            $0.coerceInfoAndDebugToDefault = true
        }
        #expect(logger.config.coerceInfoAndDebugToDefault == true)
        
        let logger2 = OSLogger(enabled: false)
            .configure {
                $0.coerceInfoAndDebugToDefault = true
            }
        #expect(logger2.config.coerceInfoAndDebugToDefault == true)
        
        _ = logger.enabled
    }
    
    /// This test is only useful with Thread Sanitizer on.
    @Test(.enabled(if: isSystemTimingStable()))
    func threading() async throws {
        let iterations = 2000
        
        actor Counter {
            var count = 0
            func inc() { count += 1 }
        }
        let counter = Counter()
        
        // log operations
        
        let logger = OSLogger { $0.coerceInfoAndDebugToDefault = false }
        
        for index in 0 ..< iterations {
            DispatchQueue.global().async { [counter] in
                logger.debug("Log thread 1 test # \(index)")
                
                // it's useful to note that os_log output to
                // Xcode's console when called rapidly
                // can sometimes produce jumbled messages
                // os_log("%{public}@",
                //       log: .default,
                //       type: .debug,
                //       "Log thread 1 test # \(index)")
                
                Task { await counter.inc() }
            }
            DispatchQueue.global().async {
                logger.debug("Log thread 2 test # \(index)")
                
                // it's useful to note that os_log output to
                // Xcode's console when called rapidly
                // can sometimes produce jumbled messages
                // os_log("%{public}@",
                //       log: .default,
                //       type: .debug,
                //       "Log thread 2 test # \(index)")
                
                Task { await counter.inc() }
            }
        }
        
        await wait(expect: { await counter.count == iterations * 2 }, timeout: 30.0)
    }
    
    @Test
    func logger() {
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default config, coerceInfoAndDebugToDefault:true ----------")
        
        let logger = OSLogger { $0.coerceInfoAndDebugToDefault = true }
        
        logger.debug("Test Log.debug()", 123)
        logger.info("Test Log.info()", 123)
        logger.default("Test Log.default()", 123)
        logger.error("Test Log.error()", 123)
        logger.fault("Test Log.fault()", 123)
        
        logger.log("Test Log.log(.debug)", 123, level: .debug)
        logger.log("Test Log.log(.info)", 123, level: .info)
        logger.log("Test Log.log(.default)", 123, level: .default)
        logger.log("Test Log.log(.error)", 123, level: .error)
        logger.log("Test Log.log(.fault)", 123, level: .fault)
        
        logger.debug(
            "Test Log.debug() in loggerTestLog",
            123,
            log: .loggerTestLog
        )
        logger.log(
            "Test Log.log(.debug) in loggerTestLog",
            123,
            level: .debug,
            log: .loggerTestLog
        )
        
        logger.error(
            "Test Log.error() in loggerTestLog",
            123,
            log: .loggerTestLog
        )
        logger.log(
            "Test Log.log(.error) in loggerTestLog",
            123,
            level: .error,
            log: .loggerTestLog
        )
    }
    
    @Test
    func logger_DefaultLog_NoEmojis() {
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, no emojis ----------")
        
        let logger = OSLogger()
        
        logger.debug("Test logger.debug()", 123)
        logger.info("Test logger.info()", 123)
        logger.default("Test logger.default()", 123)
        logger.error("Test logger.error()", 123)
        logger.fault("Test logger.fault()", 123)
    }
    
    @Test
    func logger_DefaultLog_OnlyErrorEmojis() {
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, only error emojis ----------")
        
        let logger = OSLogger {
            $0.defaultTemplate = .withEmoji()
            
            $0.levelDebug.emoji = nil
            $0.levelInfo.emoji = nil
            $0.levelDefault.emoji = nil
        }
        
        logger.debug("Test logger.debug()", 123)
        logger.info("Test logger.info()", 123)
        logger.default("Test logger.default()", 123)
        logger.error("Test logger.error()", 123)
        logger.fault("Test logger.fault()", 123)
    }
    
    @Test
    func logger_DefaultLog_AllEmojis() {
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- default log, all emojis ----------")
        
        let logger = OSLogger { $0.defaultTemplate = .withEmoji() }
        
        logger.debug("Test logger.debug()", 123)
        logger.info("Test logger.info()", 123)
        logger.default("Test logger.default()", 123)
        logger.error("Test logger.error()", 123)
        logger.fault("Test logger.fault()", 123)
    }
    
    @Test
    func logger_CustomLog_AllEmojis() {
        // this test does not assert anything, it's just for diagnostic
        
        print("---------- custom log, all emojis ----------")
        
        let logger = OSLogger {
            $0.defaultLog = .loggerTestLog // custom log
            $0.defaultTemplate = .withEmoji()
        }
        
        logger.debug("Test logger.debug()", 123)
        logger.info("Test logger.info()", 123)
        logger.default("Test logger.default()", 123)
        logger.error("Test logger.error()", 123)
        logger.fault("Test logger.fault()", 123)
    }
    
    @Test
    func logger_LogMethod() {
        // this test does not assert anything, it's just for diagnostic
        
        // default log
        
        print("---------- default log, .log(), all emojis ----------")
        
        let logger = OSLogger { $0.defaultTemplate = .withEmoji() }
        
        logger.log("Test logger.log(... , level: .debug)", 123, level: .debug)
        logger.log("Test logger.log(... , level: .info)", 123, level: .info)
        logger.log("Test logger.log(... , level: .default)", 123, level: .default)
        logger.log("Test logger.log(... , level: .error)", 123, level: .error)
        logger.log("Test logger.log(... , level: .fault)", 123, level: .fault)
    }
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension OSLog {
    fileprivate static let loggerTestLog = OSLog(
        subsystem: "com.orchetect.otcore.logtest",
        category: "General"
    )
}
