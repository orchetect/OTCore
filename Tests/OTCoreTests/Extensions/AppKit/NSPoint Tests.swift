//
//  NSPoint Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_NSPoint_Tests {
    /// This method used to test the OTCore property `cgPoint` which was removed in OTCore 1.7.9.
    @Test
    func cgPoint() {
        // just to confirm that the compiler sees both types as the same
        let cgPoint: CGPoint = NSPoint(x: 1.23, y: 2.5) // .cgPoint
        
        #expect(cgPoint.x == 1.23)
        #expect(cgPoint.y == 2.5)
    }
}

#endif
