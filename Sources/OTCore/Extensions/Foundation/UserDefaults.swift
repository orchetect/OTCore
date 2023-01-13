//
//  UserDefaults.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
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
public struct UserDefaultsBacked<Value, StorageValue> {
    private let key: String
    private let defaultValue: Value
    public var storage: UserDefaults
    
    private let getTransformation: ((StorageValue) -> Value?)
    private let setTransformation: ((Value) -> StorageValue?)
    
    public var wrappedValue: Value {
        get {
            guard let value = storage.value(forKey: key) as? StorageValue else {
                return defaultValue
            }
            let processed = process(value)
            return processed ?? defaultValue
        }
        set {
            if let asOptional = newValue as? OTCoreOptional {
                if asOptional.isNone {
                    // we have to treat newValue == nil as a special case
                    // otherwise .setValue() will throw an exception
                    storage.removeObject(forKey: key)
                } else if let unwrappedNewValue = asOptional.asAny() as? Value {
                    let processedValue = process(unwrappedNewValue)
                    storage.setValue(processedValue, forKey: key)
                }
            } else {
                let processedValue = process(newValue) ?? process(defaultValue)
                storage.setValue(processedValue, forKey: key)
            }
        }
    }
    
    private func process(_ value: StorageValue) -> Value? {
        getTransformation(value)
    }
    
    private func process(_ value: Value) -> StorageValue? {
        setTransformation(value)
    }
    
    // MARK: Init - Same Type
    
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        storage: UserDefaults = .standard
    ) where Value == StorageValue {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
        
        // not used
        getTransformation = { $0 }
        setTransformation = { $0 }
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
    
    public init<R: RangeExpression>(
        wrappedValue defaultValue: Value,
        key: String,
        clamped range: R,
        storage: UserDefaults = .standard
    ) where Value == StorageValue, R.Bound == Value {
        self.key = key
        self.storage = storage
        
        let rangeBounds = range.getAbsoluteBounds()
        
        let closure: (Value) -> Value = {
            Clamped<Value>.clamping(
                $0,
                min: rangeBounds.min,
                max: rangeBounds.max
            )
        }
        
        getTransformation = closure
        setTransformation = closure
        
        // clamp initial value
        self.defaultValue = closure(defaultValue)
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
    
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        validation closure: @escaping (Value) -> Value,
        storage: UserDefaults = .standard
    ) where Value == StorageValue {
        self.key = key
        self.storage = storage
        
        // not used
        getTransformation = closure
        setTransformation = closure
        
        // validate initial value
        self.defaultValue = closure(defaultValue)
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
    
    // MARK: - Different Types
    
    /// Uses get and set transform closures to allow a value to have a different underlying storage
    /// type.
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        get getTransformation: @escaping (StorageValue) -> Value?,
        set setTransformation: @escaping (Value) -> StorageValue?,
        storage: UserDefaults = .standard
    ) {
        self.key = key
        self.storage = storage
        self.getTransformation = getTransformation
        self.setTransformation = setTransformation
        self.defaultValue = defaultValue
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    // MARK: Init - Same Type
    
    public init(
        key: String,
        storage: UserDefaults = .standard
    ) where Value == StorageValue {
        self.init(
            wrappedValue: nil,
            key: key,
            storage: storage
        )
    }
    
    public init(
        key: String,
        validation closure: @escaping (Value) -> Value,
        storage: UserDefaults = .standard
    ) where Value == StorageValue {
        self.init(
            wrappedValue: nil,
            key: key,
            validation: closure,
            storage: storage
        )
    }
    
    // MARK: - Different Types
    
    /// Uses get and set transform closures to allow a value to have a different underlying storage
    /// type.
    public init(
        key: String,
        get getTransformation: @escaping (StorageValue) -> Value?,
        set setTransformation: @escaping (Value) -> StorageValue?,
        storage: UserDefaults = .standard
    ) {
        self.init(
            wrappedValue: nil,
            key: key,
            get: getTransformation,
            set: setTransformation,
            storage: storage
        )
    }
}

#endif
