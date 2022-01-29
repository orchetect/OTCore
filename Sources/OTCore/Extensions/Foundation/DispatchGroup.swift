//
//  DispatchGroup.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension DispatchGroup {
    
    /// **OTCore:**
    /// A thin DispatchGroup wrapper that only publicly allows `leave()` to be called.
    /// Not meant to be instanced directly. Use `DispatchGroup.sync { }` instead.
    public class ThinDispatchGroup {
        
        fileprivate var group = DispatchGroup()
        private var leaveCalled = false
        
        fileprivate init() { }
        
        public func leave() {
            guard !leaveCalled else { return }
            leaveCalled = true
            group.leave()
        }
        
    }
    
    /// **OTCore:**
    /// Convenience DispatchGroup-wrapping method to run async code synchronously.
    /// You must call `.leave()` once within the body of the closure.
    ///
    /// Example:
    ///
    ///     DispatchGroup.sync { g in
    ///         someAsyncMethod {
    ///             g.leave()
    ///         }
    ///     }
    ///     print("someAsyncMethod is done.")
    public static func sync(
        _ block: (ThinDispatchGroup) -> Void
    ) {
        
        let g = ThinDispatchGroup()
        
        g.group.enter()
        block(g)
        
        g.group.wait()
        
    }
    
    /// **OTCore:**
    /// Convenience DispatchGroup-wrapping method to run async code synchronously with a timeout period.
    /// You must call `.leave()` once within the body of the closure.
    ///
    /// Example:
    ///
    ///     DispatchGroup.sync(timeout: .seconds(10)) { g in
    ///         someAsyncMethod {
    ///             g.leave()
    ///         }
    ///     }
    ///     print("someAsyncMethod is done or timed out.")
    @discardableResult
    public static func sync(
        timeout: DispatchTimeInterval,
        _ block: (ThinDispatchGroup) -> Void
    ) -> DispatchTimeoutResult {
        
        let g = ThinDispatchGroup()
        
        g.group.enter()
        block(g)
        
        let time = DispatchTime.now() + timeout
        return g.group.wait(timeout: time)
        
    }
    
}

extension DispatchGroup {
    
    /// **OTCore:**
    /// A result value indicating whether a dispatch operation finished before a specified time. If the operation succeeded, an associated result value is returned.
    public enum DispatchSyncTimeoutResult<T> {
        case success(T)
        case timedOut
    }
    
    /// **OTCore:**
    /// A thin DispatchGroup wrapper capable of returning a value, that only publicly allows `leave(withValue:)` to be called.
    /// Not meant to be instanced directly. Use `DispatchGroup.sync { }` instead.
    public class ThinReturnValueDispatchGroup<ReturnValue> {
        
        fileprivate var group = DispatchGroup()
        fileprivate var returnValue: ReturnValue!
        private var leaveCalled = false
        
        fileprivate init() { }
        
        public func leave(withValue: ReturnValue) {
            guard !leaveCalled else { return }
            leaveCalled = true
            returnValue = withValue
            group.leave()
        }
        
    }
    
    /// **OTCore:**
    /// Convenience DispatchGroup-wrapping method to run async code synchronously and return a value.
    /// You must call `.leave(withValue:)` once within the body of the closure.
    ///
    /// Example:
    ///
    ///     let returnValue = DispatchGroup.sync { g in
    ///         someAsyncMethod { someValue in
    ///             g.leave(withValue: someValue)
    ///         }
    ///     }
    ///     print(returnValue) // prints contents of someValue
    public static func sync<T>(
        _ block: (ThinReturnValueDispatchGroup<T>) -> Void
    ) -> T {
        
        let g = ThinReturnValueDispatchGroup<T>()
        
        g.group.enter()
        block(g)
        g.group.wait()
        
        return g.returnValue! // value is guaranteed non-nil
        
    }
    
    /// **OTCore:**
    /// Convenience DispatchGroup-wrapping method to run async code synchronously and return a value with a timeout period.
    /// You must call `.leave(withValue:)` once within the body of the closure.
    ///
    /// Example:
    ///
    ///     let returnValue = DispatchGroup.sync(timeout: .seconds: 10) { g in
    ///         someAsyncMethod { someValue in
    ///             g.leave(withValue: someValue)
    ///         }
    ///     }
    ///     switch returnValue {
    ///     case .success(value):
    ///         print(returnValue) // prints contents of someValue
    ///     case .timedOut:
    ///         // operation timed out
    ///     }
    ///
    public static func sync<T>(
        timeout: DispatchTimeInterval,
        _ block: (ThinReturnValueDispatchGroup<T>) -> Void
    ) -> DispatchSyncTimeoutResult<T> {
        
        let g = ThinReturnValueDispatchGroup<T>()
        
        g.group.enter()
        block(g)
        
        let time = DispatchTime.now() + timeout
        switch g.group.wait(timeout: time) {
        case .success:
            return .success(g.returnValue)
        case .timedOut:
            return .timedOut
        }
        
    }
    
}

#endif
