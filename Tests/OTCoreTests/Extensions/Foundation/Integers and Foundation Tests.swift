//
//  Integers and Foundation Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_IntegersAndFoundation_Tests {
    @Test
    func stringPaddedTo() {
        // basic validation checks
        
        #expect(1.string(paddedTo: 1) == "1")
        #expect(1.string(paddedTo: 2) == "01")
        
        #expect(123.string(paddedTo: 1) == "123")
        
        #expect(1.string(paddedTo: -1) == "1")
        
        // BinaryInteger cases - just basic checks, since it's the same logic for all BinaryIntegers
        
        #expect(1.string(paddedTo: 1) == "1")
        #expect(UInt(1).string(paddedTo: 1) == "1")
        #expect(Int8(1).string(paddedTo: 1) == "1")
        #expect(UInt8(1).string(paddedTo: 1) == "1")
        #expect(Int16(1).string(paddedTo: 1) == "1")
        #expect(UInt16(1).string(paddedTo: 1) == "1")
        #expect(Int32(1).string(paddedTo: 1) == "1")
        #expect(UInt32(1).string(paddedTo: 1) == "1")
        #expect(Int64(1).string(paddedTo: 1) == "1")
        #expect(UInt64(1).string(paddedTo: 1) == "1")
    }
    
    #if compiler(>=6.0) && !(arch(arm) || arch(arm64_32) || arch(i386))
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @Test
    func durationTimeInterval() {
        #expect(Duration.zero.timeInterval == 0.0)
        #expect(Duration.milliseconds(-0).timeInterval == 0.0)
        
        #expect(Duration.milliseconds(20).timeInterval == 0.02)
        #expect(Duration.milliseconds(-20).timeInterval == -0.02)
        
        #expect(Duration.milliseconds(1000).timeInterval == 1.0)
        #expect(Duration.milliseconds(-1000).timeInterval == -1.0)
        
        #expect(Duration.milliseconds(1020).timeInterval == 1.02)
        #expect(Duration.milliseconds(-1020).timeInterval == -1.02)
    }
    #endif
}

#endif
