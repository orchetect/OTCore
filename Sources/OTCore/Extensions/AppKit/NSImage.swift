//
//  NSImage.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit

extension NSImage {
    /// **OTCore:**
    /// Compress image and write image file to disk.
    ///
    /// - Parameters:
    ///   - url: The location to write the data into..
    ///   - options: Options for writing the data.
    ///   - type: Image file type.
    ///   - jpegCompressionFactor: Compression factor for JPEG images only. (`0.0 ... 1.0`)
    ///     Values outside this range will be clamped to the valid value range.
    @_disfavoredOverload
    public func write(
        to url: URL,
        options: Data.WritingOptions = [],
        type: NSBitmapImageRep.FileType,
        jpegCompressionFactor compressionFactor: Double? = 0.85
    ) throws {
        var properties: [NSBitmapImageRep.PropertyKey: Any] = [:]
        properties[.compressionFactor] = compressionFactor?.clamped(to: 0.0 ... 1.0) as NSNumber?
        
        guard let imageData = tiffRepresentation,
              let imageRep = NSBitmapImageRep(data: imageData),
              let fileData = imageRep.representation(using: type, properties: properties)
        else {
            throw CocoaError(.fileWriteUnknown)
        }
        
        try fileData.write(to: url, options: options)
    }
}

#endif
