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
    public var successValue: Success? {
        
        guard case .success(let value) = self else { return nil }
        return value
        
    }
    
    /// **OTCore:**
    /// If `.failure` case, returns associated value unwrapped.
    public var failureValue: Failure? {
        
        guard case .failure(let value) = self else { return nil }
        return value
        
    }
    
    /// **OTCore:**
    /// Returns `true` if `.success(_)` case.
    /// Returns `false` if .`failure(_)` case.
    public var isSuccess: Bool {
        
        if case .success = self { return true }
        return false
        
    }
    
}
