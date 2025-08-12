//
//  PassiveDataReader Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import XCTest

class Abstractions_PassiveDataReader_Tests: XCTestCase {
    // MARK: - Data storage starting with index 0
    
    func testRead() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .read(bytes:)
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.readOffset, 0)
            XCTAssertEqual(dr.remainingByteCount, 4)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.remainingByteCount, 3)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x02]))
            XCTAssertEqual(dr.remainingByteCount, 2)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x03]))
            XCTAssertEqual(dr.remainingByteCount, 1)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x04]))
            XCTAssertEqual(dr.remainingByteCount, 0)
            XCTAssertThrowsError(try dr.read(bytes: 1))
            XCTAssertEqual(dr.remainingByteCount, 0)
        }
        
        // .readByte()
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.readOffset, 0)
            XCTAssertEqual(dr.remainingByteCount, 4)
            XCTAssertEqual(try dr.readByte(), 0x01)
            XCTAssertEqual(dr.remainingByteCount, 3)
            XCTAssertEqual(try dr.readByte(), 0x02)
            XCTAssertEqual(dr.remainingByteCount, 2)
            XCTAssertEqual(try dr.readByte(), 0x03)
            XCTAssertEqual(dr.remainingByteCount, 1)
            XCTAssertEqual(try dr.readByte(), 0x04)
            XCTAssertEqual(dr.remainingByteCount, 0)
            XCTAssertThrowsError(try dr.readByte())
            XCTAssertEqual(dr.remainingByteCount, 0)
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.read(), data)
            XCTAssertThrowsError(try dr.read(bytes: 1))
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.read(bytes: 0), Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertThrowsError(try dr.read(bytes: 5))
        }
    }
    
    func testNonAdvancingRead() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.nonAdvancingRead(), data)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
        }
        
        // single bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.nonAdvancingReadByte(), data[0])
            XCTAssertEqual(try dr.nonAdvancingReadByte(), data[0])
            XCTAssertEqual(try dr.readByte(), data[0])
            XCTAssertEqual(try dr.readByte(), data[1])
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.nonAdvancingRead(bytes: 1), Data([0x01]))
            XCTAssertEqual(try dr.nonAdvancingRead(bytes: 2), Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertThrowsError(try dr.nonAdvancingRead(bytes: 5))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    func testAdvanceBy() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // advanceBy
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            dr.advanceBy(1)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x02]))
        }
    }
    
    func testReset() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // reset
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(try dr.read(bytes: 2), Data([0x02, 0x03]))
            dr.reset()
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    /// Test to ensure closure does not capture the data.
    func testReadMutation() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        var dr = PassiveDataReader { $0(&data) }
        
        XCTAssertEqual(dr.readOffset, 0)
        XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
        XCTAssertEqual(try dr.read(bytes: 1), Data([0x02]))
        
        data = Data([0x0A, 0x0B, 0x0C, 0x0D])
        
        XCTAssertEqual(try dr.read(bytes: 1), Data([0x0C]))
        XCTAssertEqual(try dr.read(bytes: 1), Data([0x0D]))
        XCTAssertThrowsError(try dr.read(bytes: 1))
    }
    
    // MARK: - Data storage starting with index >0
    
    func testRead_DataIndicesOffset() {
        let rawData = Data([
            0x00,
            0x00,
            0x00,
            0x01,
            0x02,
            0x03,
            0x04
        ])
        var data = rawData[3 ... 6]
        
        // .read - byte by byte
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.readOffset, 0)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x02]))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x03]))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x04]))
            XCTAssertThrowsError(try dr.read(bytes: 1))
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.read(), data)
            XCTAssertThrowsError(try dr.read(bytes: 1))
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.read(bytes: 0), Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertThrowsError(try dr.read(bytes: 5))
        }
    }
    
    func testNonAdvancingRead_DataIndicesOffset() {
        let rawData = Data([
            0x00,
            0x00,
            0x00,
            0x01,
            0x02,
            0x03,
            0x04
        ])
        var data = rawData[3 ... 6]
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.nonAdvancingRead(), data)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.nonAdvancingRead(bytes: 1), Data([0x01]))
            XCTAssertEqual(try dr.nonAdvancingRead(bytes: 2), Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertThrowsError(try dr.nonAdvancingRead(bytes: 5))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertThrowsError(try dr.read(bytes: 8))
        }
    }
    
    func testAdvanceBy_DataIndicesOffset() {
        let rawData = Data([
            0x00,
            0x00,
            0x00,
            0x01,
            0x02,
            0x03,
            0x04
        ])
        var data = rawData[3 ... 6]
        
        // advanceBy
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            dr.advanceBy(1)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x02]))
        }
    }
    
    func tesReset_DataIndicesOffset() {
        let rawData = Data([
            0x00,
            0x00,
            0x00,
            0x01,
            0x02,
            0x03,
            0x04
        ])
        var data = rawData[3 ... 6]
        
        // reset
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(try dr.read(bytes: 2), Data([0x02, 0x03]))
            dr.reset()
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    func testWithDataReader() throws {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        try data.withDataReader { dr in
            XCTAssertEqual(dr.readOffset, 0)
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x02]))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x03]))
            XCTAssertEqual(try dr.read(bytes: 1), Data([0x04]))
            XCTAssertThrowsError(try dr.read(bytes: 1))
        }
        
        struct TestError: Error { }
        
        XCTAssertThrowsError(
            try data.withDataReader { dr in
                throw TestError()
            }
        )
    }
    
    func testWithDataReader_ReturnsValue() throws {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        #if swift(>=5.7)
        let getByte = try data.withDataReader { dr in
            _ = try dr.readByte()
            return try dr.readByte()
        }
        #else
        let getByte: UInt8 = try data.withDataReader { dr in
            _ = try dr.readByte()
            return try dr.readByte()
        }
        #endif
        
        XCTAssertEqual(getByte, 0x02)
    }
}
