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
    
    func testAncestors_notIncludingSelf() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let int = try Self.child(of: obj, named: "int")
        
        let ancestors = Array(int.ancestorElements(includingSelf: false))
        XCTAssertEqual(ancestors.count, 3)
        
        XCTAssertEqual(ancestors.map(\.name), ["obj", "list", "tracklist2"])
    }
    
    func testAncestors_IncludingSelf() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let int = try Self.child(of: obj, named: "int")
        
        let ancestors = Array(int.ancestorElements(includingSelf: true))
        XCTAssertEqual(ancestors.count, 4)
        
        XCTAssertEqual(ancestors.map(\.name), ["int", "obj", "list", "tracklist2"])
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
    
    func testFirstWithAttribute() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let obj2 = try Self.child(of: obj, named: "obj")
        
        let (element, attrValue) = try XCTUnwrap(
            obj2.childElements.first(withAttribute: "type")
        )
        
        XCTAssertEqual(element.name, "list")
        XCTAssertEqual(attrValue, "obj")
    }
    
    func testFirstWithAnyAttribute() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let obj2 = try Self.child(of: obj, named: "obj")
        
        let element = try XCTUnwrap(
            obj2.childElements.first(withAnyAttribute: ["non-existent", "type"])
        )
        
        XCTAssertEqual(element.name, "list")
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
    
    func testXMLElement_AddAttributeWithNameValue() {
        let element = XMLElement(name: "test")
        
        element.addAttribute(withName: "key1", value: "value1")
        XCTAssertEqual(element.objectValue(forAttributeNamed: "key1") as? String, "value1")
        
        // remove attribute if `nil` value is passed
        element.addAttribute(withName: "key1", value: nil)
        XCTAssertNil(element.objectValue(forAttributeNamed: "key1"))
    }
    
    func testXMLElement_GetBool() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "1"),
            ("key2", "0"),
            ("key3", "true"),
            ("key4", "false"),
            ("key5", "not-a-bool")
        ])
        
        XCTAssertEqual(element.getBool(forAttribute: "key1"), true)
        XCTAssertEqual(element.getBool(forAttribute: "key2"), false)
        XCTAssertEqual(element.getBool(forAttribute: "key3"), true)
        XCTAssertEqual(element.getBool(forAttribute: "key4"), false)
        XCTAssertEqual(element.getBool(forAttribute: "key5"), nil)
    }
    
    func testXMLElement_SetBool() {
        let element = XMLElement(name: "testname")
        
        element.set(bool: true, forAttribute: "key1", useInt: false)
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "true")
        
        element.set(bool: false, forAttribute: "key1", useInt: false)
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "false")
        
        element.set(bool: true, forAttribute: "key1", useInt: true)
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "1")
        
        element.set(bool: false, forAttribute: "key1", useInt: true)
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "0")
        
        element.set(bool: nil, forAttribute: "key1", useInt: false)
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), nil)
    }
    
    func testXMLElement_SetBool_removeIfDefault() {
        let element = XMLElement(name: "testname")
        
        // default true
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: false,
            useInt: false
        )
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "true")
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: true,
            useInt: false
        )
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), nil)
        
        // default false
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: false,
            removeIfDefault: false,
            useInt: false
        )
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "true")
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: false,
            removeIfDefault: true,
            useInt: false
        )
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "true")
        
        // useInt: true
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: false,
            useInt: true
        )
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "1")
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: true,
            useInt: true
        )
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), nil)
        
        // set nil
        
        element.set(
            bool: nil,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: false,
            useInt: false
        )
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), nil)
    }
    
    func testXMLElement_GetInt() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "0"),
            ("key2", "1"),
            ("key3", "123"),
            ("key4", "-10"),
            ("key5", "123.5"),
            ("key6", "not-an-int")
        ])
        
        XCTAssertEqual(element.getInt(forAttribute: "key1"), 0)
        XCTAssertEqual(element.getInt(forAttribute: "key2"), 1)
        XCTAssertEqual(element.getInt(forAttribute: "key3"), 123)
        XCTAssertEqual(element.getInt(forAttribute: "key4"), -10)
        XCTAssertEqual(element.getInt(forAttribute: "key5"), nil)
        XCTAssertEqual(element.getInt(forAttribute: "key6"), nil)
    }
    
    func testXMLElement_SetInt() {
        let element = XMLElement(name: "testname")
        
        element.set(int: 0, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "0")
        
        element.set(int: 1, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "1")
        
        element.set(int: 123, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "123")
        
        element.set(int: -10, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "-10")
        
        element.set(int: nil, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), nil)
    }
    
    func testXMLElement_GetURL() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "file:///Users/user/Desktop/"),
            ("key2", "https://www.google.com"),
            ("key3", "not-a-URL")
        ])
        
        XCTAssertEqual(element.getURL(forAttribute: "key1"), URL(string: "file:///Users/user/Desktop/")!)
        XCTAssertEqual(element.getURL(forAttribute: "key2"), URL(string: "https://www.google.com")!)
        XCTAssertEqual(element.getURL(forAttribute: "key3"), URL(string: "not-a-URL")!) // uh... okay.
    }
    
    func testXMLElement_SetURL() {
        let element = XMLElement(name: "testname")
        
        element.set(url: URL(string: "file:///Users/user/Desktop/")!, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "file:///Users/user/Desktop/")
        
        element.set(url: URL(string: "https://www.google.com")!, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "https://www.google.com")
        
        element.set(url: URL(string: "not-a-URL")!, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), "not-a-URL") // uh... okay.
        
        element.set(url: nil, forAttribute: "key1")
        XCTAssertEqual(element.stringValue(forAttributeNamed: "key1"), nil)
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
