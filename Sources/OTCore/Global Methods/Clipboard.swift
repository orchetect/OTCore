//
//  Clipboard.swift
//  OTCore
//
//  Created by Steffan Andrews on 2018-04-14.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

#if os(macOS)
	import Cocoa
#elseif os(iOS)
	import UIKit
#else
	import Foundation
#endif

/// OTCore:
/// Convenience function to set the system clipboard to a `String`. Returns `true` if successful.
@discardableResult
public func SetClipboard(toString: String) -> Bool {
	#if os(macOS)
		let p = NSPasteboard.general
	
		p.declareTypes([.string], owner: nil)
		return p.setString(toString, forType: .string)
	#elseif os(iOS)
		UIPasteboard.general.string = toString
		return true
	#else
		fatalError("setClipboard: Not implemented on this platform yet.")
	#endif
}

/// OTCore:
/// Convenience function to get the system clipboard contents if it contains a `String`. Returns `nil` if no text is found on the clipboard.
public func GetClipboardString() -> String? {
	#if os(macOS)
		return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
	#elseif os(iOS)
		return UIPasteboard.general.string
	#else
		fatalError("getClipboardString: Not implemented on this platform yet.")
	#endif
}

extension String {
	/// OTCore:
	/// Convenience function to set the system clipboard to a `String`. Returns `true` if successful.
	@discardableResult
	public func copyToClipboard() -> Bool {
		return SetClipboard(toString: self)
	}
}
