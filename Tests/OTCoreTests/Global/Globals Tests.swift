//
//  Globals Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Global_Globals_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testBundle() {
        
        // this test could break in future versions of Xcode/XCTest
        // but we'll test what 'known values' we can here
        
        XCTAssertEqual(Globals.MainBundle.name, "xctest")
        
        XCTAssertEqual(Globals.MainBundle.bundleID, "com.apple.dt.xctest.tool")
        
        // XCTest in Xcode 12 and earlier doesn't return a value
        // So there isn't a meaningful way to test this
        //   Xcode 12.4 == ""
        //   Xcode 13   == "13.0"
        _ = Globals.MainBundle.versionShort
        
        // XCTest in Xcode 12 and earlier doesn't return a value
        // So there isn't a meaningful way to test this
        //   Xcode 12.4 == 0
        //   Xcode 13   == 13
        XCTAssert(Globals.MainBundle.versionMajor > -1)
        
        // XCTest appears to always return a non-empty value
        XCTAssertTrue(Globals.MainBundle.versionBuildNumber != "")
        
    }
    
    func testSystem() {
        
        // values cannot be tested explicitly since they vary by system
        
        #if os(macOS)
        _ = Globals.System.userName
        
        _ = Globals.System.fullUserName
        #endif
        
        XCTAssert(Globals.System.osVersion != "")
        
        #if !os(watchOS)
        XCTAssert(Globals.System.name != "")
        #endif
        
        #if os(macOS)
        XCTAssertNotNil(Globals.System.serialNumber)
        
        XCTAssertNotNil(Globals.System.hardwareUUID)
        #endif
        
    }
    
    func testBundle_infoDictionaryString() {
        
        // String key name
        
        XCTAssertEqual(
            Bundle.main.infoDictionaryString(key: kCFBundleIdentifierKey as String),
            "com.apple.dt.xctest.tool"
        )
        
        // CFString key name
        
        XCTAssertEqual(
            Bundle.main.infoDictionaryString(key: kCFBundleIdentifierKey),
            "com.apple.dt.xctest.tool"
        )
        
    }
    
}

#endif
