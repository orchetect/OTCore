//
//  UserDefaults.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension UserDefaults {
    
    // custom optional methods for core data types that don't intrinsically support optionals yet
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.integer(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func integerOptional(forKey key: String) -> Int? {
        
        guard self.object(forKey: key) != nil else { return nil }
        return self.integer(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.double(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func doubleOptional(forKey key: String) -> Double? {
        
        guard self.object(forKey: key) != nil else { return nil }
        return self.double(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.float(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func floatOptional(forKey key: String) -> Float? {
        
        guard self.object(forKey: key) != nil else { return nil }
        return self.float(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Convenience method to wrap the built-in `.bool(forKey:)` method in an optional returning nil if the key doesn't exist.
    public func boolOptional(forKey key: String) -> Bool? {
        
        guard self.object(forKey: key) != nil else { return nil }
        return self.bool(forKey: key)
        
    }
    
    /// **OTCore:**
    /// Returns `true` if the key exists.
    ///
    /// This method is only useful when you don't care about extracting a value from the key and merely want to check for the key's existence.
    public func exists(key: String) -> Bool {
        
        self.object(forKey: key) != nil
        
    }
    
}

#endif
