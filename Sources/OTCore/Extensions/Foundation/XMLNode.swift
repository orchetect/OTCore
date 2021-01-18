//
//  XMLNode.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-05-11.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import Foundation

// MARK: - XMLNode

extension XMLNode {
	
	/// **OTCore:**
	/// Returns `self` typed as? `XMLElement`
	public var asElement: XMLElement? {
		
		self as? XMLElement
		
	}
	
}


// MARK: - .filter

extension Collection where Element : XMLNode {
	
	/// **OTCore:**
	/// Filters by the given XML element name
	@inlinable public func filter(elementName: String) -> [XMLNode] {
		
		self.filter { $0.name == elementName }
		
	}
	
	/// **OTCore:**
	/// Filters by the given `attribute` with matching `value`
	@inlinable public func filter(attribute: String,
								  value: String) -> [XMLNode] {
		
		self.filter {
			$0.asElement?
				.attribute(forName: attribute)?
				.stringValue == value
		}
		
	}
	
	/// **OTCore:**
	/// Filters by the given `attribute` with values that satisfy the given predicate
	@inlinable public func filter(attribute: String,
								  _ isIncluded: (String) throws -> Bool) rethrows -> [XMLNode] {
		
		try self.filter {
			let filtered = try [$0.attributeStringValue(forName: attribute)]
				.compactMap{$0}
				.filter(isIncluded)
			return filtered.count > 0
		}
		
	}
	
}

extension XMLNode {
	
	// MARK: - Attributes
	
	/// **OTCore:**
	/// Gets an attribute value. If attribute name does not exist or does not have a value, nil will be returned.
	public func attributeStringValue(forName: String) -> String? {
		
		self.asElement?.attribute(forName: forName)?.stringValue
		
	}
	
	/// **OTCore:**
	/// Gets an attribute value. If attribute name does not exist or does not have a value, nil will be returned.
	public func attributeObjectValue(forName: String) -> Any? {
		
		self.asElement?.attribute(forName: forName)?.objectValue
		
	}
	
	/// **OTCore:**
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
	
	/// **OTCore:**
	/// Convenience to initialize and populate with attributes.
	/// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain order.
	public convenience init(name: String,
							attributes: [(name: String, value: String)]) {
		
		self.init(name: name)
		
		self.addAttributes(attributes)
		
	}
	
	/// **OTCore:**
	/// Convenience to populate with attributes.
	/// Attributes are accepted as an array of tuples instead of a dictionary in order to maintain order.
	public func addAttributes(_ attributes: [(name: String, value: String)]) {
		
		attributes.forEach {
			self.addAttribute(withName: $0.name, value: $0.value)
		}
		
	}
	
}

#endif
