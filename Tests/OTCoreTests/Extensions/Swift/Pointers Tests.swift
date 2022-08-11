//
//  Pointers Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Extensions_Swift_Pointers_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testUnsafeRawBufferPointer_unsafeBufferPointer() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        data.withUnsafeBytes { unsafeRawBufferPtr in
            let unsafeBufferPtr = unsafeRawBufferPtr.unsafeBufferPointer
            XCTAssertEqual(unsafeBufferPtr[0], 0x01)
            XCTAssertEqual(unsafeBufferPtr[1], 0x02)
            XCTAssertEqual(unsafeBufferPtr[2], 0x03)
            XCTAssertEqual(unsafeBufferPtr[3], 0x04)
        }
    }
}

#endif
