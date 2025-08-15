//
//  URL and AppKit Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit
@testable import OTCore
import Testing

@Suite struct Extensions_AppKit_URLAndAppKit_Tests {
    @Test
    func urlIcon() {
        // on most, if not all, systems this should produce a value
        
        let url = URL(fileURLWithPath: "/")
        let fileIcon = url.fileIcon
        #expect(fileIcon != nil)
    }
}

#endif
