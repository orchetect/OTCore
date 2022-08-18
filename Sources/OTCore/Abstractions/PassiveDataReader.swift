//
//  PassiveDataReader.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// **OTCore:**
/// Utility to facilitate sequential reading of bytes.
/// The data is not mutated, but it is required to be a mutable `var` to facilitate `inout` access.
///
/// Usage:
///
///     var data = Data( ... )
///     var dr = DataReader { $0(&data) }
///
///     if let bytes = dr.read(bytes: 4) { ... }
///
public struct PassiveDataReader<D: DataProtocol> {
    public typealias DataAccess = (inout D) -> Void
    public typealias Closure = (_ block: DataAccess) -> Void
    
    let closure: Closure
    
    // MARK: - Init
    
    public init(_ closure: @escaping Closure) {
        self.closure = closure
    }
    
    // MARK: - State
    
    /// Current byte index of read offset (byte position).
    public internal(set) var readOffset = 0
    
    /// Returns number of available remaining bytes.
    public var remainingByteCount: Int { withData(\.count) - readOffset }
    
    /// Resets read offset back to 0.
    public mutating func reset() {
        readOffset = 0
    }
    
    // MARK: - Methods
    
    /// Manually advance by _n_ number of bytes from current read offset.
    public mutating func advanceBy(_ count: Int) {
        readOffset += count
    }
    
    /// Return the next _n_ number of bytes and increment the read offset.
    ///
    /// If `bytes` parameter is nil, the remainder of the data will be returned.
    ///
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public mutating func read(bytes count: Int? = nil) -> D.SubSequence? {
        guard let d = data(bytes: count) else { return nil }
        defer { readOffset += d.advanceCount }
        return d.data
    }
    
    /// Read _n_ number of bytes from the current read offset, without advancing the read offset.
    /// If `bytes count` passed is `nil`, the remainder of the data will be returned.
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public func nonAdvancingRead(bytes count: Int? = nil) -> D.SubSequence? {
        data(bytes: count)?.data
    }
    
    // MARK: - Internal
    
    func withData<T>(_ block: (inout D) -> T) -> T {
        var out: T!
        closure { out = block(&$0) }
        return out
    }
    
    func data(bytes count: Int? = nil) -> (data: D.SubSequence, advanceCount: Int)? {
        if count == 0 {
            return (data: withData { $0[$0.startIndex ..< $0.startIndex] }, advanceCount: 0)
        }
        
        if let count = count,
           count < 0 { return nil }
        
        let readPosStartIndex = withData { $0.index($0.startIndex, offsetBy: readOffset) }
        
        let count = count ?? (withData(\.count) - readOffset)
        
        let endIndex = withData { $0.index(readPosStartIndex, offsetBy: count - 1) }
        
        guard withData({
            $0.indices.contains(readPosStartIndex) && $0.indices.contains(endIndex)
        }) else { return nil }
        
        let returnBytes = withData { $0[readPosStartIndex ... endIndex] }
        
        return (data: returnBytes, advanceCount: count)
    }
}

extension DataProtocol {
    /// **OTCore:**
    /// Accesses the data by providing a `PassiveDataReader` instance to a closure.
    @_disfavoredOverload
    public func withDataReader(
        _ block: (_ dataReader: inout PassiveDataReader<Self>) throws -> Void
    ) rethrows {
        var mutableSelf = self
        var reader = PassiveDataReader { $0(&mutableSelf) }
        try block(&reader)
    }
}
