//
//  XMLDocument.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-05-11.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//


// This is Mac-only because XMLDocument is not available on iOS

#if os(macOS)

import Foundation


// MARK: - XMLNode

extension XMLNode {
	
	/// CUSTOM SHARED:
	/// Returns `self` typed as? `XMLElement`
	public var asElement: XMLElement? {
		return self as? XMLElement
	}
	
}


// MARK: - .filter

extension Collection where Element : XMLNode {
	
	/// CUSTOM SHARED:
	/// Filters by the given XML element name
	public func filter(elementName: String) -> [XMLNode] {
		return self
			.filter { $0.name == elementName }
	}
	
	/// CUSTOM SHARED:
	/// Filters by the given `attribute` with matching `value`
	public func filter(attribute: String, value: String) -> [XMLNode] {
		return self
			.filter { $0.asElement?.attribute(forName: attribute)?.stringValue == value }
	}
	
	/// CUSTOM SHARED:
	/// Filters by the given `attribute` with values that satisfy the given predicate
	public func filter(attribute: String, _ isIncluded: (String) throws -> Bool) rethrows -> [XMLNode] {
		return try self
			.filter {
				let filtered = try [$0.attributeStringValue(forName: attribute)]
					.compactMap{$0}
					.filter(isIncluded)
				return filtered.count > 0
		}
	}
	
}

extension XMLNode {
	
	// MARK: - Attributes
	
	/// CUSTOM SHARED:
	/// Gets an attribute value. If attribute name does not exist or does not have a value, nil will be returned.
	public func attributeStringValue(forName: String) -> String? {
		return self.asElement?.attribute(forName: forName)?.stringValue
	}
	
	/// CUSTOM SHARED:
	/// Gets an attribute value. If attribute name does not exist or does not have a value, nil will be returned.
	public func attributeObjectValue(forName: String) -> Any? {
		return self.asElement?.attribute(forName: forName)?.objectValue
	}
	
	/// CUSTOM SHARED:
	/// Adds an attribute. Replaces existing value if attribute name already exists.
	public func addAttribute(withName: String, value: String?) {
		let attr = XMLNode(kind: .attribute)
		attr.name = withName
		attr.stringValue = value
		
		self.asElement?.addAttribute(attr)
	}
	
}




// MARK: - XMLElement

extension XMLElement {
	
	/// CUSTOM SHARED:
	/// Convenience to initialize and populate with attributes.
	/// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain order.
	public convenience init(name: String, attributes: [(name: String, value: String)]) {
		self.init(name: name)
		
		self.addAttributes(attributes)
	}
	
	/// CUSTOM SHARED:
	/// Convenience to populate with attributes.
	/// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain order.
	public func addAttributes(_ attributes: [(name: String, value: String)]) {
		attributes.forEach { self.addAttribute(withName: $0.name, value: $0.value) }
	}
	
}

#endif
