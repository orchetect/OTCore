//
//  XMLNode Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import XCTest
@testable import OTCore

final class Extensions_Foundation_XMLNode_Tests: XMLTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testXMLLoad() throws {
        let loadxml = try Self.testXMLDocument()
        
        let root = loadxml.rootElement()
        let setup = root?.children?
            .asElements()
            .filter(whereAttribute: "name", hasValue: "Setup")
            .first
        
        XCTAssertEqual(setup?.childCount, 14)
    }
    
    func testCollection_FilterElementName() {
        // prep
        
        let nodes = [
            XMLNode(kind: .element),
            XMLNode(kind: .element),
            XMLNode(kind: .element),
            XMLNode(kind: .element)
        ]
        
        nodes[0].name = "list1A"
        nodes[1].name = "list1B"
        nodes[2].name = "list2"
        nodes[3].name = "obj"
        
        // test
        
        let filtered1 = nodes.filter(whereNodeNamed: "list1B")
        XCTAssertEqual(filtered1[position: 0], nodes[1])
        
        let filtered2 = nodes.filter(whereNodeNamed: "DoesNotExist")
        XCTAssert(filtered2.isEmpty)
    }
}

#endif
