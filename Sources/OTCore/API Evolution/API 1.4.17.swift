//
//  API 1.4.17.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2023 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS) && canImport(Foundation)

import Foundation

extension Collection where Element: XMLNode {
    @available(*, deprecated, renamed: "filter(whereNodeNamed:)")
    @inlinable @_disfavoredOverload
    public func filter(elementName: String) -> [XMLNode] {
        filter(whereNodeNamed: elementName)
    }
    
    @available(*, deprecated, renamed: "filter(whereAttribute:hasValue:)")
    @inlinable @_disfavoredOverload
    public func filter(
        attribute: String,
        value: String
    ) -> [XMLNode] {
        filter(whereAttribute: attribute, hasValue: value)
    }
    
    @available(*, deprecated, renamed: "filter(whereAttribute:hasValue:)")
    @inlinable @_disfavoredOverload
    public func filter(
        attribute: String,
        _ isIncluded: (_ attributeValue: String) throws -> Bool
    ) rethrows -> [XMLNode] {
        try filter(whereAttribute: attribute, isIncluded)
    }
}

extension XMLNode {
    @available(*, deprecated, renamed: "stringValue(forAttributeNamed:)")
    @_disfavoredOverload
    public func attributeStringValue(forName: String) -> String? {
        stringValue(forAttributeNamed: forName)
    }
    
    @available(*, deprecated, renamed: "objectValue(forAttributeNamed:)")
    @_disfavoredOverload
    public func attributeObjectValue(forName: String) -> Any? {
        objectValue(forAttributeNamed: forName)
    }
}

#endif
