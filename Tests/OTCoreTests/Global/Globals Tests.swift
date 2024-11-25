//
//  Globals Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing
import OTCore

@Suite struct Global_Globals_Tests {
    @Test func testBundle() {
        // this test could break in future versions of Xcode/XCTest
        // but we'll test what 'known values' we can here
        
        #expect(Globals.MainBundle.name == "xctest")
        
        #expect(Globals.MainBundle.bundleID == "com.apple.dt.xctest.tool")
        
        // XCTest in Xcode 12 and earlier doesn't return a value
        // So there isn't a meaningful way to test this
        //   Xcode 12.4 == ""
        //   Xcode 13   == "13.0"
        _ = Globals.MainBundle.versionShort
        
        // XCTest in Xcode 12 and earlier doesn't return a value
        // So there isn't a meaningful way to test this
        //   Xcode 12.4 == 0
        //   Xcode 13   == 13
        #expect(Globals.MainBundle.versionMajor > -1)
        
        // XCTest appears to always return a non-empty value
        #expect(Globals.MainBundle.versionBuildNumber != "")
    }
    
    @Test func testSystem() async {
        // values cannot be tested explicitly since they vary by system
        
        #if os(macOS)
        _ = Globals.System.userName
        
        _ = Globals.System.fullUserName
        #endif
        
        #expect(Globals.System.osVersion != "")
        
        #if !os(watchOS)
        #expect(await Globals.System.name != "")
        #endif
        
        #if os(macOS)
        #expect(Globals.System.serialNumber != nil)
        
        #expect(Globals.System.hardwareUUID != nil)
        #endif
    }
    
    @Test func testBundle_infoDictionaryString() {
        // String key name
        
        #expect(
            Bundle.main.infoDictionaryString(key: kCFBundleIdentifierKey as String) ==
            "com.apple.dt.xctest.tool"
        )
        
        // CFString key name
        
        #expect(
            Bundle.main.infoDictionaryString(key: kCFBundleIdentifierKey) ==
            "com.apple.dt.xctest.tool"
        )
    }
}
