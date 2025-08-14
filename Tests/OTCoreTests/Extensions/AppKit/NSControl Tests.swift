//
//  NSControl Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(AppKit)

import AppKit
@testable import OTCore
import Testing

@Suite struct Extensions_AppKit_NSControl_Tests {
    @Test
    func bool_stateValue() {
        #expect(true.stateValue == .on)
        #expect(false.stateValue == .off)
    }
    
    @Test
    func stateValue_prefixOperator_Not() {
        #expect(!NSControl.StateValue.on == .off)
        #expect(!NSControl.StateValue.off == .on)
        #expect(!NSControl.StateValue.mixed == .off)
    }
    
    @Test
    func stateValue_toggled() {
        #expect(NSControl.StateValue.on.toggled() == .off)
        #expect(NSControl.StateValue.off.toggled() == .on)
        #expect(NSControl.StateValue.mixed.toggled() == .off)
    }
    
    @Test
    func stateValue_toggle() {
        var stateValue: NSControl.StateValue
        
        stateValue = .on
        stateValue.toggle()
        #expect(stateValue == .off)
        
        stateValue = .off
        stateValue.toggle()
        #expect(stateValue == .on)
        
        stateValue = .mixed
        stateValue.toggle()
        #expect(stateValue == .off)
    }
}

#endif
