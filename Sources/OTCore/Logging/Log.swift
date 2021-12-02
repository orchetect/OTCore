//
//  Log.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// os.log does not rely on Foundation, but we need Foundation for file path string operations
#if canImport(Foundation)

import Foundation
import os.log

// -------------------------------------------------------------------------
// Suggestion:
// In your library/application that adopts OTCore, you can write your own centralized extension to store references to specific logs, if you require more than one.
//
//     @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
//     extension OSLog {
//         static let subsystem = "com.yourdomain.yourapp"
//
//         public static let general = OSLog(subsystem: subsystem, category: "General")
//         public static let log2 = OSLog(subsystem: subsystem, category: "Log2")
//         public static let log3 = OSLog(subsystem: subsystem, category: "Log3")
//     }
//
// Then you can log to it easily:
//
//     Log("test", log: .log2)
//
// ------------------------------------------------------------------------
// Suggestion:
// It's possible to emit emoji in log messages only for debug builds easily, to make errors stand out more.
//
//     let log = Logger()
//
//     #if RELEASE
//     log.useEmoji = .disabled
//     #else
//     log.useEmoji = .all
//     #endif
//
// ------------------------------------------------------------------------

// MARK: - Logger

/// **OTCore:**
/// Centralized logging via os_log.
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
open class Logger {
    
    /// **OTCore:**
    /// Set to `false` to suppress all logging.
    @inline(__always)
    public var enabled: Bool
    
    /// **OTCore:**
    /// Sets the default `OSLog` to use.
    @inline(__always)
    public var defaultLog: OSLog
    
    /// **OTCore:**
    /// Enables prefixing log message body text with emoji icons (ie: ⚠️ for `.error`).
    /// Individual emoji for each log level can be set using the `.level*Emoji` properties.
    @inline(__always)
    public var useEmoji: EmojiType
    
    /// **OTCore:**
    /// Set the emoji to prefix `.debug` level messages if `useEmoji == true`.
    @inline(__always)
    public var levelDebugEmoji: Character = "🔷"
    
    /// **OTCore:**
    /// Set the emoji to prefix `.info` level messages if `useEmoji == true`.
    @inline(__always)
    public var levelInfoEmoji: Character = "💬"
    
    /// **OTCore:**
    /// Set the emoji to prefix `.default` level messages if `useEmoji == true`.
    @inline(__always)
    public var levelDefaultEmoji: Character = "💬"
    
    /// **OTCore:**
    /// Set the emoji to prefix `.error` level messages if `useEmoji == true`.
    @inline(__always)
    public var levelErrorEmoji: Character = "⚠️"
    
    /// **OTCore:**
    /// Set the emoji to prefix `.fault` level messages if `useEmoji == true`.
    @inline(__always)
    public var levelFaultEmoji: Character = "🛑"
    
    /// **OTCore:**
    /// Initialize a new Logger instance.
    public init(enabled: Bool = true,
                defaultLog: OSLog = .default,
                useEmoji: EmojiType = .disabled) {
        
        self.enabled = enabled
        self.defaultLog = defaultLog
        self.useEmoji = useEmoji
        
    }
    
    
    // MARK: - Enums
    
    public enum EmojiType {
        
        case disabled
        case all
        case errorsOnly
        
    }
    
    
    // MARK: - Log methods
    
    /// **OTCore:**
    /// Log a debug message.
    /// Verbose file, line number, and function name will be included.
    ///
    /// - note: These messages are not posted to the log in a release build.
    ///
    /// - remark: OSLog Description: The lowest priority. Only captured in memory. Not stored on disk.
    @inline(__always)
    open func debug(_ items: Any?...,
                    log: OSLog? = nil,
                    file: String = #file,
                    function: String = #function) {
        
        #if RELEASE
        
        // do not post debug messages to the log in a Release build
        
        #else
        
        guard enabled else { return }
        
        autoreleasepool {
            
            let fileName = (file as NSString).lastPathComponent
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message = (useEmoji == .all ? "(levelDebugEmoji) " : "")
                + "\(content) (\(fileName):\(function))"
            
            os_log("%{public}@",
                   log: log ?? defaultLog,
                   type: .debug,
                   message)
            
        }
        
        #endif
        
    }
    
    /// **OTCore:**
    /// Log a message with default log type.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Purely informational in nature. Only captured in memory and not stored on disk unless otherwise specified. Eventually purged.
    @inline(__always)
    open func info(_ items: Any?...,
                   log: OSLog? = nil) {
        
        guard enabled else { return }
        
        autoreleasepool {
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (useEmoji == .all ? "\(levelInfoEmoji) " : "")
                + "\(content)"
            
            os_log("%{public}@",
                   log: log ?? defaultLog,
                   type: .info,
                   message)
            
        }
        
    }
    
    /// **OTCore:**
    /// Log a message with default log type.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Default behavior. Stored on disk. Eventually purged.
    @inline(__always)
    open func `default`(_ items: Any?...,
                        log: OSLog? = nil) {
        
        guard enabled else { return }
        
        autoreleasepool {
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (useEmoji == .all ? "\(levelDefaultEmoji) " : "")
                + "\(content)"
            
            os_log("%{public}@",
                   log: log ?? defaultLog,
                   type: .default,
                   message)
            
        }
        
    }
    
    /// **OTCore:**
    /// Log an error.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Something is amiss and might fail if not corrected. Always stored on disk. Eventually purged.
    @inline(__always)
    open func error(_ items: Any?...,
                    log: OSLog? = nil,
                    file: String = #file,
                    line: Int = #line,
                    column: Int = #column,
                    function: String = #function) {
        
        guard enabled else { return }
        
        autoreleasepool {
            
            let fileName = (file as NSString).lastPathComponent
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (useEmoji == .all || useEmoji == .errorsOnly ? "\(levelErrorEmoji) " : "")
                + "\(content) (\(fileName):\(line):\(column):\(function))"
            
            os_log("%{public}@",
                   log: log ?? defaultLog,
                   type: .error,
                   message)
            
        }
        
    }
    
    /// **OTCore:**
    /// Log an error.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Something has failed. Always stored on disk. Eventually purged.
    @inline(__always)
    open func fault(_ items: Any?...,
                    log: OSLog? = nil,
                    file: String = #file,
                    line: Int = #line,
                    column: Int = #column,
                    function: String = #function) {
        
        guard enabled else { return }
        
        autoreleasepool {
            
            let fileName = (file as NSString).lastPathComponent
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (useEmoji == .all || useEmoji == .errorsOnly ? "\(levelFaultEmoji) " : "")
                + "\(content) (\(fileName):\(line):\(column):\(function))"
            
            os_log("%{public}@",
                   log: log ?? defaultLog,
                   type: .fault,
                   message)
            
        }
        
    }
    
    /// **OTCore:**
    /// Log an error using the passed log message type.
    ///
    /// - note: Where possible, use direct `Logger` instance methods instead (ie: `.debug(...)`, `.error(...), etc.`), as it will typically be more performant.
    @inline(__always)
    open func log(_ items: Any?...,
                  level: OSLogType,
                  log: OSLog? = nil,
                  file: String = #file,
                  line: Int = #line,
                  column: Int = #column,
                  function: String = #function) {
        
        let log = log ?? defaultLog
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from `Any?...` to `[Any?]`
        // which produces undesirable results when passed into another
        // function which takes an `Any?...` parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        switch level {
        case .debug:
            debug(content,
                  log: log,
                  file: file,
                  function: function)
            
        case .info:
            info(content,
                 log: log)
            
        case .`default`:
            `default`(content,
                      log: log)
            
        case .error:
            error(content,
                  log: log,
                  file: file,
                  line: line,
                  column: column,
                  function: function)
            
        case .fault:
            fault(content,
                  log: log,
                  file: file,
                  line: line,
                  column: column,
                  function: function)
            
        default:
            break
            
        }
        
    }
    
}

#endif
