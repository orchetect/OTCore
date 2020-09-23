//
//  Collections.swift
//  OTCore
//
//  Created by Steffan Andrews on 2017-12-21.
//  Copyright © 2017 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - Operators

/// OTCore:
/// Syntactic sugar: Allows appending an element to an array.
public func += <T>(lhs: inout [T], rhs: T) {
	lhs.append(rhs)
}


// MARK: - Collection & array indexes

extension MutableCollection {
	/** OTCore:
	Array subscript that checks if an index exists before assigning a value
	to prevent runtime exceptions when index is out of bounds.
	*/
	public subscript (safe index: Index) -> Element? {
		get {
			return indices.contains(index) ? self[index] : nil
		}
		
		set {
			guard indices.contains(index) else { return }
			
			self[index] = newValue!
		}
	}
}

extension Array {
	
	/** OTCore:
	Subscript override that wraps the index (positive or negative)
	
	ie:
	```
	let x = ["0", "1", "2", "3", "4"]
	
	x[wrapping: 0]  // "0"
	x[wrapping: 4]  // "4"
	x[wrapping: 5]  // "0"
	x[wrapping: 6]  // "1"
	x[wrapping: -1] // "4"
	x[wrapping: -4] // "1"
	x[wrapping: -5] // "0"
	x[wrapping: -6] // "4"
	```
	*/
	public subscript (wrapping index: Index) -> Iterator.Element {
		let max = self.count
		var newIndex: Int
		
		if index >= 0 {
			newIndex = index % max
		} else {
			let calculation = max - (-index) % (-max)
			newIndex = calculation != max ? calculation : 0
		}
		
		return self[newIndex]
	}
	
}

extension Array {
	
	/// OTCore:
	/// Mirrors .remove(...) behavior but returns an optional because it might fail if the index does not exist
	@discardableResult
	public mutating func remove(safeAt index: Int) -> Element? {
		if indices.contains(index) {
			return self.remove(at: index)
		}
		
		return nil
	}
	
}

extension ArraySlice {
	
	/// OTCore:
	/// Mirrors .remove(...) behavior but returns an optional because it might fail if the index does not exist
	@discardableResult
	public mutating func remove(safeAt index: Int) -> Element? {
		if indices.contains(index) {
			return self.remove(at: index)
		}
		
		return nil
	}
	
}

extension ContiguousArray {
	
	/// OTCore:
	/// Mirrors .remove(...) behavior but returns an optional because it might fail if the index does not exist
	@discardableResult
	public mutating func remove(safeAt index: Int) -> Element? {
		if indices.contains(index) {
			return self.remove(at: index)
		}
		
		return nil
	}
	
}

// Set: doesn't really make sense to add a remove(safeAt:) because of how you typically interact with sets

// Dictionary: doesn't really make sense to add a remove(safeAt:), they already deal in Optionals


// MARK: - Convenience methods

extension Collection where Element : Hashable {
	
	/// OTCore:
	/// Counts number of occurances of the given element
	public func count(of element: Element) -> Int {
		self.filter{$0 == element}.count
	}
	
}

extension Array where Element: BinaryInteger {
	
	/// OTCore:
	/// Returns a string of integer literals, useful for generating Swift array declarations.
	public var stringValueArrayLiteral: String {
		
		self
			.map { "\($0)" }
			.joined(separator: ", " )
			.wrapped(with: .brackets)
		
	}
	
}


// MARK: - Search algorithms

extension ArraySlice where Element: Comparable {
	
	/// OTCore:
	/// Performs a binary search algorithm.
	///
	/// - If the value is found, a single-count range is returned with the index (ie: 4...4).
	///
	/// - If the value is not found, a 2-count range is returned with the two neighboring indexes below and above the search value.
	///
	/// - If the search value is not within the upper and lower bounds of the array's values, `nil` is returned.
	///
	/// ie:
	/// ```
	/// [1,2,3,4,5].binarySearch(forValue: 3)  // 2...2
	/// [1,2,4,5,6].binarySearch(forValue: 3)  // 1...2
	/// [1,2,3,4,5].binarySearch(forValue: 10) // nil
	/// [].binarySearch(forValue: 10)          // nil
	/// ```
	///
	/// - warning: The base array must be `.sorted()` prior to involking this method or it will not function as intended.
	public func binarySearch(forValue searchElement: Element) -> ClosedRange<Self.Index>? {
		guard !isEmpty else { return nil }
		guard searchElement >= first! else { return nil }
		guard searchElement <= last!  else { return nil }
		
		var searchRange = startIndex...endIndex-1
		
		while searchRange.count > 2 {
			
			let midIndex = searchRange.lowerBound + (searchRange.count / 2)
			
			let midElement = self[midIndex]
			
			if midElement == searchElement { return midIndex...midIndex }
			
			if midElement < searchElement {
				searchRange = midIndex...searchRange.upperBound
			} else {
				searchRange = searchRange.lowerBound...midIndex
			}
		}
		
		if let foundIndex = self[searchRange].firstIndex(where: { $0 == searchElement }) {
			return foundIndex...foundIndex
		} else {
			return searchRange
		}
	}
	
}

extension Array where Element: Comparable {
	
	/// OTCore:
	/// Performs a binary search algorithm.
	///
	/// - If the value is found, a single-count range is returned with the index (ie: 4...4).
	///
	/// - If the value is not found, a 2-count range is returned with the two neighboring indexes below and above the search value.
	///
	/// - If the search value is not within the upper and lower bounds of the array's values, `nil` is returned.
	///
	/// ie:
	/// ```
	/// [1,2,3,4,5].binarySearch(forValue: 3)  // 2...2
	/// [1,2,4,5,6].binarySearch(forValue: 3)  // 1...2
	/// [1,2,3,4,5].binarySearch(forValue: 10) // nil
	/// [].binarySearch(forValue: 10)          // nil
	/// ```
	///
	/// - warning: The base array must be `.sorted()` prior to involking this method or it will not function as intended.
	public func binarySearch(forValue searchElement: Element) -> ClosedRange<Self.Index>? {
		return self[0...].binarySearch(forValue: searchElement)
	}
	
}

extension Array where Element: Strideable, Element.Stride: SignedInteger {
	
	/// OTCore:
	/// Returns the first gap value not contained in the array. Starting at the first element of the array, walks through the array lazily searching for gap of n2 > n1+1 in values and returns the missing value. This method is only typically useful on an array of values that has been `.sorted()` first. Passing the `after` parameter will only return a gap value if it's greater than the `after` value.
	///
	/// If there are no gaps, `nil` is returned.
	///
	/// If the array is empty, `nil` is returned since there is no first element to derive a value from.
	///
	/// ie:
	/// ```
	/// [].firstGapValue                    // nil
	/// [1,  3,4,5].firstGapValue           // 2
	/// [1,2,  4,5].firstGapValue           // 3
	/// [1,2,3,4  ].firstGapValue           // nil
	/// [1,3,5,7,9].firstGapValue(after: 2) // 4
	/// ```
	///
	/// - complexity: O(n), where n represents index of first gap in the array
	public func firstGapValue(after: Element? = nil) -> Element? {
		if self.count < 1 { return nil }
		
		for idx in self.startIndex..<self.endIndex {
			if idx >= self.endIndex - 1 { continue }
			if self[idx+1] > (self[idx].advanced(by: 1)) {
				// found a gap
				let gapValue = self[idx].advanced(by: 1)
				if after == nil { return gapValue }
				if gapValue > after! { return gapValue }
			}
		}
		
		return nil
	}
	
}


// MARK: - Set-like functionalty for Array

extension Array where Element: Hashable {
	
	/// OTCore:
	/// Describes a an update() position behavior within the array.
	public enum PositionBehavior {
		/// Default behavior (as described in the calling function)
		case `default`
		
		/// Start of the array
		case start
		/// End of the array
		case end
	}
	
	/// OTCore:
	/// Similar behavior to a Set, this will append the element to the end of the array if it does not already exist in the array.
	public mutating func insert(_ element: Element,
								position: PositionBehavior = .default)
	{
		if !self.contains(element) {
			switch position {
			case .start:
				self.insert(element, at: 0)
			case .end, .default:
				self.append(element)
			}
			
		}
	}
	
	/// OTCore:
	/// Similar behavior to a Set, if the element exists in the array this will replace it at its current index with the new element. If it doesn't exist, it will either be replaced, reordered to the start, or reordered to the end of the array based upon the `position` specified.
	public mutating func update(with newMember: Element,
								position: PositionBehavior = .default)
	{
		if let index = self.firstIndex(of: newMember) {
			switch position {
			case .default:
				self[index] = newMember
			case .start:
				self.remove(at: index)
				self.insert(newMember, at: 0)
			case .end:
				self.remove(at: index)
				self.append(newMember)
			}
		} else {
			switch position {
			case .start:
				self.insert(newMember, at: 0)
			case .end, .default:
				self.append(newMember)
			}
		}
	}
	
	/// OTCore:
	/// Similar behavior to a Set, but removes all instances of the element.
	public mutating func removeAll(_ member: Element) {
		self.removeAll(where: { $0 == member })
	}
	
	/// OTCore:
	/// Similar behavior to a Set, join two arrays together and where elements are equal, retain the existing element.
	public func union<S>(_ other: S) -> [Element]
	where Element == S.Element, S : Sequence
	{
		var newArray = self
		other.forEach {
			newArray.insert($0)
		}
		return newArray
	}
	
	/// OTCore:
	/// Similar behavior to a Set, join two arrays together and where elements are equal, retain the existing element.
	public mutating func formUnion<S>(_ other: S)
	where Element == S.Element, S : Sequence
	{
		other.forEach {
			self.insert($0)
		}
	}
	
	/// OTCore:
	/// Similar behavior to a Set, join two arrays together and where elements are equal, replace the existing element with the new element preserving the original index.
	public func union<S>(updating other: S)
	-> [Element]
	where Element == S.Element, S : Sequence
	{
		var newArray = self
		other.forEach {
			newArray.update(with: $0)
		}
		return newArray
	}
	
	/// OTCore:
	/// Similar behavior to a Set, join two arrays together and where elements are equal, replace the existing element with the new element preserving the original index.
	public mutating func formUnion<S>(updating other: S)
	where Element == S.Element, S : Sequence
	{
		other.forEach {
			self.update(with: $0)
		}
	}
	
}

// MARK: - Set

extension Set {
	
	/// OTCore:
	/// Same as .union() but replaces existing values with new values instead of .union()'s behavior of retaining existing hash-equivalent values.
	public func union<S>(updating other: S)
	-> Set<Set<Element>.Element>
	where Element == S.Element, S : Sequence
	{
		var newSet = self
		other.forEach { newSet.update(with: $0) }
		return newSet
	}
	
	/// OTCore:
	/// Same as .formUnion() but replaces existing values with new values instead of .formUnion()'s behavior of retaining existing hash-equivalent values.
	public mutating func formUnion<S>(updating other: S)
	where Element == S.Element, S : Sequence
	{
		self = self.union(updating: other)
	}
	
}
