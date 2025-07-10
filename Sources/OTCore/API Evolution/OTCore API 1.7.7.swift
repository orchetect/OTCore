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

#endif
