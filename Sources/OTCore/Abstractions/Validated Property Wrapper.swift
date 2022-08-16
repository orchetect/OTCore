//
//  Validated Property Wrapper.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// **OTCore:**
/// Validated property wrapper.
/// Passes new value through the validation closure before storing.
@propertyWrapper
public struct Validated<Value> {
    private var value: Value
    private var validationClosure: (Value) -> Value
    
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = validationClosure(newValue)
        }
    }
    
    public init(
        wrappedValue defaultValue: Value,
        _ validationClosure: @escaping (Value) -> Value
    ) {
        self.validationClosure = validationClosure
        value = validationClosure(defaultValue)
    }
}
