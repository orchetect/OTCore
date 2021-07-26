//
//  NSAttributedString.swift
//  OTCore • https://github.com/orchetect/OTCore
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
    public func addingAttribute(alignment: NSTextAlignment) -> NSAttributedString {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        guard let copy = self.mutableCopy() as? NSMutableAttributedString
        else {
            print("Could not create mutable NSAttributedString copy.")
            return self
        }
        
        copy.addAttributes([ .paragraphStyle : paragraph ],
                           range: NSRange(location: 0, length: self.length))
        
        return copy
        
    }
    
}

extension NSMutableAttributedString {
    
    /// **OTCore:**
    /// Convenience. Adds the attribute applied to the entire string.
    public func addAttribute(alignment: NSTextAlignment) {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        self.addAttributes([ .paragraphStyle : paragraph ],
                           range: NSRange(location: 0, length: self.length))
        
    }
    
}
#endif
