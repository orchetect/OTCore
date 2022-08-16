//
//  NSAttributedString Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

#if os(macOS)
import AppKit
#else
import UIKit
#endif

import XCTest
@testable import OTCore

class Extensions_Foundation_NSAttributedString_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testNSAttributedString_addingAttribute() {
        let rawString = "Test"
        
        // vanilla NSAttributedString
        let attrStr1 = NSAttributedString(string: rawString)
        XCTAssertEqual(attrStr1.string, rawString)
        XCTAssertEqual(attrStr1.getAlignmentAttributes(), [])
        
        // with alignment attribute
        let attrStr2 = attrStr1.addingAttribute(alignment: .center)
        XCTAssertEqual(attrStr2.string, rawString)
        XCTAssertEqual(attrStr2.getAlignmentAttributes(), [.center])
    }
    
    func testNSAttributedString_addAttribute() {
        let rawString = "Test"
        
        // vanilla NSMutableAttributedString
        let attrStr = NSMutableAttributedString(string: rawString)
        XCTAssertEqual(attrStr.string, rawString)
        XCTAssertEqual(attrStr.getAlignmentAttributes(), [])
        
        // with alignment attribute
        attrStr.addAttribute(alignment: .center)
        XCTAssertEqual(attrStr.string, rawString)
        XCTAssertEqual(attrStr.getAlignmentAttributes(), [.center])
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

#endif
