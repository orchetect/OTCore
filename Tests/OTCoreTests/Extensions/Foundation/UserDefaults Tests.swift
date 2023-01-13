//
//  UserDefaults Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
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
        
        let dict: [String: Any] =
            [
                "someInt": 123,
                "someDouble": 123.456,
                "someFloat": Float(0.123456),
                "someBool": true
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
    
    func testUserDefaultsStorage_Defaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "defaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
            var pref = 2
        }
        
        var dummyPrefs = DummyPrefs()
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 2)
        XCTAssertEqual(dummyPrefs.pref, 2)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
    }
    
    func testUserDefaultsStorage_Defaulted_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "defaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
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
    
    func testUserDefaultsStorage_NonDefaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
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
    
    func testUserDefaultsStorage_NonDefaulted_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
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
    
    func testUserDefaultsStorage_Defaulted_Clamped_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "clampedPref"
            
            @UserDefaultsStorage(key: prefKey, clamped: 5 ... 10, storage: ud)
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
    
    func testUserDefaultsStorage_Defaulted_Clamped_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "clampedPref"
            
            @UserDefaultsStorage(key: prefKey, clamped: 5 ... 10, storage: ud)
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
    
    func testUserDefaultsStorage_Defaulted_Validated_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "validatedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                validation: { $0.clamped(to: 5 ... 10) },
                storage: ud
            )
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
    
    func testUserDefaultsStorage_Defaulted_Validated_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "validatedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                validation: { $0.clamped(to: 5 ... 10) },
                storage: ud
            )
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
    
    func testUserDefaultsStorage_Defaulted_GetSet_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "transformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 < 5 ? "\($0)" : nil },
                storage: ud
            )
            var pref: Int = 1
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 1)
        XCTAssertEqual(dummyPrefs.pref, 1)
        
        dummyPrefs.pref = 2
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 2)
        XCTAssertEqual(dummyPrefs.pref, 2)
        
        dummyPrefs.pref = 10
        
        // reverts to default since value of 10 will return nil from set closure
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 1)
        XCTAssertEqual(dummyPrefs.pref, 1)
    }
    
    func testUserDefaultsStorage_Defaulted_GetSet_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "transformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 < 8 ? "\($0)" : nil },
                storage: ud
            )
            var pref: Int = 1
        }
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
    }
    
    func testUserDefaultsStorage_NonDefaulted_GetSet_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedTransformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 != nil ? "\($0!)" : nil },
                storage: ud
            )
            var pref: Int?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
        
        dummyPrefs.pref = 2
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), 2)
        XCTAssertEqual(dummyPrefs.pref, 2)
        
        dummyPrefs.pref = nil
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
    }
    
    func testUserDefaultsStorage_NonDefaulted_GetSet_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedTransformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 != nil ? "\($0!)" : nil },
                storage: ud
            )
            var pref: Int?
        }
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integer(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
    }
    
    func testUserDefaultsStorage_ComputedOnly_Generic() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyPref"
            
            // not used, just here to see if this alternate syntax compiles
            @UserDefaultsStorage<Int, String>(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? 0 : 0 },
                set: { "\($0)" },
                storage: ud
            )
            private var pref1: Int
            
            // not used, just here to see if this alternate syntax compiles
            @UserDefaultsStorage(
                key: prefKey,
                get: { (storedValue: String?) in
                    storedValue != nil ? Int(storedValue!) ?? 0 : 0
                },
                set: { (newValue: Int) -> String in "\(newValue)" },
                storage: ud
            )
            private var pref2: Int
        }
        
        _ = DummyPrefs() // forces property wrappers to init
    }
    
    func testUserDefaultsStorage_ComputedOnly_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0)" },
                storage: ud
            )
            var pref: Int
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, -1)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
    }
    
    func testUserDefaultsStorage_ComputedOnly_Optional_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyOptionalPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0 ?? -1)" },
                storage: ud
            )
            var pref: Int?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, -1)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
        
        dummyPrefs.pref = nil
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, -1)
    }
    
    func testUserDefaultsStorage_ComputedOnly_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0)" },
                storage: ud
            )
            var pref: Int
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        // default value
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
    }
    
    func testUserDefaultsStorage_ComputedOnly_Optional_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyOptionalPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0 ?? -1)" },
                storage: ud
            )
            var pref: Int?
            
            @UserDefaultsStorage(
                key: "myPref",
                get: { Int($0 ?? "") ?? 0 },
                set: { "\($0)" },
                storage: ud
            )
            var myPref: Int
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        // default value
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), 6)
        XCTAssertEqual(dummyPrefs.pref, 6)
        
        dummyPrefs.pref = 4
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), 4)
        XCTAssertEqual(dummyPrefs.pref, 4)
        
        dummyPrefs.pref = nil
        
        XCTAssertEqual(ud.integerOptional(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, -1)
    }
    
    // MARK: URL
    
    func testUserDefaultsStorage_URL_Defaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
            var pref: URL = URL(fileURLWithPath: "/")
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "file:///")
        XCTAssertEqual(dummyPrefs.pref, URL(fileURLWithPath: "/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "https://www.google.com/test")
        XCTAssertEqual(dummyPrefs.pref, URL(string: "https://www.google.com/test")!)
    }
    
    func testUserDefaultsStorage_URL_Defaulted_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
            var pref: URL = URL(fileURLWithPath: "/")
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set(URL(fileURLWithPath: "/test/").absoluteString, forKey: DummyPrefs.prefKey)
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "file:///test/")
        XCTAssertEqual(dummyPrefs.pref, URL(fileURLWithPath: "/test/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "https://www.google.com/test")
        XCTAssertEqual(dummyPrefs.pref, URL(string: "https://www.google.com/test")!)
    }
    
    func testUserDefaultsStorage_URL_NonDefaulted_Optional_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
            var pref: URL?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
        
        dummyPrefs.pref = URL(fileURLWithPath: "/")
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "file:///")
        XCTAssertEqual(dummyPrefs.pref, URL(fileURLWithPath: "/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "https://www.google.com/test")
        XCTAssertEqual(dummyPrefs.pref, URL(string: "https://www.google.com/test")!)
        
        dummyPrefs.pref = nil
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
    }
    
    func testUserDefaultsStorage_URL_NonDefaulted_Optional_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: ud)
            var pref: URL?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set(URL(fileURLWithPath: "/test/").absoluteString, forKey: DummyPrefs.prefKey)
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "file:///test/")
        XCTAssertEqual(dummyPrefs.pref, URL(fileURLWithPath: "/test/"))
        
        dummyPrefs.pref = URL(fileURLWithPath: "/")
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "file:///")
        XCTAssertEqual(dummyPrefs.pref, URL(fileURLWithPath: "/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), "https://www.google.com/test")
        XCTAssertEqual(dummyPrefs.pref, URL(string: "https://www.google.com/test")!)
        
        dummyPrefs.pref = nil
        
        XCTAssertEqual(ud.string(forKey: DummyPrefs.prefKey), nil)
        XCTAssertEqual(dummyPrefs.pref, nil)
    }
}

#endif
