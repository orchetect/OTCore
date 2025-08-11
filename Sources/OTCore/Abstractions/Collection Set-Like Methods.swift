//
//  Collection Set-Like Methods.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Set-like functionality for Non-Set Collections

/// **OTCore:**
/// Describes a position behavior within a Collection use in some of the additional methods.
public enum CollectionPosition {
    /// Default behavior (as described in the calling function).
    case `default`
    
    /// Start of the collection.
    case start
    
    /// End of the collection.
    case end
}

extension CollectionPosition: Equatable { }

extension CollectionPosition: Hashable { }

extension CollectionPosition: Sendable { }

extension CollectionPosition: Identifiable {
    public var id: Self { self }
}

// RangeReplaceableCollection:
//   insert, append, remove
// MutableCollection:
//   subscript { get set }
// Will apply to Array, ArraySlice, ContiguousArray, CollectionOfOne, EmptyCollection
extension Collection where Self: RangeReplaceableCollection,
    Self: MutableCollection,
    Element: Hashable
{
    /// **OTCore:**
    /// Similar behavior to a `Set`, inserts the given element in the collection if it is not
    /// already present. The element will be appended to the end of the collection in that case.
    @inlinable @_disfavoredOverload
    public mutating func insert(
        _ element: Element
    ) {
        insert(element, position: .default)
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, inserts the given element in the collection if it is not
    /// already present. The element will either be appended to the end of the collection or
    /// inserted at the start depending on the `position` parameter.
    @inlinable
    public mutating func insert(
        _ element: Element,
        position: CollectionPosition
    ) {
        if !contains(element) {
            switch position {
            case .start:
                insert(element, at: startIndex)
            case .end, .default:
                append(element)
            }
        }
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, inserts the given element into the collection unconditionally.
    ///
    /// If the element exists in the collection this will replace it at its current index with the
    /// new element. Otherwise it will be appended to the end of the collection.
    @inlinable @_disfavoredOverload
    public mutating func update(
        with newMember: Element
    ) {
        update(with: newMember, position: .default)
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, inserts the given element into the set unconditionally.
    ///
    /// If the element exists in the collection this will replace it and optionally reposition it
    /// within the collection at the same time depending on the `position` parameter.
    ///
    /// If the element does not exist, it will either be appended to the end of the collection or
    /// inserted at the start depending on the `position` parameter.
    @inlinable
    public mutating func update(
        with newMember: Element,
        position: CollectionPosition
    ) {
        if let index = firstIndex(of: newMember) {
            switch position {
            case .default:
                self[index] = newMember
            case .start:
                remove(at: index)
                insert(newMember, at: startIndex)
            case .end:
                remove(at: index)
                append(newMember)
            }
        } else {
            switch position {
            case .start:
                insert(newMember, at: startIndex)
            case .end, .default:
                append(newMember)
            }
        }
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, but removes all instances of the element.
    @inlinable @_disfavoredOverload
    public mutating func removeAll(_ member: Element) {
        removeAll(where: { $0 == member })
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, join two collections together and where elements are equal,
    /// retain the existing element.
    @inlinable @_disfavoredOverload
    public func union<S>(_ other: S) -> Self
    where Element == S.Element, S: Sequence {
        var newCollection = self
        other.forEach {
            if !newCollection.contains($0) {
                newCollection.append($0)
            }
        }
        return newCollection
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, join two collections together and where elements are equal,
    /// retain the existing element.
    @inlinable @_disfavoredOverload
    public mutating func formUnion<S>(_ other: S)
    where Element == S.Element, S: Sequence {
        other.forEach {
            if !contains($0) {
                append($0)
            }
        }
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, join two collections together and where elements are equal,
    /// replace the existing element with the new element preserving the original index.
    @inlinable @_disfavoredOverload
    public func union<S>(updating other: S) -> Self
    where Element == S.Element, S: Sequence {
        var newCollection = self
        other.forEach {
            newCollection.update(with: $0, position: .default)
        }
        return newCollection
    }
    
    /// **OTCore:**
    /// Similar behavior to a `Set`, join two collections together and where elements are equal,
    /// replace the existing element with the new element preserving the original index.
    @inlinable @_disfavoredOverload
    public mutating func formUnion<S>(updating other: S)
    where Element == S.Element, S: Sequence {
        other.forEach {
            update(with: $0, position: .default)
        }
    }
}
