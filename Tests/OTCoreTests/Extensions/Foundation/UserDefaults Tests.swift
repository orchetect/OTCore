//
//  UserDefaults Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Foundation_UserDefaults_Tests: XCTestCase {
    
    fileprivate let domain = "com.orchetect.otcore.userdefaultstests"
    fileprivate var ud: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        // since we are accessing actual UserDefaults for these tests,
        // we need to ensure resiliency and do not mutate them
        
        // using a custom volatile domain should keep tests isolated
        
        // just in case, remove suite in case it wasn't cleaned up properly
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        // set up new UserDefaults suite
        ud = UserDefaults(suiteName: domain)
        
        guard ud != nil else {
            XCTFail("Could not set up UserDefaults suite for testing.")
            return
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        // clean up
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
    
    func testOptionalGetters() {
        
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
        
        // key exists?
        XCTAssertTrue(ud.exists(key: "someInt"))
        XCTAssertTrue(ud.exists(key: "someDouble"))
        XCTAssertTrue(ud.exists(key: "someFloat"))
        XCTAssertTrue(ud.exists(key: "someBool"))
        XCTAssertFalse(ud.exists(key: "does_not_exist"))
        
    }
    
    func testUserDefaultsBacked_Defaulted() {
        
        struct DummyPrefs {
            static let prefKey = "defaultedPref"
            
            @UserDefaultsBacked(key: prefKey)
            var pref = 2
            
            init(defaults: UserDefaults) {
                // have to inject here
                _pref.storage = defaults
            }
        }
        
        var dummyPrefs = DummyPrefs(defaults: ud)
        
        // UserDefaults returns Int 0 if key is not existent
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 0)
        
        // check our property wrapper default value being returned
        XCTAssertEqual(dummyPrefs.pref, 2)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
        
    }
    
    func testUserDefaultsBacked_NonDefaulted() {
        
        struct DummyPrefs {
            static let prefKey = "nonDefaultedPref"
            
            @UserDefaultsBacked(key: prefKey)
            var pref: String?
            
            init(defaults: UserDefaults) {
                _pref.storage = defaults // have to inject here
            }
        }
        
        var dummyPrefs = DummyPrefs(defaults: ud)
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
        
        dummyPrefs.pref = "A String"
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "A String")
        XCTAssertEqual(dummyPrefs.pref, "A String")
        XCTAssertEqual(dummyPrefs.pref!, "A String") // proves it's an Optional type
        
        dummyPrefs.pref = nil
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
        
    }
    
}

#endif
