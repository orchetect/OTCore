//
//  ZeroIndexedCollection.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2023 Steffan Andrews • Licensed under MIT License
//

// MARK: - ZeroIndexedCollection

/// **OTCore:**
/// A view on a collection that translates the base collection's indices to zero-based sequential
/// indices.
///
/// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
public struct ZeroIndexedCollection<Base: Collection> {
    private var base: Base
    
    public init(_ base: Base) {
        self.base = base
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
    public var zeroIndexed: ZeroIndexedCollection<Self> {
        ZeroIndexedCollection(self)
    }
}

// MARK: - ZeroIndexedMutableCollection

/// **OTCore:**
/// A view on a collection that translates the base collection's indices to zero-based sequential
/// indices.
///
/// For example: a collection with indices `2, 4, 5` could be accessed using indices `0, 1, 2`.
public struct ZeroIndexedMutableCollection<Base: MutableCollection> {
    private var base: Base
    
    public init(_ base: Base) {
        self.base = base
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
    public var zeroIndexed: ZeroIndexedMutableCollection<Self> {
        ZeroIndexedMutableCollection(self)
    }
}

// MARK: - Helpers

extension Collection {
    /// Internal utility to return the index at the given offset from the start index.
    func _index(forOffset offset: Int) -> Index {
        index(startIndex, offsetBy: offset)
    }
}
