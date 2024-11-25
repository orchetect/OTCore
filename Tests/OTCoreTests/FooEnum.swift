//
//  FooEnum.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Shared constants and objects for tests

/// Test enum for use in unit tests
enum FooEnum {
    case foo(Int)                           // each Int has a different hash
    case fooB(Int)                          // identical hash regardless of Int
    case one
    case two
    case three
}

extension FooEnum: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.internalHash == rhs.internalHash
    }
}

extension FooEnum: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(internalHash)
    }
    
    private var internalHash: Int {
        switch self {
        case let .foo(val):  return val << 5 // each Int has different hash
        case .fooB:          return 0b01000  // identical hash regardless of Int
        case .one:           return 0b00010
        case .two:           return 0b00100
        case .three:         return 0b01000
        }
    }
}

extension FooEnum: CustomStringConvertible {
    var description: String {
        switch self {
        case let .foo(val):  return "foo(\(val))"
        case let .fooB(val): return "fooB(\(val))"
        case .one:           return "one"
        case .two:           return "two"
        case .three:         return "three"
        }
    }
}
