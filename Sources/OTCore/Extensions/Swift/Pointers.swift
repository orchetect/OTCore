//
//  Pointers.swift
//  OTCore • https://github.com/orchetect/OTCore
//

extension UnsafeRawBufferPointer {
    
    /// **OTCore:**
    /// Convenience to return an `UnsafeBufferPointer` rebound to `UInt8` bytes.
    ///
    /// - warning: A memory location may only be bound to one type at a time.
    /// The behavior of accessing memory as a type unrelated to its bound type is undefined.
    /// (from the Swift inline documentation for `.bindMemory(to:)`)
    @inlinable @_disfavoredOverload
    public var unsafeBufferPointer: UnsafeBufferPointer<UInt8> {
        
        bindMemory(to: UInt8.self)
        
    }
    
}
