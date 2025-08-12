//
//  Ranges.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Comparable .isContained

extension Comparable {
    // ie: 5.isContained(in: 1...4)
    // ie: 5.0.isContained(in: 1.0...4.0)
    // ie: "c".isContained(in: "a"..."d")
    
    /// **OTCore:**
    /// Same as `range.contains(self)`
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    /// ```swift
    /// 5.isContained(in: 1...4) // == false
    /// ```
    ///
    /// To test if `self` is NOT contained in `range`:
    ///
    /// ```swift
    /// !5.isContained(in: 1...4) // == true
    /// // or
    /// 5.isContained(in: 1...4).toggled() // == true
    /// ```
    @inlinable @_disfavoredOverload
    public func isContained<R: RangeExpression>(in range: R) -> Bool
    where Self == R.Bound {
        range.contains(self)
    }
}

// MARK: - ClosedRange.contains(range)

// these don't make sense to implement since they would always return false:
// - ClosedRange.contains(PartialRangeFrom)
// - ClosedRange.contains(PartialRangeUpTo)
// - ClosedRange.contains(PartialRangeThrough)

extension ClosedRange {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: ClosedRange<Bound>) -> Bool {
        other.lowerBound >= lowerBound &&
            other.upperBound <= upperBound
    }
}

extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: Range<Bound>) -> Bool {
        guard !other.isEmpty else { return false }
        
        return other.lowerBound >= lowerBound &&
            other.upperBound.advanced(by: -1) <= upperBound
    }
}

// MARK: - Range.contains(range)

// these don't make sense to implement since they would always return false:
// - Range.contains(PartialRangeFrom)
// - Range.contains(PartialRangeUpTo)
// - Range.contains(PartialRangeThrough)

extension Range {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: ClosedRange<Bound>) -> Bool {
        other.lowerBound >= lowerBound &&
            other.upperBound < upperBound
    }
}

extension Range {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: Range<Bound>) -> Bool {
        guard !other.isEmpty else { return false }
        
        return other.lowerBound >= lowerBound &&
            other.upperBound <= upperBound
    }
}

// MARK: - PartialRangeFrom.contains(range)

// these don't make sense to implement since they would always return false:
// - PartialRangeFrom.contains(PartialRangeUpTo)
// - PartialRangeFrom.contains(PartialRangeThrough)

extension PartialRangeFrom {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: ClosedRange<Bound>) -> Bool {
        other.lowerBound >= lowerBound
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: Range<Bound>) -> Bool {
        other.lowerBound >= lowerBound
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: PartialRangeFrom<Bound>) -> Bool {
        other.lowerBound >= lowerBound
    }
}

// MARK: - PartialRangeThrough.contains(range)

// these don't make sense to implement since they would always return false:
// - PartialRangeThrough.contains(PartialRangeFrom)

extension PartialRangeThrough {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: ClosedRange<Bound>) -> Bool {
        other.upperBound <= upperBound
    }
}

extension PartialRangeThrough where Bound: BinaryInteger, Bound.Stride: FixedWidthInteger {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: Range<Bound>) -> Bool {
        guard other.upperBound > Bound.Stride.min else { return false }
        
        return other.upperBound.advanced(by: -1) <= upperBound
    }
}

extension PartialRangeThrough {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: PartialRangeThrough<Bound>) -> Bool {
        other.upperBound <= upperBound
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: PartialRangeUpTo<Bound>) -> Bool {
        other.upperBound < upperBound
    }
}

// MARK: - PartialRangeUpTo.contains(range)

// these don't make sense to implement since they would always return false:
// - PartialRangeUpTo.contains(PartialRangeFrom)

extension PartialRangeUpTo {
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: ClosedRange<Bound>) -> Bool {
        other.upperBound < upperBound
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: Range<Bound>) -> Bool {
        other.upperBound <= upperBound
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: PartialRangeThrough<Bound>) -> Bool {
        other.upperBound < upperBound
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable @_disfavoredOverload
    public func contains(_ other: PartialRangeUpTo<Bound>) -> Bool {
        other.upperBound <= upperBound
    }
}

// MARK: - .clamped(to:)

extension Comparable {
    // ie: 5.clamped(to: 7...10)
    // ie: 5.0.clamped(to: 7.0...10.0)
    // ie: "a".clamped(to: "b"..."h")
    /// **OTCore:**
    /// Returns the value clamped to the passed range.
    @inlinable @_disfavoredOverload
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
    
    // ie: 5.clamped(to: 300...)
    // ie: 5.0.clamped(to: 300.00...)
    // ie: "a".clamped(to: "b"...)
    /// **OTCore:**
    /// Returns the value clamped to the passed range.
    @inlinable @_disfavoredOverload
    public func clamped(to limits: PartialRangeFrom<Self>) -> Self {
        max(self, limits.lowerBound)
    }
    
    // ie: 400.clamped(to: ...300)
    // ie: 400.0.clamped(to: ...300.0)
    // ie: "k".clamped(to: ..."h")
    /// **OTCore:**
    /// Returns the value clamped to the passed range.
    @inlinable @_disfavoredOverload
    public func clamped(to limits: PartialRangeThrough<Self>) -> Self {
        min(self, limits.upperBound)
    }
    
    // ie: 5.0.clamped(to: 7.0..<10.0)
    // not a good idea to implement this -- floating point numbers don't make sense in a ..< type
    // range because would the max of 7.0..<10.0 be 9.999999999...? It can't be 10.0.
    // func clamped(to limits: Range<Self>) -> Self { }
}

extension Strideable {
    // ie: 400.clamped(to: ..<300)
    // won't work for String
    /// **OTCore:**
    /// Returns the value clamped to the passed range.
    @inlinable @_disfavoredOverload
    public func clamped(to limits: PartialRangeUpTo<Self>) -> Self {
        // advanced(by:) requires Strideable, not available on just Comparable
        min(self, limits.upperBound.advanced(by: -1))
    }
}

extension Strideable where Self.Stride: SignedInteger {
    // ie: 5.clamped(to: 7..<10)
    // won't work for String
    /// **OTCore:**
    /// Returns the value clamped to the passed range.
    @inlinable @_disfavoredOverload
    public func clamped(to limits: Range<Self>) -> Self {
        // index(before:) only available on SignedInteger
        min(
            max(self, limits.lowerBound),
            limits.index(before: limits.upperBound)
        )
    }
}

// MARK: - .first(excluding:) ClosedRange

extension ClosedRange where Bound: SignedInteger, Bound.Stride: SignedInteger {
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// This method is only typically useful on an `excluding` array that has been `sorted()` first.
    ///
    /// - note: where possible, use the `first(excluding: Range)` variants of this method because
    ///   they are far more performant than this one.
    ///
    /// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count;
    ///   lazily over `self.count`.
    @_disfavoredOverload
    public func first(excluding: ArraySlice<Bound>) -> Bound? {
        guard !excluding.isEmpty else {
            return first
        }
        
        return first(where: { !excluding.contains($0) })
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// This method is only typically useful on an `excluding` array that has been `sorted()` first.
    ///
    /// - note: where possible, use the `first(excluding: Range)` variants of this method because
    ///   they are far more performant than this one.
    ///
    /// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count;
    ///   lazily over `self.count`.
    @_disfavoredOverload
    public func first(excluding: [Bound]) -> Bound? {
        first(excluding: ArraySlice(excluding))
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    /// This method assumes the `presortedExcluding` array is already pre-sorted.
    ///
    /// This method may be more performant than calling `first(excluding: ArraySlice)` for large
    /// `presortedExcluding` arrays or potentially large overlays between `self` and
    /// `presortedExcluding`.
    ///
    /// - note: Where possible, use the `first(excluding: Range)` variants of this method because
    ///   they are far more performant.
    ///
    /// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count;
    ///   lazily over `self.count`.
    @_disfavoredOverload
    public func first(presortedExcluding: ArraySlice<Bound>) -> Bound? {
        guard !presortedExcluding.isEmpty else {
            return first
        }
        
        // optimization: check to see if entire excluding value set is < or > first base value; if so, just return first value
        if lowerBound < presortedExcluding
            .first! { return lowerBound }  // do excluding values start > first base value?
        if lowerBound > presortedExcluding
            .last! { return lowerBound }   // do excluding values end < first base value?
        
        var trimmedSortedExcluding: ArraySlice<Bound>?
        
        // optimization: trim exclusions, if exclusions start before first base value
        if lowerBound > presortedExcluding.first! {
            if let minExclusion = presortedExcluding.binarySearch(forValue: lowerBound) {
                trimmedSortedExcluding =
                    presortedExcluding[minExclusion.lowerBound ..< presortedExcluding.endIndex]
            }
        }
        
        // optimization: trim exclusions, if exclusions end after last base value
        if let maxExclusion = presortedExcluding.binarySearch(forValue: upperBound) {
            if trimmedSortedExcluding != nil {
                trimmedSortedExcluding =
                    trimmedSortedExcluding![
                        trimmedSortedExcluding!.startIndex ... maxExclusion
                            .upperBound
                    ]
            } else {
                trimmedSortedExcluding =
                    presortedExcluding[presortedExcluding.startIndex ... maxExclusion.upperBound]
            }
        }
        
        return trimmedSortedExcluding != nil
            ? first(excluding: trimmedSortedExcluding!)
            : first(excluding: presortedExcluding)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    /// This method assumes the `presortedExcluding` array is already pre-sorted.
    ///
    /// This method may be more performant than calling `first(excluding: ArraySlice)` for large
    /// `presortedExcluding` arrays or potentially large overlays between `self` and
    /// `presortedExcluding`.
    ///
    /// - note: Where possible, use the `first(excluding: Range)` variants of this method because
    ///   they are far more performant.
    ///
    /// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count;
    ///   lazily over `self.count`.
    @_disfavoredOverload
    public func first(presortedExcluding: [Bound]) -> Bound? {
        first(presortedExcluding: ArraySlice(presortedExcluding))
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with a large base range and/or exclusion array)
    /// than simply passing a pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and
    ///   O(`self.count * excluding.count`).
    @_disfavoredOverload
    public func first(sortingAndExcluding: ArraySlice<Bound>) -> Bound? {
        // optimization: if not excluding anything, just return first value
        if sortingAndExcluding.isEmpty { return lowerBound }
        
        let sortedExcluding = sortingAndExcluding.sorted()
        
        return first(excluding: sortedExcluding)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with a large base range and/or exclusion array)
    /// than simply passing a pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and
    ///   O(`self.count * excluding.count`).
    @_disfavoredOverload
    public func first(sortingAndExcluding: [Bound]) -> Bound? {
        first(sortingAndExcluding: ArraySlice(sortingAndExcluding))
    }
}

extension ClosedRange where Bound.Stride: SignedInteger, Bound: Strideable {
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: ClosedRange<Bound>) -> Bound? {
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound >= lowerBound,
           excluding.upperBound < upperBound
        {
            return excluding.upperBound.advanced(by: 1)
        }
        
        return nil
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: Range<Bound>) -> Bound? {
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        if excluding.upperBound > lowerBound,
           excluding.upperBound <= upperBound
        {
            return excluding.upperBound
        }
        
        return nil
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
        if excluding.lowerBound <= lowerBound { return nil }
        
        return lowerBound
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeThrough<Bound>) -> Bound? {
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound < upperBound { return excluding.upperBound.advanced(by: 1) }
        
        return nil
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeUpTo<Bound>) -> Bound? {
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        if excluding.upperBound <= upperBound { return excluding.upperBound }
        
        return nil
    }
}

// MARK: - .first(excluding:) Range

extension Range where Bound: SignedInteger, Bound.Stride: SignedInteger {
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    /// This method is only typically useful on an array of values that has been `sorted()` first.
    ///
    /// - complexity: O(`self.count * excluding.count`), lazily over `self.count`.
    @_disfavoredOverload
    public func first(excluding: ArraySlice<Bound>) -> Bound? {
        guard !excluding.isEmpty else {
            return first
        }
        
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound ... upperBound - 1)
            .first(excluding: excluding)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    /// This method is only typically useful on an array of values that has been `sorted()` first.
    ///
    /// - complexity: O(`self.count * excluding.count`), lazily over `self.count`.
    @_disfavoredOverload
    public func first(excluding: [Bound]) -> Bound? {
        first(excluding: ArraySlice(excluding))
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    /// This method assumes the `presortedExcluding` array is already pre-sorted.
    ///
    /// This method may be more performant than calling `first(excluding: ArraySlice)` for large
    /// `presortedExcluding` arrays or potentially large overlays between `self` and
    /// `presortedExcluding`.
    ///
    /// - note: Where possible, use the `first(excluding: Range)` variants of this method because
    ///   they are far more performant.
    ///
    /// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count;
    ///   lazily over `self.count`.
    @_disfavoredOverload
    public func first(presortedExcluding: ArraySlice<Bound>) -> Bound? {
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound ... upperBound - 1)
            .first(presortedExcluding: presortedExcluding)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    /// This method assumes the `presortedExcluding` array is already pre-sorted.
    ///
    /// This method may be more performant than calling `first(excluding: ArraySlice)` for large
    /// `presortedExcluding` arrays or potentially large overlays between `self` and
    /// `presortedExcluding`.
    ///
    /// - note: Where possible, use the `first(excluding: Range)` variants of this method because
    ///   they are far more performant.
    ///
    /// - complexity: O(*n1* * *n2*), where *n1* == self.count, *n2* == excluding.count;
    ///   lazily over `self.count`.
    @_disfavoredOverload
    public func first(presortedExcluding: [Bound]) -> Bound? {
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound ... upperBound - 1)
            .first(presortedExcluding: ArraySlice(presortedExcluding))
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with a large base range and/or exclusion array)
    /// than simply passing a pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and
    ///   O(`self.count * excluding.count`).
    @_disfavoredOverload
    public func first(sortingAndExcluding: ArraySlice<Bound>) -> Bound? {
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound ... upperBound - 1)
            .first(sortingAndExcluding: sortingAndExcluding)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with a large base range and/or exclusion array)
    /// than simply passing a pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: Varies, somewhere between O(`sortingAndExcluding.count`) and
    ///   O(`self.count * excluding.count`).
    @_disfavoredOverload
    public func first(sortingAndExcluding: [Bound]) -> Bound? {
        first(sortingAndExcluding: ArraySlice(sortingAndExcluding))
    }
}

extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: ClosedRange<Bound>) -> Bound? {
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound >= lowerBound,
           excluding.upperBound < upperBound.advanced(by: -1)
        {
            return excluding.upperBound.advanced(by: 1)
        }
        
        return nil
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: Range<Bound>) -> Bound? {
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        if excluding.upperBound >= lowerBound,
           excluding.upperBound.advanced(by: -1) < upperBound.advanced(by: -1)
        {
            return excluding.upperBound
        }
        
        return nil
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
        if excluding.lowerBound <= lowerBound { return nil }
        
        return lowerBound
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeThrough<Bound>) -> Bound? {
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound < upperBound.advanced(by: -1) {
            return excluding.upperBound.advanced(by: 1)
        }
        
        return nil
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeUpTo<Bound>) -> Bound? {
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        if excluding.upperBound < upperBound { return excluding.upperBound }
        
        return nil
    }
}

// MARK: - .first(excluding:) PartialRangeFrom

extension PartialRangeFrom where Bound.Stride: SignedInteger, Bound: Strideable {
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// This method is only typically useful with an exclusion array of that has been `sorted()`
    /// first.
    ///
    /// - complexity: O(*n*), where *n* is the length of the exclusion array.
    @_disfavoredOverload
    public func first(excluding: ArraySlice<Bound>) -> Bound {
        // should always succeed since PartialRangeFrom values ascend infinitely
        // however, we provide a fallback
        
        first(where: { !excluding.contains($0) })
            ?? lowerBound
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// This method is only typically useful with an exclusion array of that has been `sorted()`
    /// first.
    ///
    /// - complexity: O(*n*), where *n* is the length of the exclusion array.
    @_disfavoredOverload
    public func first(excluding: [Bound]) -> Bound {
        first(excluding: ArraySlice(excluding))
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with an exclusion array) than simply passing a
    /// pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: O(*n*), where *n* is the length of the exclusion array.
    @_disfavoredOverload
    public func first(presortedExcluding: ArraySlice<Bound>) -> Bound {
        if presortedExcluding.isEmpty { return lowerBound }
        
        if presortedExcluding.last! < lowerBound { return lowerBound }
        
        return presortedExcluding
            .firstGapValue(after: lowerBound.advanced(by: -1))
            ?? presortedExcluding.last!.advanced(by: 1)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with an exclusion array) than simply passing a
    /// pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: O(*n*), where *n* is the length of the exclusion array.
    @_disfavoredOverload
    public func first(presortedExcluding: [Bound]) -> Bound {
        first(presortedExcluding: ArraySlice(presortedExcluding))
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with an exclusion array) than simply passing a
    /// pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: O(*n*), where *n* is the length of the exclusion array.
    @_disfavoredOverload
    public func first(sortingAndExcluding: ArraySlice<Bound>) -> Bound {
        if sortingAndExcluding.isEmpty { return lowerBound }
        
        let sortedExcluding = sortingAndExcluding.sorted()
        
        if sortedExcluding.last! < lowerBound { return lowerBound }
        
        return sortedExcluding
            .firstGapValue(after: lowerBound.advanced(by: -1))
            ?? sortedExcluding.last!.advanced(by: 1)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `sortingAndExcluding`
    /// values.
    ///
    /// This method first sorts the values in `sortingAndExcluding` and includes additional logic
    /// that may be more efficient (when working with an exclusion array) than simply passing a
    /// pre-sorted array to `first(excluding:)`.
    ///
    /// - complexity: O(*n*), where *n* is the length of the exclusion array.
    @_disfavoredOverload
    public func first(sortingAndExcluding: [Bound]) -> Bound {
        first(sortingAndExcluding: ArraySlice(sortingAndExcluding))
    }
}

extension PartialRangeFrom where Bound.Stride: SignedInteger, Bound: Strideable {
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: ClosedRange<Bound>) -> Bound {
        if lowerBound < excluding.lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        return excluding.upperBound.advanced(by: 1)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: Range<Bound>) -> Bound {
        if lowerBound < excluding.lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        return excluding.upperBound
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
        if excluding.lowerBound <= lowerBound { return nil }
        
        return lowerBound
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeThrough<Bound>) -> Bound {
        if excluding.upperBound < lowerBound { return lowerBound }
        
        return excluding.upperBound.advanced(by: 1)
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, `nil` is returned.
    ///
    /// - complexity: O(1) or slightly higher
    @_disfavoredOverload
    public func first(excluding: PartialRangeUpTo<Bound>) -> Bound {
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        return excluding.upperBound
    }
}

// MARK: - Split

extension ClosedRange where Bound == Int {
    /// **OTCore:**
    /// Returns elements in groups of n number of elements.
    @_disfavoredOverload
    public func split(every: Int) -> [ClosedRange<Bound>] {
        if every < 1 {
            return isEmpty ? [] : [lowerBound ... upperBound]
        }
        
        if every == 1 {
            return map { $0 ... $0 }
        }
        
        var batches = count / every
        if count % every != 0 {
            batches += 1
        }
        
        return (0 ..< batches).reduce(into: [ClosedRange<Bound>]()) { base, batch in
            let offset = batch * every
            base += offset ... offset
                .advanced(by: every - 1)
                .clamped(to: ...upperBound)
        }
    }
}

extension Range where Bound == Int {
    /// **OTCore:**
    /// Returns elements in groups of n number of elements.
    @_disfavoredOverload
    public func split(every: Int) -> [ClosedRange<Bound>] {
        guard !isEmpty else { return [] }
        
        return (lowerBound ... upperBound.advanced(by: -1))
            .split(every: every)
    }
}

// MARK: - @Clamped Property Wrapper

extension RangeExpression where Bound: Strideable {
    /// **OTCore:**
    /// Returns the absolute bound values. Value(s) are `nil` when unbounded.
    @_disfavoredOverload
    public func getAbsoluteBounds() -> (min: Bound?, max: Bound?) {
        switch self {
        case let range as ClosedRange<Bound>:
            return range.absoluteBounds
            
        case let range as Range<Bound>:
            return range.absoluteBounds
            
        case let range as PartialRangeFrom<Bound>:
            return range.absoluteBounds
            
        case let range as PartialRangeUpTo<Bound>:
            return range.absoluteBounds
            
        case let range as PartialRangeThrough<Bound>:
            return range.absoluteBounds
            
        default:
            assertionFailure("Unexpected range type: \(type(of: self))")
            return (nil, nil)
        }
    }
}

extension ClosedRange {
    /// **OTCore:**
    /// Returns the absolute bound values. Value(s) are `nil` when unbounded.
    @_disfavoredOverload
    public var absoluteBounds: (min: Bound, max: Bound) {
        (min: lowerBound, max: upperBound)
    }
}

extension Range where Bound: Strideable {
    /// **OTCore:**
    /// Returns the absolute bound values. Value(s) are `nil` when unbounded.
    /// If range is empty, `min` and `max` will return `nil`.
    @_disfavoredOverload
    public var absoluteBounds: (min: Bound?, max: Bound?) {
        var newMin: Bound?
        var newMax: Bound?
        
        if lowerBound == upperBound {
            newMin = nil
            newMax = nil
        } else {
            let adjustedMin = lowerBound
            let adjustedMax = upperBound.advanced(by: -1)
            
            if adjustedMax < adjustedMin {
                // invalid range
                newMin = nil
                newMax = nil
            } else {
                newMin = adjustedMin
                newMax = adjustedMax
            }
        }
        
        return (min: newMin, max: newMax)
    }
}

extension PartialRangeUpTo where Bound: Strideable {
    /// **OTCore:**
    /// Returns the absolute bound values. Value(s) are `nil` when unbounded.
    @_disfavoredOverload
    public var absoluteBounds: (min: Bound?, max: Bound) {
        (min: nil, max: upperBound.advanced(by: -1))
    }
}

extension PartialRangeThrough {
    /// **OTCore:**
    /// Returns the absolute bound values. Value(s) are `nil` when unbounded.
    @_disfavoredOverload
    public var absoluteBounds: (min: Bound?, max: Bound) {
        (min: nil, max: upperBound)
    }
}

extension PartialRangeFrom {
    /// **OTCore:**
    /// Returns the absolute bound values. Value(s) are `nil` when unbounded.
    @_disfavoredOverload
    public var absoluteBounds: (min: Bound, max: Bound?) {
        (min: lowerBound, max: nil)
    }
}

// MARK: - .repeatEach { }

extension BinaryInteger {
    /// **OTCore:**
    /// Repeats the closure n number of times. The number must be > 0 otherwise the code is never
    /// executed.
    @_disfavoredOverload
    public func repeatEach(_ operation: @escaping () -> Void) {
        var increment = 0 as Self
        while increment < self {
            operation()
            increment += 1
        }
    }
}

extension ClosedRange where Element: BinaryInteger {
    /// **OTCore:**
    /// Repeats the closure once for each element in the range.
    @_disfavoredOverload
    public func repeatEach(_ operation: @escaping () -> Void) {
        for _ in self {
            operation()
        }
    }
}

extension Range where Element: BinaryInteger {
    /// **OTCore:**
    /// Repeats the closure once for each element in the range.
    @_disfavoredOverload
    public func repeatEach(_ operation: @escaping () -> Void) {
        for _ in self {
            operation()
        }
    }
}
