//
//  Optional.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - OTCoreOptionalTyped

/// **OTCore:**
/// Protocol describing an optional, used to enable extensions on types such as `Type<T>?`.
public protocol OTCoreOptionalTyped {
    associatedtype Wrapped
    
    /// **OTCore:**
    /// Semantic workaround used to enable extensions on types such as `Type<T>?
    @inlinable @_disfavoredOverload
    var optional: Wrapped? { get set }
}

extension OTCoreOptionalTyped {
    /// **OTCore:**
    /// Same as `Wrapped?.none`.
    @inlinable @_disfavoredOverload
    public static var noneValue: Wrapped? {
        .none
    }
}

extension Optional: OTCoreOptionalTyped {
    @inlinable @_disfavoredOverload
    public var optional: Wrapped? {
        get { self }
        set { self = newValue }
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
    @_disfavoredOverload
    func asAny() -> Any?
    
    /// **OTCore:**
    /// Returns the wrapped type of an Optional.
    @_disfavoredOverload
    func wrappedType() -> Any.Type
    
    /// **OTCore:**
    /// Returns `true` if optional is `.none` (`nil`).
    @_disfavoredOverload
    var isNone: Bool { get }
}

extension Optional: OTCoreOptional {
    @_disfavoredOverload
    public func asAny() -> Any? {
        self as Any?
    }
    
    @_disfavoredOverload
    public func wrappedType() -> Any.Type {
        Wrapped.self
    }
    
    @inline(__always) @_disfavoredOverload
    public var isNone: Bool {
        self == nil
    }
}

// MARK: - .ifNil(_:)

extension Optional {
    /// **OTCore:**
    /// Same as `self ?? defaultValue`
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func ifNil(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }
}
