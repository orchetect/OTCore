//
//  XMLElement Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import Foundation
@testable import OTCore
import Testing

@Suite struct Extensions_Foundation_XMLElement_Tests: XMLTestSuite {
    @Test
    func ancestors_notIncludingSelf() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let int = try Self.child(of: obj, named: "int")
        
        let ancestors = Array(int.ancestorElements(includingSelf: false))
        #expect(ancestors.count == 3)
        
        #expect(ancestors.map(\.name) == ["obj", "list", "tracklist2"])
    }
    
    @Test
    func ancestors_IncludingSelf() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let int = try Self.child(of: obj, named: "int")
        
        let ancestors = Array(int.ancestorElements(includingSelf: true))
        #expect(ancestors.count == 4)
        
        #expect(ancestors.map(\.name) == ["int", "obj", "list", "tracklist2"])
    }
    
    @Test
    func collection_XMLNode_FilterAttribute() throws {
        // prep
        
        let nodes = try [
            XMLElement(xmlString: "<obj class='classA' name='name1'/>"),
            XMLElement(xmlString: "<obj class='classA' name='name2'/>"),
            XMLElement(xmlString: "<obj class='classB' name='name3'/>"),
            XMLElement(xmlString: "<obj class='classB' name='name4'/>")
        ]
        
        // test
        
        var filtered = nodes.filter(whereAttribute: "name", hasValue: "name3")
        #expect(filtered[position: 0] == nodes[2])
        
        filtered = nodes.filter(whereAttribute: "name") { $0 == "name4" }
        #expect(filtered[position: 0] == nodes[3])
        
        filtered = nodes.filter(whereAttribute: "class") { $0.hasSuffix("B") }
        #expect(filtered[position: 0] == nodes[2])
        #expect(filtered[position: 1] == nodes[3])
    }
    
    @Test
    func collection_XMLNode_Lazy_FilterAttribute() throws {
        // prep
        
        let nodes = try [
            XMLElement(xmlString: "<obj class='classA' name='name1'/>"),
            XMLElement(xmlString: "<obj class='classA' name='name2'/>"),
            XMLElement(xmlString: "<obj class='classB' name='name3'/>"),
            XMLElement(xmlString: "<obj class='classB' name='name4'/>")
        ]
            .lazy
        
        // test
        
        var filtered = nodes.filter(whereAttribute: "name", hasValue: "name3")
        #expect(filtered[position: 0] == nodes[2])
        
        filtered = nodes.filter(whereAttribute: "name") { $0 == "name4" }
        #expect(filtered[position: 0] == nodes[3])
        
        filtered = nodes.filter(whereAttribute: "class") { $0.hasSuffix("B") }
        #expect(filtered[position: 0] == nodes[2])
        #expect(filtered[position: 1] == nodes[3])
    }
    
    @Test
    func firstWithAttribute() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let obj2 = try Self.child(of: obj, named: "obj")
        
        let (element, attrValue) = try #require(
            obj2.childElements.first(withAttribute: "type")
        )
        
        #expect(element.name == "list")
        #expect(attrValue == "obj")
    }
    
    @Test
    func firstWhereAnyAttribute() throws {
        let loadxml = try Self.testXMLDocument()
        
        let tracklist = try Self.child(of: loadxml, named: "tracklist2")
        let list = try Self.child(of: tracklist, named: "list")
        let obj = try Self.child(of: list, named: "obj")
        let obj2 = try Self.child(of: obj, named: "obj")
        
        let element = try #require(
            obj2.childElements.first(whereAnyAttribute: ["non-existent", "type"])
        )
        
        #expect(element.name == "list")
    }
    
    @Test
    func xmlElement_StringValueForAttribute() throws {
        let node = XMLNode(kind: .element)
        
        let attr = XMLNode(kind: .attribute)
        attr.name = "key1"
        attr.stringValue = "value1"
        (node as? XMLElement)?.addAttribute(attr)
        
        let element = try #require(node as? XMLElement)
        #expect(element.stringValue(forAttributeNamed: "key1") == "value1")
    }
    
    @Test
    func xmlElement_ObjectValueForAttribute() throws {
        let node = XMLNode(kind: .element)
        
        let attr = XMLNode(kind: .attribute)
        attr.name = "key1"
        attr.stringValue = "value1"
        (node as? XMLElement)?.addAttribute(attr)
        
        let element = try #require(node as? XMLElement)
        #expect(element.objectValue(forAttributeNamed: "key1") as? String == "value1")
    }
    
    @Test
    func xmlElement_AddAttributeWithNameValue() {
        let element = XMLElement(name: "test")
        
        element.addAttribute(withName: "key1", value: "value1")
        #expect(element.objectValue(forAttributeNamed: "key1") as? String == "value1")
        
        // remove attribute if `nil` value is passed
        element.addAttribute(withName: "key1", value: nil)
        #expect(element.objectValue(forAttributeNamed: "key1") == nil)
    }
    
    @Test
    func xmlElement_GetBool() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "1"),
            ("key2", "0"),
            ("key3", "true"),
            ("key4", "false"),
            ("key5", "not-a-bool")
        ])
        
        #expect(element.getBool(forAttribute: "key1") == true)
        #expect(element.getBool(forAttribute: "key2") == false)
        #expect(element.getBool(forAttribute: "key3") == true)
        #expect(element.getBool(forAttribute: "key4") == false)
        #expect(element.getBool(forAttribute: "key5") == nil)
    }
    
    @Test
    func xmlElement_SetBool() {
        let element = XMLElement(name: "testname")
        
        element.set(bool: true, forAttribute: "key1", useInt: false)
        #expect(element.stringValue(forAttributeNamed: "key1") == "true")
        
        element.set(bool: false, forAttribute: "key1", useInt: false)
        #expect(element.stringValue(forAttributeNamed: "key1") == "false")
        
        element.set(bool: true, forAttribute: "key1", useInt: true)
        #expect(element.stringValue(forAttributeNamed: "key1") == "1")
        
        element.set(bool: false, forAttribute: "key1", useInt: true)
        #expect(element.stringValue(forAttributeNamed: "key1") == "0")
        
        element.set(bool: nil, forAttribute: "key1", useInt: false)
        #expect(element.stringValue(forAttributeNamed: "key1") == nil)
    }
    
    @Test
    func xmlElement_SetBool_removeIfDefault() {
        let element = XMLElement(name: "testname")
        
        // default true
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: false,
            useInt: false
        )
        #expect(element.stringValue(forAttributeNamed: "key1") == "true")
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: true,
            useInt: false
        )
        #expect(element.stringValue(forAttributeNamed: "key1") == nil)
        
        // default false
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: false,
            removeIfDefault: false,
            useInt: false
        )
        #expect(element.stringValue(forAttributeNamed: "key1") == "true")
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: false,
            removeIfDefault: true,
            useInt: false
        )
        #expect(element.stringValue(forAttributeNamed: "key1") == "true")
        
        // useInt: true
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: false,
            useInt: true
        )
        #expect(element.stringValue(forAttributeNamed: "key1") == "1")
        
        element.set(
            bool: true,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: true,
            useInt: true
        )
        #expect(element.stringValue(forAttributeNamed: "key1") == nil)
        
        // set nil
        
        element.set(
            bool: nil,
            forAttribute: "key1",
            defaultValue: true,
            removeIfDefault: false,
            useInt: false
        )
        #expect(element.stringValue(forAttributeNamed: "key1") == nil)
    }
    
    @Test
    func xmlElement_GetInt() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "0"),
            ("key2", "1"),
            ("key3", "123"),
            ("key4", "-10"),
            ("key5", "123.5"),
            ("key6", "not-an-int")
        ])
        
        #expect(element.getInt(forAttribute: "key1") == 0)
        #expect(element.getInt(forAttribute: "key2") == 1)
        #expect(element.getInt(forAttribute: "key3") == 123)
        #expect(element.getInt(forAttribute: "key4") == -10)
        #expect(element.getInt(forAttribute: "key5") == nil)
        #expect(element.getInt(forAttribute: "key6") == nil)
    }
    
    @Test
    func xmlElement_SetInt() {
        let element = XMLElement(name: "testname")
        
        element.set(int: 0, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == "0")
        
        element.set(int: 1, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == "1")
        
        element.set(int: 123, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == "123")
        
        element.set(int: -10, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == "-10")
        
        element.set(int: nil, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == nil)
    }
    
    @Test
    func xmlElement_GetURL() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "file:///Users/user/Desktop/"),
            ("key2", "https://www.google.com"),
            ("key3", "not-a-URL")
        ])
        
        #expect(element.getURL(forAttribute: "key1") == URL(string: "file:///Users/user/Desktop/")!)
        #expect(element.getURL(forAttribute: "key2") == URL(string: "https://www.google.com")!)
        #expect(element.getURL(forAttribute: "key3") == URL(string: "not-a-URL")!) // uh... okay.
    }
    
    @Test
    func xmlElement_SetURL() {
        let element = XMLElement(name: "testname")
        
        element.set(url: URL(string: "file:///Users/user/Desktop/")!, forAttribute: "key1")
        #expect(
            element.stringValue(forAttributeNamed: "key1")
                == "file:///Users/user/Desktop/"
        )
        
        element.set(url: URL(string: "https://www.google.com")!, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == "https://www.google.com")
        
        element.set(url: URL(string: "not-a-URL")!, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == "not-a-URL") // uh... okay.
        
        element.set(url: nil, forAttribute: "key1")
        #expect(element.stringValue(forAttributeNamed: "key1") == nil)
    }
    
    @Test
    func addChildren() {
        let element = XMLElement(name: "testname")
        
        #expect(element.childCount == 0)
        
        let child1 = XMLElement(name: "child1", attributes: [("value", "123")])
        let child2 = XMLElement(name: "child2", attributes: [("value", "456")])
        
        element.addChildren([child1, child2])
        
        #expect(element.childCount == 2)
        
        #expect(element.child(at: 0) == child1)
        #expect(element.child(at: 0)?.name == "child1")
        
        #expect(element.child(at: 1) == child2)
        #expect(element.child(at: 1)?.name == "child2")
    }
    
    @Test
    func removeChildren_WherePredicate() {
        let element = XMLElement(name: "testname")
        
        let child1 = XMLElement(name: "child1", attributes: [("value", "123")])
        let child2 = XMLElement(name: "child2", attributes: [("value", "456")])
        let child3 = XMLElement(name: "child3", attributes: [("value", "789")])
        element.addChild(child1)
        element.addChild(child2)
        element.addChild(child3)
        
        #expect(element.childCount == 3)
        
        element.removeChildren { child in
            [1, 3].contains(child.name!.suffix(1).int!)
        }
        
        #expect(element.childCount == 1)
        
        #expect(element.child(at: 0) == child2)
    }
    
    @Test
    func removeAllChildren() {
        let element = XMLElement(name: "testname")
        
        let child1 = XMLElement(name: "child1", attributes: [("value", "123")])
        let child2 = XMLElement(name: "child2", attributes: [("value", "456")])
        let child3 = XMLElement(name: "child3", attributes: [("value", "789")])
        element.addChild(child1)
        element.addChild(child2)
        element.addChild(child3)
        
        #expect(element.childCount == 3)
        
        element.removeAllChildren()
        
        #expect(element.childCount == 0)
    }
    
    @Test
    func xmlElement_InitNameAttributes() {
        let element = XMLElement(name: "testname", attributes: [
            ("key1", "value1"),
            ("key2", "value2")
        ])
        
        #expect(element.name == "testname")
        
        #expect(element.attributes?.count == 2)
        
        #expect(element.attributes?[0].name == "key1")
        #expect(element.attributes?[0].stringValue == "value1")
        
        #expect(element.attributes?[1].name == "key2")
        #expect(element.attributes?[1].stringValue == "value2")
    }
}

#endif
