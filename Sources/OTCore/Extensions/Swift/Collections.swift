//
//  Collections.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Typealiases & Protocols

/// **OTCore:**
/// A `Sequence` whose elements consist of those in a `Base Sequence` passed through a transform
/// function returning `Element?`. These elements are computed lazily, each time they’re read, by
/// calling the transform function on a base element.
/// Similar to `LazyMapSequence` but uses `compactMap` instead of `map`.
public typealias LazyCompactMapSequence<Base: Sequence, Element> = LazyMapSequence<
    LazyFilterSequence<LazyMapSequence<LazySequence<Base>.Elements, Element?>>,
    Element
>

/// **OTCore:**
/// A lazily filtered ``LazyCompactMapSequence``.
public typealias LazyFilteredCompactMapSequence<Base: Sequence, Element> = LazyFilterSequence<
    LazyCompactMapSequence<Base, Element>.Elements
>

// MARK: - Operators

extension Collection where Self: RangeReplaceableCollection,
Self: MutableCollection {
    /// **OTCore:**
    /// Syntactic sugar: Append an element to an array.
    @inlinable @_disfavoredOverload
    public static func += (lhs: inout Self, rhs: Element) {
        lhs.append(rhs)
    }
}

extension Set {
    /// **OTCore:**
    /// Syntactic sugar: Insert an element to a set.
    @inlinable @_disfavoredOverload
    public static func += (lhs: inout Self, rhs: Element) {
        lhs.insert(rhs)
    }
    
    /// **OTCore:**
    /// Syntactic sugar: Return a new set by inserting the contents of another set into the set.
    @inlinable @_disfavoredOverload
    public static func + <S>(lhs: Self, rhs: S) -> Self 
    where S: Sequence, S.Element == Element
    {
        var copy = lhs
        copy.formUnion(rhs)
        return copy
    }
    
    /// **OTCore:**
    /// Syntactic sugar: Insert the contents of another set into the set.
    @inlinable @_disfavoredOverload
    public static func += <S>(lhs: inout Self, rhs: S)
    where S: Sequence, S.Element == Element
    {
        lhs.formUnion(rhs)
    }
}

// MARK: - [safe:]

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
    /// Set: if index does not exist, set fails silently and the value is not stored. Note that setting `nil` on a non-Optional element is not supported.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safe: 0] // Optional(1)
    ///     arr[safe: 3] // nil
    ///
    ///     // for slice, index numbers are preserved like native subscript
    ///     let arrSlice = [1, 2, 3].suffix(2)
    ///     arrSlice[safe: 0] // nil
    ///     arrSlice[safe: 1] // Optional(2)
    ///     arrSlice[safe: 2] // Optional(3)
    ///     arrSlice[safe: 3] // nil
    ///
    @inlinable @_disfavoredOverload
    public subscript(safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            guard indices.contains(index) else { return }
            
            // subscript getter and setter must be of the same type
            // (get is `Element?` so the set must also be `Element?`)
            
            // implementation makes it difficult or impossible to
            // allow setting an element to `nil` in a collection that contains Optionals,
            // because it's not easy to tell whether the collection contains Optionals or not,
            // so the best course of action is to not allow setting elements to `nil` at all.
            
            guard let newValueUnwrapped = newValue else {
                assertionFailure(
                    "Do not use [safe:] setter to set nil for elements on collections that contain Optionals. Setting nil has no effect."
                )
                return
            }
            
            self[index] = newValueUnwrapped
        }
        _modify {
            guard indices.contains(index) else {
                // _modify { } requires yield to be called, so we can't just return.
                // we have to allow the yield on a dummy variable first
                var dummy: Element?
                yield &dummy
                return
            }
            
            var valueForMutation: Element? = self[index]
            yield &valueForMutation
            
            // subscript getter and setter must be of the same type
            // (get is `Element?` so the set must also be `Element?`)
            
            // implementation makes it difficult or impossible to
            // allow setting an element to `nil` in a collection that contains Optionals,
            // because it's not easy to tell whether the collection contains Optionals or not,
            // so the best course of action is to not allow setting elements to `nil` at all.
            
            guard let valueToStore = valueForMutation else {
                assertionFailure(
                    "Do not use [safe:] setter to set nil for elements on collections that contain Optionals. Setting nil has no effect."
                )
                return
            }
            
            self[index] = valueToStore
        }
    }
}

extension MutableCollection where Element: OTCoreOptionalTyped {
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
    ///     arr[safe: 3] // nil
    ///
    ///     // for slice, index numbers are preserved like native subscript
    ///     let arrSlice = [1, 2, 3].suffix(2)
    ///     arrSlice[safe: 0] // nil
    ///     arrSlice[safe: 1] // Optional(2)
    ///     arrSlice[safe: 2] // Optional(3)
    ///     arrSlice[safe: 3] // nil
    ///
    @inlinable @_disfavoredOverload
    public subscript(safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            guard indices.contains(index) else { return }
            
            switch newValue {
            case .none:
                self[index] = Element.noneValue as! Element
            case let .some(wrapped):
                self[index] = wrapped
            }
        }
        _modify {
            guard indices.contains(index) else {
                // _modify { } requires yield to be called, so we can't just return.
                // we have to allow the yield on a dummy variable first
                var dummy: Element?
                yield &dummy
                return
            }
            
            var valueForMutation: Element? = self[index]
            yield &valueForMutation
            
            switch valueForMutation {
            case .none:
                self[index] = Element.noneValue as! Element
            case let .some(wrapped):
                self[index] = wrapped
            }
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
    ///     arr[safe: 3] // nil
    ///
    ///     // for slice, index numbers are preserved like native subscript
    ///     let arrSlice = [1, 2, 3].suffix(2)
    ///     arrSlice[safe: 0] // nil
    ///     arrSlice[safe: 1] // Optional(2)
    ///     arrSlice[safe: 2] // Optional(3)
    ///     arrSlice[safe: 3] // nil
    ///
    @inlinable @_disfavoredOverload
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index does not exist (out-of-bounds), `defaultValue` is returned.
    @inlinable @_disfavoredOverload
    public subscript(
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
    ///     arr[safe: 3] // nil
    ///
    ///     // for slice, index numbers are preserved like native subscript
    ///     let arrSlice = [1, 2, 3].suffix(2)
    ///     arrSlice[safe: 0] // nil
    ///     arrSlice[safe: 1] // Optional(2)
    ///     arrSlice[safe: 2] // Optional(3)
    ///     arrSlice[safe: 3] // nil
    ///
    @inlinable @_disfavoredOverload
    public subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - [safe: Range]

extension Collection {
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index range is not fully contained within the collection's indices, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safe range: ClosedRange<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex,
              range.upperBound < endIndex else { return nil }
        
        return self[range.lowerBound ... range.upperBound]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index range is not fully contained within the collection's indices, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safe range: Range<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex,
              range.upperBound <= endIndex else { return nil }
        
        return self[range.lowerBound ..< range.upperBound]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index range is not fully contained within the collection's indices, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safe range: PartialRangeFrom<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex,
              range.lowerBound <= endIndex else { return nil }
        
        return self[range.lowerBound...]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index range is not fully contained within the collection's indices, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safe range: PartialRangeThrough<Index>) -> SubSequence? {
        guard range.upperBound >= startIndex,
              range.upperBound < endIndex else { return nil }
        
        return self[...range.upperBound]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index range is not fully contained within the collection's indices, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safe range: PartialRangeUpTo<Index>) -> SubSequence? {
        guard range.upperBound >= startIndex,
              range.upperBound <= endIndex else { return nil }
        
        return self[..<range.upperBound]
    }
}

// MARK: - [safePosition:]

extension MutableCollection {
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[position: Int]` but returns `nil` if out-of-bounds.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored. Note that setting `nil` on a non-Optional element is not supported.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safePosition: 0] // Optional(1)
    ///     arr[safePosition: 3] // nil
    ///
    ///     let arrSlice = [1, 2, 3].suffix
    ///     arrSlice[safePosition: 0] // Optional(2)
    ///     arrSlice[safePosition: 2] // nil
    ///
    @inlinable @_disfavoredOverload
    public subscript(safePosition indexOffset: Int) -> Element? {
        get {
            guard indexOffset >= 0, indexOffset < count else { return nil }
            let idx = index(startIndex, offsetBy: indexOffset)
            return self[idx]
        }
        set {
            guard indexOffset >= 0, indexOffset < count else { return }
            let idx = index(startIndex, offsetBy: indexOffset)
            
            // subscript getter and setter must be of the same type
            // (get is `Element?` so the set must also be `Element?`)
            
            // implementation makes it difficult or impossible to
            // allow setting an element to `nil` in a collection that contains Optionals,
            // because it's not easy to tell whether the collection contains Optionals or not,
            // so the best course of action is to not allow setting elements to `nil` at all.
            
            guard let newValueUnwrapped = newValue else {
                assertionFailure(
                    "Do not use [safe:] setter to set nil for elements on collections that contain Optionals. Setting nil has no effect."
                )
                return
            }
            
            self[idx] = newValueUnwrapped
        }
        _modify {
            guard indexOffset >= 0, indexOffset < count else {
                // _modify { } requires yield to be called, so we can't just return.
                // we have to allow the yield on a dummy variable first
                var dummy: Element?
                yield &dummy
                return
            }
            
            let idx = index(startIndex, offsetBy: indexOffset)
            
            var valueForMutation: Element? = self[idx]
            yield &valueForMutation
            
            // subscript getter and setter must be of the same type
            // (get is `Element?` so the set must also be `Element?`)
            
            // implementation makes it difficult or impossible to
            // allow setting an element to `nil` in a collection that contains Optionals,
            // because it's not easy to tell whether the collection contains Optionals or not,
            // so the best course of action is to not allow setting elements to `nil` at all.
            
            guard let valueToStore = valueForMutation else {
                assertionFailure(
                    "Do not use [safe:] setter to set nil for elements on collections that contain Optionals. Setting nil has no effect."
                )
                return
            }
            
            self[idx] = valueToStore
        }
    }
}

extension MutableCollection where Element: OTCoreOptionalTyped {
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[position: Int]` but returns `nil` if out-of-bounds.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safePosition: 0] // Optional(1)
    ///     arr[safePosition: 3] // nil
    ///
    ///     let arrSlice = [1, 2, 3].suffix
    ///     arrSlice[safePosition: 0] // Optional(2)
    ///     arrSlice[safePosition: 2] // nil
    ///
    @inlinable @_disfavoredOverload
    public subscript(safePosition indexOffset: Int) -> Element? {
        get {
            guard indexOffset >= 0, indexOffset < count else { return nil }
            let idx = index(startIndex, offsetBy: indexOffset)
            return self[idx]
        }
        set {
            guard indexOffset >= 0, indexOffset < count else { return }
            let idx = index(startIndex, offsetBy: indexOffset)
            
            switch newValue {
            case .none:
                self[idx] = Element.noneValue as! Element
            case let .some(wrapped):
                self[idx] = wrapped
            }
        }
        _modify {
            guard indexOffset >= 0, indexOffset < count else {
                // _modify { } requires yield to be called, so we can't just return.
                // we have to allow the yield on a dummy variable first
                var dummy: Element?
                yield &dummy
                return
            }
            
            let idx = index(startIndex, offsetBy: indexOffset)
            
            var valueForMutation: Element? = self[idx]
            yield &valueForMutation
            
            switch valueForMutation {
            case .none:
                self[idx] = Element.noneValue as! Element
            case let .some(wrapped):
                self[idx] = wrapped
            }
        }
    }
}

extension Collection where Index == Int {
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[position: Int]` but returns `nil` if out-of-bounds.
    ///
    /// Get: if index does not exist (out-of-bounds), `nil` is returned.
    ///
    /// Set: if index does not exist, set fails silently and the value is not stored.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safePosition: 0] // Optional(1)
    ///     arr[safePosition: 3] // nil
    ///
    ///     let arrSlice = [1, 2, 3].suffix(2)
    ///     arrSlice[safePosition: 0] // Optional(2)
    ///     arrSlice[safePosition: 2] // nil
    ///
    @inlinable @_disfavoredOverload
    public subscript(safePosition index: Int) -> Element? {
        guard count > 0,
              (0 ..< count).contains(index) else { return nil }
        
        let idx = indices.index(startIndex, offsetBy: index)
        
        return self[idx]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index does not exist (out-of-bounds), `defaultValue` is returned.
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safe: 0, default: 99] // 1
    ///     arr[safe: 3, default: 99] // 99
    ///
    ///     let arrSlice = [1, 2, 3].suffix(2)
    ///     arrSlice[safe: 0, default: 99] // 99
    ///     arrSlice[safe: 1, default: 99] // 2
    ///     arrSlice[safe: 2, default: 99] // 3
    ///     arrSlice[safe: 3, default: 99] // 99
    ///
    @inlinable @_disfavoredOverload
    public subscript(
        safe index: Int,
        default defaultValue: @autoclosure () -> Element
    ) -> Element {
        indices.contains(index) ? self[index] : defaultValue()
    }
    
    /// **OTCore:**
    /// Access collection indexes safely.
    /// If index does not exist (out-of-bounds), `defaultValue` is returned.
    ///
    /// Example:
    ///
    ///     let arr = [1, 2, 3]
    ///     arr[safePosition: 0, default: 99] // 1
    ///     arr[safePosition: 3, default: 99] // 99
    ///
    ///     let arrSlice = [1, 2, 3].suffix(2)
    ///     arrSlice[safePosition: 0, default: 99] // 2
    ///     arrSlice[safePosition: 1, default: 99] // 3
    ///     arrSlice[safePosition: 2, default: 99] // 99
    ///
    @inlinable @_disfavoredOverload
    public subscript(
        safePosition index: Int,
        default defaultValue: @autoclosure () -> Element
    ) -> Element {
        guard count > 0,
              (0 ..< count).contains(index) else { return defaultValue() }
        
        let idx = indices.index(startIndex, offsetBy: index)
        
        return self[idx]
    }
}

// MARK: - [safePosition: Range]

extension Collection where Index == Int {
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[Int]` but if position range is not fully contained within the collection's element position offsets, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safePosition range: ClosedRange<Int>) -> SubSequence? {
        guard range.lowerBound >= 0,
              range.upperBound < count else { return nil }
        
        let fromIndex = index(startIndex, offsetBy: range.lowerBound)
        let toIndex = index(startIndex, offsetBy: range.upperBound)
        
        return self[fromIndex ... toIndex]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[Int]` but if position range is not fully contained within the collection's element position offsets, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safePosition range: Range<Int>) -> SubSequence? {
        guard range.lowerBound >= 0,
              range.upperBound <= count else { return nil }
        
        let fromIndex = index(startIndex, offsetBy: range.lowerBound)
        let toIndex = index(startIndex, offsetBy: range.upperBound)
        
        return self[fromIndex ..< toIndex]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[Int]` but if position range is not fully contained within the collection's element position offsets, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safePosition range: PartialRangeFrom<Int>) -> SubSequence? {
        let fromIndex = index(startIndex, offsetBy: range.lowerBound)
        
        guard fromIndex >= startIndex,
              fromIndex <= endIndex else { return nil }
        
        return self[fromIndex...]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[Int]` but if position range is not fully contained within the collection's element position offsets, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safePosition range: PartialRangeThrough<Int>) -> SubSequence? {
        let toIndex = index(startIndex, offsetBy: range.upperBound)
        
        guard toIndex >= startIndex,
              toIndex < endIndex else { return nil }
        
        return self[...toIndex]
    }
    
    /// **OTCore:**
    /// Access collection indexes safely, referenced by position offset `0..<count`. (Same as `[Int]` but if position range is not fully contained within the collection's element position offsets, `nil` is returned.
    @inlinable @_disfavoredOverload
    public subscript(safePosition range: PartialRangeUpTo<Int>) -> SubSequence? {
        let toIndex = index(startIndex, offsetBy: range.upperBound)
        
        guard toIndex >= startIndex,
              toIndex <= endIndex else { return nil }
        
        return self[..<toIndex]
    }
}

// MARK: - .remove(safeAt:)

extension RangeReplaceableCollection {
    /// **OTCore:**
    /// Same as `.remove(at:)` but returns an optional instead of throwing an exception if the index does not exist
    @inlinable @discardableResult @_disfavoredOverload
    public mutating func remove(safeAt index: Index) -> Element? {
        if indices.contains(index) {
            return remove(at: index)
        }
        
        return nil
    }
}

extension RangeReplaceableCollection where Index == Int {
    /// **OTCore:**
    /// Same as `.remove(at:)` but returns an optional instead of throwing an exception if the element at the given offset position does not exist.
    /// References index as an offset from `startIndex` and does not reference indexes directly.
    @inlinable @discardableResult @_disfavoredOverload
    public mutating func remove(safePositionAt indexOffset: Int) -> Element? {
        guard indexOffset >= 0, indexOffset < count else { return nil }
        let idx = index(startIndex, offsetBy: indexOffset)
        return remove(at: idx)
    }
}

// MARK: - Indexes

extension Collection {
    /// **OTCore:**
    /// Returns an index that is the specified distance from the start index.
    @_disfavoredOverload
    public func startIndex(offsetBy distance: Int) -> Index {
        index(startIndex, offsetBy: distance)
    }
    
    /// **OTCore:**
    /// Returns an index that is the specified distance from the end index.
    @_disfavoredOverload
    public func endIndex(offsetBy distance: Int) -> Index {
        index(endIndex, offsetBy: distance)
    }
}

extension Collection {
    /// **OTCore:**
    /// Returns the character at the given character position (offset from the start index).
    @_disfavoredOverload
    public subscript(position offsetIndex: Int) -> Element {
        let fromIndex = index(startIndex, offsetBy: offsetIndex)
        return self[fromIndex]
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    public subscript(position offsetRange: ClosedRange<Int>) -> SubSequence {
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex ... toIndex]
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    public subscript(position offsetRange: Range<Int>) -> SubSequence {
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex ..< toIndex]
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    public subscript(position offsetRange: PartialRangeFrom<Int>) -> SubSequence {
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        return self[fromIndex...]
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    public subscript(position offsetRange: PartialRangeThrough<Int>) -> SubSequence {
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[...toIndex]
    }
    
    /// **OTCore:**
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
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
    @inlinable @_disfavoredOverload
    public subscript(wrapping index: Index) -> Iterator.Element {
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

extension Collection where Element: Hashable {
    /// **OTCore:**
    /// Counts number of occurrences of the given element
    /// - complexity: O(*n*)
    @inlinable @_disfavoredOverload
    public func count(of element: Element) -> Int {
        filter { $0 == element }.count
    }
}

// MARK: - shortest() / shortestIndex()

extension Collection where Element: StringProtocol {
    /// **OTCore:**
    /// Returns the shortest string in the collection.
    /// If more than one element are the same length as the shortest element, the first will be returned.
    /// - complexity: O(*n*)
    @inlinable @_disfavoredOverload
    public func shortest() -> Element? {
        guard let idx = shortestIndex() else { return nil }
        return self[idx]
    }
    
    /// **OTCore:**
    /// Returns the index of the shortest string in the collection.
    /// If more than one element are the same length as the shortest element, the first will be returned.
    /// - complexity: O(*n*)
    @inlinable @_disfavoredOverload
    public func shortestIndex() -> Index? {
        guard !isEmpty else { return nil }
        
        var shortestIndex: Index = startIndex
        var shortestLength: Int = self[startIndex].count
        
        for index in indices {
            let elementLength = self[index].count
            if elementLength < shortestLength {
                shortestIndex = index
                shortestLength = elementLength
            }
            
            // return early if empty string is encountered since
            // there is no shorter string possible
            if elementLength == 0 {
                return shortestIndex
            }
        }
        
        return shortestIndex
    }
}

// MARK: - longest() / longestIndex()

extension Collection where Element: StringProtocol {
    /// **OTCore:**
    /// Returns the longest string in the collection.
    /// If more than one element are the same length as the longest element, the first will be returned.
    /// - complexity: O(*n*)
    @inlinable @_disfavoredOverload
    public func longest() -> Element? {
        guard let idx = longestIndex() else { return nil }
        return self[idx]
    }
    
    /// **OTCore:**
    /// Returns the index of the longest string in the collection.
    /// If more than one element are the same length as the longest element, the first will be returned.
    /// - complexity: O(*n*)
    @inlinable @_disfavoredOverload
    public func longestIndex() -> Index? {
        guard !isEmpty else { return nil }
        
        var longestIndex: Index = startIndex
        var longestLength: Int = self[startIndex].count
        
        for index in indices {
            let elementLength = self[index].count
            if elementLength > longestLength {
                longestIndex = index
                longestLength = elementLength
            }
        }
        
        return longestIndex
    }
}

// MARK: - stringValueArrayLiteral

extension Collection where Element: BinaryInteger {
    /// **OTCore:**
    /// Returns a string of integer literals, useful for generating Swift array declarations when debugging.
    @inlinable @_disfavoredOverload
    public var stringValueArrayLiteral: String {
        map { "\($0)" }
            .joined(separator: ", ")
            .wrapped(with: .brackets)
    }
}

// MARK: - Collection.firstGapValue

extension Collection where Element: Strideable,
    Element.Stride: SignedInteger,
    Self.Index: Strideable,
    Self.Index.Stride: SignedInteger
{
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
    @inlinable @_disfavoredOverload
    public func firstGapValue(after: Element? = nil) -> Element? {
        guard count > 0 else { return nil }
        
        for idx in startIndex ..< endIndex {
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
    /// Same as `union()` but replaces existing values with new values instead of `union()`'s
    /// behavior of retaining existing equivalent values.
    @inlinable @_disfavoredOverload
    public func union<S>(updating other: S) -> Set<Set<Element>.Element>
        where Element == S.Element,
        S: Sequence
    {
        var newSet = self
        
        other.forEach {
            newSet.update(with: $0)
        }
        
        return newSet
    }
    
    /// **OTCore:**
    /// Same as `formUnion()` but replaces existing values with new values instead of
    /// `formUnion()`'s behavior of retaining existing equivalent values.
    @inlinable @_disfavoredOverload
    public mutating func formUnion<S>(updating other: S)
        where Element == S.Element,
        S: Sequence
    {
        self = union(updating: other)
    }
}

// MARK: - ArraySlice

extension ArraySlice {
    /// **OTCore:**
    /// Same as `Array(self)`, to return the `ArraySlice` as a concrete Array.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public var array: [Element] {
        Array(self)
    }
}

// MARK: - Grouping

extension Sequence {
    /// **OTCore:**
    /// Same as `Dictionary(grouping: self, by:)`.
    /// (Functional convenience method)
    @inlinable @_disfavoredOverload
    public func grouping<Key: Hashable>(
        by keyForValue: (Element) throws -> Key
    ) rethrows -> [Key: [Element]] {
        try Dictionary(grouping: self, by: keyForValue)
    }
}

// MARK: - Split

extension Collection {
    /// **OTCore:**
    /// Splits a `Collection` or `String` into groups of `every` _n_ number of characters, grouping from left-to-right. If `backwards` is `true`, right-to-left.
    @_disfavoredOverload
    public func split(
        every: Int,
        backwards: Bool = false
    ) -> [SubSequence] {
        guard every != 0 else {
            return [self[startIndex...]]
        }
        
        var result: [SubSequence] = []
        
        for i in stride(from: 0, to: count, by: every) {
            switch backwards {
            case true:
                let offsetEndIndex = index(endIndex, offsetBy: -i)
                let offsetStartIndex = index(
                    offsetEndIndex,
                    offsetBy: -every,
                    limitedBy: startIndex
                )
                    ?? startIndex
                
                result.insert(self[offsetStartIndex ..< offsetEndIndex], at: 0)
                
            case false:
                let offsetStartIndex = index(startIndex, offsetBy: i)
                let offsetEndIndex = index(
                    offsetStartIndex,
                    offsetBy: every,
                    limitedBy: endIndex
                )
                    ?? endIndex
                
                result.append(self[offsetStartIndex ..< offsetEndIndex])
            }
        }
        
        return result
    }
}

extension Collection where Index == Int {
    /// **OTCore:**
    /// Returns indices in groups of n number of indices.
    @_disfavoredOverload
    public func indices(splitEvery: Int) -> [ClosedRange<Index>] {
        // this should work but doesn't
        // return indices.split(every: splitEvery)
        
        // so we need a workaround. this is really stupid but it works.
        // there is some compiler issue that reports type(of: indices) as `Range<Index>`
        // but only works if you cast it as... itself (Range<Index>, effectively Range<Int>)
        guard let i = indices as? Range<Index> else { return [] }
        return i.split(every: splitEvery)
    }
}

// MARK: - Duplicates

/// **OTCore:**
/// Cases describing duplicate collection element behavior.
public enum DuplicateElementFilter {
    /// First occurrence of duplicate elements.
    case firstOccurrences
    
    /// Only subsequence occurrences of duplicates, omitting the first instance.
    case afterFirstOccurrences
    
    /// All occurrences of duplicates, including the first instance.
    case allOccurrences
}

extension Collection
where Element: Equatable,
      Index: Strideable,
      Index.Stride: SignedInteger
{
    /// **OTCore:**
    /// Returns the array with duplicates removed.
    /// Array ordering is preserved.
    ///
    /// - Parameters:
    ///   - removing: Defines duplicate filtering.
    @_disfavoredOverload
    public func removingDuplicates(
        _ removing: DuplicateElementFilter = .afterFirstOccurrences
    ) -> [Element] {
        let dupeIndices = duplicateElementIndices(removing, sorted: false)
        
        return indices.lazy.filter { !dupeIndices.contains($0) }.map { self[$0] }
    }
}

extension RangeReplaceableCollection
where Element: Equatable,
      Index: Strideable,
      Index.Stride: SignedInteger
{
    /// **OTCore:**
    /// Removes duplicate elements.
    /// All duplicate elements are removed after the first appearance of the identical element.
    ///
    /// - Parameters:
    ///   - removing: Defines duplicate filtering.
    @_disfavoredOverload
    public mutating func removeDuplicates(
        _ removing: DuplicateElementFilter = .afterFirstOccurrences
    ) {
        let dupeIndices = duplicateElementIndices(removing, sorted: true)
        
        dupeIndices.reversed().forEach {
            remove(at: $0)
        }
    }
}

extension Collection where Element: Hashable {
    /// **OTCore:**
    /// Returns the array with duplicates removed but elements will be in random order.
    /// This is due to using a `Set` to remove duplicates performantly.
    /// If array ordering must be preserved, `removingDuplicates()` can be used instead
    /// at the cost of performance.
    @_disfavoredOverload
    public func removingDuplicatesRandomOrdering() -> [Element] {
        Array(Set(self))
    }
}

extension Collection
where Element: Equatable,
      Index: Strideable,
      Index.Stride: SignedInteger
{
    /// **OTCore:**
    /// Returns only duplicate elements (elements that occur more than once in the array).
    /// Only one instance of each duplicate element will be output in the resulting array.
    /// All duplicate elements are removed after the first appearance of the identical element.
    ///
    /// - Parameters:
    ///   - dupeFilter: Defines duplicate filtering.
    @_disfavoredOverload
    public func duplicateElements(
        _ dupeFilter: DuplicateElementFilter = .firstOccurrences
    ) -> [Element] {
        let dupeIndices = duplicateElementIndices(dupeFilter, sorted: true)
        return dupeIndices.map { self[$0] }
    }
    
    /// **OTCore:**
    /// Returns indices of duplicate elements.
    /// Returned indices are not sorted by default and may be out of order.
    /// To sort the results, pass `true` to the `sort` parameter.
    ///
    /// - Parameters:
    ///   - dupeFilter: Defines duplicate filtering.
    ///   - sorted: If `true`, resulting indices are sorted.
    /// - Returns: Index array.
    @_disfavoredOverload
    public func duplicateElementIndices(
        _ dupeFilter: DuplicateElementFilter = .firstOccurrences,
        sorted: Bool = false
    ) -> [Index] {
        var dupeIndices: [Index] = indices.reduce(into: []) { result, idx in
            let advancedIndex = self.index(idx, offsetBy: 1)
            guard advancedIndex != endIndex else { return }
            let scanIndices = advancedIndex..<endIndex
            
            switch dupeFilter {
            case .firstOccurrences:
                if let _ = scanIndices.first(where: { self[$0] == self[idx] }),
                   !result.contains(where: { self[$0] == self[idx] })
                {
                    result.append(idx)
                }
                
            case .afterFirstOccurrences:
                if let newDupeIndex = scanIndices.first(where: { self[$0] == self[idx] }) {
                    result.append(newDupeIndex)
                }
                
            case .allOccurrences:
                if let newDupeIndex = scanIndices.first(where: { self[$0] == self[idx] }) {
                    if !result.contains(where: { self[$0] == self[idx] }) {
                        result.append(idx)
                    }
                    result.append(newDupeIndex)
                }
            }
        }
        if sorted {
            dupeIndices.sort()
        }
        return dupeIndices
    }
}

// MARK: - String Collection Duplicates

extension Collection where Element: StringProtocol {
    /// **OTCore:**
    /// Returns the collection with duplicates removed using case-insensitive string comparison.
    /// Only the first occurrence of elements with duplicates will remain and subsequent instances
    /// are removed.
    @_disfavoredOverload
    public func caseInsensitiveRemovingDuplicates() -> [Element] {
        reduce(into: []) { result, element in
            if !result.contains(where: { item in
                item.caseInsensitiveCompare(element) == .orderedSame
            }) {
                result.append(element)
            }
        }
    }
    
    /// **OTCore:**
    /// Returns the collection with duplicates removed using localized string comparison.
    /// Only the first occurrence of elements with duplicates will remain and subsequent instances
    /// are removed.
    @_disfavoredOverload
    public func localizedRemovingDuplicates() -> [Element] {
        reduce(into: []) { result, element in
            if !result.contains(where: { item in
                item.localizedCompare(element) == .orderedSame
            }) {
                result.append(element)
            }
        }
    }
    
    /// **OTCore:**
    /// Returns the collection with duplicates removed using localized case-insensitive string
    /// comparison.
    /// Only the first occurrence of elements with duplicates will remain and subsequent instances
    /// are removed.
    @_disfavoredOverload
    public func localizedCaseInsensitiveRemovingDuplicates() -> [Element] {
        reduce(into: []) { result, element in
            if !result.contains(where: { item in
                item.localizedCaseInsensitiveCompare(element) == .orderedSame
            }) {
                result.append(element)
            }
        }
    }
    
    /// **OTCore:**
    /// Returns the collection with duplicates removed using localized standard string comparison.
    /// Only the first occurrence of elements with duplicates will remain and subsequent instances
    /// are removed.
    @_disfavoredOverload
    public func localizedStandardRemovingDuplicates() -> [Element] {
        reduce(into: []) { result, element in
            if !result.contains(where: { item in
                item.localizedStandardCompare(element) == .orderedSame
            }) {
                result.append(element)
            }
        }
    }
}

// MARK: - Element Equality

extension Collection where Element: Equatable {
    /// **OTCore:**
    /// Returns `true` if all elements are equal.
    @_disfavoredOverload
    public var allElementsAreEqual: Bool {
        guard !isEmpty else { return true }
        let firstValue = first
        return dropFirst().allSatisfy({ $0 == firstValue })
    }
    
    /// **OTCore:**
    /// Returns `true` if all elements are equal regardless of order.
    @_disfavoredOverload
    public func elementsEqual<C: Collection>(
        orderInsensitive other: C
    ) -> Bool
    where Element == C.Element, C.Index: Hashable
    {
        guard count == other.count else { return false }
        guard count > 0 else { return true }
        
        var rhsIndices = Set(other.indices)
        
        for lhsIndex in indices {
            guard let rhsIndex = rhsIndices.first(where: { self[lhsIndex] == other[$0] })
            else { return false }
            rhsIndices.remove(rhsIndex)
        }
        
        // double-check
        guard rhsIndices.isEmpty else { return false }
        
        return true
    }
}

// MARK: - Dictionary map

extension Dictionary {
    // Swift Standard Library provides `mapValues`,
    // so `mapKeys` and `mapDictionary` methods are useful accompaniments
    
    /// **OTCore:**
    /// Returns a new dictionary containing the values of this dictionary with the keys transformed by the given closure.
    @inlinable @_disfavoredOverload
    public func mapKeys<K: Hashable>(
        _ transform: (Key) throws -> K
    ) rethrows -> [K: Value] {
        try reduce(into: [:]) { partialResult, keyValuePair in
            let transformedKey = try transform(keyValuePair.0)
            partialResult[transformedKey] = keyValuePair.1
        }
    }
    
    /// **OTCore:**
    /// Returns a new dictionary with key/value pairs transformed by the given closure.
    /// Analogous to Swift's standard `.map` method.
    @inlinable @_disfavoredOverload
    public func mapDictionary<K: Hashable, V: Any>(
        _ transform: (Key, Value) throws -> (K, V)
    ) rethrows -> [K: V] {
        try reduce(into: [:]) { partialResult, keyValuePair in
            let transformedKeyPair = try transform(keyValuePair.0, keyValuePair.1)
            partialResult[transformedKeyPair.0] = transformedKeyPair.1
        }
    }
    
    /// **OTCore:**
    /// Returns a new dictionary with key/value pairs transformed by the given closure.
    /// Analogous to Swift's standard `.compactMap` method.
    @inlinable @_disfavoredOverload
    public func compactMapDictionary<K: Hashable, V: Any>(
        _ transform: (Key, Value) throws -> (K, V)?
    ) rethrows -> [K: V] {
        try reduce(into: [:]) { partialResult, keyValuePair in
            if let transformedKeyPair = try transform(keyValuePair.0, keyValuePair.1) {
                partialResult[transformedKeyPair.0] = transformedKeyPair.1
            }
        }
    }
}
