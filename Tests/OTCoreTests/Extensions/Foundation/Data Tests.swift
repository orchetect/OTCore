//
//  Data Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing
import TestingExtensions

@Suite struct Extensions_Foundation_Data_Tests {
    // MARK: - Ints
    
    @Test
    func int() {
        // Int is 32-bit on 32-bit systems, 64-bit on 64-bit systems
        
        #if !(arch(arm) || arch(i386))
        
        // .toData
        
        #expect(0b1.int.toData(.littleEndian) == Data([0b1, 0, 0, 0, 0, 0, 0, 0]))
        #expect(0b1.int.toData(.bigEndian) == Data([0, 0, 0, 0, 0, 0, 0, 0b1]))
        
        // .toInt64
        
        #expect(Data([]).toInt() == nil) // underflow
        #expect(Data([1]).toInt() == nil) // underflow
        #expect(Data([1, 2]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7, 8, 9]).toInt() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt(from: .littleEndian)
                == 0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000
        )
        
        // both ways
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt()?.toData()
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt(from: .littleEndian)?.toData(.bigEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt(from: .bigEndian)?.toData(.littleEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
        
        #elseif(arch(arm) || !arch(i386))
        
        // .toData
        
        #expect(0b1.int.toData(.littleEndian) == Data([0b1, 0, 0, 0]))
        #expect(0b1.int.toData(.bigEndian) == Data([0, 0, 0, 0b1]))
        
        // .toInt64
        
        #expect(Data([]).toInt() == nil) // underflow
        #expect(Data([1]).toInt() == nil) // underflow
        #expect(Data([1, 2]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3]).toInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toInt() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4]).toInt(from: .littleEndian)
                == 0b00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4]).toInt(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100
        )
        
        // both ways
        #expect(Data([1, 2, 3, 4]).toInt()?.toData() == Data([1, 2, 3, 4]))
        
        #expect(
            Data([1, 2, 3, 4]).toInt(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4])
        )
        #expect(
            Data([1, 2, 3, 4]).toInt(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4])
        )
        
        #expect(
            Data([1, 2, 3, 4]).toInt(from: .littleEndian)?.toData(.bigEndian)
                == Data([4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4]).toInt(from: .bigEndian)?.toData(.littleEndian)
                == Data([4, 3, 2, 1])
        )
        
        #else
        
        #fail("Platform not supported yet.")
        
        #endif
    }
    
    @Test
    func int8() {
        // .toData
        
        #expect(0b1.int8.toData() == Data([0b1]))
        #expect((-128).int8.toData() == Data([0b10000000]))
        
        // .toInt8
        
        #expect(Data([]).toInt8() == nil) // underflow
        #expect(Data([1]).toInt8() == 0b00000001)
        #expect(Data([1, 2]).toInt8() == nil) // overflow
        
        // both ways
        
        #expect(1.int8.toData().toInt8() == 1)
        #expect(127.int8.toData().toInt8() == 127)
        #expect((-128).int8.toData().toInt8() == -128)
    }
    
    @Test
    func int16() {
        // .toData
        
        #expect(0b1.int16.toData(.littleEndian) == Data([0b1, 0]))
        #expect(0b1.int16.toData(.bigEndian) == Data([0, 0b1]))
        
        // .toInt16
        
        #expect(Data([]).toInt16() == nil) // underflow
        #expect(Data([1]).toInt16() == nil) // underflow
        #expect(Data([1, 2, 3]).toInt16() == nil) // overflow
        
        #expect(
            Data([1, 2]).toInt16(from: .littleEndian)
                == 0b00000010_00000001
        )
        #expect(
            Data([1, 2]).toInt16(from: .bigEndian)
                == 0b00000001_00000010
        )
        
        // both ways
        #expect(Data([1, 2]).toInt16()?.toData() == Data([1, 2]))
        
        #expect(
            Data([1, 2]).toInt16(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2])
        )
        #expect(Data([1, 2]).toInt16(from: .bigEndian)?.toData(.bigEndian) == Data([1, 2]))
        
        #expect(Data([1, 2]).toInt16(from: .littleEndian)?.toData(.bigEndian) == Data([2, 1]))
        #expect(Data([1, 2]).toInt16(from: .bigEndian)?.toData(.littleEndian) == Data([2, 1]))
    }
    
    @Test
    func int32() {
        // .toData
        
        #expect(0b1.int32.toData(.littleEndian) == Data([0b1, 0, 0, 0]))
        #expect(0b1.int32.toData(.bigEndian) == Data([0, 0, 0, 0b1]))
        
        // .toInt32
        
        #expect(Data([]).toInt32() == nil) // underflow
        #expect(Data([1]).toInt32() == nil) // underflow
        #expect(Data([1, 2]).toInt32() == nil) // underflow
        #expect(Data([1, 2, 3]).toInt32() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toInt32() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4]).toInt32(from: .littleEndian)
                == 0b00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4]).toInt32(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100
        )
        
        // both ways
        #expect(Data([1, 2, 3, 4]).toInt32()?.toData() == Data([1, 2, 3, 4]))
        
        #expect(
            Data([1, 2, 3, 4]).toInt32(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4])
        )
        #expect(
            Data([1, 2, 3, 4]).toInt32(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4])
        )
        
        #expect(
            Data([1, 2, 3, 4]).toInt32(from: .littleEndian)?.toData(.bigEndian)
                == Data([4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4]).toInt32(from: .bigEndian)?.toData(.littleEndian)
                == Data([4, 3, 2, 1])
        )
    }
    
    @Test
    func int64() {
        // .toData
        
        #expect(0b1.int64.toData(.littleEndian) == Data([0b1, 0, 0, 0, 0, 0, 0, 0]))
        #expect(0b1.int64.toData(.bigEndian) == Data([0, 0, 0, 0, 0, 0, 0, 0b1]))
        
        // .toInt64
        
        #expect(Data([]).toInt64() == nil) // underflow
        #expect(Data([1]).toInt64() == nil) // underflow
        #expect(Data([1, 2]).toInt64() == nil) // underflow
        #expect(Data([1, 2, 3]).toInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4]).toInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6]).toInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7]).toInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7, 8, 9]).toInt64() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt64(from: .littleEndian)
                == 0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt64(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000
        )
        
        // both ways
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt64()?.toData()
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt64(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt64(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt64(from: .littleEndian)?.toData(.bigEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toInt64(from: .bigEndian)?.toData(.littleEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
    }
    
    // MARK: - UInts
    
    @Test
    func uInt() {
        // UInt is 32-bit on 32-bit systems, 64-bit on 64-bit systems
        
        #if !(arch(arm) || arch(i386))
        
        // .toData
        
        #expect(0b1.uInt.toData(.littleEndian) == Data([0b1, 0, 0, 0, 0, 0, 0, 0]))
        #expect(0b1.uInt.toData(.bigEndian) == Data([0, 0, 0, 0, 0, 0, 0, 0b1]))
        
        // .toUInt
        
        #expect(Data([]).toUInt() == nil) // underflow
        #expect(Data([1]).toUInt() == nil) // underflow
        #expect(Data([1, 2]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7, 8, 9]).toUInt() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt(from: .littleEndian)
                == 0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000
        )
        
        // both ways
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt()?.toData()
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt(from: .littleEndian)?.toData(.bigEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt(from: .bigEndian)?.toData(.littleEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
        
        #elseif(arch(arm) || arch(i386))
        
        // .toData
        
        #expect(0b1.uInt.toData(.littleEndian) == Data([0b1, 0, 0, 0]))
        #expect(0b1.uInt.toData(.bigEndian) == Data([0, 0, 0, 0b1]))
        
        // .toUInt
        
        #expect(Data([]).toUInt() == nil) // underflow
        #expect(Data([1]).toUInt() == nil) // underflow
        #expect(Data([1, 2]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3]).toUInt() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toUInt() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4]).toUInt(from: .littleEndian)
                == 0b00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4]).toUInt(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100
        )
        
        // both ways
        #expect(Data([1, 2, 3, 4]).toUInt()?.toData() == Data([1, 2, 3, 4]))
        
        #expect(
            Data([1, 2, 3, 4]).toUInt(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4])
        )
        #expect(
            Data([1, 2, 3, 4]).toUInt(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4])
        )
        
        #expect(
            Data([1, 2, 3, 4]).toUInt(from: .littleEndian)?.toData(.bigEndian)
                == Data([4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4]).toUInt(from: .bigEndian)?.toData(.littleEndian)
                == Data([4, 3, 2, 1])
        )
        
        #else
        
        XCTFail("Platform not supported yet.")
        
        #endif
    }
    
    @Test
    func uInt8() {
        // .toData
        
        #expect(0b1.uInt8.toData() == Data([0b1]))
        #expect(0b11111111.uInt8.toData() == Data([0b11111111]))
        
        // .toUInt8
        
        #expect(Data([]).toUInt8() == nil) // underflow
        #expect(Data([1]).toUInt8() == 0b00000001)
        #expect(Data([1, 2]).toUInt8() == nil) // overflow
        
        // both ways
        
        #expect(1.uInt8.toData().toUInt8() == 1)
        #expect(255.uInt8.toData().toUInt8() == 255)
    }
    
    @Test
    func uInt16() {
        // .toData
        
        #expect(0b1.uInt16.toData(.littleEndian) == Data([0b1, 0]))
        #expect(0b1.uInt16.toData(.bigEndian) == Data([0, 0b1]))
        
        // .toUInt16
        
        #expect(Data([]).toUInt16() == nil) // underflow
        #expect(Data([1]).toUInt16() == nil) // underflow
        #expect(Data([1, 2, 3]).toUInt16() == nil) // overflow
        
        #expect(
            Data([1, 2]).toUInt16(from: .littleEndian)
                == 0b00000010_00000001
        )
        #expect(
            Data([1, 2]).toUInt16(from: .bigEndian)
                == 0b00000001_00000010
        )
        
        // both ways
        #expect(Data([1, 2]).toUInt16()?.toData() == Data([1, 2]))
        
        #expect(Data([1, 2]).toUInt16(from: .littleEndian)?.toData(.littleEndian) == Data([1, 2]))
        #expect(Data([1, 2]).toUInt16(from: .bigEndian)?.toData(.bigEndian) == Data([1, 2]))
        
        #expect(Data([1, 2]).toUInt16(from: .littleEndian)?.toData(.bigEndian) == Data([2, 1]))
        #expect(Data([1, 2]).toUInt16(from: .bigEndian)?.toData(.littleEndian) == Data([2, 1]))
    }
    
    @Test
    func uInt32() {
        // .toData
        
        #expect(0b1.uInt32.toData(.littleEndian) == Data([0b1, 0, 0, 0]))
        #expect(0b1.uInt32.toData(.bigEndian) == Data([0, 0, 0, 0b1]))
        
        // .toUInt32
        
        #expect(Data([]).toUInt32() == nil) // underflow
        #expect(Data([1]).toUInt32() == nil) // underflow
        #expect(Data([1, 2]).toUInt32() == nil) // underflow
        #expect(Data([1, 2, 3]).toUInt32() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toUInt32() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4]).toUInt32(from: .littleEndian)
                == 0b00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4]).toUInt32(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100
        )
        
        // both ways
        #expect(Data([1, 2, 3, 4]).toUInt32()?.toData() == Data([1, 2, 3, 4]))
        
        #expect(Data([1, 2, 3, 4]).toUInt32(from: .littleEndian)?.toData(.littleEndian) == Data([1, 2, 3, 4]))
        #expect(Data([1, 2, 3, 4]).toUInt32(from: .bigEndian)?.toData(.bigEndian) == Data([1, 2, 3, 4]))
        
        #expect(Data([1, 2, 3, 4]).toUInt32(from: .littleEndian)?.toData(.bigEndian) == Data([4, 3, 2, 1]))
        #expect(Data([1, 2, 3, 4]).toUInt32(from: .bigEndian)?.toData(.littleEndian) == Data([4, 3, 2, 1]))
    }
    
    @Test
    func uInt64() {
        // .toData
        
        #expect(0b1.uInt64.toData(.littleEndian) == Data([0b1, 0, 0, 0, 0, 0, 0, 0]))
        #expect(0b1.uInt64.toData(.bigEndian) == Data([0, 0, 0, 0, 0, 0, 0, 0b1]))
        
        // .toUInt64
        
        #expect(Data([]).toUInt64() == nil) // underflow
        #expect(Data([1]).toUInt64() == nil) // underflow
        #expect(Data([1, 2]).toUInt64() == nil) // underflow
        #expect(Data([1, 2, 3]).toUInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4]).toUInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toUInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6]).toUInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7]).toUInt64() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7, 8, 9]).toUInt64() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt64(from: .littleEndian)
                == 0b00001000_00000111_00000110_00000101_00000100_00000011_00000010_00000001
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt64(from: .bigEndian)
                == 0b00000001_00000010_00000011_00000100_00000101_00000110_00000111_00001000
        )
        
        // both ways
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt64()?.toData()
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt64(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt64(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt64(from: .littleEndian)?.toData(.bigEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toUInt64(from: .bigEndian)?.toData(.littleEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
    }
    
    // MARK: - Floats
    
    @Test
    func float32() {
        // .toData
        
        #expect(0b1.float32.toData(.littleEndian) == Data([0x00, 0x00, 0x80, 0x3F]))
        #expect(0b1.float32.toData(.bigEndian) == Data([0x3F, 0x80, 0x00, 0x00]))
        
        // .toFloat32
        
        #expect(Data([]).toFloat32() == nil) // underflow
        #expect(Data([1]).toFloat32() == nil) // underflow
        #expect(Data([1, 2]).toFloat32() == nil) // underflow
        #expect(Data([1, 2, 3]).toFloat32() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toFloat32() == nil) // overflow
        
        #expect(Data([1, 2, 3, 4]).toFloat32(from: .littleEndian) == 1.5399896e-36)
        #expect(Data([1, 2, 3, 4]).toFloat32(from: .bigEndian) == 2.3879393e-38)
        
        // both ways
        #expect(Data([1, 2, 3, 4]).toFloat32()?.toData() == Data([1, 2, 3, 4]))
        
        #expect(
            Data([1, 2, 3, 4]).toFloat32(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4])
        )
        #expect(
            Data([1, 2, 3, 4]).toFloat32(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4])
        )
        
        #expect(
            Data([1, 2, 3, 4]).toFloat32(from: .littleEndian)?.toData(.bigEndian)
                == Data([4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4]).toFloat32(from: .bigEndian)?.toData(.littleEndian)
                == Data([4, 3, 2, 1])
        )
    }
    
    @Test
    func double() {
        // .toData
        
        #expect(
            0b1.double.toData(.littleEndian)
                == Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F])
        )
        #expect(
            0b1.double.toData(.bigEndian)
                == Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        )
        
        // .toDouble
        
        #expect(Data([]).toDouble() == nil) // underflow
        #expect(Data([1]).toDouble() == nil) // underflow
        #expect(Data([1, 2]).toDouble() == nil) // underflow
        #expect(Data([1, 2, 3]).toDouble() == nil) // underflow
        #expect(Data([1, 2, 3, 4]).toDouble() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5]).toDouble() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6]).toDouble() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7]).toDouble() == nil) // underflow
        #expect(Data([1, 2, 3, 4, 5, 6, 7, 8, 9]).toDouble() == nil) // overflow
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toDouble(from: .littleEndian)
                == 5.447603722011605e-270
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toDouble(from: .bigEndian)
                == 8.20788039913184e-304
        )
        
        // both ways
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toDouble()?.toData()
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toDouble(from: .littleEndian)?.toData(.littleEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toDouble(from: .bigEndian)?.toData(.bigEndian)
                == Data([1, 2, 3, 4, 5, 6, 7, 8])
        )
        
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toDouble(from: .littleEndian)?.toData(.bigEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
        #expect(
            Data([1, 2, 3, 4, 5, 6, 7, 8]).toDouble(from: .bigEndian)?.toData(.littleEndian)
                == Data([8, 7, 6, 5, 4, 3, 2, 1])
        )
    }
    
    @Test
    func memoryAlignment() {
        // test for misaligned raw pointer (memory alignment)
        
        // if the underlying `Data -> T: FixedWidthInteger` method is not properly aligned, this test
        // will trigger a runtime exception
        
        // cycle through 8 memory offset positions regardless of the type we're testing
        for offset in 1 ... 8 {
            let offSetBytes = Data([UInt8](repeating: 0x00, count: offset))
            
            // integers
            
            _ = (offSetBytes + Int8(1).toData(.bigEndian))[offset ... offset]
                .toInt8()
            
            _ = (offSetBytes + UInt8(1).toData(.bigEndian))[offset ... offset]
                .toUInt8()
            
            _ = (offSetBytes + Int16(1).toData(.bigEndian))[offset ... offset + 1]
                .toInt16(from: .bigEndian)
            
            _ = (offSetBytes + UInt16(1).toData(.bigEndian))[offset ... offset + 1]
                .toUInt16(from: .bigEndian)
            
            _ = (offSetBytes + Int32(1).toData(.bigEndian))[offset ... offset + 3]
                .toInt32(from: .bigEndian)
            
            _ = (offSetBytes + UInt32(1).toData(.bigEndian))[offset ... offset + 3]
                .toUInt32(from: .bigEndian)
            
            _ = (offSetBytes + Int64(1).toData(.bigEndian))[offset ... offset + 7]
                .toInt64(from: .bigEndian)
            
            _ = (offSetBytes + UInt64(1).toData(.bigEndian))[offset ... offset + 7]
                .toUInt64(from: .bigEndian)
            
            // floating-point
            
            _ = (offSetBytes + Float32(1).toData(.bigEndian))[offset ... offset + 3]
                .toFloat32(from: .bigEndian)
            
            _ = (offSetBytes + Double(1).toData(.bigEndian))[offset ... offset + 7]
                .toDouble(from: .bigEndian)
        }
    }
    
    // MARK: - String
    
    @Test
    func string() throws {
        // String -> Data
        
        let sourceString = "This is a test string"
        
        let expectedBytes: [UInt8] = [
            0x54, 0x68, 0x69, 0x73, 0x20, 0x69, 0x73, 0x20,
            0x61, 0x20, 0x74, 0x65, 0x73, 0x74, 0x20, 0x73,
            0x74, 0x72, 0x69, 0x6E, 0x67
        ]
        
        #expect(try #require(sourceString.toData(using: .utf8)) == Data(expectedBytes))
        
        // Data -> String
        
        let convertedString = Data(expectedBytes).toString(using: .utf8)
        
        #expect(convertedString == sourceString)
    }
    
    // MARK: - toUInt8Bytes
    
    @Test
    func dataUInt8Bytes() {
        let sourceBytes: [UInt8] = [1, 2, 3]
        
        // Collection -> Data
        
        #expect(sourceBytes.toData() == Data([1, 2, 3]))
        
        // Data -> Collection
        
        #expect(Data(sourceBytes).toUInt8Bytes() == [1, 2, 3])
    }
}

#endif
