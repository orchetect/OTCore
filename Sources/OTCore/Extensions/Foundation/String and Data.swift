//
//  String and Data.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

// MARK: - String Encoding

extension StringProtocol {
    /// **OTCore:**
    /// Encode a utf8 String to Base64
    @inlinable @_disfavoredOverload
    public var base64EncodedString: String {
        Data(utf8).base64EncodedString()
    }
}

extension String {
    /// **OTCore:**
    /// Decode a utf8 String from Base64. Returns `nil` if unsuccessful.
    @inlinable @_disfavoredOverload
    public var base64DecodedString: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}

extension Substring {
    /// **OTCore:**
    /// Decode a utf8 String from Base64. Returns `nil` if unsuccessful.
    @inlinable @_disfavoredOverload
    public var base64DecodedString: String? {
        guard let data = Data(base64Encoded: String(self)) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}

#endif
