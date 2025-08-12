//
//  DataReader Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import Testing

@Suite struct Abstractions_DataReader_Tests {
    // MARK: - Data storage starting with index 0
    
    @Test
    func read() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .read(bytes:)
        do {
            var dr = DataReader(data)
            
            #expect(dr.readOffset == 0)
            #expect(dr.remainingByteCount == 4)
            #expect(dr.read(bytes: 1) == Data([0x01]))
            #expect(dr.remainingByteCount == 3)
            #expect(dr.read(bytes: 1) == Data([0x02]))
            #expect(dr.remainingByteCount == 2)
            #expect(dr.read(bytes: 1) == Data([0x03]))
            #expect(dr.remainingByteCount == 1)
            #expect(dr.read(bytes: 1) == Data([0x04]))
            #expect(dr.remainingByteCount == 0)
            #expect(dr.read(bytes: 1) == nil)
            #expect(dr.remainingByteCount == 0)
        }
        
        // .readByte()
        do {
            var dr = DataReader(data)
            
            #expect(dr.readOffset == 0)
            #expect(dr.remainingByteCount == 4)
            #expect(dr.readByte() == 0x01)
            #expect(dr.remainingByteCount == 3)
            #expect(dr.readByte() == 0x02)
            #expect(dr.remainingByteCount == 2)
            #expect(dr.readByte() == 0x03)
            #expect(dr.remainingByteCount == 1)
            #expect(dr.readByte() == 0x04)
            #expect(dr.remainingByteCount == 0)
            #expect(dr.readByte() == nil)
            #expect(dr.remainingByteCount == 0)
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            #expect(dr.read() == data)
            #expect(dr.read(bytes: 1) == nil)
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = DataReader(data)
            
            #expect(dr.read(bytes: 0) == Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            #expect(dr.read(bytes: 5) == nil)
        }
    }
    
    @Test
    func nonAdvancingRead() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            #expect(dr.nonAdvancingRead() == data)
            #expect(dr.read(bytes: 1) == Data([0x01]))
        }
        
        // single bytes
        do {
            var dr = DataReader(data)
            
            #expect(dr.nonAdvancingReadByte() == data[0])
            #expect(dr.nonAdvancingReadByte() == data[0])
            #expect(dr.readByte() == data[0])
            #expect(dr.readByte() == data[1])
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = DataReader(data)
            
            #expect(dr.nonAdvancingRead(bytes: 1) == Data([0x01]))
            #expect(dr.nonAdvancingRead(bytes: 2) == Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            #expect(dr.nonAdvancingRead(bytes: 5) == nil)
            #expect(dr.read(bytes: 1) == Data([0x01]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            #expect(dr.read(bytes: 6) == nil)
        }
    }
    
    @Test
    func advanceBy() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // advanceBy
        do {
            var dr = DataReader(data)
            
            dr.advanceBy(1)
            #expect(dr.read(bytes: 1) == Data([0x02]))
        }
    }
    
    @Test
    func reset() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // reset
        do {
            var dr = DataReader(data)
            
            #expect(dr.read(bytes: 1) == Data([0x01]))
            #expect(dr.read(bytes: 2) == Data([0x02, 0x03]))
            dr.reset()
            #expect(dr.read(bytes: 1) == Data([0x01]))
        }
    }
    
    // MARK: - Data storage starting with index >0
    
    @Test
    func read_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        // .read - byte by byte
        do {
            var dr = DataReader(data)
            
            #expect(dr.readOffset == 0)
            #expect(dr.read(bytes: 1) == Data([0x01]))
            #expect(dr.read(bytes: 1) == Data([0x02]))
            #expect(dr.read(bytes: 1) == Data([0x03]))
            #expect(dr.read(bytes: 1) == Data([0x04]))
            #expect(dr.read(bytes: 1) == nil)
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            #expect(dr.read() == data)
            #expect(dr.read(bytes: 1) == nil)
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = DataReader(data)
            
            #expect(dr.read(bytes: 0) == Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            #expect(dr.read(bytes: 5) == nil)
        }
    }
    
    @Test
    func nonAdvancingRead_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            #expect(dr.nonAdvancingRead() == data)
            #expect(dr.read(bytes: 1) == Data([0x01]))
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = DataReader(data)
            
            #expect(dr.nonAdvancingRead(bytes: 1) == Data([0x01]))
            #expect(dr.nonAdvancingRead(bytes: 2) == Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            #expect(dr.nonAdvancingRead(bytes: 5) == nil)
            #expect(dr.read(bytes: 1) == Data([0x01]))
        }
    }
    
    @Test
    func advanceBy_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        // advanceBy
        do {
            var dr = DataReader(data)
            
            dr.advanceBy(1)
            #expect(dr.read(bytes: 1) == Data([0x02]))
        }
    }
    
    @Test
    func reset_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        // reset
        do {
            var dr = DataReader(data)
            
            #expect(dr.read(bytes: 1) == Data([0x01]))
            #expect(dr.read(bytes: 2) == Data([0x02, 0x03]))
            dr.reset()
            #expect(dr.read(bytes: 1) == Data([0x01]))
        }
    }
}
