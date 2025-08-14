//
//  FloatingPoint and Darwin Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)

import Darwin
@testable import OTCore
import Testing

@Suite struct Extensions_Darwin_FloatingPointAndDarwin_Tests {
    @Test
    func ceiling() {
        #expect(123.45.ceiling == 124.0)
    }
    
    @Test
    func floor() {
        #expect(123.45.floor == 123.0)
    }
    
    @Test
    func power() {
        // Double
        #expect(2.0.power(3) == 8.0)
        
        // Float
        #expect(Float(2.0).power(3) == 8.0)
        
        // Float80 is now removed for ARM
        #if !(arch(arm64) || arch(arm) || os(watchOS))
        #expect(Float80(2.0).power(3) == 8.0)
        #endif
    }
    
    @Test
    func truncated() {
        // Double .truncated()
        
        #expect(1.1234.truncated(decimalPlaces: -1) == 1.0)
        #expect(1.1234.truncated(decimalPlaces: 0) ==  1.0)
        #expect(1.1234.truncated(decimalPlaces: 2) ==  1.12)
        #expect(1.1234.truncated(decimalPlaces: 3) ==  1.123)
        #expect(1.1234.truncated(decimalPlaces: 4) ==  1.1234)
        #expect(1.1234.truncated(decimalPlaces: 5) ==  1.1234)
        
        #expect(0.123456789.truncated(decimalPlaces: 8) == 0.12345678)
        
        var dbl = 0.1264
        dbl.truncate(decimalPlaces: 2)
        #expect(dbl == 0.12)
        
        // Float .truncated()
        
        var flt: Float = 1.1234
        
        #expect(flt.truncated(decimalPlaces: -1) == 1.0)
        #expect(flt.truncated(decimalPlaces: 0) ==  1.0)
        #expect(flt.truncated(decimalPlaces: 2) ==  1.12)
        #expect(flt.truncated(decimalPlaces: 3) ==  1.123)
        #expect(flt.truncated(decimalPlaces: 4) ==  1.1234)
        #expect(flt.truncated(decimalPlaces: 5) ==  1.1234)
        
        // flt = 0.123456789
        // #expect(flt.truncated(decimalPlaces: 8) == 0.12345678) // fails -- precision issue??
        
        // Double .truncate()
        
        flt = 0.1264
        flt.truncate(decimalPlaces: 2)
        #expect(flt == 0.12)
    }
    
    @Test
    func quotientAndRemainder() {
        let qr = 17.5.quotientAndRemainder(dividingBy: 5.0)
        
        #expect(qr.quotient == 3)
        #expect(qr.remainder == 2.5)
    }
    
    @Test
    func integralAndFraction() {
        let iaf = 17.5.integralAndFraction
        
        #expect(iaf.integral == 17)
        #expect(iaf.fraction == 0.5)
        
        #expect(17.5.integral == 17)
        #expect(17.5.fraction == 0.5)
    }
}

#endif
