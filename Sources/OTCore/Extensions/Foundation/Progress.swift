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
        let getParent = value(forKeyPath: "parent")
        let typedParent = getParent as? Progress
        return typedParent
        
    }
    
    /// **OTCore:**
    /// Returns all child `Progress` instances that are attached.
    @_disfavoredOverload
    public var children: Set<Progress> {
        
        // keyPath "_children" also works
        let getChildren = value(forKeyPath: "children")
        guard let nsSet = getChildren as? NSSet else { return [] }
        let mappedChildren = nsSet.compactMap { $0 as? Progress }
        let mappedSet = Set(mappedChildren)
        return mappedSet
        
    }
    
}

#endif
