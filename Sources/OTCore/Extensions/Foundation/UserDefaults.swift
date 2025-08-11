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

// MARK: - UserDefaults Storage PropertyWrappers

/// **OTCore:**
/// Read and write the value of a `UserDefaults` key.
///
/// If a defaults suite is not specified, `.standard` will be used.
///
/// If a default value is provided, the `Value` will be treated as a non-Optional with a default.
///
///     @UserDefaultsStorage(key: "myPref")
///     var myPref: Bool = true
///
/// If no default is provided, the `Value` will be treated as an Optional.
///
///     @UserDefaultsStorage(key: "myPref")
///     var myPref: Bool?
///
/// A different type than the underlying storage type can be used.
/// Both `get` and `set` closures allow for custom transform code.
/// If either closure returns nil, the default value of 1 will be used.
///
///     // Stored as a `String`, but the var is an `Int`.
///     // get closure: transform `String` into `Int`
///     // set closure: transform `Int` into `String`
///     @UserDefaultsStorage(
///         key: "myPref",
///         get: { Int($0) },
///         set: { "\($0)" }
///     )
///     var myPref: Int = 1
///
/// A non-defaulted declaration relies on the closures to process the values with no default.
///
///     // Stored as a `String`, but the var is an `Int`.
///     // get closure: transform `String?` into `Int`
///     // set closure: transform `Int` into `String`
///     @UserDefaultsStorage(
///         key: "myPref",
///         get: { Int($0 ?? "") ?? 0 },
///         set: { "\($0)" }
///     )
///     var myPref: Int
///
/// Additional conveniences are available through specific parameters.
///
/// A special value validation closure is available when the value type matches the stored value
/// type.
///
///     @UserDefaultsStorage(
///         key: "myPref",
///         validation: { $0.trimmingCharacters(in: .whitespaces) },
///     )
///     var pref = "  test  " // will be stored as "test"
///
/// A special value clamping closure is available when the value type matches the stored value
/// type. Any types (not just integers) that can form a range can be clamped.
///
///     @UserDefaultsStorage(key: "myPref", clamped: 5 ... 10)
///     var pref = 1 // will be clamped to 5
///
@propertyWrapper
public struct UserDefaultsStorage<Value, StorageValue>: @unchecked Sendable where StorageValue: UserDefaultsStorable {
    private let key: String
    private let defaultValue: () -> Value
    public let storage: UserDefaults
    
    private let getTransformation: (_ storedValue: StorageValue) -> Value?
    private let setTransformation: (_ newValue: Value) -> StorageValue?
    
    private let computedOnly: Bool
    private let getTransformationComputedOnly: (_ storedValue: StorageValue?) -> Value
    private let setTransformationComputedOnly: (_ newValue: Value) -> StorageValue
    
    // note: "defaultValue as! Value" is guaranteed to work because it's only used
    // where the value is known to be of type Value.
    // it's an unfortunate workaround that defaultValue is Any but it allows us to
    // build this big beautiful single propertyWrapper with multiple uses
    // instead of having to split it up into multiple different structs.
    public var wrappedValue: Value {
        get {
            var value: StorageValue?
            if !computedOnly, Value.self is URL.Type || Value.self is URL?.Type,
               let strValue = storage.string(forKey: key)
            {
                value = URL(string: strValue) as? StorageValue
            } else {
                value = storage.value(forKey: key) as? StorageValue
            }
            if computedOnly {
                return getTransformationComputedOnly(value)
            }
            guard let value = value else {
                return defaultValue()
            }
            let processed = getTransformation(value)
            return processed ?? defaultValue()
        }
        set {
            var processedValue: StorageValue?
            
            if let asOptional = newValue as? OTCoreOptional {
                if asOptional.isNone {
                    // we have to treat newValue == nil as a special case
                    // otherwise .setValue() will throw an exception
                    storage.removeObject(forKey: key)
                    return
                } else if let unwrappedNewValue = asOptional.asAny() as? Value {
                    if computedOnly {
                        processedValue = setTransformationComputedOnly(unwrappedNewValue)
                    } else {
                        processedValue = setTransformation(unwrappedNewValue)
                    }
                }
            } else {
                if computedOnly {
                    processedValue = setTransformationComputedOnly(newValue)
                } else {
                    processedValue = setTransformation(newValue)
                        ?? setTransformation(defaultValue())
                }
            }
            
            if let processedValue = processedValue as? URL {
                storage.setValue(processedValue.absoluteString, forKey: key)
            } else {
                storage.setValue(processedValue, forKey: key)
            }
        }
    }
    
    // MARK: Init - Same Type
    
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        storage: UserDefaults = .standard
    ) where Value == StorageValue {
        self.defaultValue = { defaultValue }
        self.key = key
        self.storage = storage
        
        // not used
        getTransformation = { $0 }
        setTransformation = { $0 }
        computedOnly = false
        getTransformationComputedOnly = { _ in defaultValue }
        setTransformationComputedOnly = { $0 }
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
    
    public init<R: RangeExpression>(
        wrappedValue defaultValue: Value,
        key: String,
        clamped range: R,
        storage: UserDefaults = .standard
    ) where Value == StorageValue, Value: Strideable, R.Bound == Value {
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
        self.defaultValue = { closure(defaultValue) }
        
        // not used
        computedOnly = false
        getTransformationComputedOnly = { _ in defaultValue }
        setTransformationComputedOnly = { $0 }
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
    
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        validation closure: @escaping (_ value: Value) -> Value,
        storage: UserDefaults = .standard
    ) where Value == StorageValue {
        self.key = key
        self.storage = storage
        
        // not used
        getTransformation = closure
        setTransformation = closure
        computedOnly = false
        getTransformationComputedOnly = { _ in defaultValue }
        setTransformationComputedOnly = { $0 }
        
        // validate initial value
        self.defaultValue = { closure(defaultValue) }
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
    
    // MARK: Init - Same Type Codable
    
    /// Store and retrieve any object conforming to `Codable` by using JSON serialization and storing as `String` in UserDefaults.
    @_disfavoredOverload
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        storage: UserDefaults = .standard
    ) where Value: Codable, StorageValue == String {
        self.defaultValue = { defaultValue }
        self.key = key
        self.storage = storage
        
        getTransformation = { storedValue in
            let decoder = JSONDecoder()
            guard let data = storedValue.data(using: .utf8),
                  let decoded = try? decoder.decode(Value.self, from: data)
            else { return nil }
            return decoded
        }
        setTransformation = { newValue in
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(newValue),
                  let string = encoded.toString(using: .utf8)
            else { return nil }
            return string
        }
        
        // not used
        computedOnly = false
        getTransformationComputedOnly = { _ in defaultValue }
        setTransformationComputedOnly = { _ in "" }
    }
    
    // MARK: - Different Types
    
    /// Uses get and set transform closures to allow a value to have a different underlying storage
    /// type.
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        get getTransformation: @escaping (_ storedValue: StorageValue) -> Value?,
        set setTransformation: @escaping (_ newValue: Value) -> StorageValue?,
        storage: UserDefaults = .standard
    ) {
        self.key = key
        self.storage = storage
        self.getTransformation = getTransformation
        self.setTransformation = setTransformation
        self.defaultValue = { defaultValue }
        
        // not used
        computedOnly = false
        getTransformationComputedOnly = { _ in defaultValue }
        setTransformationComputedOnly = { setTransformation($0)! }
        
        // update stored value
        let readValue = wrappedValue
        wrappedValue = readValue
    }
    
    /// Uses get and set transform closures to allow a value to have a different underlying storage
    /// type.
    public init(
        key: String,
        get getTransformation: @escaping (_ storedValue: StorageValue?) -> Value,
        set setTransformation: @escaping (_ newValue: Value) -> StorageValue,
        storage: UserDefaults = .standard
    ) {
        computedOnly = true
        
        self.key = key
        self.storage = storage
        self.getTransformationComputedOnly = getTransformation
        self.setTransformationComputedOnly = setTransformation
        
        // not used
        self.getTransformation = { _ in nil }
        self.setTransformation = { _ in nil }
        // safe because we ensure to not use this property when computedOnly == true
        self.defaultValue = { fatalError() }
    }
}

extension UserDefaultsStorage where Value: ExpressibleByNilLiteral {
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
        validation closure: @escaping (_ value: Value) -> Value,
        storage: UserDefaults = .standard
    ) where Value == StorageValue {
        self.init(
            wrappedValue: nil,
            key: key,
            validation: closure,
            storage: storage
        )
    }
    
    // MARK: Init - Same Type Codable
    
    /// Store and retrieve any object conforming to `Codable` by using JSON serialization and storing as `String` in UserDefaults.
    @_disfavoredOverload
    public init(
        key: String,
        storage: UserDefaults = .standard
    ) where Value: Codable, StorageValue == String {
        self.init(
            wrappedValue: nil,
            key: key,
            storage: storage
        )
    }
    
    // MARK: - Different Types
    
    /// Uses get and set transform closures to allow a value to have a different underlying storage
    /// type.
    public init(
        key: String,
        get getTransformation: @escaping (_ storedValue: StorageValue) -> Value?,
        set setTransformation: @escaping (_ newValue: Value) -> StorageValue?,
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

// MARK: - UserDefaults Compatible Storage Types

public protocol UserDefaultsStorable where Self: Sendable { }

extension String: UserDefaultsStorable { }
extension Int: UserDefaultsStorable { }
extension Float: UserDefaultsStorable { }
extension Double: UserDefaultsStorable { }
extension Data: UserDefaultsStorable { }
extension Date: UserDefaultsStorable { }
extension Bool: UserDefaultsStorable { }
extension URL: UserDefaultsStorable { }
extension Array: UserDefaultsStorable where Element: UserDefaultsStorable { }
extension Dictionary: UserDefaultsStorable where Key == String, Value: UserDefaultsStorable { }
extension Optional: UserDefaultsStorable where Wrapped: UserDefaultsStorable { }

// extension NSString: UserDefaultsStorable { }
// extension NSData: UserDefaultsStorable { }
// extension NSDate: UserDefaultsStorable { }
// extension NSNumber: UserDefaultsStorable { }
// extension NSArray: UserDefaultsStorable { }
// extension NSDictionary: UserDefaultsStorable { }

#endif
