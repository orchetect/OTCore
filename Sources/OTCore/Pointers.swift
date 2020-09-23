//
//  Pointers.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-09-30.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation

/// OTCore:
/// Convert a UnsafeRawBufferPointer to UnsafePointer, typically for use with withUnsafeBytes. Its use depends on type inference.
///
/// Usage example:
///
/// Say that `address` is a pre-existing variable of type `sockaddr`, we can get an UnsafePointer to `address` like this:
///
/// ```
/// let ptr: UnsafePointer<sockaddr>? = UnsafeRawBufferPointerToUnsafePointer(pointer: address)
/// ```
///
/// Internally, this function returns the `baseAddress` of `address`.
public func UnsafeRawBufferPointerToUnsafePointer<T>(pointer: Any) -> UnsafePointer<T>? {
	
	var ptr: UnsafePointer<T>?
	
	withUnsafeBytes(of: pointer) { (rawBufferPointer: UnsafeRawBufferPointer) -> Void in
		let unsafeBufferPointer = rawBufferPointer.bindMemory(to: T.self)
		ptr = unsafeBufferPointer.baseAddress
	}
	
	return ptr
	
}

extension UnsafeRawBufferPointer {
	
	/// OTCore:
	/// Convenience to return an UnsafeBufferPointer
	public var unsafeBufferPointer: UnsafeBufferPointer<UInt8> {
		return self.bindMemory(to: UInt8.self)
	}
	
}
