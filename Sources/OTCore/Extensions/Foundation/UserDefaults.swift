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
    @_disfavoredOverload
    public func integerOptional(forKey key: String) -> Int? {
        
        guard object(forKey: key) != nil else { return nil }
        return integer(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.double(forKey:)` method in an optional returning nil if the key doesn't exist.
    @_disfavoredOverload
    public func doubleOptional(forKey key: String) -> Double? {
        
        guard object(forKey: key) != nil else { return nil }
        return double(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.float(forKey:)` method in an optional returning nil if the key doesn't exist.
    @_disfavoredOverload
    public func floatOptional(forKey key: String) -> Float? {
        
        guard object(forKey: key) != nil else { return nil }
        return float(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.bool(forKey:)` method in an optional returning nil if the key doesn't exist.
    @_disfavoredOverload
    public func boolOptional(forKey key: String) -> Bool? {
        
        guard object(forKey: key) != nil else { return nil }
        return bool(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Returns `true` if the key exists.
    ///
    /// This method is only useful when you don't care about extracting a value from the key and merely want to check for the key's existence.
    @_disfavoredOverload
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
    
    private let processor: ((Value) -> Value)?
    
    public var wrappedValue: Value {
        
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            if let asOptional = newValue as? OTCoreOptional {
                if asOptional.isNone {
                    // we have to treat newValue == nil as a special case
                    // otherwise .setValue() will throw an exception
                    storage.removeObject(forKey: key)
                } else if let unwrappedNewValue = asOptional.asAny() as? Value {
                    let processedValue = process(unwrappedNewValue, processor: processor)
                    storage.setValue(processedValue, forKey: key)
                }
            } else {
                let processedValue = process(newValue, processor: processor)
                storage.setValue(processedValue, forKey: key)
            }
        }
        
    }
    
    private func process(_ value: Value,
                         processor: ((Value) -> Value)?) -> Value {
        
        if let processor = processor {
            return processor(value)
        } else {
            return value
        }
        
    }
    
    // MARK: Init
    
    public init(wrappedValue defaultValue: Value,
                key: String,
                storage: UserDefaults = .standard) {
        
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
        self.processor = nil
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
        
    }
    
    public init<R: RangeExpression>(wrappedValue defaultValue: Value,
                                    key: String,
                                    clamped range: R,
                                    storage: UserDefaults = .standard) where R.Bound == Value {
        
        self.key = key
        self.storage = storage
        
        let rangeBounds = range.getAbsoluteBounds()
        
        self.processor = {
            Clamped<Value>.clamping($0,
                                    min: rangeBounds.min,
                                    max: rangeBounds.max)
        }
        
        self.defaultValue = self.processor!(defaultValue)
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
        
    }
    
    public init(wrappedValue defaultValue: Value,
                key: String,
                validation closure: @escaping (Value) -> Value,
                storage: UserDefaults = .standard) {
        
        self.key = key
        self.storage = storage
        self.processor = closure
        self.defaultValue = closure(defaultValue)
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
        
    }
    
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {

    public init(key: String,
                storage: UserDefaults = .standard) {

        self.init(wrappedValue: nil,
                  key: key,
                  storage: storage)

    }
    
    public init(key: String,
                validation closure: @escaping (Value) -> Value,
                storage: UserDefaults = .standard) {
        
        self.init(wrappedValue: nil,
                  key: key,
                  validation: closure,
                  storage: storage)
        
    }
    
}

#endif
