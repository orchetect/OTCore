//
//  DataReader.swift
//  OTCore • https://github.com/orchetect/OTCore
//

import Foundation

/// Utility to facilitate sequential reading of bytes.
public struct DataReader {
    public let base: Data
    
    public init(_ data: Data) {
        base = data
    }
    
    /// Current byte index of read position
    public internal(set) var readPosition = 0
    
    /// Resets read position back to 0
    public mutating func reset() {
        readPosition = 0
    }
    
    /// Manually advance by n number of bytes from current read position
    public mutating func advanceBy(_ count: Int) {
        readPosition += count
    }
    
    /// Return the next _n_ number of bytes and increment the read position.
    ///
    /// If `bytes` parameter is nil, the remainder of the data will be returned.
    ///
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public mutating func read(bytes count: Int? = nil) -> Data? {
        if count == 0 { return Data() }
        
        if let count = count,
           count < 0 { return nil }
        
        let readPosStartIndex = base.startIndex.advanced(by: readPosition)
        
        let count = count ?? (base.count - readPosition)
        
        let endIndex = readPosStartIndex.advanced(by: count - 1)
        
        guard base.indices.contains(readPosStartIndex),
              base.indices.contains(endIndex) else { return nil }
        
        let returnBytes = base[readPosStartIndex ... endIndex]
        
        // advance read position
        readPosition += count
        
        return returnBytes
    }
    
    /// Read n number of bytes from current read position, without advancing read position.
    /// If `bytes count` passed is nil, the remainder of the data will be returned.
    /// If fewer bytes remain than are requested, `nil` will be returned.
    public func nonAdvancingRead(bytes count: Int? = nil) -> Data? {
        if count == 0 { return Data() }
        
        if let count = count,
           count < 0 { return nil }
        
        let readPosStartIndex = base.startIndex.advanced(by: readPosition)
        
        let count = count ?? (base.count - readPosition)
        
        let endIndex = readPosStartIndex.advanced(by: count - 1)
        
        guard base.indices.contains(readPosStartIndex),
              base.indices.contains(endIndex) else { return nil }
        
        let returnBytes = base[readPosStartIndex ... endIndex]
        
        return returnBytes
    }
}
