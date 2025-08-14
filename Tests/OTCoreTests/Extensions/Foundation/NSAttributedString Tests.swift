//
//  NSAttributedString Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
import Foundation
#endif

@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_NSAttributedString_Tests {
    @Test
    func nsAttributedString_addingAttribute() {
        let rawString = "Test"
        
        // vanilla NSAttributedString
        let attrStr1 = NSAttributedString(string: rawString)
        #expect(attrStr1.string == rawString)
        #expect(attrStr1.getAlignmentAttributes() == [])
        
        // with alignment attribute
        let attrStr2 = attrStr1.addingAttribute(alignment: .center)
        #expect(attrStr2.string == rawString)
        #expect(attrStr2.getAlignmentAttributes() == [.center])
    }
    
    @Test
    func nsAttributedString_addAttribute() {
        let rawString = "Test"
        
        // vanilla NSMutableAttributedString
        let attrStr = NSMutableAttributedString(string: rawString)
        #expect(attrStr.string == rawString)
        #expect(attrStr.getAlignmentAttributes() == [])
        
        // with alignment attribute
        attrStr.addAttribute(alignment: .center)
        #expect(attrStr.string == rawString)
        #expect(attrStr.getAlignmentAttributes() == [.center])
    }
}

extension NSAttributedString {
    fileprivate func getAlignmentAttributes() -> [NSTextAlignment] {
        var range = NSRange(location: 0, length: length)
        
        return attributes(at: 0, effectiveRange: &range)
            .filter { $0.key == .paragraphStyle }
            .values
            .compactMap { $0 as? NSMutableParagraphStyle }
            .map { $0.alignment }
    }
}
