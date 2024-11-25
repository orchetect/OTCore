//
//  Concurrency Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OTCore

@available(macOS 10.15, iOS 13.0.0, watchOS 6.0, tvOS 13.0, *)
final class Extensions_Swift_Concurrency_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testWithOrderedTaskGroup() async {
        let input = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        
        let output: [String] = await withOrderedTaskGroup(sequence: input) { element in
            usleep(UInt32.random(in: 1 ... 10) * 1000)
            return element
        }
        
        XCTAssertEqual(input, output)
    }
}
