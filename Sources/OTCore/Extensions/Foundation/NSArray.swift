//
//  NSArray.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension NSArray {
    /// **OTCore:**
    /// Access collection indexes safely.
    ///
    /// > Note:
    /// > `NSArray/NSMutableArray` indexes are always zero-based and sequential (`0...`).
    /// > Therefore, a `[safePosition:]` subscript is unnecessary, as this subscript fills both roles.
    ///
    /// Example:
    ///
    /// ```swift
    /// let arr = [1, 2, 3] as NSArray
    /// arr[safe: 0] // Optional(1)
    /// arr[safe: 9] // nil
    /// ```
    @_disfavoredOverload
    public subscript(safe index: Int) -> Any? {
        (0 ..< count).contains(index) ? self[index] : nil
    }
}

extension NSMutableArray {
    /// **OTCore:**
    /// Access collection indexes safely.
    ///
    /// > Note:
    /// > `NSArray/NSMutableArray` indexes are always zero-based and sequential (`0...`).
    /// > Therefore, a `[safePosition:]` subscript is unnecessary, as this subscript fills both roles.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored.
    ///
    /// Example:
    ///
    /// ```swift
    /// let arr = [1, 2, 3] as NSMutableArray
    /// arr[safeMutable: 0] // Optional(1)
    /// arr[safeMutable: 9] // nil
    /// ```
    @_disfavoredOverload
    public subscript(safeMutable index: Int) -> Any? {
        get {
            (0 ..< count).contains(index) ? self[index] : nil
        }
        set {
            guard (0 ..< count).contains(index) else { return }
            
            // subscript getter and setter must be of the same type
            // (get is `Element?` so the set must also be `Element?`)
            
            // implementation makes it difficult or impossible to
            // allow setting an element to `nil` in a collection that contains Optionals,
            // because it's not easy to tell whether the collection contains Optionals or not,
            // so the best course of action is to not allow setting elements to `nil` at all.
            
            guard let valueToStore = newValue else {
                assertionFailure(
                    "Do not use [safe:] setter to set nil for elements on collections that contain Optionals. Setting nil has no effect."
                )
                return
            }
            
            self[index] = valueToStore
        }
        _modify {
            // this may never be executed, because
            // NSMutableArray seems to only support get and
            // set by assignment, not inline mutability.
            // however, Swift allows us to compile this code any way.
            
            guard (0 ..< count).contains(index) else {
                // _modify { } requires yield to be called, so we can't just return.
                // we have to allow the yield on a dummy variable first
                var dummy: Element?
                yield &dummy
                return
            }
            
            var valueForMutation: Element? = self[index]
            yield &valueForMutation
            
            // subscript getter and setter must be of the same type
            // (get is `Element?` so the set must also be `Element?`)
            
            // implementation makes it difficult or impossible to
            // allow setting an element to `nil` in a collection that contains Optionals,
            // because it's not easy to tell whether the collection contains Optionals or not,
            // so the best course of action is to not allow setting elements to `nil` at all.
            
            guard let valueToStore = valueForMutation else {
                assertionFailure(
                    "Do not use [safe:] setter to set nil for elements on collections that contain Optionals. Setting nil has no effect."
                )
                return
            }
            
            self[index] = valueToStore
        }
    }
}

#endif
