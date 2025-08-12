//
//  XMLElement.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
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
    public func ancestorElements(
        includingSelf: Bool
    ) -> UnfoldSequence<XMLElement, (XMLElement, Bool)> {
        sequence(state: (element: self, consumedSelf: false)) { state in
            if includingSelf, !state.1 {
                state.0 = self
                state.1 = true
                return state.0
            }
            guard let parent = state.0.parentElement else { return nil }
            state.0 = parent
            return state.0
        }
    }
    
    /// **OTCore:**
    /// Returns the first immediate child whose element name matches the given string.
    @_disfavoredOverload
    public func firstChildElement(named name: String) -> XMLElement? {
        childElements.first(where: { $0.name == name })
    }
    
    /// **OTCore:**
    /// Returns the first immediate child containing an attribute with the given name.
    @_disfavoredOverload
    public func firstChildElement(
        withAttribute attributeName: String
    ) -> (element: XMLElement, attributeValue: String)? {
        childElements.first(withAttribute: attributeName)
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
    /// If attribute name does not exist or does not have a value, `nil` will be returned.
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
        if let value {
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
    /// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain
    /// order.
    @_disfavoredOverload
    public func addAttributes(_ attributes: [(name: String, value: String)]) {
        for attribute in attributes {
            addAttribute(withName: attribute.name, value: attribute.value)
        }
    }
}

extension XMLElement {
    /// **OTCore:**
    /// Get a `Bool` attribute value.
    ///
    /// Valid strings are "1" or "true" for `true` and "0" or "false" for `false`.
    @_disfavoredOverload
    public func getBool(forAttribute attributeName: String) -> Bool? {
        guard let value = stringValue(forAttributeNamed: attributeName)
        else { return nil }
        
        switch value {
        case "0", "false", "FALSE": return false
        case "1", "true", "TRUE": return true
        default: return nil
        }
    }
    
    /// **OTCore:**
    /// Set a `Bool` attribute value.
    /// Adds or removes the attribute based on default behavior.
    ///
    /// Valid strings are "1" or "true" for `true` and "0" or "false" for `false`.
    ///
    /// - Parameters:
    ///   - newValue: Value to set. If `nil`, attribute will be removed.
    ///   - attributeName: Attribute name.
    ///   - defaultValue: The value considered to be the default value if the attribute is not
    ///     present. This value is used to determine behavior if `removeIfDefault` is `true`.
    ///   - removeIfDefault: Remove the attribute if the `newValue` matches the `defaultValue`.
    ///   - useInt: If `true`, writes value as an `Int` (`1` or `0`).
    ///     If `false`, writes value as a `String` (`true` or `false`).
    @_disfavoredOverload
    public func set(
        bool newValue: Bool?,
        forAttribute attributeName: String,
        defaultValue: Bool,
        removeIfDefault: Bool = false,
        useInt: Bool = false
    ) {
        guard let newValue else {
            addAttribute(withName: attributeName, value: nil)
            return
        }
        
        if removeIfDefault, newValue == defaultValue {
            addAttribute(withName: attributeName, value: nil)
            return
        }
        
        set(bool: newValue, forAttribute: attributeName, useInt: useInt)
    }
    
    /// **OTCore:**
    /// Set a `Bool` attribute value.
    /// Explicitly adds the attribute if the value is non-nil.
    ///
    /// Valid strings are "1" or "true" for `true` and "0" or "false" for `false`.
    ///
    /// - Parameters:
    ///   - newValue: Value to set. If `nil`, attribute will be removed.
    ///   - attributeName: Attribute name.
    ///   - useInt: If `true`, writes value as an `Int` (`1` or `0`).
    ///     If `false`, writes value as a `String` (`true` or `false`).
    @_disfavoredOverload
    public func set(
        bool newValue: Bool?,
        forAttribute attributeName: String,
        useInt: Bool = false
    ) {
        guard let newValue else {
            addAttribute(withName: attributeName, value: nil)
            return
        }
        
        let newValueString: String
        if useInt {
            newValueString = newValue ? "1" : "0"
        } else {
            newValueString = newValue ? "true" : "false"
        }
        
        addAttribute(withName: attributeName, value: newValueString)
    }
}

extension XMLElement {
    /// **OTCore:**
    /// Get an `Int` attribute value.
    @_disfavoredOverload
    public func getInt(forAttribute attributeName: String) -> Int? {
        stringValue(forAttributeNamed: attributeName)?.int
    }
    
    /// **OTCore:**
    /// Set an `Int` attribute value.
    @_disfavoredOverload
    public func set(int newValue: Int?, forAttribute attributeName: String) {
        addAttribute(withName: attributeName, value: newValue?.string)
    }
}

extension XMLElement {
    /// **OTCore:**
    /// Get a `URL` attribute value.
    @_disfavoredOverload
    public func getURL(forAttribute attributeName: String) -> URL? {
        guard let value = stringValue(forAttributeNamed: attributeName)
        else { return nil }
        return URL(string: value)
    }
    
    /// **OTCore:**
    /// Set a `URL` attribute value.
    @_disfavoredOverload
    public func set(url newValue: URL?, forAttribute attributeName: String) {
        addAttribute(withName: attributeName, value: newValue?.absoluteString)
    }
    
    // TODO: differentiate absolute URL from relative URL?
}

// MARK: - Children

extension XMLElement {
    /// **OTCore:**
    /// Adds one or more child nodes at the end of the receiver’s current list of children.
    @inlinable @_disfavoredOverload
    public func addChildren<S: Sequence>(_ children: S) where S.Element: XMLNode {
        for child in children {
            addChild(child)
        }
    }
    
    /// **OTCore:**
    /// Removes the child nodes of the receiver that satisfy the given predicate.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable @_disfavoredOverload
    public func removeChildren(
        where shouldBeRemoved: (_ child: XMLElement) throws -> Bool
    ) rethrows {
        guard childCount > 0 else { return }
        
        let indicesToRemove = try childElements
            .filter { try shouldBeRemoved($0) }
            .map(\.index)
            .sorted() // may be unnecessary
            .reversed() // remove in order from last to first
        
        for index in indicesToRemove {
            removeChild(at: index)
        }
    }
    
    /// **OTCore:**
    /// Removes all child nodes of the receiver.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable @_disfavoredOverload
    public func removeAllChildren() {
        while childCount > 0 {
            removeChild(at: childCount - 1)
        }
    }
}

// MARK: - Convenience Inits

extension XMLElement {
    /// **OTCore:**
    /// Convenience to initialize and populate with attributes.
    /// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain
    /// order.
    @_disfavoredOverload
    public convenience init(
        name: String,
        attributes: [(name: String, value: String)]
    ) {
        self.init(name: name)
        
        addAttributes(attributes)
    }
}

// MARK: - Sequence Filtering

extension Sequence where Element: XMLElement {
    /// **OTCore:**
    /// Filters by the given XML element name.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereElementNamed nodeName: String
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        lazy.filter(whereElementNamed: nodeName)
    }
    
    /// **OTCore:**
    /// Filters by any of the given XML element names.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereElementNamed nodeNames: [String]
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        lazy.filter(whereElementNamed: nodeNames)
    }
    
    /// **OTCore:**
    /// Filters elements that have an attribute matching the given `attribute` name and `value`.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereAttribute attributeName: String,
        hasValue attributeValue: String
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        lazy.filter(whereAttribute: attributeName, hasValue: attributeValue)
    }
    
    /// **OTCore:**
    /// Filters elements that have an attribute matching the given `attribute` name and satisfies
    /// the given predicate.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereAttribute attributeName: String,
        _ isIncluded: @escaping (_ attributeValue: String) -> Bool
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        lazy.filter(whereAttribute: attributeName, isIncluded)
    }
    
    /// **OTCore:**
    /// Filters elements that have an attribute matching the given `attribute` name.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        withAttribute attributeName: String
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        lazy.filter { $0.attribute(forName: attributeName) != nil }
    }
}

// MARK: - LazySequence Filtering

extension LazySequence where Element: XMLElement {
    /// **OTCore:**
    /// Filters by the given XML element name.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereElementNamed nodeName: String
    ) -> LazyFilterSequence<LazySequence<Base>.Elements> {
        filter { $0.name == nodeName }
    }
    
    /// **OTCore:**
    /// Filters by any of the given XML element names.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereElementNamed nodeNames: [String]
    ) -> LazyFilterSequence<LazySequence<Base>.Elements> {
        filter {
            guard let name = $0.name else { return false }
            return nodeNames.contains(name)
        }
    }
    
    /// **OTCore:**
    /// Filters nodes that have an attribute matching the given `attribute` name and `value`.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereAttribute attributeName: String,
        hasValue attributeValue: String
    ) -> LazyFilterSequence<LazySequence<Base>.Elements> {
        filter {
            $0.stringValue(forAttributeNamed: attributeName) == attributeValue
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

// MARK: - Sequence First

extension Sequence where Element: XMLElement {
    /// **OTCore:**
    /// Returns the first element with the given XML node name.
    @inlinable @_disfavoredOverload
    public func first(
        whereElementNamed nodeName: String
    ) -> Element? {
        first { $0.name == nodeName }
    }
    
    /// **OTCore:**
    /// Returns the first element with any of the given XML node names.
    @inlinable @_disfavoredOverload
    public func first(
        whereElementNamed nodeNames: [String]
    ) -> Element? {
        first {
            guard let name = $0.name else { return false }
            return nodeNames.contains(name)
        }
    }
    
    /// **OTCore:**
    /// Returns the first element that has an attribute matching the given `attribute` name and
    /// `value`.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func first(
        whereAttribute attributeName: String,
        hasValue attributeValue: String
    ) -> Element? {
        first {
            $0.stringValue(forAttributeNamed: attributeName) == attributeValue
        }
    }
    
    /// **OTCore:**
    /// Finds the first element in the collection that has an attribute matching the given
    /// attribute name, and returns the element as well as the attribute's value.
    @inlinable @_disfavoredOverload
    public func first(
        withAttribute attributeName: String
    ) -> (element: Element, attributeValue: String)? {
        for element in self {
            if let attributeValue = element.stringValue(forAttributeNamed: attributeName) {
                return (element: element, attributeValue: attributeValue)
            }
        }
        return nil
    }
    
    /// **OTCore:**
    /// Finds the first element in the collection that has an attribute matching any of the given
    /// attribute names, and returns the element.
    @inlinable @_disfavoredOverload
    public func first(
        whereAnyAttribute attributeNames: [String]
    ) -> Element? {
        first {
            for attributeName in attributeNames {
                if $0.attribute(forName: attributeName) != nil { return true }
            }
            return false
        }
    }
}

#endif
