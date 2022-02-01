//
//  String and NumberFormatter Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_StringAndNumberFormatter_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testStringInterpolationFormatter() {
        
        XCTAssertEqual("\(3, format: .ordinal)", "3rd")
        XCTAssertEqual("\(3, format: .spellOut)", "three")
        
    }
    
}

#endif
