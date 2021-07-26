//
//  CharacterSet Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_CharacterSet_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testContainsCharacter() {
        
        let charset = CharacterSet.alphanumerics
        
        let a = Character("a")
        let one = Character("1")
        let ds = Character("$")
        
        XCTAssertTrue(charset.contains(a))
        XCTAssertTrue(charset.contains(one))
        XCTAssertFalse(charset.contains(ds))
        
    }
    
}

#endif
