//
//  OTCore API 1.4.6.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - UserDefaults.swift

@available(*, unavailable, renamed: "UserDefaultsStorage")
@propertyWrapper
public struct UserDefaultsBacked<Value> {
    public var storage: UserDefaults
    public var wrappedValue: Value
    
    //public init(wrappedValue: Value) { fatalError() }
    
    //public init(key: String) { fatalError() }
    
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        storage: UserDefaults = .standard
    ) { fatalError() }
    
    public init<R: RangeExpression>(
        wrappedValue defaultValue: Value,
        key: String,
        clamped range: R,
        storage: UserDefaults = .standard
    ) where R.Bound == Value { fatalError() }
    
    public init(
        wrappedValue defaultValue: Value,
        key: String,
        validation closure: @escaping (Value) -> Value,
        storage: UserDefaults = .standard
    ) { fatalError() }
    
    /* extension UserDefaultsBacked where Value: ExpressibleByNilLiteral { */
    
    public init<V>(
        key: String,
        storage: UserDefaults = .standard
    ) where Value == V? { fatalError() }
    
    public init<V>(
        key: String,
        validation closure: @escaping (Value) -> Value,
        storage: UserDefaults = .standard
    ) where Value == V? { fatalError() }
}

#endif
