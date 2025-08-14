//
//  Decimal Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_Decimal_Tests {
    @Test
    func typeConversions_IntsToInts() {
        _ = 1.decimal
        _ = UInt(1).decimal
        
        _ = Int8(1).decimal
        _ = UInt8(1).decimal
        
        _ = Int16(1).decimal
        _ = UInt16(1).decimal
        
        _ = Int32(1).decimal
        _ = UInt32(1).decimal
        
        _ = Int64(1).decimal
        _ = UInt64(1).decimal
    }
    
    @Test
    func boolValue() {
        _ = Decimal(1).boolValue
    }
    
    @Test
    func power() {
        #expect(Decimal(string: "2.0")!.power(3) == 8.0)
    }
    
    @Test
    func string() {
        #expect(Decimal(1).string == "1")
    }
    
    @Test
    func fromString() {
        // String
        
        let str = "1.0"
        
        #expect(str.decimal == Decimal(string: "1.0")!)
        #expect(str.decimal(locale: .init(identifier: "en_US")) == Decimal(string: "1.0")!)
        
        // Substring
        
        let subStr = str.prefix(3)
        
        #expect(subStr.decimal == Decimal(string: "1.0")!)
        #expect(subStr.decimal(locale: .init(identifier: "en_US")) == Decimal(string: "1.0")!)
    }
    
    @Test
    func rounded() {
        // .rounded()
        
        #expect(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: -1)
                == Decimal(string: "1.0")!
        )
        #expect(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 0)
                == Decimal(string: "1.0")!
        )
        #expect(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 1)
                == Decimal(string: "1.1")!
        )
        #expect(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 2)
                == Decimal(string: "1.12")!
        )
        #expect(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 3)
                == Decimal(string: "1.124")!
        )
        #expect(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 4)
                == Decimal(string: "1.1236")!
        )
        #expect(
            Decimal(string: "1.1236")!.rounded(decimalPlaces: 5)
                == Decimal(string: "1.1236")!
        )
        
        #expect(
            Decimal(string: "0.123456789")!.rounded(decimalPlaces: 8)
                == Decimal(string: "0.12345679")!
        )
        
        #expect(Decimal(string: "-0.1")!.rounded(decimalPlaces: 0) == Decimal(string: "-0.0")!)
        #expect(Decimal(string: "-0.1")!.rounded(decimalPlaces: 1) == Decimal(string: "-0.1")!)
        #expect(Decimal(string: "-1.7")!.rounded(decimalPlaces: 0) == Decimal(string: "-2.0")!)
        #expect(Decimal(string: "-1.7")!.rounded(decimalPlaces: 1) == Decimal(string: "-1.7")!)
        
        // .round()
        
        var dec = Decimal(string: "0.1264")!
        dec.round(decimalPlaces: 2)
        #expect(dec == Decimal(string: "0.13")!)
        
        dec = Decimal(string: "0.1264")!
        dec.round(decimalPlaces: 3)
        #expect(dec == Decimal(string: "0.126")!)
    }
    
    @Test
    func truncated() {
        // .truncated()
        
        #expect(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: -1)
                == Decimal(string: "1.0")!
        )
        #expect(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 0)
                == Decimal(string: "1.0")!
        )
        #expect(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 1)
                == Decimal(string: "1.1")!
        )
        #expect(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 2)
                == Decimal(string: "1.12")!
        )
        #expect(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 3)
                == Decimal(string: "1.123")!
        )
        #expect(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 4)
                == Decimal(string: "1.1236")!
        )
        #expect(
            Decimal(string: "1.1236")!.truncated(decimalPlaces: 5)
                == Decimal(string: "1.1236")!
        )
        
        #expect(
            Decimal(string: "0.123456789")!.truncated(decimalPlaces: 8)
                == Decimal(string: "0.12345678")!
        )
        
        #expect(
            Decimal(string: "-0.1")!.truncated(decimalPlaces: 0)
                == Decimal(string: "0")!
        )
        #expect(
            Decimal(string: "-0.1")!.truncated(decimalPlaces: 1)
                == Decimal(string: "-0.1")!
        )
        #expect(
            Decimal(string: "-1.7")!.truncated(decimalPlaces: 0)
                == Decimal(string: "-1.0")!
        )
        #expect(
            Decimal(string: "-1.7")!.truncated(decimalPlaces: 1)
                == Decimal(string: "-1.7")!
        )
        
        // .truncate()
        
        var dec = Decimal(0.1264)
        dec.truncate(decimalPlaces: 2)
        #expect(dec == Decimal(0.12))
    }
    
    @Test
    func truncatingRemainder() {
        let tr = Decimal(string: "20.5")!.truncatingRemainder(dividingBy: Decimal(8))
        
        #expect(tr == Decimal(string: "4.5")!)
    }
    
    @Test
    func quotientAndRemainder() {
        let qr = Decimal(string: "17.5")!.quotientAndRemainder(dividingBy: 5.0)
        
        #expect(qr.quotient == Decimal(string: "3")!)
        #expect(qr.remainder == Decimal(string: "2.5")!)
    }
    
    @Test
    func integralAndFraction() {
        let iaf = Decimal(string: "17.5")!.integralAndFraction
        
        #expect(iaf.integral == Decimal(string: "17")!)
        #expect(iaf.fraction == Decimal(string: "0.5")!)
        
        #expect(Decimal(string: "17.5")!.integral == Decimal(string: "17")!)
        #expect(Decimal(string: "17.5")!.fraction == Decimal(string: "0.5")!)
    }
    
    @Test
    func integralDigitPlaces_and_fractionDigitPlaces() {
        // we'll cast the number literals as Double to see if Decimal converts them and results are
        // still as expected
        
        #expect(Decimal(0.05 as Double).integralDigitPlaces == 0)
        #expect(Decimal(0.05 as Double).fractionDigitPlaces == 2)
        #expect(Decimal(-0.05 as Double).integralDigitPlaces == 0)
        #expect(Decimal(-0.05 as Double).fractionDigitPlaces == 2)
        
        #expect(Decimal(10.0 as Double).integralDigitPlaces == 2)
        #expect(Decimal(10.0 as Double).fractionDigitPlaces == 0)
        #expect(Decimal(-10.0 as Double).integralDigitPlaces == 2)
        #expect(Decimal(-10.0 as Double).fractionDigitPlaces == 0)
        
        #expect(Decimal(10.123 as Double).integralDigitPlaces == 2)
        #expect(Decimal(10.123 as Double).fractionDigitPlaces == 3)
        #expect(Decimal(-10.123 as Double).integralDigitPlaces == 2)
        #expect(Decimal(-10.123 as Double).fractionDigitPlaces == 3)
        
        #expect(Decimal(10_000.123 as Double).integralDigitPlaces == 5)
        #expect(Decimal(10_000.123 as Double).fractionDigitPlaces == 3)
        #expect(Decimal(-10_000.123 as Double).integralDigitPlaces == 5)
        #expect(Decimal(-10_000.123 as Double).fractionDigitPlaces == 3)
        
        #expect(Decimal(10_000.0 as Double).integralDigitPlaces == 5)
        #expect(Decimal(10_000.0 as Double).fractionDigitPlaces == 0)
        #expect(Decimal(-10_000.0 as Double).integralDigitPlaces == 5)
        #expect(Decimal(-10_000.0 as Double).fractionDigitPlaces == 0)
        
        #expect(Decimal(12_345.0 as Double).integralDigitPlaces == 5)
        #expect(Decimal(12_345.0 as Double).fractionDigitPlaces == 0)
        #expect(Decimal(-12_345.0 as Double).integralDigitPlaces == 5)
        #expect(Decimal(-12_345.0 as Double).fractionDigitPlaces == 0)
        
        #expect(Decimal(12_345.67 as Double).integralDigitPlaces == 5)
        #expect(Decimal(12_345.67 as Double).fractionDigitPlaces == 2)
        #expect(Decimal(-12_345.67 as Double).integralDigitPlaces == 5)
        #expect(Decimal(-12_345.67 as Double).fractionDigitPlaces == 2)
    }
}

#endif
