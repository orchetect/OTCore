//
//  NSControl Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
@testable import OTCore
import XCTest

class Extensions_AppKit_NSControl_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testBool_stateValue() {
        XCTAssertEqual(true.stateValue, .on)
        XCTAssertEqual(false.stateValue, .off)
    }
    
    func testStateValue_prefixOperator_Not() {
        XCTAssertEqual(!NSControl.StateValue.on, .off)
        XCTAssertEqual(!NSControl.StateValue.off, .on)
        XCTAssertEqual(!NSControl.StateValue.mixed, .off)
    }
    
    func testStateValue_toggled() {
        XCTAssertEqual(NSControl.StateValue.on.toggled(), .off)
        XCTAssertEqual(NSControl.StateValue.off.toggled(), .on)
        XCTAssertEqual(NSControl.StateValue.mixed.toggled(), .off)
    }
    
    func testStateValue_toggle() {
        var stateValue: NSControl.StateValue
        
        stateValue = .on
        stateValue.toggle()
        XCTAssertEqual(stateValue, .off)
        
        stateValue = .off
        stateValue.toggle()
        XCTAssertEqual(stateValue, .on)
        
        stateValue = .mixed
        stateValue.toggle()
        XCTAssertEqual(stateValue, .off)
    }
}

#endif
