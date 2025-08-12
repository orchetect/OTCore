//
//  OTCore API 1.4.17.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS) && canImport(Foundation)

import Foundation

extension Collection where Element: XMLNode {
    @available(*, deprecated, renamed: "filter(whereNodeNamed:)")
    @inlinable @_disfavoredOverload
    public func filter(elementName: String) -> [XMLNode] {
        Array(filter(whereNodeNamed: elementName))
    }
    
    @available(
        *,
        deprecated,
        renamed: "filter(whereAttribute:hasValue:)",
        message: "Method has been renamed, and is also now only available on XMLElement and no longer available on XMLNode."
    )
    @inlinable @_disfavoredOverload
    public func filter(
        attribute: String,
        value: String
    ) -> [XMLNode] {
        Array(asElements().filter(whereAttribute: attribute, hasValue: value))
    }
    
    @available(
        *,
        deprecated,
        renamed: "filter(whereAttribute:hasValue:)",
        message: "Method has been renamed, and is also now only available on XMLElement and no longer available on XMLNode."
    )
    @inlinable @_disfavoredOverload
    public func filter(
        attribute: String,
        _ isIncluded: @escaping (_ attributeValue: String) throws -> Bool
    ) rethrows -> [XMLNode] {
        let filtered = asElements().filter(whereAttribute: attribute) {
            (try? isIncluded($0)) == true
        }
        return Array(filtered)
    }
}

extension XMLNode {
    @available(
        *,
        deprecated,
        renamed: "stringValue(forAttributeNamed:)",
        message: "Method has been renamed, and is also now only available on XMLElement and no longer available on XMLNode."
    )
    @_disfavoredOverload
    public func attributeStringValue(forName: String) -> String? {
        asElement?.stringValue(forAttributeNamed: forName)
    }
    
    @available(
        *,
        deprecated,
        renamed: "objectValue(forAttributeNamed:)",
        message: "Method has been renamed, and is also now only available on XMLElement and no longer available on XMLNode."
    )
    @_disfavoredOverload
    public func attributeObjectValue(forName: String) -> Any? {
        asElement?.objectValue(forAttributeNamed: forName)
    }
}

#endif
