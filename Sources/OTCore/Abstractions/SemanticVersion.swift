//
//  SemanticVersion.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

/// **OTCore:**
/// Struct that represents a SemVer 2.0 version string into its components.
/// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
public struct SemanticVersion {
    /// Major version component. Must be `0` or greater. (ie: `x.2.4`)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting a value less than `0` causes a precondition failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var major: Int {
        didSet {
            precondition(major >= 0)
            if major < 0 { major = oldValue }
        }
    }
	
    /// Minor version component. Must be `0` or greater. (ie: `1.x.4`)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting a value less than `0` causes a precondition failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var minor: Int {
        didSet {
            precondition(minor >= 0)
            if minor < 0 { minor = oldValue }
        }
    }
	
    /// Patch version component. Must be `0` or greater. (ie: `1.2.x`)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting a value less than `0` causes a precondition failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var patch: Int {
        didSet {
            precondition(patch >= 0)
            if patch < 0 { patch = oldValue }
        }
    }
    
    /// Pre-release information. (Optional)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting an invalid string causes an assertion failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var preRelease: String? {
        didSet {
            guard let preRelease else { return }
            guard !preRelease.isEmpty else {
                self.preRelease = nil
                return
            }
            guard Self.isPreReleaseValid(preRelease) else {
                assertionFailure("Invalid pre-release string.")
                self.preRelease = oldValue
                return
            }
        }
    }
    
    /// Build metadata. (Optional)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting an invalid string causes an assertion failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var build: String? {
        didSet {
            guard let build else { return }
            guard !build.isEmpty else {
                self.build = nil
                return
            }
            guard Self.isBuildValid(build) else {
                assertionFailure("Invalid build string.")
                self.build = oldValue
                return
            }
        }
    }
}

extension SemanticVersion: RawRepresentable {
    /// **OTCore:**
    /// Parses a semantic version string, strictly adhering to SemVer specification.
    public init?(rawValue: String) {
        let rawString = rawValue.hasPrefix(caseInsensitive: "v") ? rawValue.dropFirst().string : rawValue
        
        let pattern = #"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"#
        let groups = rawString.regexMatches(captureGroupsFromPattern: pattern)
        
        guard groups.count >= 4,
              let maj = groups[1]?.int,
              let min = groups[2]?.int,
              let pat = groups[3]?.int
        else { return nil }
        
        major = maj
        minor = min
        patch = pat
        preRelease = groups[safe: 4]??.string
        build = groups[safe: 5]??.string
        
        guard major >= 0, minor >= 0, patch >= 0 else { return nil }
    }
    
    /// Returns the full version string.
    public var rawValue: String {
        let pre = preRelease == nil ? "" : "-" + preRelease!
        let bld = build == nil ? "" : "+" + build!
        return "\(major).\(minor).\(patch)\(pre)\(bld)"
    }
}

extension SemanticVersion: Equatable { }

extension SemanticVersion: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }
        
        guard lhs.preRelease != rhs.preRelease else { return false }
        
        // One or both pre-release strings will be non-nil at this point.
        
        guard let lhsPreRelease = lhs.preRelease, let rhsPreRelease = rhs.preRelease else {
            // Only one pre-release string is non-nil. In that case, the non-pre-release takes precedence.
            return lhs.preRelease != nil
        }
        
        // Both pre-release strings are non-nil now, and we have determined they are not equal.
        
        // Pre-release strings must be compared by comparing each dot separated identifier from left
        // to right until a difference is found as follows:
        //     1. Identifiers consisting of only digits are compared numerically.
        //     2. Identifiers with letters or hyphens are compared lexically in ASCII sort order.
        //     3. Numeric identifiers always have lower precedence than non-numeric identifiers.
        //     4. A larger set of pre-release fields has a higher precedence than a smaller set, if all
        //        of the preceding identifiers are equal.
        
        let lhsIdentifiers = lhsPreRelease.split(separator: ".", omittingEmptySubsequences: false)
        let rhsIdentifiers = rhsPreRelease.split(separator: ".", omittingEmptySubsequences: false)
        
        var index = 0
        
        while lhsIdentifiers.indices.contains(index), rhsIdentifiers.indices.contains(index) {
            defer { index += 1 }
            let lhsID = lhsIdentifiers[index]
            let rhsID = rhsIdentifiers[index]
            
            if lhsID != rhsID {
                // first try numerical comparison if they are both integers
                if let lhsInt = Int(lhsID), let rhsInt = Int(rhsID) {
                    return lhsInt < rhsInt
                }
                // then try ASCII character ordering
                
                let lhsChars = lhsID.compactMap(\.asciiValue)
                assert(lhsChars.count == lhsID.count)
                
                let rhsChars = rhsID.compactMap(\.asciiValue)
                assert(rhsChars.count == rhsID.count)
                
                return lhsChars.lexicographicallyPrecedes(rhsChars)
            }
        }
        
        // at this point, one of the IDs may exist at the current index and the other does not.
        // (Technically it shouldn't be possible that both indexes don't exist, because that implies both
        // pre-release strings are equal, which we already checked for.)
        if lhsIdentifiers.indices.contains(index) { return false }
        if rhsIdentifiers.indices.contains(index) { return true }
        
        // We should never reach this point, because it implies that both pre-release strings are equal
        // (which we already checked for).
        return false
        
        // Note: SemVer spec specifies omitting build metadata from version precedence comparisons
    }
}

extension SemanticVersion: Hashable { }

extension SemanticVersion: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension SemanticVersion: Codable { }

extension SemanticVersion: Sendable { }

// MARK: - Additional Inits

extension SemanticVersion {
    /// **OTCore:**
    /// Parses a semantic version string, strictly adhering to SemVer specification.
    ///
    /// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
    public init?(_ strict: String) {
        self.init(rawValue: strict)
    }
    
    /// **OTCore:**
    /// Parses a semantic version string, using relaxed rules where `major` or `major.minor` version
    /// strings are accepted and any omitted trailing version components are assumed to be zero (`0`).
    public init?(nonStrict rawValue: String) {
        if let strict = Self(rawValue: rawValue) {
            self = strict
            return
        }
        
        let rawString = rawValue.hasPrefix(caseInsensitive: "v") ? rawValue.dropFirst().string : rawValue
        
        let pattern = #"^(0|[1-9]\d*)(\.(0|[1-9]\d*)){0,1}$"#
        let groups = rawString.regexMatches(captureGroupsFromPattern: pattern)
        
        guard let majorVer = groups[safe: 1]??.int else { return nil }
        
        major = majorVer
        minor = groups[safe: 3]??.int ?? 0
        patch = 0
        preRelease = nil
        build = nil
        
        guard major >= 0, minor >= 0, patch >= 0 else { return nil }
    }
    
    /// **OTCore:**
    /// Initialize from individual version components.
    ///
    /// - Parameters:
    ///   - major: Major version component. Must be `0` or greater. (Required)
    ///   - minor: Minor version component. Must be `0` or greater. (Required)
    ///   - patch: Patch version component. Must be `0` or greater. (Required)
    ///   - preRelease: Pre-release information. (Optional)
    ///   - build: Build metadata. (Optional)
    ///
    /// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
    ///
    /// - Returns: This initializer will fail if either `major`, `minor`, or `patch` components are `< 0`.
    ///   This will also fail if `preRelease` or `build` are invalid strings.
    @_disfavoredOverload
    public init?(
        _ major: Int,
        _ minor: Int,
        _ patch: Int,
        preRelease: String? = nil,
        build: String? = nil
    ) {
        guard major >= 0, minor >= 0, patch >= 0 else { return nil }
        self.init(UInt(major), UInt(minor), UInt(patch), preRelease: preRelease, build: build)
    }
    
    /// **OTCore:**
    /// Initialize from individual version components.
    ///
    /// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
    ///
    /// - Parameters:
    ///   - major: Major version component. Must be `0` or greater. (Required)
    ///   - minor: Minor version component. Must be `0` or greater. (Required)
    ///   - patch: Patch version component. Must be `0` or greater. (Required)
    public init(
        _ major: UInt,
        _ minor: UInt,
        _ patch: UInt
    ) {
        self.major = Int(major)
        self.minor = Int(minor)
        self.patch = Int(patch)
    }
    
    /// **OTCore:**
    /// Initialize from individual version components.
    ///
    /// - Parameters:
    ///   - major: Major version component. Must be `0` or greater. (Required)
    ///   - minor: Minor version component. Must be `0` or greater. (Required)
    ///   - patch: Patch version component. Must be `0` or greater. (Required)
    ///   - preRelease: Pre-release information. (Optional)
    ///   - build: Build metadata. (Optional)
    ///
    /// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
    ///
    /// - Returns: This initializer will fail if `preRelease` or `build` are invalid strings.
    public init?(
        _ major: UInt,
        _ minor: UInt,
        _ patch: UInt,
        preRelease: String? = nil,
        build: String? = nil
    ) {
        self.major = Int(major)
        self.minor = Int(minor)
        self.patch = Int(patch)
        
        if let preRelease, !preRelease.isEmpty {
            guard Self.isPreReleaseValid(preRelease) else { return nil }
            self.preRelease = preRelease
        } else {
            self.preRelease = nil
        }
        
        if let build, !build.isEmpty {
            guard Self.isBuildValid(build) else { return nil }
            self.build = build
        } else {
            self.build = nil
        }
    }
}

// MARK: - Static Constructors

extension SemanticVersion {
    /// **OTCore:**
    /// Semantic version zero (`0.0.0`).
    public static let zero: SemanticVersion = SemanticVersion(0, 0, 0)
}

// MARK: - Computed Metadata Properties

extension SemanticVersion {
    /// Returns `true` if the version is considered a stable release.
    public var isStable: Bool { preRelease == nil }
    
    /// Returns `true` if the version is considered a major release (ie: `2.0.0`).
    public var isMajorRelease: Bool { major > 0 && minor == 0 && patch == 0 }
    
    /// Returns `true` if the version is considered a minor release (ie: `2.1.0`).
    public var isMinorRelease: Bool { minor > 0 && patch == 0 }
    
    /// Returns `true` if the version is considered a patch release (ie: `2.1.3`).
    public var isPatchRelease: Bool { patch > 0 }
    
    /// Returns `true` if the version is considered a pre-release.
    public var isPreRelease: Bool { preRelease != nil }
    
    /// Returns `true` if the version is considered the initial release.
    /// The only version that matches this criteria is `0.0.0`.
    public var isInitialRelease: Bool { isZero }
    
    /// Returns `true` if the version is zero without any pre-release or build metadata.
    /// The only version that matches this criteria is `0.0.0`.
    public var isZero: Bool { self == .zero }
}

// MARK: - Helpers {

extension SemanticVersion {
    /// Internal:
    /// Validates a pre-release component string.
    static func isPreReleaseValid(_ string: String) -> Bool {
        let pattern = #"^(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*$"#
        let matches = string.regexMatches(pattern: pattern)
        return matches.count == 1
    }
    
    /// Internal:
    /// Validates a build component string.
    static func isBuildValid(_ string: String) -> Bool {
        let pattern = #"^[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*$"#
        let matches = string.regexMatches(pattern: pattern)
        return matches.count == 1
    }
}

#endif
