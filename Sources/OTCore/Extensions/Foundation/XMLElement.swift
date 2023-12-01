//
//  XMLElement.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import Foundation

// MARK: - XML Traversal

extension XMLElement {
    /// **OTCore:**
    /// Iterates on all ancestors of the element, starting with the element's parent.
    /// Iterator is performed lazily.
    @_disfavoredOverload
    public var ancestorElements: UnfoldSequence<XMLElement, XMLElement> {
        sequence(state: self) { element in
            guard let parent = element.parentElement else { return nil }
            element = parent
            return parent
        }
    }
    
    /// **OTCore:**
    /// Returns the first immediate child whose element name matches the given string.
    @_disfavoredOverload
    public func firstChild(named name: String) -> XMLElement? {
        childElements.first(where: { $0.name == name })
    }
}

// MARK: - Attributes

extension XMLElement {
    /// **OTCore:**
    /// Gets an attribute value as `String`.
    /// If attribute name does not exist or does not have a value convertible to `String`, `nil`
    /// will be returned.
    @_disfavoredOverload
    public func stringValue(forAttributeNamed attributeName: String) -> String? {
        attribute(forName: attributeName)?.stringValue
    }
    
    /// **OTCore:**
    /// Gets an attribute value.
    /// If attribute name does not exist or does not have a value, nil will be returned.
    @_disfavoredOverload
    public func objectValue(forAttributeNamed attributeName: String) -> Any? {
        attribute(forName: attributeName)?.objectValue
    }
    
    /// **OTCore:**
    /// Adds an attribute.
    /// Replaces existing value if attribute name already exists.
    /// Removes attribute if `value` is `nil`.
    @_disfavoredOverload
    public func addAttribute(withName attributeName: String, value: String?) {
        if let value = value {
            let attr = XMLNode(kind: .attribute)
            attr.name = attributeName
            attr.stringValue = value
            addAttribute(attr)
        } else {
            removeAttribute(forName: attributeName)
        }
    }
    
    /// **OTCore:**
    /// Convenience to populate with attributes.
    /// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain order.
    @_disfavoredOverload
    public func addAttributes(_ attributes: [(name: String, value: String)]) {
        attributes.forEach {
            addAttribute(withName: $0.name, value: $0.value)
        }
    }
}

// MARK: - Convenience Inits

extension XMLElement {
    /// **OTCore:**
    /// Convenience to initialize and populate with attributes.
    /// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain order.
    @_disfavoredOverload
    public convenience init(
        name: String,
        attributes: [(name: String, value: String)]
    ) {
        self.init(name: name)
        
        addAttributes(attributes)
    }
}

// MARK: - Collection Filtering

extension Collection where Element: XMLElement {
    /// **OTCore:**
    /// Filters nodes that have an attribute matching the given `attribute` name and `value`.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereAttribute attributeName: String,
        hasValue value: String
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        self.lazy.filter {
            $0.attribute(forName: attributeName)?
                .stringValue == value
        }
    }
    
    /// **OTCore:**
    /// Filters nodes that have an attribute matching the given `attribute` name and satisfies the
    /// given predicate.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereAttribute attributeName: String,
        _ isIncluded: @escaping (_ attributeValue: String) -> Bool
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        self.lazy.filter(whereAttribute: attributeName, isIncluded)
    }
}

// MARK: - LazyCollection Filtering

extension LazyCollection where Element: XMLElement {
    /// **OTCore:**
    /// Filters nodes that have an attribute matching the given `attribute` name and `value`.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereAttribute attributeName: String,
        hasValue value: String
    ) -> LazyFilterSequence<LazySequence<Base>.Elements> {
        filter {
            $0.attribute(forName: attributeName)?
                .stringValue == value
        }
    }
    
    /// **OTCore:**
    /// Filters nodes that have an attribute matching the given `attribute` name and satisfies the
    /// given predicate.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereAttribute attributeName: String,
        _ isIncluded: @escaping (_ attributeValue: String) -> Bool
    ) -> LazyFilterSequence<LazySequence<Base>.Elements> {
        filter {
            guard let value = $0.stringValue(forAttributeNamed: attributeName)
            else { return false }
            
            return isIncluded(value)
        }
    }
}

#endif
