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
//     #if RELEASE
//     Log.useEmoji = .disabled
//     #else
//     Log.useEmoji = .all
//     #endif
//
// ------------------------------------------------------------------------


// MARK: - Internal property storage

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var _otCoreLogEnabled = true

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var _otCoreDefaultLog = OSLog.default

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var _otCoreDefaultSubsystem: String? = nil

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var _otCoreUseEmoji: Log.EmojiType = .disabled


// MARK: - Log

/// **OTCore:**
/// Centralized logging via os_log
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public enum Log {
    
    /// **OTCore:**
    /// Set to false to suppress logging
    public static var enabled: Bool {
        get { _otCoreLogEnabled }
        set { _otCoreLogEnabled = newValue }
    }
    
    /// **OTCore:**
    /// Sets the default OSLog to use
    public static var defaultLog: OSLog {
        get { _otCoreDefaultLog }
        set { _otCoreDefaultLog = newValue }
    }
    
    /// **OTCore:**
    /// Sets the default OSLog subsystem to use
    public static var defaultSubsystem: String? {
        get { _otCoreDefaultSubsystem }
        set { _otCoreDefaultSubsystem = newValue }
    }
    
    /// **OTCore:**
    /// Enables prefixing log messages with emoji icons (ie: ⚠️ for .error)
    public static var useEmoji: EmojiType {
        get { _otCoreUseEmoji }
        set { _otCoreUseEmoji = newValue }
    }
    
    /// **OTCore:**
    /// Sets up all Log properties at once
    public static func setup(enabled: Bool = true,
                             defaultLog: OSLog? = nil,
                             defaultSubsystem: String? = nil,
                             useEmoji: EmojiType? = nil) {
        
        _otCoreLogEnabled = enabled
        _otCoreDefaultLog = defaultLog ?? .default
        _otCoreDefaultSubsystem = defaultSubsystem
        _otCoreUseEmoji = useEmoji ?? .disabled
        
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
    /// - note: These messages are not posted to the log in a release build.
    /// - remark: OSLog Description: The lowest priority. Only captured in memory. Not stored on disk.
    @inline(__always)
    public static func debug(_ items: Any?...,
                             log: OSLog? = nil,
                             file: String = #file,
                             function: String = #function) {
        
        #if RELEASE
        
        // do not post debug messages to the log in a Release build
        
        #else
        
        guard _otCoreLogEnabled else { return }
        
        autoreleasepool {
            
            let fileName = (file as NSString).lastPathComponent
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message = (_otCoreUseEmoji == .all ? "🔷 " : "")
                + "\(content) (\(fileName):\(function))"
            
            os_log("%{public}@",
                   log: log ?? _otCoreDefaultLog,
                   type: .debug,
                   message)
            
        }
        
        #endif
        
    }
    
    /// **OTCore:**
    /// Log a message with default log type.
    /// Appears in both release and debug builds.
    /// - remark: OSLog Description: Purely informational in nature. Only captured in memory and not stored on disk unless otherwise specified. Eventually purged.
    @inline(__always)
    public static func info(_ items: Any?...,
                            log: OSLog? = nil) {
        
        guard _otCoreLogEnabled else { return }
        
        autoreleasepool {
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (_otCoreUseEmoji == .all ? "💬 " : "")
                + "\(content)"
            
            os_log("%{public}@",
                   log: log ?? _otCoreDefaultLog,
                   type: .info,
                   message)
            
        }
        
    }
    
    /// **OTCore:**
    /// Log a message with default log type.
    /// Appears in both release and debug builds.
    /// - remark: OSLog Description: Default behavior. Stored on disk. Eventually purged.
    @inline(__always)
    public static func `default`(_ items: Any?...,
                                 log: OSLog? = nil) {
        
        guard _otCoreLogEnabled else { return }
        
        autoreleasepool {
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (_otCoreUseEmoji == .all ? "💬 " : "")
                + "\(content)"
            
            os_log("%{public}@",
                   log: log ?? _otCoreDefaultLog,
                   type: .default,
                   message)
            
        }
        
    }
    
    /// **OTCore:**
    /// Log an error.
    /// Appears in both release and debug builds.
    /// - remark: OSLog Description: Something is amiss and might fail if not corrected. Always stored on disk. Eventually purged.
    @inline(__always)
    public static func error(_ items: Any?...,
                             log: OSLog? = nil,
                             file: String = #file,
                             line: Int = #line,
                             column: Int = #column,
                             function: String = #function) {
        
        guard _otCoreLogEnabled else { return }
        
        autoreleasepool {
            
            let fileName = (file as NSString).lastPathComponent
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (_otCoreUseEmoji == .all || _otCoreUseEmoji == .errorsOnly ? "⚠️ " : "")
                + "\(content) (\(fileName):\(line):\(column):\(function))"
            
            os_log("%{public}@",
                   log: log ?? _otCoreDefaultLog,
                   type: .error,
                   message)
            
        }
        
    }
    
    /// **OTCore:**
    /// Log an error.
    /// Appears in both release and debug builds.
    /// - remark: OSLog Description: Something has failed. Always stored on disk. Eventually purged.
    @inline(__always)
    public static func fault(_ items: Any?...,
                             log: OSLog? = nil,
                             file: String = #file,
                             line: Int = #line,
                             column: Int = #column,
                             function: String = #function) {
        
        guard _otCoreLogEnabled else { return }
        
        autoreleasepool {
            
            let fileName = (file as NSString).lastPathComponent
            
            let content = items
                .map { String(describing: $0 ?? "nil") }
                .joined(separator: " ")
            
            let message =
                (_otCoreUseEmoji == .all || _otCoreUseEmoji == .errorsOnly ? "🛑 " : "")
                + "\(content) (\(fileName):\(line):\(column):\(function))"
            
            os_log("%{public}@",
                   log: log ?? _otCoreDefaultLog,
                   type: .fault,
                   message)
            
        }
        
    }
    
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension OSLogType {
    
    /// **OTCore:**
    /// Log an error using the `self` log message type.
    ///
    /// - note: Where possible, use the `Log.*` methods instead (ie: `Log.debug()`, `Log.error()`, etc.)
    @inline(__always)
    public func log(_ items: Any?...,
                    log: OSLog? = nil,
                    file: String = #file,
                    line: Int = #line,
                    column: Int = #column,
                    function: String = #function) {
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from Any?... to [Any?]
        // which produces undesirable results when passed into another
        // function which takes an Any?... parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        switch self {
        case .debug:
            Log.debug(content,
                      log: log,
                      file: file,
                      function: function)
            
        case .info:
            Log.info(content,
                     log: log)
            
        case .default:
            Log.default(content,
                        log: log)
            
        case .error:
            Log.error(content,
                      log: log,
                      file: file,
                      line: line,
                      column: column,
                      function: function)
            
        case .fault:
            Log.fault(content,
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
