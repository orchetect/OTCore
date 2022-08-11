//
//  Result.swift
//  OTCore • https://github.com/orchetect/OTCore
//

/// **OTCore:**
/// Generic alias for any `Result<,>` type.
public typealias AnyResult = Result<Any, Error>

extension Result {
    /// **OTCore:**
    /// If `.success` case, returns associated value unwrapped.
    @_disfavoredOverload
    public var successValue: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    /// **OTCore:**
    /// If `.failure` case, returns associated value unwrapped.
    @_disfavoredOverload
    public var failureValue: Failure? {
        guard case let .failure(value) = self else { return nil }
        return value
    }
    
    /// **OTCore:**
    /// Returns `true` if `.success(_)` case.
    /// Returns `false` if .`failure(_)` case.
    @_disfavoredOverload
    public var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
