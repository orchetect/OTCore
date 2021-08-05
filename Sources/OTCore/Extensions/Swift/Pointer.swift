//
//  Pointer.swift
//  OTCore • https://github.com/orchetect/OTCore
//

extension UnsafePointer {
    
    /// **OTCore:**
    /// Convert an `UnsafePointer<SomeType>` to `UnsafeRawBufferPointer`.
    @inlinable public init?(unsafeRawBufferPointer: Any) {
        
        var ptr: UnsafePointer<Pointee>?
        
        withUnsafeBytes(of: unsafeRawBufferPointer) { unsafeRawBufferPointer -> Void in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: Pointee.self)
            ptr = unsafeBufferPointer.baseAddress
        }
        
        if let unwrappedPtr = ptr {
            self = unwrappedPtr
        } else {
            return nil
        }
        
    }
    
}

extension UnsafeRawBufferPointer {
    
    /// **OTCore:**
    /// Convert an `UnsafeRawBufferPointer` to `UnsafePointer`, typically for use with `withUnsafeBytes`.
    ///
    /// Usage example:
    ///
    ///     let data = Data([0x01, 0x02, 0x03])
    ///
    /// Use of this property requires the type be explicitly supplied with the following syntax:
    ///
    ///     // where urbp == UnsafeRawBufferPointer<SomeType>
    ///     let ptr: UnsafePointer<SomeType>? = urbp.unsafePointer()
    ///
    @inlinable public func unsafePointer<T: Any>() -> UnsafePointer<T>? {
        
        var ptr: UnsafePointer<T>?
        
        withUnsafeBytes { unsafeRawBufferPointer in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: T.self)
            ptr = unsafeBufferPointer.baseAddress
        }
        
        return ptr
        
    }
    
    /// **OTCore:**
    /// Convenience to return an `UnsafeBufferPointer` of UInt8 bytes
    ///
    /// - warning: A memory location may only be bound to one type at a time.
    /// The behavior of accessing memory as a type unrelated to its bound type is undefined.
    /// (from the Swift inline documentation for `.bindMemory(to:)`)
    @inlinable public var unsafeBufferPointer: UnsafeBufferPointer<UInt8> {
        
        self.bindMemory(to: UInt8.self)
        
    }
    
}
