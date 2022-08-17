//
//  PassiveDataReader Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Abstractions_PassiveDataReader_Tests: XCTestCase {
    // MARK: - Data storage starting with index 0
    
    func testRead() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .read - byte by byte
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.readOffset, 0)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x03]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x04]))
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.read(), data)
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.read(bytes: 0), Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.read(bytes: 5), nil)
        }
    }
    
    func testNonAdvancingRead() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.nonAdvancingRead(), data)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 2), Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 5), nil)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    func testAdvanceBy() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // advanceBy
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            dr.advanceBy(1)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
        }
    }
    
    func testReset() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        // reset
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 2), Data([0x02, 0x03]))
            dr.reset()
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    /// Test to ensure closure does not capture the data.
    func testReadMutation() {
        var data = Data([0x01, 0x02, 0x03, 0x04])
        
        var dr = PassiveDataReader { $0(&data) }
        
        XCTAssertEqual(dr.readOffset, 0)
        XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
        
        data = Data([0x0A, 0x0B, 0x0C, 0x0D])
        
        XCTAssertEqual(dr.read(bytes: 1), Data([0x0C]))
        XCTAssertEqual(dr.read(bytes: 1), Data([0x0D]))
        XCTAssertEqual(dr.read(bytes: 1), nil)
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
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x03]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x04]))
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.read(), data)
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.read(bytes: 0), Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.read(bytes: 5), nil)
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
            
            XCTAssertEqual(dr.nonAdvancingRead(), data)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 2), Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = PassiveDataReader { $0(&data) }
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 5), nil)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
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
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
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
            
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 2), Data([0x02, 0x03]))
            dr.reset()
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
    }
}

#endif
