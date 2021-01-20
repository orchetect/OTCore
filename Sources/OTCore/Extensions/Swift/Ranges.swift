//
//  Ranges.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-12.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

// MARK: - isContained

extension Comparable {
	
	// ie: 5.isContained(in: 1...4)
	// ie: 5.0.isContained(in: 1.0...4.0)
	// ie: "c".isContained(in: "a"..."d")
	
	/// **OTCore:**
	/// Same as `range.contains(self)`
	/// (Functional convenience method)
	@inlinable public
	func isContained<T: RangeExpression>(in range: T) -> Bool
	where Self == T.Bound {
		
		range.contains(self)
		
	}
	
	/// **OTCore:**
	/// If `self` is in range, output the new `value`, otherwise pass `self` through.
	/// (Functional convenience method)
	@inlinable public
	func ifContained<T: RangeExpression>(in range: T,
										 then value: T.Bound) -> T.Bound?
	where Self == T.Bound {
		
		range.contains(self) ? value : self
		
	}
	
	/// **OTCore:**
	/// If `self` is not in range, output the new `value`, otherwise pass `self` through.
	/// (Functional convenience method)
	@inlinable public
	func ifNotContained<T: RangeExpression>(in range: T,
											then value: T.Bound) -> T.Bound?
	where Self == T.Bound {
		
		range.contains(self) ? self : value
		
	}
	
}


// MARK: - .clamped(to:)

extension Comparable {
	
	// ie: 5.clamped(to: 7...10)
	// ie: 5.0.clamped(to: 7.0...10.0)
	// ie: "a".clamped(to: "b"..."h")
	/// **OTCore:**
	/// Returns the value clamped to the passed range.
	@inlinable public func clamped(to limits: ClosedRange<Self>) -> Self {
		
		min(max(self, limits.lowerBound), limits.upperBound)
		
	}
	
	// ie: 5.clamped(to: 300...)
	// ie: 5.0.clamped(to: 300.00...)
	// ie: "a".clamped(to: "b"...)
	/// **OTCore:**
	/// Returns the value clamped to the passed range.
	@inlinable public func clamped(to limits: PartialRangeFrom<Self>) -> Self {
		
		max(self, limits.lowerBound)
		
	}
	
	// ie: 400.clamped(to: ...300)
	// ie: 400.0.clamped(to: ...300.0)
	// ie: "k".clamped(to: ..."h")
	/// **OTCore:**
	/// Returns the value clamped to the passed range.
	@inlinable public func clamped(to limits: PartialRangeThrough<Self>) -> Self {
		
		min(self, limits.upperBound)
		
	}
	
	// ie: 5.0.clamped(to: 7.0..<10.0)
	// not a good idea to implement this -- floating point numbers don't make sense in a ..< type range
	// because would the max of 7.0..<10.0 be 9.999999999...? It can't be 10.0.
	// func clamped(to limits: Range<Self>) -> Self { }
	
}

extension Strideable {
	
	// ie: 400.clamped(to: ..<300)
	// won't work for String
	/// **OTCore:**
	/// Returns the value clamped to the passed range.
	@inlinable public func clamped(to limits: PartialRangeUpTo<Self>) -> Self {
		
		// advanced(by:) requires Strideable, not available on just Comparable
		min(self, limits.upperBound.advanced(by: -1))
		
	}
	
}

extension Strideable where Self.Stride: SignedInteger {
	
	// ie: 5.clamped(to: 7..<10)
	// won't work for String
	/// **OTCore:**
	/// Returns the value clamped to the passed range.
	@inlinable public func clamped(to limits: Range<Self>) -> Self {
		
		// index(before:) only available on SignedInteger
		min(max(self, limits.lowerBound), limits.index(before: limits.upperBound))
		
	}
	
}


// MARK: - .first(excluding:) ClosedRange

extension ClosedRange where Bound: SignedInteger, Bound.Stride: SignedInteger {
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	///
	/// This method is only typically useful on an `excluding` array that has been `.sorted()` first.
	///
	/// - note: where possible, use the `.first(excluding: Range)` variants of this method because they are far more performant than this one.
	///
	/// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count; lazily over `self.count`.
	public func first(excluding: ArraySlice<Bound>) -> Bound? {
		
		guard excluding.count > 0 else {
			return self.first
		}
		
		return self.first(where: { !excluding.contains($0) } )
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	///
	/// This method is only typically useful on an `excluding` array that has been `.sorted()` first.
	///
	/// - note: where possible, use the `.first(excluding: Range)` variants of this method because they are far more performant than this one.
	///
	/// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count; lazily over `self.count`.
	public func first(excluding: [Bound]) -> Bound? {
		
		first(excluding: ArraySlice(excluding))
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// This method assumes the `presortedExcluding` array is already pre-sorted.
	///
	/// This method may be more performant than calling `first(excluding: ArraySlice)` for large `presortedExcluding` arrays or potentially large overlays between `self` and `presortedExcluding`.
	///
	/// - note: Where possible, use the `.first(excluding: Range)` variants of this method because they are far more performant.
	///
	/// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count; lazily over `self.count`.
	public func first(presortedExcluding: ArraySlice<Bound>) -> Bound? {
		
		guard presortedExcluding.count > 0 else {
			return self.first
		}
		
		// optimization: check to see if entire excluding value set is < or > first base value; if so, just return first value
		if self.lowerBound < presortedExcluding.first! { return self.lowerBound }	// do excluding values start > first base value?
		if self.lowerBound > presortedExcluding.last! { return self.lowerBound }	// do excluding values end < first base value?
		
		var trimmedSortedExcluding: ArraySlice<Bound>?
		
		// optimization: trim exclusions, if exclusions start before first base value
		if self.lowerBound > presortedExcluding.first! {
			if let minExclusion = presortedExcluding.binarySearch(forValue: self.lowerBound) {
				trimmedSortedExcluding = presortedExcluding[minExclusion.lowerBound..<presortedExcluding.endIndex]
			}
		}
		
		// optimization: trim exclusions, if exclusions end after last base value
		if let maxExclusion = presortedExcluding.binarySearch(forValue: self.upperBound) {
			if trimmedSortedExcluding != nil {
				trimmedSortedExcluding = trimmedSortedExcluding![trimmedSortedExcluding!.startIndex...maxExclusion.upperBound]
			} else {
				trimmedSortedExcluding = presortedExcluding[presortedExcluding.startIndex...maxExclusion.upperBound]
			}
		}
		
		return trimmedSortedExcluding != nil ?
			self.first(excluding: trimmedSortedExcluding!) :
			self.first(excluding: presortedExcluding)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// This method assumes the `presortedExcluding` array is already pre-sorted.
	///
	/// This method may be more performant than calling `first(excluding: ArraySlice)` for large `presortedExcluding` arrays or potentially large overlays between `self` and `presortedExcluding`.
	///
	/// - note: Where possible, use the `.first(excluding: Range)` variants of this method because they are far more performant.
	///
	/// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count; lazily over `self.count`.
	public func first(presortedExcluding: [Bound]) -> Bound? {
		
		first(presortedExcluding: ArraySlice(presortedExcluding))
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values. If there are no available elements, nil is returned.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with a large base range and/or exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and O(`self.count * excluding.count`).
	public func first(sortingAndExcluding: ArraySlice<Bound>) -> Bound? {
		
		// optimization: if not excluding anything, just return first value
		if sortingAndExcluding.count == 0 { return self.lowerBound }
		
		let sortedExcluding = sortingAndExcluding.sorted()
		
		return self.first(excluding: sortedExcluding)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values. If there are no available elements, nil is returned.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with a large base range and/or exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and O(`self.count * excluding.count`).
	public func first(sortingAndExcluding: [Bound]) -> Bound? {
		
		first(sortingAndExcluding: ArraySlice(sortingAndExcluding))
		
	}
	
}

extension ClosedRange where Bound.Stride: SignedInteger, Bound: Strideable {
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: ClosedRange<Bound>) -> Bound? {
		
		if excluding.lowerBound > self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound < self.lowerBound { return self.lowerBound } // no overlaps in ranges; return first
		
		if excluding.upperBound >= self.lowerBound &&
			excluding.upperBound < self.upperBound { return excluding.upperBound.advanced(by: 1) }
		
		return nil
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: Range<Bound>) -> Bound? {
		
		if excluding.lowerBound > self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound <= self.lowerBound { return self.lowerBound } // no overlaps in ranges; return first
		
		if excluding.upperBound > self.lowerBound &&
			excluding.upperBound <= self.upperBound { return excluding.upperBound }
		
		return nil
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
		
		if excluding.lowerBound <= self.lowerBound { return nil }
		
		return self.lowerBound
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeThrough<Bound>) -> Bound? {
		
		if excluding.upperBound < self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound < self.upperBound { return excluding.upperBound.advanced(by: 1) }
		
		return nil
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeUpTo<Bound>) -> Bound? {
		
		if excluding.upperBound <= self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound <= self.upperBound { return excluding.upperBound }
		
		return nil
		
	}
	
}


// MARK: - .first(excluding:) Range

extension Range where Bound: SignedInteger, Bound.Stride: SignedInteger {
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// This method is only typically useful on an array of values that has been `.sorted()` first.
	///
	/// - complexity: O(`self.count * excluding.count`), lazily over `self.count`.
	public func first(excluding: ArraySlice<Bound>) -> Bound? {
		
		guard excluding.count > 0 else {
			return self.first
		}
		
		if self.upperBound == self.lowerBound { return nil }
		
		// Form ClosedRange and call .first(...) on it
		return (self.lowerBound...self.upperBound-1)
			.first(excluding: excluding)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned. This method is only typically useful on an array of values that has been `.sorted()` first.
	///
	/// - complexity: O(`self.count * excluding.count`), lazily over `self.count`.
	public func first(excluding: [Bound]) -> Bound? {
		
		first(excluding: ArraySlice(excluding))
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// This method assumes the `presortedExcluding` array is already pre-sorted.
	///
	/// This method may be more performant than calling `first(excluding: ArraySlice)` for large `presortedExcluding` arrays or potentially large overlays between `self` and `presortedExcluding`.
	///
	/// - note: Where possible, use the `.first(excluding: Range)` variants of this method because they are far more performant.
	///
	/// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count; lazily over `self.count`.
	public func first(presortedExcluding: ArraySlice<Bound>) -> Bound? {
		
		if self.upperBound == self.lowerBound { return nil }
		
		// Form ClosedRange and call .first(...) on it
		return (self.lowerBound...self.upperBound-1)
			.first(presortedExcluding: presortedExcluding)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// This method assumes the `presortedExcluding` array is already pre-sorted.
	///
	/// This method may be more performant than calling `first(excluding: ArraySlice)` for large `presortedExcluding` arrays or potentially large overlays between `self` and `presortedExcluding`.
	///
	/// - note: Where possible, use the `.first(excluding: Range)` variants of this method because they are far more performant.
	///
	/// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count; lazily over `self.count`.
	public func first(presortedExcluding: [Bound]) -> Bound? {
		
		if self.upperBound == self.lowerBound { return nil }
		
		// Form ClosedRange and call .first(...) on it
		return (self.lowerBound...self.upperBound-1)
			.first(presortedExcluding: ArraySlice(presortedExcluding))
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values.
	/// If there are no available elements, nil is returned.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with a large base range and/or exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and O(`self.count * excluding.count`).
	public func first(sortingAndExcluding: ArraySlice<Bound>) -> Bound? {
		
		if self.upperBound == self.lowerBound { return nil }
		
		// Form ClosedRange and call .first(...) on it
		return (self.lowerBound...self.upperBound-1)
			.first(sortingAndExcluding: sortingAndExcluding)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values.
	/// If there are no available elements, nil is returned.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with a large base range and/or exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and O(`self.count * excluding.count`).
	public func first(sortingAndExcluding: [Bound]) -> Bound? {
		
		first(sortingAndExcluding: ArraySlice(sortingAndExcluding))
		
	}
	
}

extension Range where Bound : Strideable, Bound.Stride : SignedInteger {
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: ClosedRange<Bound>) -> Bound? {
		
		if excluding.lowerBound > self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound < self.lowerBound { return self.lowerBound } // no overlaps in ranges; return first
		
		if excluding.upperBound >= self.lowerBound &&
			excluding.upperBound < self.upperBound.advanced(by: -1) {
			return excluding.upperBound.advanced(by: 1)
		}
		
		return nil
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: Range<Bound>) -> Bound? {
		
		if excluding.lowerBound > self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound <= self.lowerBound { return self.lowerBound } // no overlaps in ranges; return first
		
		if excluding.upperBound >= self.lowerBound &&
			excluding.upperBound.advanced(by: -1) < self.upperBound.advanced(by: -1) {
			return excluding.upperBound
		}
		
		return nil
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
		
		if excluding.lowerBound <= self.lowerBound { return nil }
		
		return self.lowerBound
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeThrough<Bound>) -> Bound? {
		
		if excluding.upperBound < self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound < self.upperBound.advanced(by: -1) {
			return excluding.upperBound.advanced(by: 1)
		}
		
		return nil
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeUpTo<Bound>) -> Bound? {
		
		if excluding.upperBound <= self.lowerBound { return self.lowerBound }
		
		if excluding.upperBound < self.upperBound { return excluding.upperBound }
		
		return nil
		
	}
	
}


// MARK: - .first(excluding:) PartialRangeFrom

extension PartialRangeFrom where Bound.Stride: SignedInteger, Bound: Strideable {
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. This method is only typically useful with an exclusion array of that has been `.sorted()` first.
	///
	/// - complexity: O(*n*), where *n* is the length of the exclusion array.
	public func first(excluding: ArraySlice<Bound>) -> Bound {
		
		// should always succeed since PartialRangeFrom values ascend infinitely
		// however, we provide a fallback
		
		self.first(where: { !excluding.contains($0) } )
			?? lowerBound
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values. This method is only typically useful with an exclusion array of that has been `.sorted()` first.
	///
	/// - complexity: O(*n*), where *n* is the length of the exclusion array.
	public func first(excluding: [Bound]) -> Bound {
		
		first(excluding: ArraySlice(excluding))
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with an exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: O(*n*), where *n* is the length of the exclusion array.
	public func first(presortedExcluding: ArraySlice<Bound>) -> Bound {
		
		if presortedExcluding.isEmpty { return self.lowerBound }
		
		if presortedExcluding.last! < self.lowerBound { return self.lowerBound }
		
		return presortedExcluding
			.firstGapValue(after: self.lowerBound.advanced(by: -1))
			?? presortedExcluding.last!.advanced(by: 1)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with an exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: O(*n*), where *n* is the length of the exclusion array.
	public func first(presortedExcluding: [Bound]) -> Bound {
		
		first(presortedExcluding: ArraySlice(presortedExcluding))
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with an exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: O(*n*), where *n* is the length of the exclusion array.
	public func first(sortingAndExcluding: ArraySlice<Bound>) -> Bound {
		
		if sortingAndExcluding.isEmpty { return self.lowerBound }
		
		let sortedExcluding = sortingAndExcluding.sorted()
		
		if sortedExcluding.last! < self.lowerBound { return self.lowerBound }
		
		return sortedExcluding
			.firstGapValue(after: self.lowerBound.advanced(by: -1))
			?? sortedExcluding.last!.advanced(by: 1)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `sortingAndExcluding` values.
	///
	/// This method first sorts the values in `sortingAndExcluding` and includes additional logic that may be more efficient (when working with an exclusion array) than simply passing a pre-sorted array to `first(excluding:)`.
	///
	/// - complexity: O(*n*), where *n* is the length of the exclusion array.
	public func first(sortingAndExcluding: [Bound]) -> Bound {
		
		first(sortingAndExcluding: ArraySlice(sortingAndExcluding))
		
	}
	
}

extension PartialRangeFrom where Bound.Stride: SignedInteger, Bound: Strideable {
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: ClosedRange<Bound>) -> Bound {
		
		if self.lowerBound < excluding.lowerBound { return self.lowerBound }
		
		if excluding.upperBound < self.lowerBound { return self.lowerBound } // no overlaps in ranges; return first
		
		return excluding.upperBound.advanced(by: 1)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: Range<Bound>) -> Bound {
		
		if self.lowerBound < excluding.lowerBound { return self.lowerBound }
		
		if excluding.upperBound < self.lowerBound { return self.lowerBound } // no overlaps in ranges; return first
		
		return excluding.upperBound
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
		
		if excluding.lowerBound <= self.lowerBound { return nil }

		return self.lowerBound
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeThrough<Bound>) -> Bound {
		
		if excluding.upperBound < self.lowerBound { return self.lowerBound }

		return excluding.upperBound.advanced(by: 1)
		
	}
	
	/// **OTCore:**
	/// Returns the first element of the range that does not match any of the `excluding` values.
	/// If there are no available elements, nil is returned.
	/// - complexity: O(1) or slightly higher
	public func first(excluding: PartialRangeUpTo<Bound>) -> Bound {
		
		if excluding.upperBound <= self.lowerBound { return self.lowerBound }
		
		return excluding.upperBound
		
	}
	
}


// MARK: - .repeatEach { }

extension BinaryInteger {
	
	/// **OTCore:**
	/// Repeats the closure n number of times. The number must be > 0 otherwise the code is never executed.
	public func repeatEach(_ operation: @escaping () -> Void) {
		
		var increment = 0 as Self
		while increment < self {
			operation()
			increment += 1
		}
		
	}
	
}

extension ClosedRange where Element : BinaryInteger {
	
	/// **OTCore:**
	/// Repeats the closure once for each element in the range.
	public func repeatEach(_ operation: @escaping () -> Void) {
		
		for _ in self { operation() }
		
	}
	
}

extension Range where Element : BinaryInteger {
	
	/// **OTCore:**
	/// Repeats the closure once for each element in the range.
	public func repeatEach(_ operation: @escaping () -> Void) {
		
		for _ in self { operation() }
		
	}
	
}
