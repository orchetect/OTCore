//
//  ZeroIndexedCollection.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2023 Steffan Andrews • Licensed under MIT License
//

// MARK: - ZeroIndexedCollection

/// **OTCore:**
/// A view into a collection that translates the base collection's indices to zero-based sequential
/// indices.
///
/// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
public struct ZeroIndexedCollection<Base: Collection> {
    private let base: Slice<Base>
    
    public init(_ base: Base) {
        self.base = Slice(base: base, bounds: base.startIndex ..< base.endIndex)
    }
}

extension ZeroIndexedCollection: Collection {
    public typealias Element = Base.Element
    
    public var startIndex: Int { 0 }
    
    public var endIndex: Int { base.count }
    
    public func index(after i: Int) -> Int { i + 1 }
    
    public subscript(_ indexOffset: Int) -> Base.Element {
        base[base._index(forOffset: indexOffset)]
    }
}

extension Collection {
    /// **OTCore:**
    /// Returns a view on the collection that translates the base collection's indices to zero-based
    /// sequential indices.
    ///
    /// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
    @_disfavoredOverload
    public var zeroIndexed: ZeroIndexedCollection<Self> {
        ZeroIndexedCollection(self)
    }
}

// MARK: - ZeroIndexedMutableCollection

/// **OTCore:**
/// A view into a collection that translates the base collection's indices to zero-based sequential
/// indices.
///
/// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
public struct ZeroIndexedMutableCollection<Base: MutableCollection> {
    private var base: Slice<Base>
    
    public init(_ base: Base) {
        self.base = Slice(base: base, bounds: base.startIndex ..< base.endIndex)
    }
}

extension ZeroIndexedMutableCollection: MutableCollection {
    public typealias Element = Base.Element
    
    public var startIndex: Int { 0 }
    
    public var endIndex: Int { base.count }
    
    public func index(after i: Int) -> Int { i + 1 }
    
    public subscript(_ indexOffset: Int) -> Base.Element {
        get {
            base[base._index(forOffset: indexOffset)]
        }
        _modify {
            var value = base[base._index(forOffset: indexOffset)]
            yield &value
            base[base._index(forOffset: indexOffset)] = value
        }
        set {
            base[base._index(forOffset: indexOffset)] = newValue
        }
    }
}

extension MutableCollection {
    /// **OTCore:**
    /// Returns a view on the collection that translates the base collection's indices to zero-based
    /// sequential indices.
    ///
    /// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
    @_disfavoredOverload
    public var zeroIndexed: ZeroIndexedMutableCollection<Self> {
        ZeroIndexedMutableCollection(self)
    }
}

// MARK: - ZeroIndexedRangeReplaceableCollection

/// **OTCore:**
/// A view into a collection that translates the base collection's indices to zero-based sequential
/// indices.
///
/// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
public struct ZeroIndexedRangeReplaceableCollection<Base: RangeReplaceableCollection> {
    private var base: Slice<Base>
    
    public init(_ base: Base) {
        self.base = Slice(base: base, bounds: base.startIndex ..< base.endIndex)
    }
}

extension ZeroIndexedRangeReplaceableCollection: Collection {
    public typealias Element = Base.Element
    
    public var startIndex: Int { 0 }
    
    public var endIndex: Int { base.count }
    
    public func index(after i: Int) -> Int { i + 1 }
    
    public subscript(_ indexOffset: Index) -> Element {
        base[base._index(forOffset: indexOffset)]
    }
}

extension ZeroIndexedRangeReplaceableCollection: RangeReplaceableCollection {
    public mutating func replaceSubrange<C>(
        _ subrange: Range<Index>,
        with newElements: C
    ) where C: Collection, Element == C.Element {
        let offsetLowerBound = base._index(forOffset: subrange.lowerBound)
        let offsetUpperBound = base._index(forOffset: subrange.upperBound)
        base.replaceSubrange(offsetLowerBound ..< offsetUpperBound, with: newElements)
    }
    
    public init() {
        base = .init()
    }
}

extension RangeReplaceableCollection {
    /// **OTCore:**
    /// Returns a view on the collection that translates the base collection's indices to zero-based
    /// sequential indices.
    ///
    /// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
    public var zeroIndexed: ZeroIndexedRangeReplaceableCollection<Self> {
        ZeroIndexedRangeReplaceableCollection(self)
    }
}

// MARK: - Helpers

extension Collection {
    /// Internal utility to return the index at the given offset from the start index.
    func _index(forOffset offset: Int) -> Index {
        index(startIndex, offsetBy: offset)
    }
}
