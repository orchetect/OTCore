//
//  XMLElement Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import XCTest
@testable import OTCore

final class Extensions_Foundation_XMLElement_Tests: XMLTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testAncestors() throws {
        let loadxml = try Self.testXMLDocument
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let int = try Self.child(of: obj, named: "int")
        
        let ancestors = Array(int.ancestorElements)
        XCTAssertEqual(ancestors.count, 3)
        dump(ancestors.map(\.name))
    }
    
    func testCollection_XMLNode_FilterAttribute() throws {
        // prep
        
        let nodes = [
            try XMLElement(xmlString: "<obj class='classA' name='name1'/>"),
            try XMLElement(xmlString: "<obj class='classA' name='name2'/>"),
            try XMLElement(xmlString: "<obj class='classB' name='name3'/>"),
            try XMLElement(xmlString: "<obj class='classB' name='name4'/>")
        ]
        
        // test
        
        var filtered = nodes.filter(whereAttribute: "name", hasValue: "name3")
        XCTAssertEqual(filtered[position: 0], nodes[2])
        
        filtered = nodes.filter(whereAttribute: "name") { $0 == "name4" }
        XCTAssertEqual(filtered[position: 0], nodes[3])
        
        filtered = nodes.filter(whereAttribute: "class") { $0.hasSuffix("B") }
        XCTAssertEqual(filtered[position: 0], nodes[2])
        XCTAssertEqual(filtered[position: 1], nodes[3])
    }
    
    func testCollection_XMLNode_Lazy_FilterAttribute() throws {
        // prep
        
        let nodes = [
            try XMLElement(xmlString: "<obj class='classA' name='name1'/>"),
            try XMLElement(xmlString: "<obj class='classA' name='name2'/>"),
            try XMLElement(xmlString: "<obj class='classB' name='name3'/>"),
            try XMLElement(xmlString: "<obj class='classB' name='name4'/>")
        ]
            .lazy
        
        // test
        
        var filtered = nodes.filter(whereAttribute: "name", hasValue: "name3")
        XCTAssertEqual(filtered[position: 0], nodes[2])
        
        filtered = nodes.filter(whereAttribute: "name") { $0 == "name4" }
        XCTAssertEqual(filtered[position: 0], nodes[3])
        
        filtered = nodes.filter(whereAttribute: "class") { $0.hasSuffix("B") }
        XCTAssertEqual(filtered[position: 0], nodes[2])
        XCTAssertEqual(filtered[position: 1], nodes[3])
    }
    
    func testXMLElement_StringValueForAttribute() throws {
        let node = XMLNode(kind: .element)
        
        let attr = XMLNode(kind: .attribute)
        attr.name = "key1"
        attr.stringValue = "value1"
        (node as? XMLElement)?.addAttribute(attr)
        
        let element = try XCTUnwrap(node as? XMLElement)
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "value1")
    }
    
    func testXMLElement_ObjectValueForAttribute() throws {
        let node = XMLNode(kind: .element)
        
        let attr = XMLNode(kind: .attribute)
        attr.name = "key1"
        attr.stringValue = "value1"
        (node as? XMLElement)?.addAttribute(attr)
        
        let element = try XCTUnwrap(node as? XMLElement)
        XCTAssertEqual(element.objectValue(forAttributeNamed: "key1") as? String, "value1")
    }
    
    func testXMLElement_AddAttributeWithNameValue() throws {
        let element = XMLElement(name: "test")
        
        element.addAttribute(withName: "key1", value: "value1")
        XCTAssertEqual(element.objectValue(forAttributeNamed: "key1") as? String, "value1")
        
        // remove attribute if `nil` value is passed
        element.addAttribute(withName: "key1", value: nil)
        XCTAssertNil(element.objectValue(forAttributeNamed: "key1"))
    }
    
    func testXMLElement_InitNameAttributes() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "value1"),
            ("key2", "value2")
        ])
        
        XCTAssertEqual(element.name, "testname")
        
        XCTAssertEqual(element.attributes?.count, 2)
        
        XCTAssertEqual(element.attributes?[0].name, "key1")
        XCTAssertEqual(element.attributes?[0].stringValue, "value1")
        
        XCTAssertEqual(element.attributes?[1].name, "key2")
        XCTAssertEqual(element.attributes?[1].stringValue, "value2")
    }
}

#endif
