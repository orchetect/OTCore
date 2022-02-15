//
//  Progress.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension Progress {
    
    /// **OTCore:**
    /// Returns the parent `Progress` instance, if one is attached.
    @_disfavoredOverload
    public var parent: Progress? {
        
        // keyPath "_parent" also works
        value(forKeyPath: "parent") as? Progress
        
    }
    
    /// **OTCore:**
    /// Returns all child `Progress` instances that are attached.
    @_disfavoredOverload
    public var children: Set<Progress> {
        
        // keyPath "_"children"" also works
        value(forKeyPath: "children") as? Set<Progress> ?? []
        
    }
    
}

#endif
