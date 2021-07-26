//
//  NSArray.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension NSArray {
    
    /// **OTCore:**
    /// Access collection indexes safely.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3] as NSArray
    ///     arr[safe: 0] // Optional(1)
    ///     arr[safe: 9] // nil
    ///
    open subscript(safe index: Int) -> Any? {
        
        (0..<count).contains(index) ? self[index] : nil
        
    }
    
}

extension NSMutableArray {
    
    /// **OTCore:**
    /// Access collection indexes safely.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3] as NSMutableArray
    ///     arr[safeMutable: 0] // Optional(1)
    ///     arr[safeMutable: 9] // nil
    ///
    open subscript(safeMutable index: Int) -> Any? {
        
        get {
            (0..<count).contains(index) ? self[index] : nil
        }
        set {
            guard (0..<count).contains(index) else { return }
            
            self[index] = newValue!
        }
        
    }
    
}

#endif
