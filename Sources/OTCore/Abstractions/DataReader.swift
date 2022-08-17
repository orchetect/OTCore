//
//  DataReader.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// **OTCore:**
/// Utility to facilitate sequential reading of bytes.
public struct DataReader {
    public let base: Data
    
    public init(_ data: Data) {
        base = data
    }
    
    /// Current byte index of read offset.
    public internal(set) var readOffset = 0
    
    /// Current byte index of read offset.
    @available(
        *,
        deprecated,
        message: "This property has been renamed to readOffset and will be removed in a future version of OTCore."
    )
    public var readPosition: Int { readOffset }
    
    /// Resets read offset back to 0.
    public mutating func reset() {
        readOffset = 0
    }
    
    /// Manually advance by _n_ number of bytes from current read offset.
    public mutating func advanceBy(_ count: Int) {
        readOffset += count
    }
    
    /// Return the next _n_ number of bytes and increment the read offset.
    ///
    /// If `bytes` parameter is nil, the remainder of the data will be returned.
    ///
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public mutating func read(bytes count: Int? = nil) -> Data? {
        guard let d = data(bytes: count) else { return nil }
        defer { readOffset += d.advanceCount }
        return d.data
    }
    
    /// Read _n_ number of bytes from the current read offset, without advancing the read offset.
    /// If `bytes count` passed is `nil`, the remainder of the data will be returned.
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public func nonAdvancingRead(bytes count: Int? = nil) -> Data? {
        data(bytes: count)?.data
    }
    
    // MARK: - Internal
    
    func data(bytes count: Int? = nil) -> (data: Data, advanceCount: Int)? {
        if count == 0 {
            return (data: Data(), advanceCount: 0)
        }
        
        if let count = count,
           count < 0 { return nil }
        
        let readPosStartIndex = base.startIndex.advanced(by: readOffset)
        
        let count = count ?? (base.count - readOffset)
        
        let endIndex = readPosStartIndex.advanced(by: count - 1)
        
        guard base.indices.contains(readPosStartIndex),
              base.indices.contains(endIndex) else { return nil }
        
        let returnBytes = base[readPosStartIndex ... endIndex]
        
        return (data: returnBytes, advanceCount: count)
    }
}
