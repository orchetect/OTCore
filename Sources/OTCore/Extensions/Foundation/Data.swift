//
//  Data.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-12.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

// Endianness: All Apple platforms are currently little-endian

// Floating endianness:
/* On some machines, while integers were represented in little-endian form, floating point numbers were represented in big-endian form. Because there are many floating point formats, and a lack of a standard "network" representation, no standard for transferring floating point values has been made. This means that floating point data written on one machine may not be readable on another, and this is the case even if both use IEEE 754 floating point arithmetic since the endianness of the memory representation is not part of the IEEE specification. */

// int32
//   32-bit big-endian two's complement integer
// float32
//   OSC spec: 32-bit big-endian IEEE 754 floating point number
//   (I believe this means decimal32 of the IEEE 754 spec.)
// int64
//   OSC spec: 64-bit big-endian fixed-point

#if canImport(Foundation)

import Foundation

// MARK: - Int

extension Data {
	
	/// **OTCore:**
	/// Returns an Int64 value from Data
	/// Returns nil if Data is not the correct length.
	public func toInt(from endianness: NumberEndianness = .platformDefault) -> Int? {
		
		toNumber(from: endianness, toType: Int.self)
		
	}
	
}


// MARK: - Int8

extension Data {
	
	/// **OTCore:**
	/// Returns a Int8 value from Data (stored as two's complement).
	/// Returns nil if Data is not the correct length.
	public func toInt8() -> Int8? {
		
		if self.count != 1 { return nil }
		
		var int = UInt8()
		withUnsafeMutablePointer(to: &int) {
			self.copyBytes(to: $0, count: 1)
        }
		return Int8(bitPattern: int)
		
	}
	
}


// MARK: - Int16

extension Data {
	
	/// **OTCore:**
	/// Returns an Int16 value from Data
	/// Returns nil if Data is not the correct length.
	public func toInt16(from endianness: NumberEndianness = .platformDefault) -> Int16? {
		
		toNumber(from: endianness, toType: Int16.self)
		
	}
	
}


// MARK: - Int32

extension Data {
	
	/// **OTCore:**
	/// Returns an Int32 value from Data
	/// Returns nil if Data is not the correct length.
	public func toInt32(from endianness: NumberEndianness = .platformDefault) -> Int32? {
		
		toNumber(from: endianness, toType: Int32.self)
		
	}
	
}


// MARK: - Int64

extension Data {
	
	/// **OTCore:**
	/// Returns an Int64 value from Data
	/// Returns nil if Data is not the correct length.
	public func toInt64(from endianness: NumberEndianness = .platformDefault) -> Int64? {
		
		toNumber(from: endianness, toType: Int64.self)
		
	}
	
}


// MARK: - UInt

extension Data {
	
	/// **OTCore:**
	/// Returns a UInt value from Data.
	/// Returns nil if Data is not the correct length.
	public func toUInt(from endianness: NumberEndianness = .platformDefault) -> UInt? {
		
		toNumber(from: endianness, toType: UInt.self)
		
	}
	
}


// MARK: - UInt8

extension Data {
	
	/// **OTCore:**
	/// Returns a UInt8 value from Data.
	/// Returns nil if Data is not the correct length.
	public func toUInt8() -> UInt8? {
		
		if self.count != 1 { return nil }
		return self.first
		
	}
	
}


// MARK: - UInt16

extension Data {
	
	/// **OTCore:**
	/// Returns a UInt16 value from Data.
	/// Returns nil if Data is not the correct length.
	public func toUInt16(from endianness: NumberEndianness = .platformDefault) -> UInt16? {
		
		toNumber(from: endianness, toType: UInt16.self)
		
	}
	
}


// MARK: - UInt32

extension Data {
	
	/// **OTCore:**
	/// Returns a UInt32 value from Data.
	/// Returns nil if Data is not the correct length.
	public func toUInt32(from endianness: NumberEndianness = .platformDefault) -> UInt32? {
		
		toNumber(from: endianness, toType: UInt32.self)
		
	}
	
}


// MARK: - UInt64

extension Data {
	
	/// **OTCore:**
	/// Returns a UInt64 value from Data.
	/// Returns nil if Data is not the correct length.
	public func toUInt64(from endianness: NumberEndianness = .platformDefault) -> UInt64? {
		
		toNumber(from: endianness, toType: UInt64.self)
		
	}
	
}


// MARK: - Float32

extension Float32 {
	
	/// **OTCore:**
	/// Returns Data representation of a Float32 value.
	public func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
		
		var number = self
		var data: Data!
		
		withUnsafeBytes(of: &number) { rawBuffer in
			
			let unsafeBufferPointer = rawBuffer.unsafeBufferPointer
			
			switch endianness {
			case .platformDefault:
				data = Data(buffer: unsafeBufferPointer)
				
			case .littleEndian:
				switch NumberEndianness.system {
				case .littleEndian:
					data = Data(buffer: unsafeBufferPointer)
				case .bigEndian:
					data = Data(Data(buffer: unsafeBufferPointer).reversed())
				default:
					fatalError() // should never happen
				}
				
			case .bigEndian:
				switch NumberEndianness.system {
				case .littleEndian:
					data = Data(Data(buffer: unsafeBufferPointer).reversed())
				case .bigEndian:
					data = Data(buffer: unsafeBufferPointer)
				default:
					fatalError() // should never happen
				}
				
			}
			
		}
		
		return data
		
	}
	
}

extension Data {
	
	/// **OTCore:**
	/// Returns a Float32 value from Data
	/// Returns nil if Data is != 4 bytes.
	public func toFloat32(from endianness: NumberEndianness = .platformDefault) -> Float32? {
		
		if self.count != 4 { return nil }
		
		// define conversions
		
		let number = { self.withUnsafeBytes { $0.load(as: Float32.self) } }()
		
		let numberSwapped: Float32 = {
			var floatsw = CFConvertFloat32HostToSwapped(Float32())
			floatsw = self.withUnsafeBytes { $0.load(as: CFSwappedFloat32.self) }
			return CFConvertFloat32SwappedToHost(floatsw)
		}()
		
		// determine which conversion is needed
		
		switch endianness {
		case .platformDefault:
			return number
			
		case .littleEndian:
			switch NumberEndianness.system {
			case .littleEndian:
				return number
			case .bigEndian:
				return numberSwapped
			default:
				fatalError() // should never happen
			}
			
		case .bigEndian:
			switch NumberEndianness.system {
			case .littleEndian:
				return numberSwapped
			case .bigEndian:
				return number
			default:
				fatalError() // should never happen
			}
		}
		
	}
	
}


// MARK: - Double

extension Double {
	
	/// **OTCore:**
	/// Returns Data representation of a Double value.
	public func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
		
		var number = self
		var data: Data!
		
		withUnsafeBytes(of: &number) { rawBuffer in
			
			let unsafeBufferPointer = rawBuffer.unsafeBufferPointer
			
			switch endianness {
			case .platformDefault:
				data = Data(buffer: unsafeBufferPointer)
				
			case .littleEndian:
				switch NumberEndianness.system {
				case .littleEndian:
					data = Data(buffer: unsafeBufferPointer)
				case .bigEndian:
					data = Data(Data(buffer: unsafeBufferPointer).reversed())
				default:
					fatalError() // should never happen
				}
				
			case .bigEndian:
				switch NumberEndianness.system {
				case .littleEndian:
					data = Data(Data(buffer: unsafeBufferPointer).reversed())
				case .bigEndian:
					data = Data(buffer: unsafeBufferPointer)
				default:
					fatalError() // should never happen
				}
				
			}
			
		}
		
		return data
		
	}
	
}

extension Data {
	
	/// **OTCore:**
	/// Returns a Double value from Data
	/// Returns nil if Data is != 8 bytes.
	public func toDouble(from endianness: NumberEndianness = .platformDefault) -> Double? {
		
		if self.count != 8 { return nil }
		
		// define conversions
		
		let number: Double = { self.withUnsafeBytes { $0.load(as: Double.self) } }()
		
		let numberSwapped: Double = {
			var floatsw = CFConvertDoubleHostToSwapped(Double())
			floatsw = self.withUnsafeBytes { $0.load(as: CFSwappedFloat64.self) }
			return CFConvertDoubleSwappedToHost(floatsw)
		}()
		
		// determine which conversion is needed
		
		switch endianness {
		case .platformDefault:
			return number
			
		case .littleEndian:
			switch NumberEndianness.system {
			case .littleEndian:
				return number
			case .bigEndian:
				return numberSwapped
			default:
				fatalError() // should never happen
			}
			
		case .bigEndian:
			switch NumberEndianness.system {
			case .littleEndian:
				return numberSwapped
			case .bigEndian:
				return number
			default:
				fatalError() // should never happen
			}
		}
		
	}
	
}


// MARK: - .toData

extension FixedWidthInteger {
	
	/// **OTCore:**
	/// Returns Data representation of an integer. (Endianness has no effect on single-byte integers.)
	public func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
		
		var int: Self
		var data: Data!
		
		switch endianness {
		case .platformDefault:	int = self
		case .littleEndian:		int = self.littleEndian
		case .bigEndian:		int = self.bigEndian
		}
		
		withUnsafeBytes(of: &int) { rawBuffer in
			let unsafeBufferPointer = rawBuffer.unsafeBufferPointer
			data = Data(buffer: unsafeBufferPointer)
		}
		
		return data
		
	}
	
}


// MARK: - Helper methods

extension Data {
	
	/// Internal use.
	private func toNumber<T: FixedWidthInteger>(from endianness: NumberEndianness = .platformDefault, toType: T.Type) -> T? {
		
		guard self.count == MemoryLayout<T>.size else { return nil }
		
		// define conversion
		
		let int = { self.withUnsafeBytes { $0.load(as: T.self) } }()
		
		// determine which conversion is needed
		
		switch endianness {
		case .platformDefault:
			return int
			
		case .littleEndian:
			switch NumberEndianness.system {
			case .littleEndian:
				return int
			case .bigEndian:
				return int.byteSwapped
			default:
				fatalError() // should never happen
			}
			
		case .bigEndian:
			switch NumberEndianness.system {
			case .littleEndian:
				return int.byteSwapped
			case .bigEndian:
				return int
			default:
				fatalError() // should never happen
			}
			
		}
	}
	
}


// MARK: - String

extension String {
	
	/// **OTCore:**
	/// Returns a Data representation of a String, defaulting to utf8 encoding.
	public func toData(using encoding: String.Encoding = .utf8) -> Data? {
		
		self.data(using: encoding)
		
	}
	
}

extension Data {
	
	/// **OTCore:**
	/// Returns a String converted from Data. Optionally pass an encoding type.
	public func toString(using encoding: String.Encoding = .utf8) -> String? {
		
		String(data: self, encoding: encoding)
		
	}
	
}


// MARK: - Data Bytes

extension Collection where Element == UInt8 {
	
	/// **OTCore:**
	/// Same as `Data(self)`
	/// Returns a Data object using the array as bytes.
	public var data: Data {
		
		Data(self)
		
	}
}

extension Data {
	
	/// **OTCore:**
	/// Returns an array of bytes.
	/// Same as `[UInt8](self)`
	public var bytes: [UInt8] {
		
		[UInt8](self)
		
	}
	
}

#endif
