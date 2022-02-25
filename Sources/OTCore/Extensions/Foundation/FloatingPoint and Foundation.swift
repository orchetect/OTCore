//
//  FloatingPoint and Foundation.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

// MARK: - FloatingPointHighPrecisionStringConvertible

extension Double:  FloatingPointHighPrecisionStringConvertible { }
extension Float:   FloatingPointHighPrecisionStringConvertible { }

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: FloatingPointHighPrecisionStringConvertible { }
#endif

/// Internal - cached
fileprivate let ZeroCharacterSet   = CharacterSet(charactersIn: "0")
fileprivate let PeriodCharacterSet = CharacterSet(charactersIn: ".")

extension FloatingPoint where Self : CVarArg,
                              Self : FloatingPointHighPrecisionStringConvertible {
    
    /// **OTCore:**
    /// Returns a string representation of a floating-point number, with maximum 100 decimal places of precision.
    @_disfavoredOverload
    public var stringValueHighPrecision: String {
        
        var formatted = String(format: "%.100f", self)
            .trimmingCharacters(in: ZeroCharacterSet)
        
        if formatted.prefix(1) == "." { formatted = "0\(formatted)" }
        
        formatted.removeSuffix(".")
        
        return formatted
        
    }
    
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80 {
    
    /// **OTCore:**
    /// Returns a string representation of a floating-point number, with maximum 100 decimal places of precision.
    @_disfavoredOverload
    public var stringValueHighPrecision: String {
        
        // String(format:) does not work with Float80
        // so we need a custom implementation here
        return String(describing: self)
        
    }
    
}
#endif

#endif
