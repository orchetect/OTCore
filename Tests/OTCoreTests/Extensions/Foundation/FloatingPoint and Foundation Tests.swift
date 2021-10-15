//
//  FloatingPoint and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_FloatingPointAndFoundation_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testStringValueHighPrecision() {
        
        // Double
        
        XCTAssertEqual(Double(0.0).stringValueHighPrecision, "0")
        XCTAssertEqual(Double(0.1).stringValueHighPrecision, "0.1000000000000000055511151231257827021181583404541015625")
        XCTAssertEqual(Double(1.0).stringValueHighPrecision, "1")
        
        let double: Double = 3603.59999999999990905052982270717620849609375
        XCTAssertEqual(double.stringValueHighPrecision, "3603.59999999999990905052982270717620849609375")
        
        // Float
        
        let float: Float = 3603.59999999999990905052982270717620849609375
        XCTAssertEqual(float.stringValueHighPrecision, "3603.60009765625")
        
        // Float80
        let float80: Float80 = 3603.59999999999990905052982270717620849609375
        XCTAssertEqual(float80.stringValueHighPrecision, "3603.599999999999909")
        
        // CGFloat
        
        let cgfloat = CGFloat(exactly: 3603.59999999999990905052982270717620849609375)!
        XCTAssertEqual(cgfloat.stringValueHighPrecision, "3603.59999999999990905052982270717620849609375")
        
    }
    
}

#endif
