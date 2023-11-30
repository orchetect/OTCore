//
//  XMLNode Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import XCTest
@testable import OTCore

final class Extensions_Foundation_XMLNode_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testXMLNode_XMLLoad() throws {
        let xmlOptions: XMLNode.Options = [.nodePrettyPrint, .nodeCompactEmptyElement]
        guard let data = testXML.toData()
        else { XCTFail(); return }
        let loadxml = try XMLDocument(data: data, options: xmlOptions)
        
        let root = loadxml.rootElement()
        let setup = root?.children?
            .asElements()
            .filter(whereAttribute: "name", hasValue: "Setup")
            .first
        
        XCTAssertEqual(setup?.childCount, 14)
    }
    
    func testCollection_XMLNode_FilterElementName() {
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
        XCTAssertEqual(filtered1[0], nodes[1])
        
        let filtered2 = nodes.filter(whereNodeNamed: "DoesNotExist")
        XCTAssertEqual(filtered2, [])
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
        XCTAssertEqual(filtered[0], nodes[2])
        
        filtered = nodes.filter(whereAttribute: "name") { $0 == "name4" }
        XCTAssertEqual(filtered[0], nodes[3])
        
        filtered = nodes.filter(whereAttribute: "class") { $0.hasSuffix("B") }
        XCTAssertEqual(filtered, [nodes[2], nodes[3]])
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

fileprivate let testXML = """
    <?xml version="1.0" encoding="utf-8"?>
    <tracklist2>
       <list name="track" type="obj">
          <obj class="MMarkerTrackEvent" ID="140320982296080">
             <int name="Flags" value="1"/>
             <float name="Start" value="0"/>
             <float name="Length" value="276276.0030000000260770320892333984375"/>
             <obj class="MListNode" name="Node" ID="140320982296384">
                <string name="Name" value="Cues" wide="true"/>
                <member name="Domain">
                   <int name="Type" value="0"/>
                   <obj class="MTempoTrackEvent" name="Tempo Track" ID="140320982295760">
                      <list name="TempoEvent" type="obj">
                         <obj class="MTempoEvent" ID="105553228726608">
                            <float name="BPM" value="115"/>
                            <float name="PPQ" value="0"/>
                         </obj>
                      </list>
                      <float name="RehearsalTempo" value="120"/>
                      <member name="Additional Attributes">
                         <int name="TTlB" value="80"/>
                         <int name="TTuB" value="200"/>
                         <int name="TLID" value="1"/>
                         <obj class="MTrackVariationCollection" name="TVCi" ID="105553136897840">
                            <int name="ownership" value="2"/>
                            <list name="obj" type="obj">
                               <obj class="MTrackVariation" ID="105553147636160">
                                  <string name="name" value="v1" wide="true"/>
                                  <int name="variationID" value="0"/>
                               </obj>
                            </list>
                         </obj>
                         <int name="Lock" value="0"/>
                         <int name="Eths" value="-260498236"/>
                      </member>
                   </obj>
                   <obj class="MSignatureTrackEvent" name="Signature Track" ID="140320982295168">
                      <list name="SignatureEvent" type="obj">
                         <obj class="MTimeSignatureEvent" ID="105553221146240">
                            <int name="Flags" value="8"/>
                            <float name="Start" value="0"/>
                            <float name="Length" value="1"/>
                            <int name="Bar" value="0"/>
                            <int name="Numerator" value="4"/>
                            <int name="Denominator" value="4"/>
                            <int name="Position" value="0"/>
                         </obj>
                      </list>
                      <member name="Additional Attributes">
                         <int name="TLID" value="1"/>
                         <int name="LocS" value="0"/>
                         <obj class="MTrackVariationCollection" name="TVCi" ID="105553136897600">
                            <int name="ownership" value="2"/>
                            <list name="obj" type="obj">
                               <obj class="MTrackVariation" ID="105553147633856">
                                  <string name="name" value="v1" wide="true"/>
                                  <int name="variationID" value="0"/>
                               </obj>
                            </list>
                         </obj>
                         <int name="Eths" value="-260498236"/>
                      </member>
                   </obj>
                </member>
                <list name="Events" type="obj">
                   <obj class="MRangeMarkerEvent" ID="105553163661184">
                      <float name="Start" value="1920"/>
                      <float name="Length" value="1920"/>
                      <member name="Additional Attributes">
                         <member name="tAMA">
                         </member>
                      </member>
                      <string name="Name" value="Cycle Marker Name 1" wide="true"/>
                      <int name="ID" value="1"/>
                   </obj>
                </list>
             </obj>
             <member name="Additional Attributes">
                <int name="Eths" value="-260498236"/>
             </member>
             <obj class="MTrack" name="Track Device" ID="105553182997024">
                <int name="Connection Type" value="2"/>
             </obj>
          </obj>
          <obj class="MMarkerTrackEvent" ID="140320982296656">
             <int name="Flags" value="1"/>
             <float name="Start" value="0"/>
             <float name="Length" value="276276.0030000000260770320892333984375"/>
             <obj class="MListNode" name="Node" ID="140320982296960">
                <string name="Name" value="Stems" wide="true"/>
                <member name="Domain">
                   <int name="Type" value="0"/>
                   <obj name="Tempo Track" ID="140320982295760"/>
                   <obj name="Signature Track" ID="140320982295168"/>
                </member>
                <list name="Events" type="obj">
                   <obj class="MRangeMarkerEvent" ID="105553233363328">
                      <float name="Start" value="3840"/>
                      <float name="Length" value="1920"/>
                      <member name="Additional Attributes">
                         <member name="tAMA">
                         </member>
                      </member>
                      <string name="Name" value="Cycle Marker Name 2" wide="true"/>
                      <int name="ID" value="1"/>
                   </obj>
                </list>
             </obj>
             <member name="Additional Attributes">
                <int name="TLID" value="1"/>
                <int name="Eths" value="-260498236"/>
             </member>
             <obj class="MTrack" name="Track Device" ID="105553182997264">
                <int name="Connection Type" value="2"/>
             </obj>
          </obj>
          <obj class="MMarkerTrackEvent" ID="140320982297232">
             <int name="Flags" value="1"/>
             <float name="Start" value="0"/>
             <float name="Length" value="276276.0030000000260770320892333984375"/>
             <obj class="MListNode" name="Node" ID="140320982297536">
                <string name="Name" value="Markers" wide="true"/>
                <member name="Domain">
                   <int name="Type" value="0"/>
                   <obj name="Tempo Track" ID="140320982295760"/>
                   <obj name="Signature Track" ID="140320982295168"/>
                </member>
                <list name="Events" type="obj">
                   <obj class="MMarkerEvent" ID="105553233326336">
                      <float name="Start" value="528"/>
                      <float name="Length" value="0"/>
                      <member name="Additional Attributes">
                         <member name="tAMA">
                         </member>
                      </member>
                      <string name="Name" value="Marker at One Hour" wide="true"/>
                      <int name="ID" value="1"/>
                   </obj>
                </list>
             </obj>
             <member name="Additional Attributes">
                <int name="TLID" value="1"/>
                <int name="Eths" value="-260498236"/>
             </member>
             <obj class="MTrack" name="Track Device" ID="105553182996544">
                <int name="Connection Type" value="2"/>
             </obj>
          </obj>
       </list>
       <obj class="ExternalRouting" name="ExternalRouting" ID="105553210797376">
          <member name="Audio">
          </member>
       </obj>
       <obj class="PArrangeSetup" name="Setup" ID="140320710100576">
          <member name="Start">
             <float name="Time" value="3599.426086997986203641630709171295166015625"/>
             <member name="Domain">
                <int name="Type" value="1"/>
                <float name="Period" value="1"/>
             </member>
          </member>
          <member name="Length">
             <float name="Time" value="300.30000000000001136868377216160297393798828125"/>
             <member name="Domain">
                <int name="Type" value="1"/>
                <float name="Period" value="1"/>
             </member>
          </member>
          <int name="BarOffset" value="0"/>
          <int name="FrameType" value="12"/>
          <int name="TimeType" value="0"/>
          <float name="SampleRate" value="48000"/>
          <int name="SampleSize" value="24"/>
          <int name="SampleFormatSize" value="3"/>
          <int name="PanLaw" value="6"/>
          <int name="RecordFile" value="1"/>
          <member name="RecordFileType">
             <int name="MacType" value="1463899717"/>
             <string name="DosType" value="wav" wide="true"/>
             <string name="UnixType" value="wav" wide="true"/>
             <string name="Name" value="Broadcast Wave File" wide="true"/>
          </member>
          <int name="VolumeMax" value="1"/>
          <int name="HmtType" value="0"/>
          <int name="HmtDepth" value="100"/>
       </obj>
    </tracklist2>
    """

#endif
