//
//  OSLogger.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
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
//     logger.debug("test", log: .log2)
//
// ------------------------------------------------------------------------

// MARK: - OSLogger

/// **OTCore:**
/// Centralized logging via os_log.
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public final class OSLogger: Sendable {
    /// **OTCore:**
    /// Set to `false` to suppress all logging.
    @inline(__always)
    public let enabled: Bool
    
    @inline(__always)
    public let config: Config
    
    /// **OTCore:**
    /// Initialize a new `OSLogger` instance.
    public init(
        enabled: Bool = true,
        config: Config = .init()
    ) {
        self.enabled = enabled
        self.config = config
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
    public func debug(
        _ items: Any?...,
        log: OSLog? = nil,
        template: LogTemplate? = nil,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        #if DEBUG
        
        guard enabled else { return }
        
        // if log is nil, use log for level ignoring coerceInfoAndDebugToDefault
        let log = log ?? config.log(for: .debug)
        
        let level: OSLogType = config.coerceInfoAndDebugToDefault
            ? .default
            : .debug
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from `Any?...` to `[Any?]`
        // which produces undesirable results when passed into another
        // function which takes an `Any?...` parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        autoreleasepool {
            let message = assembleMessage(
                template: template,
                flatItems: content,
                level: level,
                file: file,
                line: line,
                column: column,
                function: function
            )
            
            os_log(
                "%{public}@",
                log: log,
                type: level,
                message
            )
        }
        
        #endif
    }
    
    /// **OTCore:**
    /// Log a message with default log type.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Purely informational in nature. Only captured in memory and not stored on disk unless otherwise specified. Eventually purged.
    @inline(__always)
    public func info(
        _ items: Any?...,
        log: OSLog? = nil,
        template: LogTemplate? = nil,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        guard enabled else { return }
        
        // if log is nil, use log for level ignoring coerceInfoAndDebugToDefault
        let log = log ?? config.log(for: .info)
        
        let level: OSLogType = config.coerceInfoAndDebugToDefault
            ? .default
            : .info
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from `Any?...` to `[Any?]`
        // which produces undesirable results when passed into another
        // function which takes an `Any?...` parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        autoreleasepool {
            let message = assembleMessage(
                template: template,
                flatItems: content,
                level: level,
                file: file,
                line: line,
                column: column,
                function: function
            )
            
            os_log(
                "%{public}@",
                log: log,
                type: level,
                message
            )
        }
    }
    
    /// **OTCore:**
    /// Log a message with default log type.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Default behavior. Stored on disk. Eventually purged.
    @inline(__always)
    public func `default`(
        _ items: Any?...,
        log: OSLog? = nil,
        template: LogTemplate? = nil,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        guard enabled else { return }
        
        // if log is nil, use log for level ignoring coerceInfoAndDebugToDefault
        let log = log ?? config.log(for: .default)
        
        let level: OSLogType = .default
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from `Any?...` to `[Any?]`
        // which produces undesirable results when passed into another
        // function which takes an `Any?...` parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        autoreleasepool {
            let message = assembleMessage(
                template: template,
                flatItems: content,
                level: level,
                file: file,
                line: line,
                column: column,
                function: function
            )
            
            os_log(
                "%{public}@",
                log: log,
                type: level,
                message
            )
        }
    }
    
    /// **OTCore:**
    /// Log an error.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Something is amiss and might fail if not corrected. Always stored on disk. Eventually purged.
    @inline(__always)
    public func error(
        _ items: Any?...,
        log: OSLog? = nil,
        template: LogTemplate? = nil,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        guard enabled else { return }
        
        // if log is nil, use log for level ignoring coerceInfoAndDebugToDefault
        let log = log ?? config.log(for: .error)
        
        let level: OSLogType = .error
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from `Any?...` to `[Any?]`
        // which produces undesirable results when passed into another
        // function which takes an `Any?...` parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        autoreleasepool {
            let message = assembleMessage(
                template: template,
                flatItems: content,
                level: level,
                file: file,
                line: line,
                column: column,
                function: function
            )
            
            os_log(
                "%{public}@",
                log: log,
                type: level,
                message
            )
        }
    }
    
    /// **OTCore:**
    /// Log an error.
    /// Appears in both release and debug builds.
    ///
    /// - remark: OSLog Description: Something has failed. Always stored on disk. Eventually purged.
    @inline(__always)
    public func fault(
        _ items: Any?...,
        log: OSLog? = nil,
        template: LogTemplate? = nil,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        guard enabled else { return }
        
        // if log is nil, use log for level ignoring coerceInfoAndDebugToDefault
        let log = log ?? config.log(for: .fault)
        
        let level: OSLogType = .fault
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from `Any?...` to `[Any?]`
        // which produces undesirable results when passed into another
        // function which takes an `Any?...` parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        autoreleasepool {
            let message = assembleMessage(
                template: template,
                flatItems: content,
                level: level,
                file: file,
                line: line,
                column: column,
                function: function
            )
            
            os_log(
                "%{public}@",
                log: log,
                type: level,
                message
            )
        }
    }
    
    /// **OTCore:**
    /// Log an error using the passed log message type.
    @inline(__always)
    public func log(
        _ items: Any?...,
        level: OSLogType,
        log: OSLog? = nil,
        template: LogTemplate? = nil,
        file: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        #if !DEBUG
        // do not post debug messages to the log in a non-Debug build
        if level == .debug { return }
        #endif
        
        guard enabled else { return }
        
        // if log is nil, use log for level ignoring coerceInfoAndDebugToDefault
        let log = log ?? config.log(for: level)
        
        let level = (
            (level == .debug || level == .info)
                && config.coerceInfoAndDebugToDefault
        )
            ? .default
            : level
        
        // we have to flatten the items here,
        // otherwise it gets internally converted from `Any?...` to `[Any?]`
        // which produces undesirable results when passed into another
        // function which takes an `Any?...` parameter
        
        let content = items
            .map { String(describing: $0 ?? "nil") }
            .joined(separator: " ")
        
        autoreleasepool {
            let message = assembleMessage(
                template: template,
                flatItems: content,
                level: level,
                file: file,
                line: line,
                column: column,
                function: function
            )
            
            os_log(
                "%{public}@",
                log: log,
                type: level,
                message
            )
        }
    }
    
    /// Internal util.
    @inline(__always)
    private func assembleMessage(
        template: LogTemplate?,
        flatItems: String,
        level: OSLogType,
        file: String,
        line: Int,
        column: Int,
        function: String
    ) -> String {
        let template = template ?? config.defaultTemplate
        
        return template.compactMap { token in
            switch token {
            case .message:
                return flatItems
                
            case let .emoji(padding):
                switch level {
                case .debug:   return parseOptional(config.levelDebug.emoji, padding)
                case .info:    return parseOptional(config.levelInfo.emoji, padding)
                case .default: return parseOptional(config.levelDefault.emoji, padding)
                case .error:   return parseOptional(config.levelError.emoji, padding)
                case .fault:   return parseOptional(config.levelFault.emoji, padding)
                default:       return nil
                }
                
            case .file:
                return (file as NSString).lastPathComponent
                
            case .function:
                return function
                
            case .line:
                return "\(line)"
                
            case .column:
                return "\(column)"
                
            case .space:
                return " "
                
            case let .string(str):
                return str
            }
        }
        .joined()
    }
    
    /// Internal util.
    @inline(__always)
    private func parseOptional(
        _ character: Character?,
        _ padding: LogToken.OptionalPadding
    ) -> String? {
        guard let charString = character?.string else { return nil }
        
        switch padding {
        case .none: return charString
        case .leading: return " \(charString)"
        case .trailing: return "\(charString) "
        case .leadingAndTrailing: return " \(charString) "
        }
    }
    
    /// Internal util.
    @inline(__always)
    private func parseOptional(
        _ string: String?,
        _ padding: LogToken.OptionalPadding
    ) -> String? {
        guard let unwrappedString = string else { return nil }
        
        switch padding {
        case .none: return unwrappedString
        case .leading: return " \(unwrappedString)"
        case .trailing: return "\(unwrappedString) "
        case .leadingAndTrailing: return " \(unwrappedString) "
        }
    }
}

// MARK: - LogToken

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension OSLogger {
    public typealias LogTemplate = [LogToken]
    
    /// **OTCore:**
    /// Log tokens for assembling log messages.
    public enum LogToken: Sendable {
        case message
        case emoji(padding: OptionalPadding)
        
        case file
        case function
        
        case line
        case column
        
        case space
        case string(String)
        
        public enum OptionalPadding: Sendable {
            case none
            case leading
            case trailing
            case leadingAndTrailing
        }
    }
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension OSLogger {
    /// **OTCore:**
    /// Configuration settings for `OSLogger`.
    public struct Config: Sendable {
        /// **OTCore:**
        /// Sets the default `OSLog` to use.
        ///
        /// It is highly recommended to define a custom `OSLog` and not use the `default` (which does not post bundleID/subsystem information to the Console).
        @inline(__always)
        public var defaultLog: OSLog
        
        /// **OTCore:**
        /// Sets the default log message template to use.
        @inline(__always)
        public var defaultTemplate: OSLogger.LogTemplate
        
        /// **OTCore:**
        /// When enabled, all `debug` and `info` log level messages will be coerced to be `default` log level.
        /// This allows them to be printed to the system Console log.
        /// Otherwise by default, logging calls to OSLog will not print `debug` or `info` level messages to the Console log.
        @inline(__always)
        public var coerceInfoAndDebugToDefault: Bool = false
        
        // MARK: Level Settings
        
        public struct LevelSettings: Sendable {
            /// **OTCore:**
            /// Set the emoji used for the `emoji` LogToken.
            @inline(__always)
            public var emoji: Character?
            
            /// **OTCore:**
            /// Set the log used for this log level.
            /// If `nil`, the `defaultLog` Config property will be used.
            @inline(__always)
            public var log: OSLog?
        }
        
        /// **OTCore:**
        /// Settings for the `debug` log level.
        @inline(__always)
        public var levelDebug = LevelSettings(
            emoji: "🔷",
            log: nil
        )
        
        /// **OTCore:**
        /// Settings for the `info` log level.
        @inline(__always)
        public var levelInfo = LevelSettings(
            emoji: "💬",
            log: nil
        )
        
        /// **OTCore:**
        /// Settings for the `default` log level.
        @inline(__always)
        public var levelDefault = LevelSettings(
            emoji: "💬",
            log: nil
        )
        
        /// **OTCore:**
        /// Settings for the `error` log level.
        @inline(__always)
        public var levelError = LevelSettings(
            emoji: "⚠️",
            log: nil
        )
        
        /// **OTCore:**
        /// Settings for the `fault` log level.
        @inline(__always)
        public var levelFault = LevelSettings(
            emoji: "🛑",
            log: nil
        )
        
        /// Internal util.
        @inline(__always)
        func log(for log: OSLogType) -> OSLog {
            switch log {
            case .debug:   return levelDebug.log ?? defaultLog
            case .info:    return levelInfo.log ?? defaultLog
            case .default: return levelDefault.log ?? defaultLog
            case .error:   return levelError.log ?? defaultLog
            case .fault:   return levelFault.log ?? defaultLog
            default:       return defaultLog
            }
        }
        
        /// **OTCore:**
        /// Initialize all settings.
        /// If `nil` is passed for any level, defaults will be used.
        public init(
            defaultLog: OSLog = .default,
            defaultTemplate: OSLogger.LogTemplate = .default(),
            coerceInfoAndDebugToDefault: Bool = false,
            debug: LevelSettings? = nil,
            info: LevelSettings? = nil,
            default: LevelSettings? = nil,
            error: LevelSettings? = nil,
            fault: LevelSettings? = nil
        ) {
            self.defaultLog = defaultLog
            self.defaultTemplate = defaultTemplate
            self.coerceInfoAndDebugToDefault = coerceInfoAndDebugToDefault
            if let _debug = debug { levelDebug = _debug }
            if let _info = info { levelInfo = _info }
            if let _default = `default` { levelDefault = _default }
            if let _error = error { levelError = _error }
            if let _fault = fault { levelFault = _fault }
        }
    }
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension OSLogger {
    /// **OTCore:**
    /// Initialize a new instance while modifying the logger configuration in a closure.
    public convenience init(_ configuration: (inout Config) -> Void) {
        var config = Config()
        configuration(&config)
        self.init(config: config)
    }
    
    /// **OTCore:**
    /// Modify logger configuration within a closure.
    public func configure(_ configuration: (inout Config) -> Void) -> OSLogger {
        var config = Config()
        configuration(&config)
        return OSLogger(enabled: enabled, config: config)
    }
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
extension OSLogger.LogTemplate {
    /// **OTCore:**
    /// Default log template (message only).
    public static func `default`() -> Self {
        [.message]
    }
    
    /// **OTCore:**
    /// Message only.
    public static func minimal() -> Self {
        [.message]
    }
    
    /// **OTCore:**
    /// Message, prefixed by log level emoji.
    public static func withEmoji() -> Self {
        [.emoji(padding: .trailing), .message]
    }
    
    /// **OTCore:**
    /// All meta fields are used to provide as much information as possible.
    /// (emoji, message, file name, function name, line/column numbers)
    public static func verbose() -> Self {
        [
            .emoji(padding: .trailing),
            .message,
            .space,
            .string("("),
            .file,
            .string(":"),
            .function,
            .string(":"),
            .line,
            .string(":"),
            .column,
            .string(")")
        ]
    }
}

#endif
