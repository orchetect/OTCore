//
//  Result Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Extensions_Swift_Result_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    /// Enum for test
    fileprivate enum PasswordError: Error, Equatable {
        case short
        case obvious
        case simple
    }
    
    /// Func for test
    fileprivate func doStuff(_ trigger: Bool) -> Result<String, PasswordError> {
        trigger
            ? .success("we succeeded")
            : .failure(.short)
    }
    
    func testResultSuccessValue() {
        XCTAssertEqual(doStuff(true).successValue, "we succeeded")
        XCTAssertNotEqual(doStuff(true).successValue, "blah blah")
    }
    
    func testResultFailureValue() {
        XCTAssertEqual(doStuff(false).failureValue, .short)
        XCTAssertNotEqual(doStuff(false).failureValue, .simple)
    }
    
    func testResultIsSuccess() {
        XCTAssertEqual(doStuff(true).isSuccess, true)
        XCTAssertEqual(doStuff(false).isSuccess, false)
    }
}

#endif
