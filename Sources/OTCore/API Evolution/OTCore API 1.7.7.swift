//
//  OTCore API 1.7.7.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)
import Foundation

// MARK: - IPAddress.swift

extension IPAddress {
    @available(*, deprecated, renamed: "Version")
    public typealias IPAddressType = Version
    
    @available(*, deprecated, renamed: "version")
    public var format: IPAddressType {
        version
    }
}

// MARK: - Data.swift

extension Collection where Element == UInt8 {
    /// **OTCore:**
    /// Same as `Data(self)`.
    /// Returns a Data object using the array as bytes.
    @_disfavoredOverload
    @available(*, deprecated, renamed: "toData()")
    public var data: Data {
        toData()
    }
}

extension Data {
    /// **OTCore:**
    /// Returns an array of bytes.
    /// Same as `[UInt8](self)`
    @_disfavoredOverload
    @available(
        *,
        deprecated,
        renamed: "toUInt8Bytes()",
        message: "Swift 6.2 introduces a bytes property. OTCore's bytes property is now renamed to the toUInt8Bytes() method."
    )
    public var bytes: [UInt8] {
        toUInt8Bytes()
    }
}

// MARK: - DateComponents from String.swift

extension DateComponents {
    /// **OTCore:**
    /// Parse a date string heuristically in a variety of formats involving month and day, and optionally year.
    ///
    /// Only produces day, month and year components.
    ///
    /// Acceptable formats include:
    ///
    /// - "10-21-20" (or "10/21/20")
    /// - "21-10-20" (or "21/10/20")
    ///
    /// - "2020-10-21" (or "2020/10/21")
    /// - "2020-21-10" (or "2020/21/10")
    /// - "10-21-2020" (or "10/21/2020")
    /// - "21-10-2020" (or "21/10/2020")
    ///
    /// - "2020-Oct-21" (or "2020/Oct/21")
    /// - "2020-21-Oct" (or "2020/21/Oct")
    ///
    /// - "Oct 21 2020"
    /// - "October 21 2020"
    /// - "Oct 21, 2020"
    /// - "October 21, 2020"
    /// - "21 Oct 2020"
    /// - "21 October 2020"
    ///
    /// - "21Oct2020"
    /// - "2020Oct21"
    @_disfavoredOverload
    @available(*, deprecated, renamed: "init(fuzzy:)")
    public init?(string: String) {
        self.init(fuzzy: string)
    }
}

// MARK: - URL and AppKit.swift

#if os(macOS)
import AppKit

extension URL {
    /// **OTCore:**
    /// Returns the icon that represents the given file, folder, application, etc.
    /// Returns `nil` if URL is not a file URL or if file does not exist.
    /// Thread-safe.
    @_disfavoredOverload
    @available(*, deprecated, renamed: "fileIcon")
    public var icon: NSImage? {
        fileIcon
    }
}

#endif

#endif
