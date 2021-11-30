//
//  Optional.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - OptionalType

/// **OTCore:**
/// Protocol describing an optional, used to enable extensions on types such as `Type<T>?`.
public protocol OptionalType {
    
    associatedtype Wrapped

    /// **OTCore:**
    /// Semantic workaround used to enable extensions on types such as `Type<T>?
    @inlinable var optional: Wrapped? { get }
    
}

extension OptionalType {
    
    /// **OTCore:**
    /// Internal use.
    @inlinable
    internal static var _none: Optional<Wrapped> { .none }
    
}

extension Optional: OptionalType {
    
    @inlinable public var optional: Wrapped? {
        
        self
        
    }
    
}


// MARK: - .ifNil(_:)

extension Optional {
    
    /// **OTCore:**
    /// Same as `self ?? defaultValue`
    /// (Functional convenience method)
    @inlinable public func ifNil(_ defaultValue: Wrapped) -> Wrapped {
        
        self ?? defaultValue
        
    }
    
}
