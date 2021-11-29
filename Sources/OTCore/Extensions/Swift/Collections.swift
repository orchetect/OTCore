//
//  Collections.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - Operators

extension Collection where Self: RangeReplaceableCollection,
                           Self: MutableCollection {
    
    /// **OTCore:**
    /// Syntactic sugar: Append an element to an array.
    @inlinable static public func += (lhs: inout Self, rhs: Element) {
        
        lhs.append(rhs)
        
    }
    
}

// MARK: - Safe subscripts

// MutableCollection:
// (inherits from Sequence, Collection)
// (conformance on Array, ArraySlice, ContiguousArray, CollectionOfOne, EmptyCollection, etc.)
// (does not conform on Set, Dictionary, Range, ClosedRange, KeyValuePairs, etc.)
extension MutableCollection {
    
    /// **OTCore:**
    /// Access collection indexes safely.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safe: 0] // Optional(1)
    ///     arr[safe: 9] // nil
    ///
    @inlinable public subscript(safe index: Index) -> Element? {
        
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            guard indices.contains(index) else { return }
            
            self[index] = newValue!
        }
        
    }
    
}

// Collection:
// (inherits from Sequence)
// (conformance on Array, ArraySlice, ContiguousArray, Dictionary, Set, Range, ClosedRange, KeyValuePairs, CollectionOfOne, EmptyCollection, etc.)
// (does not conform on NSArray, NSDictionary, etc.)
extension Collection {
    
    /// **OTCore:**
    /// Access collection indexes safely.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safe: 0] // Optional(1)
    ///     arr[safe: 9] // nil
    ///
    @inlinable public subscript(safe index: Index) -> Element? {
        
        indices.contains(index) ? self[index] : nil
        
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index does not exist (out-of-bounds), `defaultValue` is returned.
    @inlinable public subscript(
        safe index: Index,
        default defaultValue: @autoclosure () -> Element
    ) -> Element {
        
        indices.contains(index) ? self[index] : defaultValue()
        
    }
    
}

extension Collection where Index == Int {
    
    /// **OTCore:**
    /// Access collection indexes safely.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safe: 0] // Optional(1)
    ///     arr[safe: 9] // nil
    ///
    @inlinable public subscript(safe index: Int) -> Element? {
        
        guard count > 0 else { return nil }
        guard index >= 0 else { return nil }
        
        let idx = indices.index(startIndex, offsetBy: index)
        
        return index < indices.count ? self[idx] : nil
        
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index does not exist (out-of-bounds), `defaultValue` is returned.
    @inlinable public subscript(
        safe index: Int,
        default defaultValue: @autoclosure () -> Element
    ) -> Element {
        
        guard count > 0 else { return defaultValue() }
        guard index >= 0 else { return defaultValue() }
        
        let idx = indices.index(startIndex, offsetBy: index)
        
        return index < indices.count ? self[idx] : defaultValue()
        
    }
    
}


// MARK: - .remove(safeAt:)

extension RangeReplaceableCollection {
    
    /// **OTCore:**
    /// Same as `.remove(at:)` but returns an optional instead of throwing an exception if the index does not exist
    @discardableResult
    @inlinable public mutating func remove(safeAt index: Index) -> Element? {
        
        if indices.contains(index) {
            return remove(at: index)
        }
        
        return nil
        
    }
    
}


// MARK: - Indexes

extension Collection {
    
    /// **OTCore:**
    /// Returns an index that is the specified distance from the start index.
    public func startIndex(offsetBy distance: Int) -> Index {
        index(startIndex, offsetBy: distance)
    }
    
    /// **OTCore:**
    /// Returns an index that is the specified distance from the start index.
    public func endIndex(offsetBy distance: Int) -> Index {
        index(endIndex, offsetBy: distance)
    }
    
}

extension Collection {
    
    /// **OTCore:**
    /// Returns the character at the given character position (offset from the start index).
    public subscript(position offsetIndex: Int) -> Element {
        
        let fromIndex = index(startIndex, offsetBy: offsetIndex)
        return self[fromIndex]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: ClosedRange<Int>) -> SubSequence {
        
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex...toIndex]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: Range<Int>) -> SubSequence {
        
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex..<toIndex]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: PartialRangeFrom<Int>) -> SubSequence {
        
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        return self[fromIndex...]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: PartialRangeThrough<Int>) -> SubSequence {
        
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[...toIndex]
        
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    public subscript(position offsetRange: PartialRangeUpTo<Int>) -> SubSequence {
        
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[..<toIndex]
        
    }
    
}


// MARK: - Array[wrapping:]

extension Array {
    
    /// **OTCore:**
    /// Subscript override that wraps the index (positive or negative)
    ///
    /// Example:
    ///
    ///     let x = ["0", "1", "2", "3", "4"]
    ///
    ///     x[wrapping: 0]  // "0"
    ///     x[wrapping: 4]  // "4"
    ///     x[wrapping: 5]  // "0"
    ///     x[wrapping: 6]  // "1"
    ///     x[wrapping: -1] // "4"
    ///     x[wrapping: -4] // "1"
    ///     x[wrapping: -5] // "0"
    ///     x[wrapping: -6] // "4"
    ///
    @inlinable public subscript(wrapping index: Index) -> Iterator.Element {
        
        let max = count
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


// MARK: - count(of:)

extension Collection where Element : Hashable {
    
    /// **OTCore:**
    /// Counts number of occurrences of the given element
    /// - complexity: O(*n*)
    @inlinable public func count(of element: Element) -> Int {
        
        filter{$0 == element}.count
        
    }
    
}


// MARK: - stringValueArrayLiteral

extension Collection where Element: BinaryInteger {
    
    /// **OTCore:**
    /// Returns a string of integer literals, useful for generating Swift array declarations when debugging.
    @inlinable public var stringValueArrayLiteral: String {
        
        map { "\($0)" }
            .joined(separator: ", " )
            .wrapped(with: .brackets)
        
    }
    
}


// MARK: - Collection.firstGapValue

extension Collection where Element: Strideable,
                           Element.Stride: SignedInteger,
                           Self.Index: Strideable,
                           Self.Index.Stride: SignedInteger {
    
    /// **OTCore:**
    /// Returns the first gap value not contained in the array.
    ///
    /// Starting at the first element of the array, walks through the array lazily searching for gap of `n2 > n1+1` in values and returns the missing value.
    ///
    /// This method is only typically useful on an array of values that has been `.sorted()` first. Passing the `after` parameter will only return a gap value if it's greater than the `after` value.
    ///
    /// If there are no gaps, `nil` is returned.
    ///
    /// If the array is empty, `nil` is returned since there is no first element to derive a value from.
    ///
    /// Example:
    ///
    ///     [].firstGapValue                    // nil
    ///     [1,  3,4,5].firstGapValue           // 2
    ///     [1,2,  4,5].firstGapValue           // 3
    ///     [1,2,3,4  ].firstGapValue           // nil
    ///     [1,3,5,7,9].firstGapValue(after: 2) // 4
    ///
    /// - complexity: O(*n*), where *n* represents index of first gap in the array
    @inlinable public func firstGapValue(after: Element? = nil) -> Element? {
        
        guard count > 0 else { return nil }
        
        for idx in startIndex..<endIndex {
            
            if idx >= endIndex.advanced(by: -1) { continue }
            
            if self[idx.advanced(by: 1)] > (self[idx].advanced(by: 1)) {
                // found a gap
                let gapValue = self[idx].advanced(by: 1)
                if after == nil { return gapValue }
                if gapValue > after! { return gapValue }
            }
            
        }
        
        return nil
        
    }
    
}


// MARK: - Set.union

extension Set {
    
    /// **OTCore:**
    /// Same as `.union()` but replaces existing values with new values instead of `.union()`'s behavior of retaining existing hash-equivalent values.
    @inlinable public func union<S>(updating other: S) -> Set<Set<Element>.Element>
    where Element == S.Element, S : Sequence {
        
        var newSet = self
        
        other.forEach {
            newSet.update(with: $0)
        }
        
        return newSet
        
    }
    
    /// **OTCore:**
    /// Same as `.formUnion()` but replaces existing values with new values instead of `.formUnion()`'s behavior of retaining existing hash-equivalent values.
    @inlinable public mutating func formUnion<S>(updating other: S)
    where Element == S.Element, S : Sequence {
        
        self = union(updating: other)
        
    }
    
}

// MARK: - ArraySlice

extension ArraySlice {
    
    /// **OTCore:**
    /// Same as `Array(self)`, to return the `ArraySlice` as a concrete Array.
    /// (Functional convenience method)
    @inlinable public var array: [Element] {
        
        Array(self)
        
    }
    
}

// MARK: - Grouping

extension Sequence {
    
    /// **OTCore:**
    /// Same as `Dictionary(grouping: self, by:)`.
    /// (Functional convenience method)
    @inlinable public func grouping<Key: Hashable>(
        by keyForValue: (Element) throws -> Key
    ) rethrows -> [Key : [Element]] {
        
        try Dictionary(grouping: self, by: keyForValue)
        
    }
    
}

// MARK: - Dictionary map

extension Dictionary {
    
    // Swift Standard Library provides `mapValues`,
    // so `mapKeys` and `mapDictionary` methods are useful accompaniments
    
    /// **OTCore:**
    /// Returns a new dictionary containing the values of this dictionary with the keys transformed by the given closure.
    @inlinable public func mapKeys<K: Hashable>(
        _ transform: (Key) throws -> K
    ) rethrows -> Dictionary<K, Value> {
        
        try reduce(into: [:]) { partialResult, keyValuePair in
            let transformedKey = try transform(keyValuePair.0)
            partialResult[transformedKey] = keyValuePair.1
        }
        
    }
    
    /// **OTCore:**
    /// Returns a new dictionary with key/value pairs transformed by the given closure.
    @inlinable public func mapDictionary<K: Hashable, V: Any>(
        _ transform: (Key, Value) throws -> (K, V)
    ) rethrows -> Dictionary<K, V> {
        
        try reduce(into: [:]) { partialResult, keyValuePair in
            let transformedKeyPair = try transform(keyValuePair.0, keyValuePair.1)
            partialResult[transformedKeyPair.0] = transformedKeyPair.1
        }
        
    }
    
}
