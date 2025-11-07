//
//  SemanticVersion Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
import OTCore
import Testing

@Suite struct SemanticVersionTests {
    @Test func init_string_valid() async {
        #expect(SemanticVersion("0.0.4") != nil)
        #expect(SemanticVersion("1.2.3") != nil)
        #expect(SemanticVersion("10.20.30") != nil)
        #expect(SemanticVersion("1.1.2-prerelease+meta") != nil)
        #expect(SemanticVersion("1.1.2+meta") != nil)
        #expect(SemanticVersion("1.1.2+meta-valid") != nil)
        #expect(SemanticVersion("1.0.0-alpha") != nil)
        #expect(SemanticVersion("1.0.0-beta") != nil)
        #expect(SemanticVersion("1.0.0-alpha.beta") != nil)
        #expect(SemanticVersion("1.0.0-alpha.beta.1") != nil)
        #expect(SemanticVersion("1.0.0-alpha.1") != nil)
        #expect(SemanticVersion("1.0.0-alpha0.valid") != nil)
        #expect(SemanticVersion("1.0.0-alpha.0valid") != nil)
        #expect(SemanticVersion("1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay") != nil)
        #expect(SemanticVersion("1.0.0-rc.1+build.1") != nil)
        #expect(SemanticVersion("2.0.0-rc.1+build.123") != nil)
        #expect(SemanticVersion("1.2.3-beta") != nil)
        #expect(SemanticVersion("10.2.3-DEV-SNAPSHOT") != nil)
        #expect(SemanticVersion("1.2.3-SNAPSHOT-123") != nil)
        #expect(SemanticVersion("1.0.0") != nil)
        #expect(SemanticVersion("2.0.0") != nil)
        #expect(SemanticVersion("1.1.7") != nil)
        #expect(SemanticVersion("2.0.0+build.1848") != nil)
        #expect(SemanticVersion("2.0.1-alpha.1227") != nil)
        #expect(SemanticVersion("1.0.0-alpha+beta") != nil)
        #expect(SemanticVersion("1.2.3----RC-SNAPSHOT.12.9.1--.12+788") != nil)
        #expect(SemanticVersion("1.2.3----R-S.12.9.1--.12+meta") != nil)
        #expect(SemanticVersion("1.2.3----RC-SNAPSHOT.12.9.1--.12") != nil)
        #expect(SemanticVersion("1.0.0+0.build.1-rc.10000aaa-kk-0.1") != nil)
        #expect(SemanticVersion("9999999999999999.99999999999999.9999999999999") != nil)
        #expect(SemanticVersion("1.0.0-0A.is.legal") != nil)
    }
    
    @Test func init_string_valid_allowLeadingV() async {
        #expect(SemanticVersion("v0.0.4") != nil)
        #expect(SemanticVersion("V0.0.4") != nil)
    }
    
    @Test func init_string_invalid() async {
        #expect(SemanticVersion("1") == nil)
        #expect(SemanticVersion("1.2") == nil)
        #expect(SemanticVersion("1.2.3-0123") == nil)
        #expect(SemanticVersion("1.2.3-0123.0123") == nil)
        #expect(SemanticVersion("1.1.2+.123") == nil)
        #expect(SemanticVersion("+invalid") == nil)
        #expect(SemanticVersion("-invalid") == nil)
        #expect(SemanticVersion("-invalid+invalid") == nil)
        #expect(SemanticVersion("-invalid.01") == nil)
        #expect(SemanticVersion("alpha") == nil)
        #expect(SemanticVersion("alpha.beta") == nil)
        #expect(SemanticVersion("alpha.beta.1") == nil)
        #expect(SemanticVersion("alpha.1") == nil)
        #expect(SemanticVersion("alpha+beta") == nil)
        #expect(SemanticVersion("alpha_beta") == nil)
        #expect(SemanticVersion("alpha.") == nil)
        #expect(SemanticVersion("alpha..") == nil)
        #expect(SemanticVersion("beta") == nil)
        #expect(SemanticVersion("1.0.0-alpha_beta") == nil)
        #expect(SemanticVersion("-alpha.") == nil)
        #expect(SemanticVersion("1.0.0-alpha..") == nil)
        #expect(SemanticVersion("1.0.0-alpha..1") == nil)
        #expect(SemanticVersion("1.0.0-alpha...1") == nil)
        #expect(SemanticVersion("1.0.0-alpha....1") == nil)
        #expect(SemanticVersion("1.0.0-alpha.....1") == nil)
        #expect(SemanticVersion("1.0.0-alpha......1") == nil)
        #expect(SemanticVersion("1.0.0-alpha.......1") == nil)
        #expect(SemanticVersion("01.1.1") == nil)
        #expect(SemanticVersion("1.01.1") == nil)
        #expect(SemanticVersion("1.1.01") == nil)
        #expect(SemanticVersion("1.2") == nil)
        #expect(SemanticVersion("1.2.3.DEV") == nil)
        #expect(SemanticVersion("1.2-SNAPSHOT") == nil)
        #expect(SemanticVersion("1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788") == nil)
        #expect(SemanticVersion("1.2-RC-SNAPSHOT") == nil)
        #expect(SemanticVersion("-1.0.3-gamma+b7718") == nil)
        #expect(SemanticVersion("+justmeta") == nil)
        #expect(SemanticVersion("9.8.7+meta+meta") == nil)
        #expect(SemanticVersion("9.8.7-whatever+meta+meta") == nil)
    }
    
    @Test func init_string_basic() async {
        #expect(SemanticVersion("1.2.3")! == SemanticVersion(1, 2, 3))
        #expect(SemanticVersion("v1.2.3")! == SemanticVersion(1, 2, 3))
        #expect(SemanticVersion("V1.2.3")! == SemanticVersion(1, 2, 3))
        #expect(SemanticVersion("1.2.3-rc")! == SemanticVersion(1, 2, 3, preRelease: "rc")!)
        #expect(SemanticVersion("v1.2.3-beta1")! == SemanticVersion(1, 2, 3, preRelease: "beta1")!)
        #expect(SemanticVersion("v1.2.3-beta1+build5")! == SemanticVersion(1, 2, 3, preRelease: "beta1", build: "build5")!)
        #expect(SemanticVersion("1.2.3-beta-foo")! == SemanticVersion(1, 2, 3, preRelease: "beta-foo")!)
        #expect(SemanticVersion("1.2.3-beta-foo+build-42")! == SemanticVersion(1, 2, 3, preRelease: "beta-foo", build: "build-42")!)
        #expect(SemanticVersion("1.2.3")! == SemanticVersion(1, 2, 3, preRelease: "", build: "")!)
        #expect(SemanticVersion("") == nil)
        #expect(SemanticVersion("1") == nil)
        #expect(SemanticVersion("1.2") == nil)
        #expect(SemanticVersion("1.2.3rc") == nil)
        #expect(SemanticVersion("swift-2.2-SNAPSHOT-2016-01-11-a") == nil)
    }
    
    @Test func init_int_basic() async {
        #expect(SemanticVersion(Int(1), Int(2), Int(3))! == SemanticVersion(1, 2, 3))
        #expect(
            SemanticVersion(Int(1), Int(2), Int(3), preRelease: "rc")!
                == SemanticVersion(1, 2, 3, preRelease: "rc")
        )
        #expect(
            SemanticVersion(Int(1), Int(2), Int(3), preRelease: "rc", build: "build5")!
                == SemanticVersion(1, 2, 3, preRelease: "rc", build: "build5")
        )
    }
    
    @Test func init_int_edgeCases() async {
        #expect(SemanticVersion(Int(-1), Int(0), Int(0)) == nil)
        #expect(SemanticVersion(Int(1), Int(-2), Int(0)) == nil)
        #expect(SemanticVersion(Int(1), Int(2), Int(-3)) == nil)
    }
    
    @Test func propertySetters() async {
        var semVer = SemanticVersion(0, 0, 0)
        
        semVer.major = 1
        semVer.minor = 2
        semVer.patch = 3
        semVer.preRelease = "beta1"
        semVer.build = "1478"
        #expect(semVer.major == 1)
        #expect(semVer.minor == 2)
        #expect(semVer.patch == 3)
        #expect(semVer.preRelease == "beta1")
        #expect(semVer.build == "1478")
        
        semVer.preRelease = "" // empty string is interpreted as `nil`
        #expect(semVer.preRelease == nil)
        #expect(semVer.rawValue == "1.2.3+1478") // ensure other values have not changed
        
        semVer.build = "" // empty string is interpreted as `nil`
        #expect(semVer.build == nil)
        #expect(semVer.rawValue == "1.2.3") // ensure other values have not changed
    }
    
    #if os(macOS) && swift(>=6.2)
    @available(macOS 15, *)
    @Test func propertySetters_edgeCases() async {
        // setting invalid value (negative) fails a precondition in debug builds
        await #expect(processExitsWith: .failure) {
            var semVer = SemanticVersion(1, 2, 3)
            semVer.major = -1
        }
        await #expect(processExitsWith: .failure) {
            var semVer = SemanticVersion(1, 2, 3)
            semVer.minor = -1
        }
        await #expect(processExitsWith: .failure) {
            var semVer = SemanticVersion(1, 2, 3)
            semVer.patch = -1
        }
        await #expect(processExitsWith: .failure) {
            var semVer = SemanticVersion(1, 2, 3)
            semVer.preRelease = "alpha_14"
        }
        await #expect(processExitsWith: .failure) {
            var semVer = SemanticVersion(1, 2, 3)
            semVer.build = "nightly_build_20251106"
        }
    }
    #endif
    
    @Test func description() async {
        #expect(SemanticVersion("1.2.3")!.description == "1.2.3")
        #expect(SemanticVersion("v1.2.3")!.description == "1.2.3")
        #expect(SemanticVersion("1.2.3-beta1")!.description == "1.2.3-beta1")
        #expect(SemanticVersion("1.2.3-beta1+build")!.description == "1.2.3-beta1+build")
    }
    
    @Test func comparable_basic() async {
        #expect(!(SemanticVersion(1, 0, 0) < SemanticVersion(1, 0, 0))) // identical
        #expect(!(SemanticVersion(1, 0, 0) > SemanticVersion(1, 0, 0))) // identical
        
        #expect(SemanticVersion(1, 0, 0) < SemanticVersion(1, 0, 1))
        #expect(SemanticVersion(1, 0, 0) < SemanticVersion(1, 1, 0))
        #expect(SemanticVersion(1, 0, 0) < SemanticVersion(2, 0, 0))
    }
    
    @Test func comparable_preRelease() async {
        // pre-releases always precede when the major/minor/patch version is identical
        #expect(SemanticVersion(1, 0, 0, preRelease: "a")! < SemanticVersion(1, 0, 0))
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.a")! < SemanticVersion(1, 0, 0))
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.100")! < SemanticVersion(1, 0, 0))
        
        // identifiers with letters or hyphens are compared lexically in ASCII sort order
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a")! < SemanticVersion(1, 0, 0, preRelease: "a")!)) // identical
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a")! > SemanticVersion(1, 0, 0, preRelease: "a")!)) // identical
        #expect(SemanticVersion(1, 0, 0, preRelease: "a")! < SemanticVersion(1, 0, 0, preRelease: "b")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "b")! > SemanticVersion(1, 0, 0, preRelease: "a")!)
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a.a")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)) // identical
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.a")! < SemanticVersion(1, 0, 0, preRelease: "a.b")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.b")! > SemanticVersion(1, 0, 0, preRelease: "a.a")!)
        
        // identifiers consisting of only digits are compared numerically
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a.1")! < SemanticVersion(1, 0, 0, preRelease: "a.1")!)) // identical
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.1")! < SemanticVersion(1, 0, 0, preRelease: "a.2")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.2")! > SemanticVersion(1, 0, 0, preRelease: "a.1")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.1")! < SemanticVersion(1, 0, 0, preRelease: "a.100")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.1")! < SemanticVersion(1, 0, 0, preRelease: "a.123")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.2")! < SemanticVersion(1, 0, 0, preRelease: "a.10")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.2")! < SemanticVersion(1, 0, 0, preRelease: "a.11")!)
        
        // numeric identifiers always have lower precedence than non-numeric identifiers
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.1")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.2")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.1")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.100")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.123")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.10")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a.11")! < SemanticVersion(1, 0, 0, preRelease: "a.a")!)
    }
    
    @Test func comparable_build() async {
        // build metadata is omitted from precedence comparisons
        #expect(!(SemanticVersion(1, 0, 0, build: "a")! < SemanticVersion(1, 0, 0, build: "a")!)) // identical
        #expect(!(SemanticVersion(1, 0, 0, build: "a")! < SemanticVersion(1, 0, 0, build: "b")!))
        #expect(!(SemanticVersion(1, 0, 0, build: "b")! < SemanticVersion(1, 0, 0, build: "a")!))
        
        #expect(!(SemanticVersion(1, 0, 0, build: "a")! > SemanticVersion(1, 0, 0, build: "a")!)) // identical
        #expect(!(SemanticVersion(1, 0, 0, build: "a")! > SemanticVersion(1, 0, 0, build: "b")!))
        #expect(!(SemanticVersion(1, 0, 0, build: "b")! > SemanticVersion(1, 0, 0, build: "a")!))
        
        #expect(SemanticVersion(1, 0, 0, build: "a")! <= SemanticVersion(1, 0, 0, build: "a")!) // identical
        #expect(SemanticVersion(1, 0, 0, build: "a")! <= SemanticVersion(1, 0, 0, build: "b")!)
        #expect(SemanticVersion(1, 0, 0, build: "b")! <= SemanticVersion(1, 0, 0, build: "a")!)
        
        #expect(SemanticVersion(1, 0, 0, build: "a")! >= SemanticVersion(1, 0, 0, build: "a")!) // identical
        #expect(SemanticVersion(1, 0, 0, build: "a")! >= SemanticVersion(1, 0, 0, build: "b")!)
        #expect(SemanticVersion(1, 0, 0, build: "b")! >= SemanticVersion(1, 0, 0, build: "a")!)
    }
    
    @Test func comparable_preReleaseAndBuild() async {
        // ensure that build metadata component never affects comparison
        
        // identical
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a", build: "a")! < SemanticVersion(1, 0, 0, preRelease: "a", build: "a")!))
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a", build: "a")! > SemanticVersion(1, 0, 0, preRelease: "a", build: "a")!))
        #expect(SemanticVersion(1, 0, 0, preRelease: "a", build: "a")! == SemanticVersion(1, 0, 0, preRelease: "a", build: "a")!)
        
        // only build differs
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a", build: "a")! < SemanticVersion(1, 0, 0, preRelease: "a", build: "b")!))
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a", build: "a")! > SemanticVersion(1, 0, 0, preRelease: "a", build: "b")!))
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a", build: "a")! == SemanticVersion(1, 0, 0, preRelease: "a", build: "b")!))
        
        // builds in descending order, but pre-releases in ascending order
        #expect(SemanticVersion(1, 0, 0, preRelease: "y", build: "b")! < SemanticVersion(1, 0, 0, preRelease: "z", build: "a")!)
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "y", build: "b")! > SemanticVersion(1, 0, 0, preRelease: "z", build: "a")!))
    }
    
    // MARK: - Computed Metadata Properties
    
    @Test func isStable() async {
        #expect(SemanticVersion(1, 0, 0).isStable)
        #expect(SemanticVersion(1, 0, 0, preRelease: "")!.isStable)
        #expect(SemanticVersion(1, 0, 0, preRelease: "", build: "")!.isStable)
        
        #expect(!(SemanticVersion(1, 0, 0, preRelease: "a")!.isStable))
        #expect((SemanticVersion(1, 0, 0, preRelease: "", build: "a")!.isStable))
    }
    
    @Test func isMajorRelease() async {
        #expect(SemanticVersion(1, 0, 0).isMajorRelease)
        #expect(SemanticVersion(1, 0, 0, preRelease: "b")!.isMajorRelease)
        #expect(SemanticVersion(1, 0, 0, build: "b")!.isMajorRelease)
        #expect(SemanticVersion(1, 0, 0, preRelease: "b", build: "b")!.isMajorRelease)
        
        #expect(!SemanticVersion(0, 0, 1).isMajorRelease)
        #expect(!SemanticVersion(0, 0, 1, preRelease: "b")!.isMajorRelease)
        #expect(!SemanticVersion(0, 1, 0).isMajorRelease)
        #expect(!SemanticVersion(0, 1, 0, preRelease: "b")!.isMajorRelease)
        #expect(!SemanticVersion(0, 1, 1).isMajorRelease)
        #expect(!SemanticVersion(0, 0, 0).isMajorRelease)
    }
    
    @Test func isMinorRelease() async {
        #expect(!SemanticVersion(1, 0, 0).isMinorRelease)
        #expect(!SemanticVersion(1, 0, 0, preRelease: "b")!.isMinorRelease)
        #expect(!SemanticVersion(0, 0, 1).isMinorRelease)
        #expect(!SemanticVersion(0, 0, 1, preRelease: "b")!.isMinorRelease)
        
        #expect(SemanticVersion(0, 1, 0).isMinorRelease)
        #expect(SemanticVersion(0, 1, 0, preRelease: "b")!.isMinorRelease)
        #expect(SemanticVersion(0, 1, 0, build: "b")!.isMinorRelease)
        #expect(SemanticVersion(0, 1, 0, preRelease: "a", build: "b")!.isMinorRelease)
        
        #expect(!SemanticVersion(0, 1, 1).isMinorRelease)
        #expect(!SemanticVersion(0, 0, 0).isMinorRelease)
    }
    
    @Test func isPatchRelease() async {
        #expect(!SemanticVersion(1, 0, 0).isPatchRelease)
        #expect(!SemanticVersion(1, 0, 0, preRelease: "b")!.isPatchRelease)
        
        #expect(SemanticVersion(0, 0, 1).isPatchRelease)
        #expect(SemanticVersion(0, 0, 1, preRelease: "b")!.isPatchRelease)
        #expect(SemanticVersion(0, 0, 1, build: "b")!.isPatchRelease)
        #expect(SemanticVersion(0, 0, 1, preRelease: "a", build: "b")!.isPatchRelease)
        
        #expect(!SemanticVersion(0, 1, 0).isPatchRelease)
        #expect(!SemanticVersion(0, 1, 0, preRelease: "b")!.isPatchRelease)
        
        #expect(SemanticVersion(0, 1, 1).isPatchRelease)
        #expect(!SemanticVersion(0, 0, 0).isPatchRelease)
    }
    
    @Test func isPreRelease() async {
        #expect(!SemanticVersion(1, 0, 0).isPreRelease)
        #expect(!SemanticVersion(1, 0, 0, build: "a")!.isPreRelease)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a")!.isPreRelease)
        #expect(SemanticVersion(1, 0, 0, preRelease: "a", build: "b")!.isPreRelease)
    }
	
    @Test func isInitialRelease() async {
        #expect(SemanticVersion(0, 0, 0).isInitialRelease)
        #expect(!SemanticVersion(0, 0, 1).isInitialRelease)
        #expect(!SemanticVersion(0, 1, 0).isInitialRelease)
        #expect(!SemanticVersion(1, 0, 0).isInitialRelease)
    }
    
    @Test func isZero() async {
        #expect(SemanticVersion(0, 0, 0).isZero)
        #expect(!SemanticVersion(0, 0, 1).isZero)
        #expect(!SemanticVersion(0, 1, 0).isZero)
        #expect(!SemanticVersion(1, 0, 0).isZero)
    }
    
    // extra
	
    @Test func testNonStrict() async {
        #expect(SemanticVersion(nonStrict: "0")! == SemanticVersion(0, 0, 0))
        #expect(SemanticVersion(nonStrict: "0.2")! == SemanticVersion(0, 2, 0))
        #expect(SemanticVersion(nonStrict: "0.2.0")! == SemanticVersion(0, 2, 0))
        #expect(SemanticVersion(nonStrict: "0.2.0-alpha1")! == SemanticVersion(0, 2, 0, preRelease: "alpha1")!)
        #expect(SemanticVersion(nonStrict: "1")! == SemanticVersion(1, 0, 0))
        #expect(SemanticVersion(nonStrict: "1.2")! == SemanticVersion(1, 2, 0))
        
        // with leading v
        #expect(SemanticVersion(nonStrict: "v0")! == SemanticVersion(0, 0, 0))
        #expect(SemanticVersion(nonStrict: "v0.2")! == SemanticVersion(0, 2, 0))
        #expect(SemanticVersion(nonStrict: "v0.2.0")! == SemanticVersion(0, 2, 0))
        #expect(SemanticVersion(nonStrict: "v0.2.0-alpha1")! == SemanticVersion(0, 2, 0, preRelease: "alpha1")!)
        #expect(SemanticVersion(nonStrict: "v1")! == SemanticVersion(1, 0, 0))
        #expect(SemanticVersion(nonStrict: "v1.2")! == SemanticVersion(1, 2, 0))
        
        // edge cases
        #expect(SemanticVersion(nonStrict: "") == nil)
        #expect(SemanticVersion(nonStrict: "string") == nil)
        #expect(SemanticVersion(nonStrict: ".1") == nil)
        #expect(SemanticVersion(nonStrict: "A") == nil)
        #expect(SemanticVersion(nonStrict: "A.1") == nil)
        #expect(SemanticVersion(nonStrict: "1.A") == nil)
        #expect(SemanticVersion(nonStrict: "-1") == nil)
        #expect(SemanticVersion(nonStrict: "-1.2") == nil)
        #expect(SemanticVersion(nonStrict: "-1.2.3") == nil)
        #expect(SemanticVersion(nonStrict: "1.-2.3") == nil)
    }
	
    @Test func testCodableA() async throws {
        let sv = try #require(SemanticVersion("1.0.25"))
		
        // set up JSON coders with default settings
		
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
		
        // encode
		
        let encoded = try encoder.encode(sv)
        
        // ensure value is being stored as a string, and not multiple integers etc.
		
        #expect(String(data: encoded, encoding: .utf8) == #""1.0.25""#)
		
        // decode
		
        let decoded = try decoder.decode(
            SemanticVersion.self,
            from: encoded
        )
        
        // compare original to reconstructed
		
        #expect(sv == decoded)
		
        #expect(sv.major == 1)
        #expect(sv.minor == 0)
        #expect(sv.patch == 25)
        #expect(sv.rawValue == "1.0.25")
    }
    
    @Test func testCodableB() async throws {
        let sv = try #require(SemanticVersion("1.2.3-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay"))
        
        // set up JSON coders with default settings
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // encode
        
        let encoded = try encoder.encode(sv)
        
        // ensure value is being stored as a string, and not multiple integers etc.
        
        #expect(String(data: encoded, encoding: .utf8) == #""1.2.3-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay""#)
        
        // decode
        
        let decoded = try decoder.decode(
            SemanticVersion.self,
            from: encoded
        )
        
        // compare original to reconstructed
        
        #expect(sv == decoded)
        
        #expect(sv.major == 1)
        #expect(sv.minor == 2)
        #expect(sv.patch == 3)
        #expect(sv.preRelease == "alpha-a.b-c-somethinglong")
        #expect(sv.build == "build.1-aef.1-its-okay")
        #expect(sv.rawValue == "1.2.3-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay")
    }
}

#endif
