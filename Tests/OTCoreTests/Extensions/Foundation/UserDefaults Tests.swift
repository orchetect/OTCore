//
//  UserDefaults Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_UserDefaults_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testUserDefaults() {
        
        // since we are accessing actual UserDefaults for these tests,
        // we need to ensure resiliency and do not mutate them
        
        // using a custom volatile domain should keep tests isolated
        
        let domain = "com.orchetect.otcore.userdefaultstests"
        
        // set up UserDefaults suite
        
        UserDefaults.standard.removeSuite(named: domain)
        
        guard let ud = UserDefaults(suiteName: domain) else {
            XCTFail("Could not set up UserDefaults suite for testing.")
            return
        }
        
        // push sample data to volatile user defaults
        
        // prep sample key/value data
        
        let dict: [String : Any] =
            [
                "someInt" : 123,
                "someDouble" : 123.456,
                "someFloat" : Float(0.123456),
                "someBool" : true
            ]
        
        for (key, value) in dict {
            ud.setValue(value, forKey: key)
        }
        
        // test methods
        
        // existent values
        
        XCTAssertEqual(ud.integerOptional(forKey: "someInt"), 123)
        XCTAssertEqual(ud.doubleOptional(forKey: "someDouble"), 123.456)
        XCTAssertEqual(ud.floatOptional(forKey: "someFloat"), 0.123456)
        XCTAssertEqual(ud.boolOptional(forKey: "someBool"), true)
        
        // non-existent values
        
        XCTAssertNil(ud.integerOptional(forKey: "does_not_exist"))
        XCTAssertNil(ud.doubleOptional(forKey: "does_not_exist"))
        XCTAssertNil(ud.floatOptional(forKey: "does_not_exist"))
        XCTAssertNil(ud.boolOptional(forKey: "does_not_exist"))
        
        // clean up
        
        UserDefaults.standard.removeSuite(named: domain)
        
    }
    
}

#endif
