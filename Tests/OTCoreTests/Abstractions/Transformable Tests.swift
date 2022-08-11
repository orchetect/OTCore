//
//  Transformable Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if shouldTestCurrentPlatform

#if canImport(UIKit)
import UIKit
#endif

#if canImport(WatchKit)
import WatchKit
#endif
    
import XCTest
import OTCore

class Abstractions_Transformable_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testValueBaseType_Transform() {
        var int = 123
        
        let newInt = int.transform { $0 *= 2 }
            .transformed { $0 + 2 }
        
        XCTAssertEqual(int, 246)
        XCTAssertEqual(newInt, 248)
    }
    
    func testValueBaseType_Transformed() {
        // emitting same type as self
        
        XCTAssertEqual(
            123.transformed { $0 * 2 },
            246
        )
        
        // emitting different type than self
        
        XCTAssertEqual(
            123.transformed { "\($0 * 2)" },
            "246"
        )
    }
    
    func testValueBaseType_Transform_Optional() {
        var int: Int? = 123
        
        let newInt = int.transformOptional { $0! *= 2 }?
            .transformed { $0 + 2 }
        
        XCTAssertEqual(int, 246)
        XCTAssertEqual(newInt, 248)
    }
    
    func testValueBaseType_Transformed_Optional() {
        // emitting same type as self
        
        let int: Int? = 123
        
        XCTAssertEqual(
            int.transformedOptional { $0! * 2 },
            246
        )
        
        // emitting different type than self
        
        XCTAssertEqual(
            int.transformedOptional { "\($0! * 2)" },
            "246"
        )
    }
    
    func testValueBaseType_Transformed_ImplicitlyUnwrappedOptional() {
        let int: Int! = 123
        
        XCTAssertEqual(
            int.transformed { $0 * 2 },
            246
        )
        
        XCTAssertEqual(
            int.transformedOptional { $0! * 2 },
            246
        )
    }
    
    func testValueBaseType_Transform_ImplicitlyUnwrappedOptional() {
        var int: Int! = 123
        
        let newInt = int.transform { $0 *= 2 }
            .transformed { $0 + 2 }
        
        XCTAssertEqual(int, 246)
        XCTAssertEqual(newInt, 248)
    }
    
    func testValueBaseType_VirginTypes() {
        // test origin type that don't conform to Equatable
        
        struct DummyStruct {
            var val = 123
        }
        
        // .transform
        
        do {
            // var s: DummyStruct = .init()
            
            // no conformance, so the method just doesn't exist
            // s.transform { _ = $0; return }
        }
        
        // .transformed
        
        do {
            // let s: DummyStruct = .init()
            
            // no conformance, so the method just doesn't exist
            // _ = s.transformed { String(describing: $0) }
        }
        
        // .transform - optional
        
        do {
            var s: DummyStruct? = .init()
            
            s.transform { $0?.val = 456 }
            
            // no conformance, so the method just doesn't exist
            // s?.transform { $0.val = 456 }
            
            XCTAssertEqual(s?.val, 456)
        }
        
        // .transformed - optional
        
        do {
            let s: DummyStruct? = .init()
            
            _ = s.transformed { String(describing: $0) }
                .transformed { $0 + "-" }
        }
    }
    
    func testReferenceBaseType_VirginTypes() {
        // test origin type that don't conform to Equatable
        
        class DummyClass {
            var val = 123
        }
        
        // .transform
        
        do {
            // var c: DummyClass = .init()
            
            // no conformance, so the method just doesn't exist
            // c.transform { $0.val = 456 }
        }
        
        // .transformed
        
        do {
            // let c: DummyClass = .init()
            
            // no conformance, so the method just doesn't exist
            // _ = c.transformed { String(describing: $0) }
        }
        
        // .transform - optional
        
        do {
            let c: DummyClass? = .init()
            
            c.transform { $0?.val = 345 }
            
            // no conformance, so the method just doesn't exist
            // c?.transform { $0.val = 456 }
            
            XCTAssertEqual(c?.val, 345)
        }
        
        // .transformed - optional
        
        do {
            let s: DummyClass? = .init()
            
            _ = s.transformed { "\(($0?.val ?? 0) + 2)" }
            
            // no conformance, so the method just doesn't exist
            // _ = s?.transformed { "\($0.val + 2)" }
            
            XCTAssertEqual(s?.val, 123) // not mutating
        }
    }
    
    func testValueBaseType_VirginTypes_Transformable() {
        // test origin type that don't conform to Equatable
        
        struct DummyStruct: Transformable {
            var val = 123
        }
        
        // .transform
        
        do {
            var s: DummyStruct = .init()
            
            s.transform { $0.val = 456 }
            
            XCTAssertEqual(s.val, 456)
        }
        
        // .transformed
        
        do {
            let s: DummyStruct = .init()
            
            _ = s.transformed { "\($0.val + 2)" }
            
            XCTAssertEqual(s.val, 123) // not mutating
        }
        
        // .transform - optional
        
        do {
            var s: DummyStruct? = .init()
            
            s.transform { $0?.val = 345 }
            s?.transform { $0.val = 456 }
            
            XCTAssertEqual(s?.val, 456)
        }
        
        // .transformed - optional
        
        do {
            let s: DummyStruct? = .init()
            
            _ = s.transformed { "\($0?.val ?? 0)" }
            _ = s?.transformed { "\($0.val + 2)" }
            
            XCTAssertEqual(s?.val, 123) // not mutating
        }
    }
    
    func testReferenceBaseType_VirginTypes_Transformable() {
        // test origin type that don't conform to Equatable
        
        final class DummyClass: Transformable {
            var val = 123
        }
        
        // .transform
        
        do {
            let c: DummyClass = .init()
            
            c
                .transform { $0.val = 234 }
                .transform { $0.val = 345 }
                .transform { $0.val = 456 }
            
            XCTAssertEqual(c.val, 456)
        }
        
        // .transformed
        
        do {
            let c: DummyClass = .init()
            
            _ = c.transformed { "\($0.val + 2)" }
            
            XCTAssertEqual(c.val, 123) // not mutating
        }
        
        // .transform - optional
        
        do {
            let c: DummyClass? = .init()
            
            c?
                .transform { $0.val = 234 }
                .transform { $0.val = 345 }
            c
                .transform { $0?.val = 400 }
                .transform { $0?.val = 456 }
            
            XCTAssertEqual(c?.val, 456)
        }
        
        // .transformed - optional
        
        do {
            let c: DummyClass? = .init()
            
            _ = c.transformed { "\($0?.val ?? 0)" }
            _ = c?.transformed { "\($0.val + 2)" }
            
            XCTAssertEqual(c?.val, 123) // not mutating
        }
    }
    
    func testVariousBaseTypes() {
        _ = 123.transformed { "\($0)" }
        _ = UInt32(123).transformed { "\($0)" }
        _ = "string".transformed { "\($0)" }
        _ = NSObject().transformed { "\($0)" }
        _ = CGPoint(x: 5, y: 8).transformed { "\($0)" }
        
        _ = Optional(123).transformedOptional { "\(String(describing: $0))" }
        _ = Optional(UInt32(123)).transformedOptional { "\(String(describing: $0))" }
        _ = Optional("string").transformedOptional { "\(String(describing: $0))" }
        _ = Optional(NSObject()).transformedOptional { "\(String(describing: $0))" }
        // _ = Optional(CGPoint(x: 5, y: 8)).transformed { "\($0)" } // doesn't work
        
        _ = Optional(123)?.transformed { "\($0)" }
        _ = Optional(UInt32(123))?.transformed { "\($0)" }
        _ = Optional("string")?.transformed { "\($0)" }
        _ = Optional(NSObject())?.transformed { "\($0)" }
        _ = Optional(CGPoint(x: 5, y: 8))?.transformed { "\($0)" }
    }
    
    func testPlatforms_Transform() {
        // all platforms
        
        let nsMAttrString = NSMutableAttributedString()
        
        nsMAttrString
            .transform { $0.mutableString.setString("new string 1") }
            .transform { $0.mutableString.setString("new string 2") }
        
        XCTAssertEqual(nsMAttrString.string, "new string 2")
        
        // individual platforms
        
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        
        let nsButton = NSButton() // root class: NSObject
        
        nsButton
            .transform { $0.title = "title" }
            .transform { $0.title = "new title" }
        
        XCTAssertEqual(nsButton.title, "new title")
        
        #elseif canImport(UIKit) && !os(watchOS)
        
        let uiButton = UIButton() // root class: NSObject
        
        uiButton.transform {
            $0.setTitle("title", for: .normal)
            $0.setTitleColor(.blue, for: .normal)
        }.transform {
            $0.setTitle("new title", for: .normal)
        }
        
        let uiButtonTitle = uiButton
            .transformed { $0.currentTitle }?
            .transformed { $0.uppercased() }
        
        XCTAssertEqual(uiButtonTitle, "NEW TITLE")
        
        #elseif os(watchOS)
        
        let wkButton = WKImage(imageName: "")
        _ = wkButton.transform {
            _ = $0.imageName
        }.transformed {
            $0.imageName ?? "nil"
        }
        
        #endif
    }
}

#endif
