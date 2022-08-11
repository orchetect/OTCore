//
//  Clamped Property Wrapper.swift
//  OTCore • https://github.com/orchetect/OTCore
//

import Foundation

/// **OTCore:**
/// Property wrapper that clamps the wrapped value to a given range.
@propertyWrapper
public struct Clamped<Value> where Value: Comparable {
    var min: Value?
    var max: Value?
    private var value: Value
    
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = Self.clamping(newValue, min: min, max: max)
        }
    }
    
    internal static func clamping(
        _ value: Value,
        min: Value?,
        max: Value?
    ) -> Value {
        if let min = min {
            if let max = max {
                return value.clamped(to: min ... max)
            } else {
                return value.clamped(to: min...)
            }
        } else if let max = max {
            return value.clamped(to: ...max)
        } else {
            return value
        }
    }
    
    public init(
        wrappedValue defaultValue: Value,
        to range: ClosedRange<Value>
    ) {
        let formRange = range.absoluteBounds
        
        self.min = formRange.min
        self.max = formRange.max
        
        value = Self.clamping(
            defaultValue,
            min: formRange.min,
            max: formRange.max
        )
    }
    
    public init(
        wrappedValue defaultValue: Value,
        to range: Range<Value>
    ) where Value: Strideable {
        let formRange = range.absoluteBounds
        
        self.min = formRange.min
        self.max = formRange.max
        
        value = Self.clamping(
            defaultValue,
            min: formRange.min,
            max: formRange.max
        )
    }
    
    public init(
        wrappedValue defaultValue: Value,
        to range: PartialRangeUpTo<Value>
    ) where Value: Strideable {
        let formRange = range.absoluteBounds
        
        self.min = formRange.min
        self.max = formRange.max
        
        value = Self.clamping(
            defaultValue,
            min: formRange.min,
            max: formRange.max
        )
    }
    
    public init(
        wrappedValue defaultValue: Value,
        to range: PartialRangeThrough<Value>
    ) {
        let formRange = range.absoluteBounds
        
        self.min = formRange.min
        self.max = formRange.max
        
        value = Self.clamping(
            defaultValue,
            min: formRange.min,
            max: formRange.max
        )
    }
    
    public init(
        wrappedValue defaultValue: Value,
        to range: PartialRangeFrom<Value>
    ) {
        let formRange = range.absoluteBounds
        
        self.min = formRange.min
        self.max = formRange.max
        
        value = Self.clamping(
            defaultValue,
            min: formRange.min,
            max: formRange.max
        )
    }
}
