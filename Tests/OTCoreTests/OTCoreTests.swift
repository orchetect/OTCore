//
//  OTCoreTests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - Shared constants and objects for tests

#if !os(watchOS)

/// Test enum for use in unit tests
enum fooEnum: Hashable, CustomStringConvertible {
    
    case foo(Int)                           // each Int has a different hash
    case fooB(Int)                          // identical hash regardless of Int
    case one
    case two
    case three
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(internalHash)
        
    }
    
    var internalHash: Int {
        
        switch self {
        case .foo(let val): return val << 5 // each Int has different hash
        case .fooB(_):      return 0b01000  // identical hash regardless of Int
        case .one:          return 0b00010
        case .two:          return 0b00100
        case .three:        return 0b01000
        }
        
    }
    
    var description: String {
        
        switch self {
        case .foo(let val): return ".foo(\(val))"
        case .fooB(let val): return ".fooB(\(val))"
        case .one:    return ".one"
        case .two:    return ".two"
        case .three:  return ".three"
        }
        
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        
        lhs.internalHash == rhs.internalHash
        
    }
    
}

#endif
