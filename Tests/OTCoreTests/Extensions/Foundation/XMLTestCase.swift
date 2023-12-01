//
//  XMLTestCase.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// This is Mac-only because even though XMLNode exists in Foundation, it is only available on macOS
#if os(macOS)

import XCTest
@testable import OTCore

class XMLTestCase: XCTestCase {
    static func child(of node: XMLNode, named: String) throws -> XMLElement {
        let child = node.children?
            .lazy
            .compactMap(\.asElement)
            .first(where: { $0.name == named })
        let unwrapped = try XCTUnwrap(child)
        return unwrapped
    }
    
    static func testXMLDocument() throws -> XMLDocument {
        try XMLDocument(
            data: testXMLStringData,
            options: [.nodePrettyPrint, .nodeCompactEmptyElement]
        )
    }
    static let testXMLStringData = testXMLString.toData()!
    static let testXMLString = """
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
}

#endif
