//
//  Collection BinarySearch.swift
//  OTCore
//
//  Created by Steffan Andrews on 2017-12-21.
//  Copyright © 2017 Steffan Andrews. All rights reserved.
//

// MARK: - Search algorithms

extension ArraySlice where Element: Comparable {
	
	/// **OTCore:**
	/// Performs a binary search algorithm.
	///
	/// - If the value is found, a single-count range is returned with the index (ie: 4...4).
	///
	/// - If the value is not found, a 2-count range is returned with the two neighboring indexes below and above the search value.
	///
	/// - If the search value is not within the upper and lower bounds of the array's values, `nil` is returned.
	///
	/// Example:
	///
	///     [1,2,3,4,5].binarySearch(forValue: 3)  // 2...2
	///     [1,2,4,5,6].binarySearch(forValue: 3)  // 1...2
	///     [1,2,3,4,5].binarySearch(forValue: 10) // nil
	///     [].binarySearch(forValue: 10)          // nil
	///
	/// - warning: The base array must be `.sorted()` prior to invoking this method or it will not function as intended.
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
	
	/// **OTCore:**
	/// Performs a binary search algorithm.
	///
	/// - If the value is found, a single-count range is returned with the index (ie: 4...4).
	///
	/// - If the value is not found, a 2-count range is returned with the two neighboring indexes below and above the search value.
	///
	/// - If the search value is not within the upper and lower bounds of the array's values, `nil` is returned.
	///
	/// Example:
	///
	///     [1,2,3,4,5].binarySearch(forValue: 3)  // 2...2
	///     [1,2,4,5,6].binarySearch(forValue: 3)  // 1...2
	///     [1,2,3,4,5].binarySearch(forValue: 10) // nil
	///     [].binarySearch(forValue: 10)          // nil
	///
	/// - warning: The base array must be `.sorted()` prior to invoking this method or it will not function as intended.
	public func binarySearch(forValue searchElement: Element) -> ClosedRange<Self.Index>? {
		ArraySlice(self).binarySearch(forValue: searchElement)
	}
	
}


// MARK: - Set-like functionality for Array

extension Array where Element: Hashable {
	
	/// **OTCore:**
	/// Describes a position behavior within the array as used in the `update()` method.
	public enum PositionBehavior {
		/// Default behavior (as described in the calling function)
		case `default`
		
		/// Start of the array
		case start
		/// End of the array
		case end
	}
	
	/// **OTCore:**
	/// Similar behavior to a Set, this will append the element to the end of the array if it does not already exist in the array.
	@inlinable public mutating func insert(_ element: Element,
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
	
	/// **OTCore:**
	/// Similar behavior to a Set, if the element exists in the array this will replace it at its current index with the new element. If it doesn't exist, it will either be replaced, reordered to the start, or reordered to the end of the array based upon the `position` specified.
	@inlinable public mutating func update(with newMember: Element,
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
	
	/// **OTCore:**
	/// Similar behavior to a Set, but removes all instances of the element.
	@inlinable public mutating func removeAll(_ member: Element) {
		self.removeAll(where: { $0 == member })
	}
	
	/// **OTCore:**
	/// Similar behavior to a Set, join two arrays together and where elements are equal, retain the existing element.
	@inlinable public func union<S>(_ other: S) -> [Element]
	where Element == S.Element, S : Sequence
	{
		var newArray = self
		other.forEach {
			newArray.insert($0)
		}
		return newArray
	}
	
	/// **OTCore:**
	/// Similar behavior to a Set, join two arrays together and where elements are equal, retain the existing element.
	@inlinable public mutating func formUnion<S>(_ other: S)
	where Element == S.Element, S : Sequence
	{
		other.forEach {
			self.insert($0)
		}
	}
	
	/// **OTCore:**
	/// Similar behavior to a Set, join two arrays together and where elements are equal, replace the existing element with the new element preserving the original index.
	@inlinable public func union<S>(updating other: S)
	-> [Element]
	where Element == S.Element, S : Sequence
	{
		var newArray = self
		other.forEach {
			newArray.update(with: $0)
		}
		return newArray
	}
	
	/// **OTCore:**
	/// Similar behavior to a Set, join two arrays together and where elements are equal, replace the existing element with the new element preserving the original index.
	@inlinable public mutating func formUnion<S>(updating other: S)
	where Element == S.Element, S : Sequence
	{
		other.forEach {
			self.update(with: $0)
		}
	}
	
}
