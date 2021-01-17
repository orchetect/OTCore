//
//  Log.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-11.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

// os.log does not rely on Foundation, but we need Foundation for file path string operations
#if canImport(Foundation)

import Foundation
import os.log

// -------------------------------------------------------------------------
// Suggestion:
// In your library/application that adopts OTCore, you can write your own centralized extension to store references to specific logs, if you require more than one.
//
//     fileprivate let subsystem = "com.yourdomain.yourapp"
//
//     extension OSLog {
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
fileprivate var LogEnabled = false

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var DefaultLog = OSLog.default

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var DefaultSubsystem: String? = nil

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var UseEmoji: Log.EmojiType = .disabled


// MARK: - Log

/// **OTCore:**
/// Centralized logging via os_log
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public enum Log {
	
	/// **OTCore:**
	/// Set to false to suppress logging
	public var enabled: Bool {
		get { LogEnabled }
		set { LogEnabled = newValue }
	}
	
	/// **OTCore:**
	/// Sets the default OSLog to use
	public var defaultLog: OSLog {
		get { DefaultLog }
		set { DefaultLog = newValue }
	}
	
	/// **OTCore:**
	/// Sets the default OSLog subsystem to use
	public var defaultSubsystem: String? {
		get { DefaultSubsystem }
		set { DefaultSubsystem = newValue }
	}
	
	/// **OTCore:**
	/// Enables prefixing log messages with emoji icons (ie: ⚠️ for .error)
	public var useEmoji: EmojiType {
		get { UseEmoji }
		set { UseEmoji = newValue }
	}
	
	/// **OTCore:**
	/// Sets up all Log properties at once
	public static func setup(enabled: Bool = true,
							 defaultLog: OSLog? = nil,
							 defaultSubsystem: String? = nil,
							 useEmoji: EmojiType? = nil) {
		LogEnabled = enabled
		DefaultLog = defaultLog ?? .default
		DefaultSubsystem = defaultSubsystem
		UseEmoji = useEmoji ?? .disabled
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
		
		guard LogEnabled else { return }
		
		let fileName = (file as NSString).lastPathComponent
		
		let content = items
			.map { String(describing: $0 ?? "nil") }
			.joined(separator: " ")
		
		let message = (UseEmoji == .all ? "🔷 " : "")
			+ "\(content) (\(fileName):\(function))"
		
		os_log("%{public}@",
			   log: log ?? DefaultLog,
			   type: .debug,
			   message)
		
		#endif
		
	}
	
	/// **OTCore:**
	/// Log a message with default log type.
	/// Appears in both release and debug builds.
	/// - remark: OSLog Description: Purely informational in nature. Only captured in memory and not stored on disk unless otherwise specified. Eventually purged.
	@inline(__always)
	public static func info(_ items: Any?...,
							log: OSLog? = nil) {
		
		guard LogEnabled else { return }
		
		let content = items
			.map { String(describing: $0 ?? "nil") }
			.joined(separator: " ")
		
		let message =
			(UseEmoji == .all ? "💬 " : "")
			+ "\(content)"
		
		os_log("%{public}@",
			   log: log ?? DefaultLog,
			   type: .info,
			   message)
		
	}
	
	/// **OTCore:**
	/// Log a message with default log type.
	/// Appears in both release and debug builds.
	/// - remark: OSLog Description: Default behavior. Stored on disk. Eventually purged.
	@inline(__always)
	public static func `default`(_ items: Any?...,
								 log: OSLog? = nil) {
		
		guard LogEnabled else { return }
		
		let content = items
			.map { String(describing: $0 ?? "nil") }
			.joined(separator: " ")
		
		let message =
			(UseEmoji == .all ? "💬 " : "")
			+ "\(content)"
		
		os_log("%{public}@",
			   log: log ?? DefaultLog,
			   type: .default,
			   message)
		
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
		
		guard LogEnabled else { return }
		
		let fileName = (file as NSString).lastPathComponent
		
		let content = items
			.map { String(describing: $0 ?? "nil") }
			.joined(separator: " ")
		
		let message =
			(UseEmoji == .all || UseEmoji == .errorsOnly ? "⚠️ " : "")
			+ "\(content) (\(fileName):\(line):\(column):\(function))"
		
		os_log("%{public}@",
			   log: log ?? DefaultLog,
			   type: .error,
			   message)
		
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
		
		guard LogEnabled else { return }
		
		let fileName = (file as NSString).lastPathComponent
		
		let content = items
			.map { String(describing: $0 ?? "nil") }
			.joined(separator: " ")
		
		let message =
			(UseEmoji == .all || UseEmoji == .errorsOnly ? "🛑 " : "")
			+ "\(content) (\(fileName):\(line):\(column):\(function))"
		
		os_log("%{public}@",
			   log: log ?? DefaultLog,
			   type: .fault,
			   message)
		
	}
	
}

#endif
