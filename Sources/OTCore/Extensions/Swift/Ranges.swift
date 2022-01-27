//
//  Ranges.swift
//  OTCore • https://github.com/orchetect/OTCore
//

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
    ///     5.isContained(in: 1...4) // == false
    ///
    /// To test if `self` is NOT contained in `range`:
    ///
    ///     !5.isContained(in: 1...4) // == true
    ///     // or
    ///     5.isContained(in: 1...4).toggled() // == true
    ///
    @inlinable public
    func isContained<R: RangeExpression>(in range: R) -> Bool
    where Self == R.Bound {
        
        range.contains(self)
        
    }
    
}


// MARK: - Comparable .ifContained(in:then:)

extension Comparable {
    
    /// **OTCore:**
    /// If `self` is in range, output the `newValue`, otherwise pass `self` through.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.ifContained(in: 1...500, then: 1000) // 1000
    ///
    ///     700.ifContained(in: 1...500) { 1000 } // 700
    ///
    ///     700.ifContained(in: 1...500) {
    ///         // perform more complex logic to produce a new value
    ///         let p = 500
    ///         return p * 2
    ///     }
    ///
    @inlinable public
    func ifContained<R: RangeExpression>(in range: R,
                                         then newValue: @autoclosure () throws -> R.Bound) rethrows -> R.Bound
    where Self == R.Bound {
        
        try range.contains(self) ? newValue() : self
        
    }
    
    /// **OTCore:**
    /// If `self` is in range, output the `newValue`, otherwise pass `self` through.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.ifContained(in: 1...500, then: { $0 + 5 }) // 128
    ///
    ///     700.ifContained(in: 1...500) { $0 + 5 } // 700
    ///
    ///     700.ifContained(in: 1...500) {
    ///         // perform more complex logic to produce a new value
    ///         let p = 5
    ///         return $0 + p
    ///     } // 700
    ///
    @inlinable public
    func ifContained<R: RangeExpression>(in range: R,
                                         then newValue: (Self) throws -> R.Bound) rethrows -> R.Bound
    where Self == R.Bound {
        
        try range.contains(self) ? newValue(self) : self
        
    }
    
    /// **OTCore:**
    /// If `self` is in range, output the `newValue`, otherwise returns `nil`.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.ifContained(in: 1...500, then: { "\($0) in range" })
    ///     // Optional("123 in range")
    ///
    ///     700.ifContained(in: 1...500) { "\($0) in range" }
    ///     // nil
    ///
    ///     700.ifContained(in: 1...500) { source -> String in
    ///         // perform more complex logic to produce a new value
    ///         let s = "in range"
    ///         return String(source) + " " + s
    ///     } nil
    ///
    @inlinable public
    func ifContained<R: RangeExpression, U>(in range: R,
                                            then newValue: (Self) throws -> U) rethrows -> U?
    where Self == R.Bound {
        
        try range.contains(self) ? newValue(self) : nil
        
    }
    
}


// MARK: - Comparable .ifNotContained(in:then:)

extension Comparable {
    
    /// **OTCore:**
    /// If `self` is not in range, output the new `value`, otherwise pass `self` through.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.ifNotContained(in: 1...500, then: 250) // 123
    ///
    ///     700.ifNotContained(in: 1...500) { 250 } // 250
    ///
    ///     700.ifNotContained(in: 1...500) {
    ///         // perform more complex logic to produce a new value
    ///         let p = 125
    ///         return p * 2
    ///     }
    ///
    @inlinable public
    func ifNotContained<R: RangeExpression>(in range: R,
                                            then newValue: @autoclosure () throws -> R.Bound) rethrows -> R.Bound
    where Self == R.Bound {
        
        try range.contains(self) ? self : newValue()
        
    }
    
    /// **OTCore:**
    /// If `self` is not in range, output the new `value`, otherwise pass `self` through.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.ifNotContained(in: 1...500, then: { $0 + 5 }) // 123
    ///
    ///     700.ifNotContained(in: 1...500) { $0 + 5 } // 705
    ///
    ///     700.ifNotContained(in: 1...500) {
    ///         // perform more complex logic to produce a new value
    ///         let p = 5
    ///         return $0 + p
    ///     } // 705
    ///
    @inlinable public
    func ifNotContained<R: RangeExpression>(in range: R,
                                            then newValue: (Self) throws -> R.Bound) rethrows -> R.Bound
    where Self == R.Bound {
        
        try range.contains(self) ? self : newValue(self)
        
    }
    
    /// **OTCore:**
    /// If `self` is in range, output the `newValue`, otherwise returns `nil`.
    /// (Functional convenience method)
    ///
    /// Example:
    ///
    ///     123.ifNotContained(in: 1...500, then: "\($0) not in range")
    ///     // nil
    ///
    ///     700.ifNotContained(in: 1...500) { "\($0) not in range" }
    ///     // Optional("700 not in range")
    ///
    ///     700.ifNotContained(in: 1...500) { source -> String in
    ///         // perform more complex logic to produce a new value
    ///         let s = "not in range"
    ///         return String(source) + " " + s
    ///     } // Optional("700 not in range")
    ///
    @inlinable public
    func ifNotContained<R: RangeExpression, U>(in range: R,
                                               then newValue: (Self) throws -> U) rethrows -> U?
    where Self == R.Bound {
        
        try range.contains(self) ? nil : newValue(self)
        
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
    @inlinable public
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        
        other.lowerBound >= lowerBound &&
        other.upperBound <= upperBound
        
    }
    
}

extension ClosedRange where Bound : Strideable,
                            Bound.Stride : SignedInteger {
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: Range<Bound>) -> Bool {
        
        guard let unwrappedMax = self.max() else { return false }
        
        guard !other.isEmpty else { return false }
        
        return other.lowerBound >= lowerBound &&
            other.upperBound.advanced(by: -1) <= unwrappedMax
        
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
    @inlinable public
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        
        other.lowerBound >= lowerBound &&
        other.upperBound < upperBound
        
    }
    
}

extension Range where Bound : Strideable,
                      Bound.Stride : SignedInteger {
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: Range<Bound>) -> Bool {
        
        other.lowerBound >= lowerBound &&
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
    @inlinable public
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        
        other.lowerBound >= lowerBound
        
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: Range<Bound>) -> Bool {
        
        other.lowerBound >= lowerBound
        
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: PartialRangeFrom<Bound>) -> Bool {
        
        other.lowerBound >= lowerBound
        
    }
    
}


// MARK: - PartialRangeThrough.contains(range)

// these don't make sense to implement since they would always return false:
// - PartialRangeThrough.contains(PartialRangeFrom)

extension PartialRangeThrough {
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        
        other.upperBound <= upperBound
        
    }
}

extension PartialRangeThrough where Bound : BinaryInteger,
                                    Bound.Stride : FixedWidthInteger {
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: Range<Bound>) -> Bool {
        
        guard other.upperBound > Bound.Stride.min else { return false }
        
        return other.upperBound.advanced(by: -1) <= upperBound
        
    }
    
}

extension PartialRangeThrough {
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: PartialRangeThrough<Bound>) -> Bool {
        
        other.upperBound <= upperBound
        
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: PartialRangeUpTo<Bound>) -> Bool {
        
        other.upperBound < upperBound
        
    }
    
}

// MARK: - PartialRangeUpTo.contains(range)

// these don't make sense to implement since they would always return false:
// - PartialRangeUpTo.contains(PartialRangeFrom)

extension PartialRangeUpTo {
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        
        other.upperBound < upperBound
        
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: Range<Bound>) -> Bool {
        
        other.upperBound <= upperBound
        
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: PartialRangeThrough<Bound>) -> Bool {
        
        other.upperBound < upperBound
        
    }
    
    /// **OTCore:**
    /// Returns `true` if base range contains the given range.
    @inlinable public
    func contains(_ other: PartialRangeUpTo<Bound>) -> Bool {
        
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
    @inlinable public
    func clamped(to limits: ClosedRange<Self>) -> Self {
        
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
            return first
        }
        
        return first(where: { !excluding.contains($0) } )
        
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
            return first
        }
        
        // optimization: check to see if entire excluding value set is < or > first base value; if so, just return first value
        if lowerBound < presortedExcluding.first! { return lowerBound }  // do excluding values start > first base value?
        if lowerBound > presortedExcluding.last! { return lowerBound }   // do excluding values end < first base value?
        
        var trimmedSortedExcluding: ArraySlice<Bound>?
        
        // optimization: trim exclusions, if exclusions start before first base value
        if lowerBound > presortedExcluding.first! {
            if let minExclusion = presortedExcluding.binarySearch(forValue: lowerBound) {
                trimmedSortedExcluding = presortedExcluding[minExclusion.lowerBound..<presortedExcluding.endIndex]
            }
        }
        
        // optimization: trim exclusions, if exclusions end after last base value
        if let maxExclusion = presortedExcluding.binarySearch(forValue: upperBound) {
            if trimmedSortedExcluding != nil {
                trimmedSortedExcluding = trimmedSortedExcluding![trimmedSortedExcluding!.startIndex...maxExclusion.upperBound]
            } else {
                trimmedSortedExcluding = presortedExcluding[presortedExcluding.startIndex...maxExclusion.upperBound]
            }
        }
        
        return trimmedSortedExcluding != nil
            ? first(excluding: trimmedSortedExcluding!)
            : first(excluding: presortedExcluding)
        
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
        if sortingAndExcluding.count == 0 { return lowerBound }
        
        let sortedExcluding = sortingAndExcluding.sorted()
        
        return first(excluding: sortedExcluding)
        
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
        
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound >= lowerBound &&
            excluding.upperBound < upperBound {
            return excluding.upperBound.advanced(by: 1)
        }
        
        return nil
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: Range<Bound>) -> Bound? {
        
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        if excluding.upperBound > lowerBound &&
            excluding.upperBound <= upperBound {
            return excluding.upperBound
        }
        
        return nil
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
        
        if excluding.lowerBound <= lowerBound { return nil }
        
        return lowerBound
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeThrough<Bound>) -> Bound? {
        
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound < upperBound { return excluding.upperBound.advanced(by: 1) }
        
        return nil
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
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
    /// If there are no available elements, nil is returned.
    /// This method is only typically useful on an array of values that has been `.sorted()` first.
    ///
    /// - complexity: O(`self.count * excluding.count`), lazily over `self.count`.
    public func first(excluding: ArraySlice<Bound>) -> Bound? {
        
        guard excluding.count > 0 else {
            return self.first
        }
        
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound...upperBound-1)
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
        
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound...upperBound-1)
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
        
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound...upperBound-1)
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
        
        if upperBound == lowerBound { return nil }
        
        // Form ClosedRange and call .first(...) on it
        return (lowerBound...upperBound-1)
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
        
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound >= lowerBound &&
            excluding.upperBound < upperBound.advanced(by: -1) {
            return excluding.upperBound.advanced(by: 1)
        }
        
        return nil
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: Range<Bound>) -> Bound? {
        
        if excluding.lowerBound > lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        if excluding.upperBound >= lowerBound &&
            excluding.upperBound.advanced(by: -1) < upperBound.advanced(by: -1) {
            return excluding.upperBound
        }
        
        return nil
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
        
        if excluding.lowerBound <= lowerBound { return nil }
        
        return lowerBound
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeThrough<Bound>) -> Bound? {
        
        if excluding.upperBound < lowerBound { return lowerBound }
        
        if excluding.upperBound < upperBound.advanced(by: -1) {
            return excluding.upperBound.advanced(by: 1)
        }
        
        return nil
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values. If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeUpTo<Bound>) -> Bound? {
        
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        if excluding.upperBound < upperBound { return excluding.upperBound }
        
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
        
        first(where: { !excluding.contains($0) } )
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
        
        if presortedExcluding.isEmpty { return lowerBound }
        
        if presortedExcluding.last! < lowerBound { return lowerBound }
        
        return presortedExcluding
            .firstGapValue(after: lowerBound.advanced(by: -1))
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
        
        if sortingAndExcluding.isEmpty { return lowerBound }
        
        let sortedExcluding = sortingAndExcluding.sorted()
        
        if sortedExcluding.last! < lowerBound { return lowerBound }
        
        return sortedExcluding
            .firstGapValue(after: lowerBound.advanced(by: -1))
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
        
        if lowerBound < excluding.lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        return excluding.upperBound.advanced(by: 1)
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: Range<Bound>) -> Bound {
        
        if lowerBound < excluding.lowerBound { return lowerBound }
        
        // no overlaps in ranges; return first
        if excluding.upperBound < lowerBound { return lowerBound }
        
        return excluding.upperBound
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeFrom<Bound>) -> Bound? {
        
        if excluding.lowerBound <= lowerBound { return nil }
        
        return lowerBound
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeThrough<Bound>) -> Bound {
        
        if excluding.upperBound < lowerBound { return lowerBound }
        
        return excluding.upperBound.advanced(by: 1)
        
    }
    
    /// **OTCore:**
    /// Returns the first element of the range that does not match any of the `excluding` values.
    /// If there are no available elements, nil is returned.
    /// - complexity: O(1) or slightly higher
    public func first(excluding: PartialRangeUpTo<Bound>) -> Bound {
        
        if excluding.upperBound <= lowerBound { return lowerBound }
        
        return excluding.upperBound
        
    }
    
}


// MARK: - @Clamped Property Wrapper

@propertyWrapper
public struct Clamped<Value> where Value : Comparable {
    
    var min: Value?
    var max: Value?
    private var value: Value
    
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = Self.clamping(newValue, min: min, max: max)
        }
    }
    
    private static func clamping(_ value: Value,
                                 min: Value?,
                                 max: Value?) -> Value {
        
        if let min = min {
            if let max = max {
                return value.clamped(to: min...max)
            } else {
                return value.clamped(to: min...)
            }
        } else if let max = max {
            return value.clamped(to: ...max)
        } else {
            return value
        }
        
    }
    
    public init(wrappedValue defaultValue: Value,
                to range: ClosedRange<Value>) {
        
        let newMin = range.lowerBound
        let newMax = range.upperBound
        
        self.min = newMin
        self.max = newMax
        
        self.value = Self.clamping(defaultValue,
                                   min: newMin,
                                   max: newMax)
        
    }
    
    public init(wrappedValue defaultValue: Value,
                to range: Range<Value>) where Value : Strideable {
        
        var newMin: Value?
        var newMax: Value?
        
        if range.lowerBound == range.upperBound {
            newMin = nil
            newMax = nil
        } else {
            let adjustedMin = range.lowerBound
            let adjustedMax = range.upperBound.advanced(by: -1)
            
            if adjustedMax <= adjustedMin {
                // invalid range
                newMin = nil
                newMax = nil
            } else {
                newMin = adjustedMin
                newMax = adjustedMax
            }
        }
        
        self.min = newMin
        self.max = newMax
        
        self.value = Self.clamping(defaultValue,
                                   min: newMin,
                                   max: newMax)
        
    }
    
    public init(wrappedValue defaultValue: Value,
                to range: PartialRangeUpTo<Value>) where Value : Strideable {
        
        let newMin: Value? = nil
        let newMax: Value? = range.upperBound.advanced(by: -1)
        
        self.min = newMin
        self.max = newMax
        
        self.value = Self.clamping(defaultValue,
                                   min: newMin,
                                   max: newMax)
        
    }
    
    public init(wrappedValue defaultValue: Value,
                to range: PartialRangeThrough<Value>) {
        
        let newMin: Value? = nil
        let newMax: Value? = range.upperBound
        
        self.min = newMin
        self.max = newMax
        
        self.value = Self.clamping(defaultValue,
                                   min: newMin,
                                   max: newMax)
        
    }
    
    public init(wrappedValue defaultValue: Value,
                to range: PartialRangeFrom<Value>) {
        
        let newMin: Value? = range.lowerBound
        let newMax: Value? = nil
        
        self.min = newMin
        self.max = newMax
        
        self.value = Self.clamping(defaultValue,
                                   min: newMin,
                                   max: newMax)
        
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
