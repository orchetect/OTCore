//
//  UserDefaults.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension UserDefaults {
    
    // custom optional methods for core data types that don't intrinsically support optionals yet
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.integer(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func integerOptional(forKey key: String) -> Int? {
        
        guard object(forKey: key) != nil else { return nil }
        return integer(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.double(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func doubleOptional(forKey key: String) -> Double? {
        
        guard object(forKey: key) != nil else { return nil }
        return double(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.float(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func floatOptional(forKey key: String) -> Float? {
        
        guard object(forKey: key) != nil else { return nil }
        return float(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.bool(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func boolOptional(forKey key: String) -> Bool? {
        
        guard object(forKey: key) != nil else { return nil }
        return bool(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Returns `true` if the key exists.
    ///
    /// This method is only useful when you don't care about extracting a value from the key and merely want to check for the key's existence.
    public func exists(key: String) -> Bool {
        
        object(forKey: key) != nil
        
    }
    
}

// MARK: - Backed PropertyWrappers

/// **OTCore:**
/// Read and write the value of a `UserDefaults` key.
///
/// If a default value is provided, the `Value` will be treated as a non-Optional.
///
///     @UserDefaultsBacked(key: "myPref")
///     var myPref = true
///
/// If no default is provided, the `Value` will be treated as an Optional.
///
///     @UserDefaultsBacked(key: "myPref")
///     var myPref: Bool?
///
/// If a defaults suite is not specified, `.standard` will be used.
@propertyWrapper
public struct UserDefaultsBacked<Value> {
    
    private let key: String
    private let defaultValue: Value
    public var storage: UserDefaults
    
    public var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            // we have to treat newValue == nil as a special case
            // otherwise .setValue() will throw an exception
            
            if let asOptional = newValue as? OTCoreOptional,
               asOptional.isNone {
                storage.removeObject(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
    
    public init(wrappedValue defaultValue: Value,
                key: String,
                storage: UserDefaults = .standard) {
        
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
        
    }
    
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {

    public init(key: String,
                storage: UserDefaults = .standard) {

        self.init(wrappedValue: nil,
                  key: key,
                  storage: storage)

    }
    
}

#endif
