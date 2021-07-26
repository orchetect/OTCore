//
//  Optional.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - OptionalType

/// **OTCore:**
/// Protocol describing an optional, so `.optional` is available on all Optionals.
/// Used to enable extensions on types such as `Type<T>?`.
public protocol OptionalType {
    
    associatedtype Wrapped
    
    /// **OTCore:**
    /// Return an object as an optional.
    @inlinable var optional: Wrapped? { get }
    
}

extension Optional: OptionalType {
    
    /// **OTCore:**
    /// Semantic workaround to make `.optional` available on all Optionals.
    /// Used to enable extensions on types such as `Type<T>?`.
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
