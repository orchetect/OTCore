//
//  String and NumberFormatter Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_StringAndNumberFormatter_Tests {
    @Test
    func stringInterpolationFormatter() {
        #expect("\(3, format: .ordinal)" == "3rd")
        #expect("\(3, format: .spellOut)" == "three")
    }
}

#endif
