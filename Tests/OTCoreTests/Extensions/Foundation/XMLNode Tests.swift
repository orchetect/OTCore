//
//  XMLNode Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_XMLNode_Tests: XMLTestSuite {
    @Test
    func xmlLoad() throws {
        let loadxml = try Self.testXMLDocument()
        
        let root = loadxml.rootElement()
        let setup = root?.children?
            .asElements()
            .filter(whereAttribute: "name", hasValue: "Setup")
            .first
        
        #expect(setup?.childCount == 14)
    }
    
    @Test
    func collection_FilterElementName() {
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
        #expect(filtered1[position: 0] == nodes[1])
        
        let filtered2 = nodes.filter(whereNodeNamed: "DoesNotExist")
        #expect(filtered2.isEmpty)
    }
}

#endif
