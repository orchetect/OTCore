//
//  OTCoreTestingTests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCoreTestingXCTest
import OTCoreTesting

class Assertions_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testAssert() {
        
        expectAssert {
            assert(1 == 2)
        }
        
    }
    
    func testAssertionFailure() {
        
        expectAssertionFailure {
            assertionFailure("Test assertionFailure")
        }
        
    }
    
    func testPrecondition() {
        
        expectPrecondition {
            precondition(false)
        }
        
    }
    
    func testPreconditionFailure() {
        
        expectPreconditionFailure {
            preconditionFailure("Test preconditionFailure")
        }
        
    }
    
    func testFatalError() {
        
        expectFatalError {
            fatalError("Test fatalError")
        }
        
    }
    
}

#endif
