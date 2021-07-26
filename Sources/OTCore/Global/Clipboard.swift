//
//  Clipboard.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

/// **OTCore:**
/// Convenience function to set the system clipboard to a `String`.
/// Returns `true` if successful.
@available(macOS 10.0, macCatalyst 1.0, iOS 1.0, tvOS 9999, watchOS 9999, *)
@discardableResult
public func setClipboard(toString: String) -> Bool {
    
    #if os(macOS)
    
        let p = NSPasteboard.general
        p.declareTypes([.string], owner: nil)
        return p.setString(toString, forType: .string)
    
    #elseif os(iOS)
    
        UIPasteboard.general.string = toString
        return true
    
    #else
    
        fatalError("Not implemented on this platform yet.")
    
    #endif
    
}

/// **OTCore:**
/// Convenience function to get the system clipboard contents if it contains a `String`.
/// Returns `nil` if no text is found on the clipboard.
@available(macOS 10.0, macCatalyst 1.0, iOS 1.0, tvOS 9999, watchOS 9999, *)
public func getClipboardString() -> String? {
    
    #if os(macOS)
        return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
    #elseif os(iOS)
        return UIPasteboard.general.string
    #else
        fatalError("Not implemented on this platform yet.")
    #endif
    
}

extension String {
    
    /// **OTCore:**
    /// Convenience function to set the system clipboard to a `String`.
    /// Returns `true` if successful.
    
    @discardableResult
    public func copyToClipboard() -> Bool {
        
        setClipboard(toString: self)
        
    }
    
}
