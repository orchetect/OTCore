//
//  UserDefaults Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

fileprivate var ud: UserDefaults!

class Extensions_Foundation_UserDefaults_Tests: XCTestCase {
    
    fileprivate let domain = "com.orchetect.otcore.userdefaultstests"
    
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
    
    func testUserDefaultsBacked_Defaulted_NoPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "defaultedPref"
            
            @UserDefaultsBacked(key: prefKey, storage: ud)
            var pref = 2
        }
        
        var dummyPrefs = DummyPrefs()
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 2)
        XCTAssertEqual(dummyPrefs.pref, 2)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
        
    }
    
    func testUserDefaultsBacked_Defaulted_HasPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "defaultedPref"
            
            @UserDefaultsBacked(key: prefKey, storage: ud)
            var pref = 2
        }
        
        // set a pre-existing value
        ud.set(6, forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
        
    }
    
    func testUserDefaultsBacked_NonDefaulted_NoPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "nonDefaultedPref"
            
            @UserDefaultsBacked(key: prefKey, storage: ud)
            var pref: String?
        }
        
        var dummyPrefs = DummyPrefs()
        
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
    
    func testUserDefaultsBacked_NonDefaulted_HasPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "nonDefaultedPref"
            
            @UserDefaultsBacked(key: prefKey, storage: ud)
            var pref: String?
        }
        
        // set a pre-existing value
        ud.set("Pre-Existing String", forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "Pre-Existing String")
        XCTAssertEqual(dummyPrefs.pref, "Pre-Existing String")
        
        dummyPrefs.pref = "A String"
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "A String")
        XCTAssertEqual(dummyPrefs.pref, "A String")
        XCTAssertEqual(dummyPrefs.pref!, "A String") // proves it's an Optional type
        
        dummyPrefs.pref = nil
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
        
    }
    
    func testUserDefaultsBacked_Defaulted_Clamped_NoPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "clampedPref"
            
            @UserDefaultsBacked(key: prefKey, clamped: 5...10, storage: ud)
            var pref = 1
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value clamped
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 2
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
            
        dummyPrefs.pref = 5
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 6
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 10
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
        dummyPrefs.pref = 11
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
    }
    
    func testUserDefaultsBacked_Defaulted_Clamped_HasPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "clampedPref"
            
            @UserDefaultsBacked(key: prefKey, clamped: 5...10, storage: ud)
            var pref = 1
        }
        
        // set a pre-existing value
        ud.set(15, forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value clamped
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
        dummyPrefs.pref = 2
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 5
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 6
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 10
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
        dummyPrefs.pref = 11
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
    }
    
    func testUserDefaultsBacked_Defaulted_Validated_NoPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "validatedPref"
            
            @UserDefaultsBacked(key: prefKey,
                                validation: { $0.clamped(to: 5...10) },
                                storage: ud)
            var pref = 1
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value clamped
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 2
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 5
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 6
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 10
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
        dummyPrefs.pref = 11
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
    }
    
    func testUserDefaultsBacked_Defaulted_Validated_HasPreviousValue() {
        
        struct DummyPrefs {
            static let prefKey = "validatedPref"
            
            @UserDefaultsBacked(key: prefKey,
                                validation: { $0.clamped(to: 5...10) },
                                storage: ud)
            var pref = 1
        }
        
        // set a pre-existing value
        ud.set(15, forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value validated
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
        dummyPrefs.pref = 2
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 5
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 5)
        XCTAssertEqual(dummyPrefs.pref, 5)
        
        dummyPrefs.pref = 6
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 10
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
        dummyPrefs.pref = 11
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 10)
        XCTAssertEqual(dummyPrefs.pref, 10)
        
    }
    
}

#endif
