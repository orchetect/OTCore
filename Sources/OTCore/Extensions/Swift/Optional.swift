//
//  Optional.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - OTCoreOptionalTyped

/// **OTCore:**
/// Protocol describing an optional, used to enable extensions on types such as `Type<T>?`.
public protocol OTCoreOptionalTyped {
    
    associatedtype Wrapped

    /// **OTCore:**
    /// Semantic workaround used to enable extensions on types such as `Type<T>?
    @inlinable var optional: Wrapped? { get }
    
}

extension OTCoreOptionalTyped {
    
    /// **OTCore:**
    /// Same as `Wrapped?.none`.
    @inlinable
    public static var noneValue: Optional<Wrapped> { .none }
    
}

extension Optional: OTCoreOptionalTyped {
    
    @inlinable public var optional: Wrapped? {
        
        self
        
    }
    
}

// MARK: - OTCoreOptional

/// **OTCore:**
/// Protocol to allow conditional casting of an unknown type to an Optional.
///
/// First, conditionally cast `Any` as? `OTCoreOptional`:
///
///     let value: Any = Optional("Test")
///     guard let asOptional = value as? OTCoreOptional else { ... }
///
/// An easy way to test if the Optional is `nil`:
///
///     asOptional.isNone // false
///
/// Switch over wrapped concrete type:
///
///     switch asOptional.wrappedType() {
///     case is String.Type:
///         // case matches if wrapped type is String
///         // regardless whether it's .some() or nil
///     case is Int.Type:
///         // ...
///     }
///
/// Switch by conditionally casting concrete type, preserving the Optional:
///
///     switch asOptional {
///     case let string as String?:
///         // string == Optional("Test")
///     case let int as Int?:
///         // ...
///     }
///
/// Unwrap by switching:
///
///     switch asOptional {
///     case let string as String:
///         // string == "Test"
///     case let int as Int:
///         // ...
///     default:
///         // nil
///     }
///
/// Unwrap by `if let` binding:
///
///     if let string = asOptional.asAny() as? String {
///         // string == "Test" (unwrapped)
///     } else {
///         // nil
///     }
///
protocol OTCoreOptional {
    
    /// **OTCore:**
    /// Returns the optional Typed as `Any?`.
    func asAny() -> Any?
    
    /// **OTCore:**
    /// Returns the wrapped type of an Optional.
    func wrappedType() -> Any.Type
    
    /// **OTCore:**
    /// Returns `true` if optional is `.none` (`nil`).
    var isNone: Bool { get }
    
}

extension Optional: OTCoreOptional {
    public func asAny() -> Any? {
        self as Any?
    }
    
    public func wrappedType() -> Any.Type {
        Wrapped.self
    }
    
    public var isNone: Bool {
        self == nil
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
