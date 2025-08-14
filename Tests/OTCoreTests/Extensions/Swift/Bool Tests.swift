//
//  Bool Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Extensions_Swift_Bool_Tests {
    @Test
    func toInt() {
        // Bool

        #expect(true.intValue == 1)
        #expect(true.int8Value == 1)
        #expect(true.int16Value == 1)
        #expect(true.int32Value == 1)
        #expect(true.int64Value == 1)
        #expect(true.uIntValue == 1)
        #expect(true.uInt8Value == 1)
        #expect(true.uInt16Value == 1)
        #expect(true.uInt32Value == 1)
        #expect(true.uInt64Value == 1)

        #expect(false.intValue == 0)
        #expect(false.int8Value == 0)
        #expect(false.int16Value == 0)
        #expect(false.int32Value == 0)
        #expect(false.int64Value == 0)
        #expect(false.uIntValue == 0)
        #expect(false.uInt8Value == 0)
        #expect(false.uInt16Value == 0)
        #expect(false.uInt32Value == 0)
        #expect(false.uInt64Value == 0)
    }

    @Test
    func toggled() {
        #expect(true.toggled() == false)
        #expect(false.toggled() == true)
    }

    @Test
    func expressibleByIntegerLiteral() {
        #expect(Bool(-1) == false)
        #expect(Bool(integerLiteral: 0) == false)  // same as b: Bool = 0
        #expect(Bool(0) == false)
        #expect(Bool(integerLiteral: 1) == true)   // same as b: Bool = 1
        #expect(Bool(1) == true)
        #expect(Bool(integerLiteral: 123) == true) // same as b: Bool = 123
        #expect(Bool(123) == true)

        // ExpressibleByIntegerLiteral - these should all be possible

        var b = false
        b = -1
        b = 0
        b = 1
        b = 123
        b = Bool(1)
        b = Bool(UInt8(1))
        b = 0.boolValue
        b = UInt8(1).boolValue
        _ = b // silences 'variable was written to, but never read' warning
    }

    func binaryIntegerBoolValue() {
        #expect((-1).boolValue == false)
        #expect(0.boolValue == false)
        #expect(1.boolValue == true)
        #expect(123.boolValue == true)
    }
}
