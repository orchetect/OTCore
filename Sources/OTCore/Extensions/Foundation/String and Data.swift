//
//  String and Data.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if canImport(Foundation)

import Foundation

// MARK: - String Encoding

extension String {
	
	/// **OTCore:**
	/// Encode a utf8 String to Base64
	@inlinable public var base64EncodedString: String {
		Data(self.utf8).base64EncodedString()
	}
	
	/// **OTCore:**
	/// Decode a utf8 String from Base64. Returns nil if unsuccessful.
	@inlinable public var base64DecodedString: String? {
		guard let data = Data(base64Encoded: self) else { return nil }
		return String(data: data, encoding: .utf8)
	}
	
}

#endif
