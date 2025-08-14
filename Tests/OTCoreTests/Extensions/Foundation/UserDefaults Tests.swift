//
//  UserDefaults Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing

private let domain = "com.orchetect.otcore.userdefaultstests"

extension UserDefaults {
    fileprivate static var testSuite: UserDefaults {
        UserDefaults(suiteName: domain)!
    }
}

@Suite(.serialized)
struct Extensions_Foundation_UserDefaults_Tests {
    let ud = UserDefaults.testSuite
    
    init() throws {
        // since we are accessing actual UserDefaults for these tests,
        // we need to ensure resiliency and do not mutate them
        
        // using a custom volatile domain should keep tests isolated
        
        // just in case, remove suite in case it wasn't cleaned up properly
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
    
    @Test
    func optionalGetters() {
        // push sample data to volatile user defaults
        
        // prep sample key/value data
        
        let dict: [String: Any] = [
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
        
        #expect(ud.integerOptional(forKey: "someInt") == 123)
        #expect(ud.doubleOptional(forKey: "someDouble") == 123.456)
        #expect(ud.floatOptional(forKey: "someFloat") == 0.123456)
        #expect(ud.boolOptional(forKey: "someBool") == true)
        
        // non-existent values
        
        #expect(ud.integerOptional(forKey: "does_not_exist") == nil)
        #expect(ud.doubleOptional(forKey: "does_not_exist") == nil)
        #expect(ud.floatOptional(forKey: "does_not_exist") == nil)
        #expect(ud.boolOptional(forKey: "does_not_exist") == nil)
        
        // key exists?
        #expect(ud.exists(key: "someInt"))
        #expect(ud.exists(key: "someDouble"))
        #expect(ud.exists(key: "someFloat"))
        #expect(ud.exists(key: "someBool"))
        #expect(!ud.exists(key: "does_not_exist"))
    }
    
    @Test
    func userDefaultsStorage_Defaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "defaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref = 2
        }
        
        var dummyPrefs = DummyPrefs()
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 2)
        #expect(dummyPrefs.pref == 2)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
    }
    
    @Test
    func userDefaultsStorage_Defaulted_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "defaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref = 2
        }
        
        // set a pre-existing value
        ud.set(6, forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
    }
    
    @Test
    func userDefaultsStorage_NonDefaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: String?
        }
        
        var dummyPrefs = DummyPrefs()
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
        
        dummyPrefs.pref = "A String"
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "A String")
        #expect(dummyPrefs.pref == "A String")
        #expect(dummyPrefs.pref! == "A String") // proves it's an Optional type
        
        dummyPrefs.pref = nil
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
    }
    
    @Test
    func userDefaultsStorage_NonDefaulted_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: String?
        }
        
        // set a pre-existing value
        ud.set("Pre-Existing String", forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "Pre-Existing String")
        #expect(dummyPrefs.pref == "Pre-Existing String")
        
        dummyPrefs.pref = "A String"
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "A String")
        #expect(dummyPrefs.pref == "A String")
        #expect(dummyPrefs.pref! == "A String") // proves it's an Optional type
        
        dummyPrefs.pref = nil
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
    }
    
    @Test
    func userDefaultsStorage_Defaulted_Clamped_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "clampedPref"
            
            @UserDefaultsStorage(key: prefKey, clamped: 5 ... 10, storage: .testSuite)
            var pref = 1
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value clamped
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 2
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
            
        dummyPrefs.pref = 5
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 6
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 10
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
        
        dummyPrefs.pref = 11
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
    }
    
    @Test
    func userDefaultsStorage_Defaulted_Clamped_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "clampedPref"
            
            @UserDefaultsStorage(key: prefKey, clamped: 5 ... 10, storage: .testSuite)
            var pref = 1
        }
        
        // set a pre-existing value
        ud.set(15, forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value clamped
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
        
        dummyPrefs.pref = 2
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 5
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 6
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 10
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
        
        dummyPrefs.pref = 11
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
    }
    
    @Test
    func userDefaultsStorage_Defaulted_Validated_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "validatedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                validation: { $0.clamped(to: 5 ... 10) },
                storage: .testSuite
            )
            var pref = 1
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value clamped
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 2
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 5
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 6
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 10
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
        
        dummyPrefs.pref = 11
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
    }
    
    @Test
    func userDefaultsStorage_Defaulted_Validated_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "validatedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                validation: { $0.clamped(to: 5 ... 10) },
                storage: .testSuite
            )
            var pref = 1
        }
        
        // set a pre-existing value
        ud.set(15, forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value validated
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
        
        dummyPrefs.pref = 2
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 5
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 5)
        #expect(dummyPrefs.pref == 5)
        
        dummyPrefs.pref = 6
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 10
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
        
        dummyPrefs.pref = 11
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 10)
        #expect(dummyPrefs.pref == 10)
    }
    
    @Test
    func userDefaultsStorage_Defaulted_GetSet_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "transformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 < 5 ? "\($0)" : nil },
                storage: .testSuite
            )
            var pref: Int = 1
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 1)
        #expect(dummyPrefs.pref == 1)
        
        dummyPrefs.pref = 2
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 2)
        #expect(dummyPrefs.pref == 2)
        
        dummyPrefs.pref = 10
        
        // reverts to default since value of 10 will return nil from set closure
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 1)
        #expect(dummyPrefs.pref == 1)
    }
    
    @Test
    func userDefaultsStorage_Defaulted_GetSet_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "transformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 < 8 ? "\($0)" : nil },
                storage: .testSuite
            )
            var pref: Int = 1
        }
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
    }
    
    @Test
    func userDefaultsStorage_NonDefaulted_GetSet_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedTransformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 != nil ? "\($0!)" : nil },
                storage: .testSuite
            )
            var pref: Int?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
        
        dummyPrefs.pref = 2
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == 2)
        #expect(dummyPrefs.pref == 2)
        
        dummyPrefs.pref = nil
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
    }
    
    @Test
    func userDefaultsStorage_NonDefaulted_GetSet_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "nonDefaultedTransformedPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { Int($0) },
                set: { $0 != nil ? "\($0!)" : nil },
                storage: .testSuite
            )
            var pref: Int?
        }
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integer(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
    }
    
    @Test
    func userDefaultsStorage_ComputedOnly_Generic() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyPref"
            
            // not used, just here to see if this alternate syntax compiles
            @UserDefaultsStorage<Int, String>(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? 0 : 0 },
                set: { "\($0)" },
                storage: .testSuite
            )
            private var pref1: Int
            
            // not used, just here to see if this alternate syntax compiles
            @UserDefaultsStorage(
                key: prefKey,
                get: { (storedValue: String?) in
                    storedValue != nil ? Int(storedValue!) ?? 0 : 0
                },
                set: { (newValue: Int) -> String in "\(newValue)" },
                storage: .testSuite
            )
            private var pref2: Int
        }
        
        _ = DummyPrefs() // forces property wrappers to init
    }
    
    @Test
    func userDefaultsStorage_ComputedOnly_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0)" },
                storage: .testSuite
            )
            var pref: Int
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == -1)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
    }
    
    @Test
    func userDefaultsStorage_ComputedOnly_Optional_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyOptionalPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0 ?? -1)" },
                storage: .testSuite
            )
            var pref: Int?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == -1)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
        
        dummyPrefs.pref = nil
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == -1)
    }
    
    @Test
    func userDefaultsStorage_ComputedOnly_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0)" },
                storage: .testSuite
            )
            var pref: Int
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        // default value
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
    }
    
    @Test
    func userDefaultsStorage_ComputedOnly_Optional_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "computedOnlyOptionalPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { $0 != nil ? Int($0!) ?? -1 : -1 },
                set: { "\($0 ?? -1)" },
                storage: .testSuite
            )
            var pref: Int?
            
            @UserDefaultsStorage(
                key: "myPref",
                get: { Int($0 ?? "") ?? 0 },
                set: { "\($0)" },
                storage: .testSuite
            )
            var myPref: Int
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set("6", forKey: DummyPrefs.prefKey)
        
        // default value
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == 6)
        #expect(dummyPrefs.pref == 6)
        
        dummyPrefs.pref = 4
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == 4)
        #expect(dummyPrefs.pref == 4)
        
        dummyPrefs.pref = nil
        
        #expect(ud.integerOptional(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == -1)
    }
    
    @Test
    func userDefaultsStorage_ComputedOnly_URL_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(
                key: prefKey,
                get: { storedValue in
                    if let storedValue {
                        return URL(fileURLWithPath: storedValue)
                    } else {
                        return URL(fileURLWithPath: "/default")
                    }
                },
                set: { newValue in
                    newValue.path
                },
                storage: .testSuite
            )
            var pref: URL
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(dummyPrefs.pref.absoluteString == "file:///default")
        
        // set raw value
        ud.set("/Some/Path/file.txt", forKey: DummyPrefs.prefKey)
        #expect(dummyPrefs.pref.absoluteString == "file:///Some/Path/file.txt")
        
        // set using property wrapper
        dummyPrefs.pref = URL(fileURLWithPath: "/New/Path/newfile.txt")
        #expect(dummyPrefs.pref.absoluteString == "file:///New/Path/newfile.txt")
    }
    
    // MARK: URL
    
    @Test
    func userDefaultsStorage_URL_Defaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: URL = URL(fileURLWithPath: "/")
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "file:///")
        #expect(dummyPrefs.pref == URL(fileURLWithPath: "/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "https://www.google.com/test")
        #expect(dummyPrefs.pref == URL(string: "https://www.google.com/test")!)
    }
    
    @Test
    func userDefaultsStorage_URL_Defaulted_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: URL = URL(fileURLWithPath: "/")
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set(URL(fileURLWithPath: "/test/").absoluteString, forKey: DummyPrefs.prefKey)
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "file:///test/")
        #expect(dummyPrefs.pref == URL(fileURLWithPath: "/test/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "https://www.google.com/test")
        #expect(dummyPrefs.pref == URL(string: "https://www.google.com/test")!)
    }
    
    @Test
    func userDefaultsStorage_URL_NonDefaulted_Optional_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: URL?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
        
        dummyPrefs.pref = URL(fileURLWithPath: "/")
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "file:///")
        #expect(dummyPrefs.pref == URL(fileURLWithPath: "/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "https://www.google.com/test")
        #expect(dummyPrefs.pref == URL(string: "https://www.google.com/test")!)
        
        dummyPrefs.pref = nil
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
    }
    
    @Test
    func userDefaultsStorage_URL_NonDefaulted_Optional_HasPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "urlPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: URL?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // set a pre-existing value
        ud.set(URL(fileURLWithPath: "/test/").absoluteString, forKey: DummyPrefs.prefKey)
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "file:///test/")
        #expect(dummyPrefs.pref == URL(fileURLWithPath: "/test/"))
        
        dummyPrefs.pref = URL(fileURLWithPath: "/")
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "file:///")
        #expect(dummyPrefs.pref == URL(fileURLWithPath: "/"))
        
        dummyPrefs.pref = URL(string: "https://www.google.com/test")!
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "https://www.google.com/test")
        #expect(dummyPrefs.pref == URL(string: "https://www.google.com/test")!)
        
        dummyPrefs.pref = nil
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
    }
    
    // MARK: Date
    
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *) // needed for Date.advanced(by:)
    @Test
    func userDefaultsStorage_Date_Defaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "datePref"
            
            static let date = Date()
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: Date = date
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.value(forKey: DummyPrefs.prefKey) as? Date == DummyPrefs.date)
        #expect(dummyPrefs.pref == DummyPrefs.date)
        
        dummyPrefs.pref = DummyPrefs.date.advanced(by: 10)
        
        #expect(ud.value(forKey: DummyPrefs.prefKey) as? Date == DummyPrefs.date.advanced(by: 10))
        #expect(dummyPrefs.pref == DummyPrefs.date.advanced(by: 10))
    }
    
    // MARK: Double
    
    @Test
    func userDefaultsStorage_Double_Defaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "doublePref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: Double = 2.0
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.double(forKey: DummyPrefs.prefKey) == 2.0)
        #expect(dummyPrefs.pref == 2.0)
        
        dummyPrefs.pref = 5.0
        
        #expect(ud.double(forKey: DummyPrefs.prefKey) == 5.0)
        #expect(dummyPrefs.pref == 5.0)
    }
    
    // MARK: Float
    
    @Test
    func userDefaultsStorage_Float_Defaulted_NoPreviousValue() {
        struct DummyPrefs {
            static let prefKey = "floatPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: Float = 2.0
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.float(forKey: DummyPrefs.prefKey) == 2.0)
        #expect(dummyPrefs.pref == 2.0)
        
        dummyPrefs.pref = 5.0
        
        #expect(ud.float(forKey: DummyPrefs.prefKey) == 5.0)
        #expect(dummyPrefs.pref == 5.0)
    }
    
    // MARK: Codable
    
    @Test
    func userDefaultsStorage_Codable_NonDefaulted_Optional_NoPreviousValue() {
        struct Prefs: Codable, Equatable {
            var someString: String
            var someInt: Int
            var array: [String]
            var dict: [String: String]
            var nestedStruct: NestedStruct
            
            struct NestedStruct: Codable, Equatable {
                var nestedInt: Int
                var nestedString: String
            }
        }
        
        struct DummyPrefs {
            static let prefKey = "codablePref"
            static let prefsTemplate = Prefs(
                someString: "hello",
                someInt: 123,
                array: ["one", "two"],
                dict: ["Key1": "ValA", "Key2": "ValB"],
                nestedStruct: .init(nestedInt: 456, nestedString: "test")
            )
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: Prefs?
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
        
        dummyPrefs.pref = DummyPrefs.prefsTemplate
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) != nil)
        #expect(dummyPrefs.pref == DummyPrefs.prefsTemplate)
        
        dummyPrefs.pref = nil
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
    }
    
    @Test
    func userDefaultsStorage_Codable_Defaulted_NoPreviousValue() {
        struct Prefs: Codable, Equatable {
            var someString: String
            var someInt: Int
            var array: [String]
            var dict: [String: String]
            var nestedStruct: NestedStruct
            
            struct NestedStruct: Codable, Equatable {
                var nestedInt: Int
                var nestedString: String
            }
        }
        
        struct DummyPrefs {
            static let prefKey = "codablePref"
            static let prefsTemplate = Prefs(
                someString: "hello",
                someInt: 123,
                array: ["one", "two"],
                dict: ["Key1": "ValA", "Key2": "ValB"],
                nestedStruct: .init(nestedInt: 456, nestedString: "test")
            )
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: Prefs = prefsTemplate
        }
        
        var dummyPrefs = DummyPrefs()
        
        // default value
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == DummyPrefs.prefsTemplate)
        
        dummyPrefs.pref = DummyPrefs.prefsTemplate
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) != nil)
        #expect(dummyPrefs.pref == DummyPrefs.prefsTemplate)
    }
    
    /// Test that a primitive type that already conforms to Codable is stored normally and
    /// not by using the Codable inits on `@UserDefaultsStorage`.
    @Test
    func userDefaultsStorage_String_NonCodable() {
        struct DummyPrefs {
            static let prefKey = "stringPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: String = "A"
        }
        
        var dummyPrefs = DummyPrefs()
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "A")
        #expect(dummyPrefs.pref == "A")
        
        dummyPrefs.pref = "ABC"
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "ABC")
        #expect(dummyPrefs.pref == "ABC")
    }
    
    /// Test that a primitive type that already conforms to Codable is stored normally and
    /// not by using the Codable inits on `@UserDefaultsStorage`.
    @Test
    func userDefaultsStorage_String_Optional_NonCodable() {
        struct DummyPrefs {
            static let prefKey = "stringPref"
            
            @UserDefaultsStorage(key: prefKey, storage: .testSuite)
            var pref: String?
        }
        
        var dummyPrefs = DummyPrefs()
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == nil)
        #expect(dummyPrefs.pref == nil)
        
        dummyPrefs.pref = "ABC"
        
        #expect(ud.string(forKey: DummyPrefs.prefKey) == "ABC")
        #expect(dummyPrefs.pref == "ABC")
    }
}

#endif
