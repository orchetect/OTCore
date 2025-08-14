//
//  Operators Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import CoreGraphics
import OTCore
import Testing

@Suite struct Extensions_Swift_Operators_Tests {
    @Test
    func modulo() {
        // Double, Float, Float80
        
        #expect(43.0 % 10.0 == 3.0)
        #expect(Float(43.0) % 10.0 == 3.0)
        
        #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
        #expect(Float80(43.0) % 10.0 == 3.0)
        #endif
        
        // CGFloat
        
        // % is built-in for CGFloat:
        _ = (43.0 as CGFloat) % 10.0
        
        // Decimal
        
        // _ = (43.0 as Decimal) % (10.0 as Decimal)                 // doesn't work
        // _ = (43.0 as NSDecimalNumber) % (10.0 as NSDecimalNumber) // doesn't work
        
        // .truncatingRemainder(dividingBy:) and fmod() are not usable with Decimal
    }
}
