//
//  NSAttributedString.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension NSAttributedString {
    /// **OTCore:**
    /// Convenience. Returns a new `NSAttributedString` with the attribute applied to the entire string.
    @_disfavoredOverload
    public func addingAttribute(alignment: NSTextAlignment) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        guard let copy = mutableCopy() as? NSMutableAttributedString
        else {
            print("Could not create mutable NSAttributedString copy.")
            return self
        }
        
        copy.addAttributes(
            [.paragraphStyle: paragraph],
            range: NSRange(location: 0, length: length)
        )
        
        return copy
    }
}

extension NSMutableAttributedString {
    /// **OTCore:**
    /// Convenience. Adds the attribute applied to the entire string.
    @_disfavoredOverload
    public func addAttribute(alignment: NSTextAlignment) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        addAttributes(
            [.paragraphStyle: paragraph],
            range: NSRange(location: 0, length: length)
        )
    }
}
#endif
