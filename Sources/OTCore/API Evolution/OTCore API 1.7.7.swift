//
//  OTCore API 1.7.7.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2024 Steffan Andrews • Licensed under MIT License
//

// MARK: - URL.swift

#if canImport(Foundation)
import Foundation

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

#endif
