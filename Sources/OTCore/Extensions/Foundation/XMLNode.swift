//
//  XMLNode.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import Foundation

// MARK: - Typing

extension XMLNode {
    /// **OTCore:**
    /// Returns `self` typed as `XMLElement`.
    @inlinable @_disfavoredOverload
    public var asElement: XMLElement? {
        self as? XMLElement
    }
    
    /// **OTCore:**
    /// Returns `parent` typed as `XMLElement`.
    @inlinable @_disfavoredOverload
    public var parentElement: XMLElement? {
        parent as? XMLElement
    }
    
    /// **OTCore:**
    /// Returns `children` typed as `XMLElement`s.
    @inlinable @_disfavoredOverload
    public var childElements: LazyCompactMapSequence<[XMLNode], XMLElement> {
        (children ?? []).asElements()
    }
}

// MARK: - Collection Typing

extension Collection where Element: XMLNode {
    /// **OTCore:**
    /// Returns the collection as a lazy iterator that compact maps to `XMLElement`.
    /// Mapping is performed lazily.
    @inlinable @_disfavoredOverload
    public func asElements() -> LazyCompactMapSequence<Self, XMLElement> {
        self.lazy.compactMap(\.asElement)
    }
}

// MARK: - Collection Filtering

extension Collection where Element: XMLNode {
    /// **OTCore:**
    /// Filters by the given XML node name.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereNodeNamed nodeName: String
    ) -> LazyFilterSequence<LazySequence<Self>.Elements> {
        self.lazy.filter(whereNodeNamed: nodeName)
    }
}

// MARK: - LazyCollection Filtering

extension LazyCollection where Element: XMLNode {
    /// **OTCore:**
    /// Filters by the given XML node name.
    /// Filter is performed lazily.
    @inlinable @_disfavoredOverload
    public func filter(
        whereNodeNamed nodeName: String
    ) -> LazyFilterSequence<LazySequence<Base>.Elements> {
        filter { $0.name == nodeName }
    }
}

#endif
