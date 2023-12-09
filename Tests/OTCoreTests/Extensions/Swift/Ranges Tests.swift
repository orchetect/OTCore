//
//  Ranges Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OTCore

class Extensions_Swift_Ranges_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testIsContained_InRange() {
        // int
        
        XCTAssertEqual(0.isContained(in: 1 ... 4), false)
        XCTAssertEqual(1.isContained(in: 1 ... 4), true)
        XCTAssertEqual(2.isContained(in: 1 ... 4), true)
        XCTAssertEqual(4.isContained(in: 1 ... 4), true)
        XCTAssertEqual(5.isContained(in: 1 ... 4), false)
        
        XCTAssertEqual(0.isContained(in: 1 ..< 4), false)
        XCTAssertEqual(1.isContained(in: 1 ..< 4), true)
        XCTAssertEqual(2.isContained(in: 1 ..< 4), true)
        XCTAssertEqual(4.isContained(in: 1 ..< 4), false)
        XCTAssertEqual(5.isContained(in: 1 ..< 4), false)
        
        XCTAssertEqual(0.isContained(in: 1...), false)
        XCTAssertEqual(1.isContained(in: 1...), true)
        XCTAssertEqual(2.isContained(in: 1...), true)
        
        XCTAssertEqual(0.isContained(in: ...2), true)
        XCTAssertEqual(1.isContained(in: ...2), true)
        XCTAssertEqual(2.isContained(in: ...2), true)
        XCTAssertEqual(3.isContained(in: ...2), false)
        
        XCTAssertEqual(0.isContained(in: ..<2), true)
        XCTAssertEqual(1.isContained(in: ..<2), true)
        XCTAssertEqual(2.isContained(in: ..<2), false)
        XCTAssertEqual(3.isContained(in: ..<2), false)
        
        // floating point
        
        XCTAssertEqual(0.0.isContained(in: 1.0 ... 4.0), false)
        XCTAssertEqual(1.0.isContained(in: 1.0 ... 4.0), true)
        XCTAssertEqual(2.0.isContained(in: 1.0 ... 4.0), true)
        XCTAssertEqual(4.0.isContained(in: 1.0 ... 4.0), true)
        XCTAssertEqual(5.0.isContained(in: 1.0 ... 4.0), false)
        
        XCTAssertEqual(0.0.isContained(in: 1.0 ..< 4.0), false)
        XCTAssertEqual(1.0.isContained(in: 1.0 ..< 4.0), true)
        XCTAssertEqual(2.0.isContained(in: 1.0 ..< 4.0), true)
        XCTAssertEqual(4.0.isContained(in: 1.0 ..< 4.0), false)
        XCTAssertEqual(5.0.isContained(in: 1.0 ..< 4.0), false)
        
        XCTAssertEqual(0.0.isContained(in: 1.0...), false)
        XCTAssertEqual(1.0.isContained(in: 1.0...), true)
        XCTAssertEqual(2.0.isContained(in: 1.0...), true)
        
        XCTAssertEqual(0.0.isContained(in: ...2.0), true)
        XCTAssertEqual(1.0.isContained(in: ...2.0), true)
        XCTAssertEqual(2.0.isContained(in: ...2.0), true)
        XCTAssertEqual(3.0.isContained(in: ...2.0), false)
        
        XCTAssertEqual(0.0.isContained(in: ..<2.0), true)
        XCTAssertEqual(1.0.isContained(in: ..<2.0), true)
        XCTAssertEqual(2.0.isContained(in: ..<2.0), false)
        XCTAssertEqual(3.0.isContained(in: ..<2.0), false)
        
        // other Comparable, such as String:
        
        XCTAssertEqual("c".isContained(in: "a" ... "d"), true)
        XCTAssertEqual("e".isContained(in: "a" ... "d"), false)
    }
    
    func testClosedRange_contains_ClosedRange() {
        XCTAssertTrue((1 ... 10).contains(1 ...  1))
        XCTAssertTrue((1 ... 10).contains(3 ... 7))
        XCTAssertTrue((1 ... 10).contains(1 ... 10))
        XCTAssertTrue((1 ... 10).contains(10 ... 10))
        
        XCTAssertFalse((1 ... 10).contains(0 ...  0))
        XCTAssertFalse((1 ... 10).contains(0 ...  1))
        XCTAssertFalse((1 ... 10).contains(0 ...  2))
        XCTAssertFalse((1 ... 10).contains(0 ... 10))
        XCTAssertFalse((1 ... 10).contains(9 ... 11))
        XCTAssertFalse((1 ... 10).contains(10 ... 11))
        XCTAssertFalse((1 ... 10).contains(11 ... 11))
        
        XCTAssertFalse((1 ... 10).contains(-1 ...  1))
    }
    
    func testClosedRange_contains_Range() {
        XCTAssertFalse((1 ... 10).contains(1 ..<  1)) // empty, but in range
        XCTAssertTrue((1 ... 10).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((1 ... 10).contains(3 ..< 8)) // 3...7
        XCTAssertTrue((1 ... 10).contains(1 ..< 11)) // 1...10
        XCTAssertFalse((1 ... 10).contains(10 ..< 10)) // empty
        XCTAssertTrue((1 ... 10).contains(10 ..< 11)) // 10...10

        XCTAssertFalse((1 ... 10).contains(0 ..<  0)) // empty, out of range
        XCTAssertFalse((1 ... 10).contains(0 ..<  1)) // 0...0, out of range
        XCTAssertFalse((1 ... 10).contains(0 ..<  2)) // 0...1, lowerBound out of range
        XCTAssertFalse((1 ... 10).contains(0 ..< 10)) // 0...9, lowerBound out of range
        XCTAssertTrue((1 ... 10).contains(9 ..< 11)) // 9...10
        XCTAssertTrue((1 ... 10).contains(10 ..< 11)) // 10...10
        XCTAssertFalse((1 ... 10).contains(11 ..< 11)) // empty, out of range

        XCTAssertFalse((1 ... 10).contains(-1 ..< 1))
    }
    
    func testRange_contains_ClosedRange() {
        XCTAssertTrue((1 ..< 10).contains(1 ... 1))
        XCTAssertTrue((1 ..< 10).contains(3 ... 7))
        XCTAssertTrue((1 ..< 10).contains(1 ... 9))
        XCTAssertFalse((1 ..< 10).contains(1 ... 10))
        XCTAssertFalse((1 ..< 10).contains(10 ... 10))
        
        XCTAssertFalse((1 ..< 10).contains(0 ... 0))
        XCTAssertFalse((1 ..< 10).contains(0 ... 1))
        XCTAssertFalse((1 ..< 10).contains(0 ... 2))
        XCTAssertFalse((1 ..< 10).contains(0 ... 9))
        XCTAssertFalse((1 ..< 10).contains(0 ... 10))
        XCTAssertFalse((1 ..< 10).contains(9 ... 11))
        XCTAssertFalse((1 ..< 10).contains(10 ... 11))
        XCTAssertFalse((1 ..< 10).contains(11 ... 11))
        
        XCTAssertFalse((1 ..< 10).contains(-1 ... 1))
    }
    
    func testRange_contains_Range() {
        XCTAssertFalse((1 ..< 10).contains(1 ..< 1)) // empty
        XCTAssertTrue((1 ..< 10).contains(3 ..< 8)) // 3...7
        XCTAssertTrue((1 ..< 10).contains(1 ..< 10)) // identical
        XCTAssertFalse((1 ..< 10).contains(1 ..< 11)) // 1...10
        XCTAssertFalse((1 ..< 10).contains(10 ..< 10)) // empty
        XCTAssertFalse((1 ..< 10).contains(10 ..< 11)) // 10...10

        XCTAssertFalse((1 ..< 10).contains(0 ..< 0)) // empty, out of range
        XCTAssertFalse((1 ..< 10).contains(0 ..< 1)) // 0...0, out of range
        XCTAssertFalse((1 ..< 10).contains(0 ..< 2)) // 0...1, lowerBound out of range
        XCTAssertFalse((1 ..< 10).contains(0 ..< 10)) // 0...9, lowerBound out of range
        XCTAssertFalse((1 ..< 10).contains(9 ..< 11)) // 9...10
        XCTAssertFalse((1 ..< 10).contains(10 ..< 11)) // 10...10, out of range
        XCTAssertFalse((1 ..< 10).contains(11 ..< 12)) // 11...11, out of range
        XCTAssertFalse((1 ..< 10).contains(11 ..< 11)) // empty, out of range

        XCTAssertFalse((1 ..< 10).contains(-1 ..< 1))
        
        // edge cases
        
        XCTAssertTrue((Int.min ..< Int.max).contains(1 ..< 10))
        XCTAssertFalse((Int.max ..< Int.max).contains(1 ..< 10))
        XCTAssertTrue((Int.min ..< Int.max).contains(Int.min ..< Int.max))
        XCTAssertFalse((Int.max ..< Int.max).contains(Int.min ..< Int.max))
    }
    
    func testPartialRangeFrom_contains_ClosedRange() {
        XCTAssertTrue(((-1)...).contains(1 ... 10))
        XCTAssertTrue((0...).contains(1 ... 10))
        XCTAssertTrue((1...).contains(1 ... 10))
        XCTAssertFalse((2...).contains(1 ... 10))
        XCTAssertFalse((9...).contains(1 ... 10))
        XCTAssertFalse((10...).contains(1 ... 10))
        XCTAssertFalse((11...).contains(1 ... 10))
        
        // edge cases
        
        XCTAssertTrue((Int.min...).contains(1 ... 10))
        XCTAssertFalse((Int.max...).contains(1 ... 10))
        XCTAssertTrue((Int.min...).contains(Int.min ... Int.max))
        XCTAssertFalse((Int.max...).contains(Int.min ... Int.max))
    }
    
    func testPartialRangeFrom_contains_Range() {
        XCTAssertTrue(((-1)...).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((0...).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((1...).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((2...).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((9...).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((10...).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((11...).contains(1 ..< 10)) // 1...9
        
        // edge cases
        
        XCTAssertTrue((Int.min...).contains(1 ..< 10))
        XCTAssertFalse((Int.max...).contains(1 ..< 10))
        XCTAssertTrue((Int.min...).contains(Int.min ..< Int.max))
        XCTAssertFalse((Int.max...).contains(Int.min ..< Int.max))
    }
    
    func testPartialRangeFrom_contains_PartialRangeFrom() {
        XCTAssertFalse((1...).contains((-1)...))
        XCTAssertFalse((1...).contains(0...))
        XCTAssertTrue((1...).contains(1...))
        XCTAssertTrue((1...).contains(2...))
        
        // edge cases
        
        XCTAssertTrue((Int.min...).contains(1...))
        XCTAssertFalse((Int.max...).contains(1...))
        XCTAssertTrue((Int.min...).contains(Int.min...))
        XCTAssertFalse((Int.max...).contains(Int.min...))
        XCTAssertTrue((Int.max...).contains(Int.max...))
    }
    
    func testPartialRangeThrough_contains_ClosedRange() {
        XCTAssertTrue((...(-1)).contains(-10 ... -1))
        XCTAssertFalse((...(-1)).contains(1 ... 10))
        XCTAssertFalse((...0).contains(1 ... 10))
        XCTAssertFalse((...1).contains(1 ... 10))
        XCTAssertFalse((...2).contains(1 ... 10))
        XCTAssertFalse((...9).contains(1 ... 10))
        XCTAssertTrue((...10).contains(1 ... 10))
        XCTAssertTrue((...11).contains(1 ... 10))
        
        // edge cases
        
        XCTAssertFalse((...Int.min).contains(1 ... 10))
        XCTAssertTrue((...Int.max).contains(1 ... 10))
        XCTAssertTrue((...Int.min).contains(Int.min ... Int.min))
        XCTAssertFalse((...Int.min).contains(Int.min ... Int.max))
        XCTAssertTrue((...Int.max).contains(Int.min ... Int.max))
    }
    
    func testPartialRangeThrough_contains_Range() {
        XCTAssertTrue((...(-1)).contains(-10 ..< 0)) // -10 ... -1
        XCTAssertFalse((...(-1)).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((...0).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((...1).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((...2).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((...9).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((...10).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((...11).contains(1 ..< 10)) // 1...9
        
        // edge cases
        
        XCTAssertFalse((...Int.min).contains(1 ..< 10))
        XCTAssertTrue((...Int.max).contains(1 ..< 10))
        XCTAssertFalse((...Int.min).contains(Int.min ..< Int.min))
        XCTAssertFalse((...Int.min).contains(Int.min ..< Int.max))
        XCTAssertTrue((...Int.max).contains(Int.max ..< Int.max))
        XCTAssertTrue((...Int.max).contains(Int.min ..< Int.max))
    }

    func testPartialRangeThrough_contains_PartialRangeThrough() {
        XCTAssertFalse((...(-1)).contains(...1))
        XCTAssertFalse((...0).contains(...1))
        XCTAssertTrue((...1).contains(...1))
        XCTAssertTrue((...2).contains(...1))
        
        // edge cases
        
        XCTAssertFalse((...Int.min).contains(...1))
        XCTAssertTrue((...Int.max).contains(...1))
        XCTAssertTrue((...Int.min).contains(...Int.min))
        XCTAssertFalse((...Int.min).contains(...Int.max))
        XCTAssertTrue((...Int.max).contains(...Int.min))
        XCTAssertTrue((...Int.max).contains(...Int.max))
    }

    func testPartialRangeThrough_contains_PartialRangeUpTo() {
        XCTAssertFalse((...(-1)).contains(..<1))
        XCTAssertFalse((...0).contains(..<1))
        XCTAssertFalse((...1).contains(..<1))
        XCTAssertTrue((...2).contains(..<1))
        
        // edge cases
        
        XCTAssertFalse((...Int.min).contains(..<1))
        XCTAssertTrue((...Int.max).contains(..<1))
        XCTAssertFalse((...Int.min).contains(..<Int.min))
        XCTAssertFalse((...Int.min).contains(..<Int.max))
        XCTAssertTrue((...Int.max).contains(..<Int.min))
        XCTAssertFalse((...Int.max).contains(..<Int.max))
    }
    
    func testPartialRangeUpTo_contains_ClosedRange() {
        XCTAssertTrue((..<(-1)).contains(-10 ... -2))
        XCTAssertFalse((..<(-1)).contains(-10 ... -1))
        XCTAssertFalse((..<(-1)).contains(1 ... 10))
        XCTAssertFalse((..<0).contains(1 ... 10))
        XCTAssertFalse((..<1).contains(1 ... 10))
        XCTAssertFalse((..<2).contains(1 ... 10))
        XCTAssertFalse((..<9).contains(1 ... 10))
        XCTAssertFalse((..<10).contains(1 ... 10))
        XCTAssertTrue((..<11).contains(1 ... 10))
        
        // edge cases
        
        XCTAssertFalse((..<Int.min).contains(1 ... 10))
        XCTAssertTrue((..<Int.max).contains(1 ... 10))
        XCTAssertFalse((..<Int.min).contains(Int.min ... Int.min))
        XCTAssertFalse((..<Int.min).contains(Int.min ... Int.max))
        XCTAssertFalse((..<Int.max).contains(Int.min ... Int.max))
    }
    
    func testPartialRangeUpTo_contains_Range() {
        XCTAssertTrue((..<(-1)).contains(-10 ..< -1)) // -10 ... -2
        XCTAssertFalse((..<(-1)).contains(-10 ..< 0))  // -10 ... -1
        XCTAssertFalse((..<(-1)).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((..<0).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((..<1).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((..<2).contains(1 ..< 10)) // 1...9
        XCTAssertFalse((..<9).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((..<10).contains(1 ..< 10)) // 1...9
        XCTAssertTrue((..<11).contains(1 ..< 10)) // 1...9
        
        // edge cases
        
        XCTAssertFalse((..<Int.min).contains(1 ..< 10))
        XCTAssertTrue((..<Int.max).contains(1 ..< 10))
        XCTAssertTrue((..<Int.min).contains(Int.min ..< Int.min))
        XCTAssertFalse((..<Int.min).contains(Int.min ..< Int.max))
        XCTAssertTrue((..<Int.max).contains(Int.max ..< Int.max))
        XCTAssertTrue((..<Int.max).contains(Int.min ..< Int.max))
    }
    
    func testPartialRangeUpTo_contains_PartialRangeThrough() {
        XCTAssertFalse((..<(-1)).contains(...1))
        XCTAssertFalse((..<0).contains(...1))
        XCTAssertFalse((..<1).contains(...1))
        XCTAssertTrue((..<2).contains(...1))
        
        // edge cases
        
        XCTAssertFalse((..<Int.min).contains(...1))
        XCTAssertTrue((..<Int.max).contains(...1))
        XCTAssertFalse((..<Int.min).contains(...Int.min))
        XCTAssertFalse((..<Int.min).contains(...Int.max))
        XCTAssertTrue((..<Int.max).contains(...Int.min))
        XCTAssertFalse((..<Int.max).contains(...Int.max))
    }
    
    func testPartialRangeUpTo_contains_PartialRangeUpTo() {
        XCTAssertFalse((..<(-1)).contains(..<1))
        XCTAssertFalse((..<0).contains(..<1))
        XCTAssertTrue((..<1).contains(..<1))
        XCTAssertTrue((..<2).contains(..<1))
        
        // edge cases
        
        XCTAssertFalse((..<Int.min).contains(..<1))
        XCTAssertTrue((..<Int.max).contains(..<1))
        XCTAssertTrue((..<Int.min).contains(..<Int.min))
        XCTAssertFalse((..<Int.min).contains(..<Int.max))
        XCTAssertTrue((..<Int.max).contains(..<Int.min))
        XCTAssertTrue((..<Int.max).contains(..<Int.max))
    }
    
    func testNumber_ClampedTo_Ranges() {
        // .clamped(ClosedRange)
        
        XCTAssertEqual(5.clamped(to: 7 ... 10),      7)
        XCTAssertEqual(8.clamped(to: 7 ... 10),      8)
        XCTAssertEqual(20.clamped(to: 7 ... 10),     10)
        
        XCTAssertEqual(5.0.clamped(to: 7.0 ... 10.0),  7.0)
        XCTAssertEqual(8.0.clamped(to: 7.0 ... 10.0),  8.0)
        XCTAssertEqual(20.0.clamped(to: 7.0 ... 10.0), 10.0)
        
        XCTAssertEqual("a".clamped(to: "b" ... "h"),  "b")
        XCTAssertEqual("c".clamped(to: "b" ... "h"),  "c")
        XCTAssertEqual("k".clamped(to: "b" ... "h"),  "h")
        
        // .clamped(Range)
        
        XCTAssertEqual(5.clamped(to: 7 ..< 10),      7)
        XCTAssertEqual(8.clamped(to: 7 ..< 10),      8)
        XCTAssertEqual(20.clamped(to: 7 ..< 10),      9)
        
        // .clamped(PartialRangeFrom)
        
        XCTAssertEqual(5.clamped(to: 300...),    300)
        XCTAssertEqual(400.clamped(to: 300...),    400)
        
        XCTAssertEqual(5.0.clamped(to: 300.00...), 300.0)
        XCTAssertEqual(400.0.clamped(to: 300.00...), 400.0)
        
        XCTAssertEqual("a".clamped(to: "b"...),    "b")
        XCTAssertEqual("g".clamped(to: "b"...),    "g")
        
        // .clamped(PartialRangeThrough)
        
        XCTAssertEqual(200.clamped(to: ...300),    200)
        XCTAssertEqual(400.clamped(to: ...300),    300)
        
        XCTAssertEqual(200.0.clamped(to: ...300.0),  200.0)
        XCTAssertEqual(400.0.clamped(to: ...300.0),  300.0)
        
        XCTAssertEqual("a".clamped(to: ..."h"),    "a")
        XCTAssertEqual("k".clamped(to: ..."h"),    "h")
        
        // .clamped(PartialRangeUpTo)
        
        XCTAssertEqual(200.clamped(to: ..<300),    200)
        XCTAssertEqual(400.clamped(to: ..<300),    299)
    }
    
    func testFirstExcluding_ClosedRange() {
        // .first(excluding:) Generic Tests
        XCTAssertEqual((0 ... 10).first(excluding: [2, 5]),   0)
        XCTAssertEqual((0 ... 10).first(excluding: [0, 2, 5]), 1)
        
        XCTAssertEqual((0 ... 10).first(excluding: 0 ... 0),   1)
        XCTAssertEqual((0 ... 10).first(excluding: 2 ... 5),   0)
        XCTAssertEqual((0 ... 10).first(excluding: 0 ... 5),   6)
        
        XCTAssertEqual((0 ... 10).first(excluding: 2 ..< 5),   0)
        XCTAssertEqual((0 ... 10).first(excluding: 0 ..< 5),   5)
        
        XCTAssertEqual((0 ... 10).first(excluding: 2...),    0)
        XCTAssertEqual((0 ... 10).first(excluding: 0...),    nil)
        
        XCTAssertEqual((0 ... 10).first(excluding: ...0),    1)
        XCTAssertEqual((0 ... 10).first(excluding: ...10),   nil)
        
        XCTAssertEqual((0 ... 10).first(excluding: ..<0),    0)
        XCTAssertEqual((0 ... 10).first(excluding: ..<10),   10)
        XCTAssertEqual((0 ... 10).first(excluding: ..<11),   nil)
        
        // .first(excluding: [])
        XCTAssertEqual((1 ... 10).first(excluding: []), 1)
        XCTAssertEqual((1 ... 10).first(excluding: [-1]), 1)
        XCTAssertEqual((1 ... 10).first(excluding: [1]), 2)
        XCTAssertEqual((1 ... 10).first(excluding: [5, 1, 2]), 3)
        XCTAssertEqual((1 ... 10).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]), 10)
        XCTAssertEqual((1 ... 10).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]), 10)
        XCTAssertEqual((1 ... 10).first(excluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]), nil)
        
        // first(presortedExcluding: [])
        XCTAssertEqual((1 ... 10).first(presortedExcluding: []), 1)
        XCTAssertEqual((1 ... 10).first(presortedExcluding: [-1]), 1)
        XCTAssertEqual((1 ... 10).first(presortedExcluding: [1]), 2)
        XCTAssertEqual((1 ... 10).first(presortedExcluding: [1, 2]), 3)
        XCTAssertEqual((1 ... 10).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9]), 10)
        XCTAssertEqual((1 ... 10).first(presortedExcluding: [-1, 1, 2, 3, 4, 5, 6, 7, 8, 9]), 10)
        XCTAssertEqual((1 ... 10).first(presortedExcluding: [1, 2, 3, 4, 6, 7, 9, 8, 10]), 5)
        XCTAssertEqual((1 ... 10).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), nil)
        
        // .first(sortingAndExcluding: [])
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: []), 1)
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: [-1]), 1)
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: [1]), 2)
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: [2]), 1)
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: [5, 1, 2]), 3)
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]), 10)
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]), 10)
        XCTAssertEqual((1 ... 10).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]), nil)
        XCTAssertEqual((1 ... 200).first(sortingAndExcluding: Array(-10 ... 150)), 151)
        XCTAssertEqual((1 ... 1000).first(sortingAndExcluding: Array(-10 ... 999)), 1000)
        XCTAssertEqual((1 ... 1000).first(sortingAndExcluding: Array(-10 ... 1100)), nil)
        XCTAssertEqual(
            (10 ... 20)
                .first(sortingAndExcluding: [15, 11, 10, 12, 14, 13, 19, 17, 18, 16, 9, 8, 7]),
            20
        )
        
        // .first(excluding: ClosedRange)
        XCTAssertEqual((1 ... 10000).first(excluding:    10000 ... 12000), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: (-12000) ... (-10000)), 1)
        
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ... (-1)), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ... 0), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ... 1), 2)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ... 2), 3)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ... 3), 4)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ... 0), 1)
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ... 1), 2)
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ... 2), 3)
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ... 3), 4)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ... 1), 2)
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ... 2), 3)
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ... 3), 4)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  2 ... 2), 1)
        XCTAssertEqual((1 ... 10000).first(excluding:  2 ... 3), 1)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  3 ... 3), 1)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ... 9999), 10000)
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ... 10000), nil)
        XCTAssertEqual((1 ... 10000).first(excluding:  2 ... 9999), 1)
        
        // .first(excluding: Range)
        XCTAssertEqual((1 ... 10000).first(excluding:    10000 ..< 12000), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: (-12000) ..< (-10000)), 1)
        
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ..< (-1)), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ..< 0), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ..< 1), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ..< 2), 2)
        XCTAssertEqual((1 ... 10000).first(excluding: -1 ..< 3), 3)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ..< 0), 1)
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ..< 1), 1)
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ..< 2), 2)
        XCTAssertEqual((1 ... 10000).first(excluding:  0 ..< 3), 3)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ..< 1), 1)
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ..< 2), 2)
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ..< 3), 3)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  2 ..< 2), 1)
        XCTAssertEqual((1 ... 10000).first(excluding:  2 ..< 3), 1)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  3 ..< 3), 1)
        
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ..< 9999), 9999)
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ..< 10000), 10000)
        XCTAssertEqual((1 ... 10000).first(excluding:  1 ..< 10001), nil)
        XCTAssertEqual((1 ... 10000).first(excluding:  2 ..< 9999), 1)
        
        // .first(excluding: PartialRangeFrom)
        XCTAssertEqual((1 ... 10000).first(excluding:  9999...), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: 10000...), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: 10001...), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: (-1)...), nil)
        XCTAssertEqual((1 ... 10000).first(excluding: 0...), nil)
        XCTAssertEqual((1 ... 10000).first(excluding: 1...), nil)
        XCTAssertEqual((1 ... 10000).first(excluding: 2...), 1)
        
        // .first(excluding: PartialRangeThrough)
        XCTAssertEqual((1 ... 10000).first(excluding: ...9998), 9999)
        XCTAssertEqual((1 ... 10000).first(excluding: ...9999), 10000)
        XCTAssertEqual((1 ... 10000).first(excluding: ...10000), nil)
        XCTAssertEqual((1 ... 10000).first(excluding: ...10001), nil)
        XCTAssertEqual((1 ... 10000).first(excluding: ...(-1)), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: ...0), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: ...1), 2)
        XCTAssertEqual((1 ... 10000).first(excluding: ...2), 3)
        
        // .first(excluding: PartialRangeUpTo)
        XCTAssertEqual((1 ... 10000).first(excluding: ..<9999), 9999)
        XCTAssertEqual((1 ... 10000).first(excluding: ..<10000), 10000)
        XCTAssertEqual((1 ... 10000).first(excluding: ..<10001), nil)
        XCTAssertEqual((1 ... 10000).first(excluding: ..<(-1)), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: ..<0), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: ..<1), 1)
        XCTAssertEqual((1 ... 10000).first(excluding: ..<2), 2)
        
        // these integers result in overflow on armv7/i386 (32-bit arch)
        #if !(arch(arm) || arch(i386))
        // very large ranges
        XCTAssertEqual((1 ... 10_000_000_000).first(excluding: [1]), 2)
        #endif
        
        // zero element ranges
        XCTAssertEqual((0 ... 0).first(excluding: 0 ... 5), nil)
    }
    
    func testFirstExcluding_Range() {
        // .first(excluding:) Generic Tests
        
        XCTAssertEqual((0 ..< 10).first(excluding: [2, 5]),    0)
        XCTAssertEqual((0 ..< 10).first(excluding: [0, 2, 5]),  1)
        
        XCTAssertEqual((0 ..< 10).first(excluding: 0 ... 0),    1)
        XCTAssertEqual((0 ..< 10).first(excluding: 2 ... 5),    0)
        XCTAssertEqual((0 ..< 10).first(excluding: 0 ... 5),    6)
        
        XCTAssertEqual((0 ..< 10).first(excluding: 2 ..< 5),    0)
        XCTAssertEqual((0 ..< 10).first(excluding: 0 ..< 5),    5)
        
        XCTAssertEqual((0 ..< 10).first(excluding: 2...),     0)
        XCTAssertEqual((0 ..< 10).first(excluding: 0...),     nil)
        
        XCTAssertEqual((0 ..< 10).first(excluding: ...0),     1)
        XCTAssertEqual((0 ..< 10).first(excluding: ...10),    nil)
        
        XCTAssertEqual((0 ..< 10).first(excluding: ..<0),     0)
        XCTAssertEqual((0 ..< 10).first(excluding: ..<9),     9)
        XCTAssertEqual((0 ..< 10).first(excluding: ..<10),    nil)
        
        // .first(excluding: [])
        XCTAssertEqual((1 ..< 10).first(excluding: []), 1)
        XCTAssertEqual((1 ..< 10).first(excluding: [-1]), 1)
        XCTAssertEqual((1 ..< 10).first(excluding: [1]), 2)
        XCTAssertEqual((1 ..< 10).first(excluding: [5, 1, 2]), 3)
        XCTAssertEqual((1 ..< 11).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]), 10)
        XCTAssertEqual((1 ..< 11).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]), 10)
        XCTAssertEqual((1 ..< 11).first(excluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]), nil)
        
        // first(presortedExcluding: [])
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: []), 1)
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: [-1]), 1)
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: [1]), 2)
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: [1, 2]), 3)
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9]), 10)
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: [-1, 1, 2, 3, 4, 5, 6, 7, 8, 9]), 10)
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: [1, 2, 3, 4, 6, 7, 9, 8, 10]), 5)
        XCTAssertEqual((1 ..< 11).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), nil)
        
        // .first(sortingAndExcluding: [])
        XCTAssertEqual((1 ..< 10).first(sortingAndExcluding: []), 1)
        XCTAssertEqual((1 ..< 10).first(sortingAndExcluding: [-1]), 1)
        XCTAssertEqual((1 ..< 10).first(sortingAndExcluding: [1]), 2)
        XCTAssertEqual((1 ..< 10).first(sortingAndExcluding: [5, 1, 2]), 3)
        XCTAssertEqual((1 ..< 11).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]), 10)
        XCTAssertEqual((1 ..< 11).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]), 10)
        XCTAssertEqual((1 ..< 11).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]), nil)
        XCTAssertEqual((1 ..< 200).first(sortingAndExcluding: Array(-10 ... 150)), 151)
        XCTAssertEqual((1 ..< 1001).first(sortingAndExcluding: Array(-10 ... 999)), 1000)
        XCTAssertEqual((1 ..< 1000).first(sortingAndExcluding: Array(-10 ... 1100)), nil)
        XCTAssertEqual(
            (10 ..< 21)
                .first(sortingAndExcluding: [15, 11, 10, 12, 14, 13, 19, 17, 18, 16, 9, 8, 7]),
            20
        )
        
        // .first(excluding: ClosedRange)
        XCTAssertEqual((1 ..< 10000).first(excluding:     9999 ... 12000), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: (-12000) ... (-10000)), 1)
        
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ... (-1)), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ... 0), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ... 1), 2)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ... 2), 3)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ... 3), 4)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ... 0), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ... 1), 2)
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ... 2), 3)
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ... 3), 4)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ... 1), 2)
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ... 2), 3)
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ... 3), 4)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  2 ... 2), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  2 ... 3), 1)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  3 ... 3), 1)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ... 9998), 9999)
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ... 9999), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding:  2 ... 9999), 1)
        
        // .first(excluding: Range)
        XCTAssertEqual((1 ..< 10000).first(excluding:     9999 ..< 12000), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: (-12000) ..< (-10000)), 1)
        
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ..< (-1)), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ..< 0), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ..< 1), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ..< 2), 2)
        XCTAssertEqual((1 ..< 10000).first(excluding: -1 ..< 3), 3)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ..< 0), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ..< 1), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ..< 2), 2)
        XCTAssertEqual((1 ..< 10000).first(excluding:  0 ..< 3), 3)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ..< 1), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ..< 2), 2)
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ..< 3), 3)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  2 ..< 2), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  2 ..< 3), 1)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  3 ..< 3), 1)
        
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ..< 9998), 9998)
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ..< 9999), 9999)
        XCTAssertEqual((1 ..< 10000).first(excluding:  1 ..< 10000), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding:  2 ..< 9999), 1)
        
        // .first(excluding: PartialRangeFrom)
        XCTAssertEqual((1 ..< 10000).first(excluding:  9998...), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  9999...), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: 10000...), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding:  (-1)...), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding:     0...), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding:     1...), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding:     2...), 1)
        
        // .first(excluding: PartialRangeThrough)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...9997), 9998)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...9998), 9999)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...9999), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...10000), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...(-1)), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...0), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...1), 2)
        XCTAssertEqual((1 ..< 10000).first(excluding: ...2), 3)
        
        // .first(excluding: PartialRangeUpTo)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<9998), 9998)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<9999), 9999)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<10000), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<10001), nil)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<(-1)), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<0), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<1), 1)
        XCTAssertEqual((1 ..< 10000).first(excluding: ..<2), 2)
        
        // these integers result in overflow on armv7/i386 (32-bit arch)
        #if !(arch(arm) || arch(i386))
        // very large ranges
        XCTAssertEqual((1 ..< 10_000_000_000).first(excluding: [1]), 2)
        #endif
        
        // zero element ranges
        XCTAssertEqual((0 ..< 0).first(excluding: 0 ... 5), nil)
    }
    
    func testFirstExcluding_PartialRangeFrom() {
        // .first(excluding: [])
        XCTAssertEqual((1...).first(excluding: []), 1)
        XCTAssertEqual((1...).first(excluding: [-1]), 1)
        XCTAssertEqual((1...).first(excluding: [1]), 2)
        XCTAssertEqual((1...).first(excluding: [5, 1, 2]), 3)
        XCTAssertEqual((1...).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]), 10)
        XCTAssertEqual((1...).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]), 10)
        XCTAssertEqual((1...).first(excluding: [5, 2, 4, 3, 9, 10, 7, 8, 6]), 1)
        
        // first(presortedExcluding: [])
        XCTAssertEqual((1...).first(presortedExcluding: []), 1)
        XCTAssertEqual((1...).first(presortedExcluding: [-1]), 1)
        XCTAssertEqual((1...).first(presortedExcluding: [1]), 2)
        XCTAssertEqual((1...).first(presortedExcluding: [1, 2]), 3)
        XCTAssertEqual((1...).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9]), 10)
        XCTAssertEqual((1...).first(presortedExcluding: [-1, 1, 2, 3, 4, 5, 6, 7, 8, 9]), 10)
        XCTAssertEqual((1...).first(presortedExcluding: [1, 2, 3, 4, 6, 7, 9, 8, 10]), 5)
        XCTAssertEqual((1...).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), 11)
        
        // .first(sortingAndExcluding: [])
        XCTAssertEqual((1...).first(sortingAndExcluding: []), 1)
        XCTAssertEqual((1...).first(sortingAndExcluding: [-1]), 1)
        XCTAssertEqual((1...).first(sortingAndExcluding: [1]), 2)
        XCTAssertEqual((1...).first(sortingAndExcluding: [5, 1, 2]), 3)
        XCTAssertEqual((1...).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]), 10)
        XCTAssertEqual((1...).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 6, -1]), 8)
        XCTAssertEqual((1...).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]), 11)
        XCTAssertEqual((1...).first(sortingAndExcluding: Array(-10 ... 150)), 151)
        XCTAssertEqual((1...).first(sortingAndExcluding: Array(-10 ... 999)), 1000)
        XCTAssertEqual(
            (10...).first(sortingAndExcluding: [15, 11, 10, 12, 14, 13, 16, 9, 8, 7]),
            17
        )
        
        // .first(excluding: ClosedRange)
        XCTAssertEqual((1...).first(excluding: -3 ... (-1)), 1)
        XCTAssertEqual((1...).first(excluding: -3 ... 0), 1)
        XCTAssertEqual((1...).first(excluding: -3 ... 1), 2)
        XCTAssertEqual((1...).first(excluding:  1 ... 1), 2)
        XCTAssertEqual((1...).first(excluding:  1 ... 1000), 1001)
        XCTAssertEqual((1...).first(excluding:  2 ... 1000), 1)
        
        // .first(excluding: Range)
        XCTAssertEqual((1...).first(excluding: -3 ..< (-1)), 1)
        XCTAssertEqual((1...).first(excluding: -3 ..< 0), 1)
        XCTAssertEqual((1...).first(excluding: -3 ..< 1), 1)
        XCTAssertEqual((1...).first(excluding: -3 ..< 2), 2)
        XCTAssertEqual((1...).first(excluding:  1 ..< 1), 1)
        XCTAssertEqual((1...).first(excluding:  1 ..< 2), 2)
        XCTAssertEqual((1...).first(excluding:  1 ..< 1000), 1000)
        XCTAssertEqual((1...).first(excluding:  2 ..< 1000), 1)
        
        // .first(excluding: PartialRangeFrom)
        XCTAssertEqual((1...).first(excluding: 100...), 1)
        XCTAssertEqual((1...).first(excluding: (-1)...), nil)
        XCTAssertEqual((1...).first(excluding: 0...), nil)
        XCTAssertEqual((1...).first(excluding: 1...), nil)
        XCTAssertEqual((1...).first(excluding: 2...), 1)
        XCTAssertEqual((1...).first(excluding: 3...), 1)
        
        // .first(excluding: PartialRangeThrough)
        XCTAssertEqual((1...).first(excluding: ...100), 101)
        XCTAssertEqual((1...).first(excluding: ...(-1)), 1)
        XCTAssertEqual((1...).first(excluding: ...0), 1)
        XCTAssertEqual((1...).first(excluding: ...1), 2)
        XCTAssertEqual((1...).first(excluding: ...2), 3)
        XCTAssertEqual((1...).first(excluding: ...3), 4)
        
        // .first(excluding: PartialRangeUpTo)
        XCTAssertEqual((1...).first(excluding: ..<100), 100)
        XCTAssertEqual((1...).first(excluding: ..<(-1)), 1)
        XCTAssertEqual((1...).first(excluding: ..<0), 1)
        XCTAssertEqual((1...).first(excluding: ..<1), 1)
        XCTAssertEqual((1...).first(excluding: ..<2), 2)
        XCTAssertEqual((1...).first(excluding: ..<3), 3)
    }
    
    func testClosedRange_SplitEvery() {
        XCTAssertEqual((0 ... 10).split(every: -1), [0 ... 10])
        XCTAssertEqual((0 ... 10).split(every:  0), [0 ... 10])
        XCTAssertEqual((0 ... 10).split(every:  1), [
            0 ... 0,
            1 ... 1,
            2 ... 2,
            3 ... 3,
            4 ... 4,
            5 ... 5,
            6 ... 6,
            7 ... 7,
            8 ... 8,
            9 ... 9,
            10 ... 10
        ])
        XCTAssertEqual((0 ... 10).split(every:  2), [
            0 ... 1,
            2 ... 3,
            4 ... 5,
            6 ... 7,
            8 ... 9,
            10 ... 10
        ])
        XCTAssertEqual((0 ... 10).split(every:  3), [0 ... 2, 3 ... 5, 6 ... 8, 9 ... 10])
        XCTAssertEqual((0 ... 10).split(every:  4), [0 ... 3, 4 ... 7, 8 ... 10])
        XCTAssertEqual((0 ... 10).split(every:  5), [0 ... 4, 5 ... 9, 10 ... 10])
        XCTAssertEqual((0 ... 10).split(every: 10), [0 ... 9, 10 ... 10])
        XCTAssertEqual((0 ... 10).split(every: 11), [0 ... 10])
        XCTAssertEqual((0 ... 10).split(every: 12), [0 ... 10])
    }
    
    func testRange_SplitEvery() {
        XCTAssertEqual((0 ..< 11).split(every: -1), [0 ... 10])
        XCTAssertEqual((0 ..< 11).split(every:  0), [0 ... 10])
        XCTAssertEqual((0 ..< 11).split(every:  1), [
            0 ... 0,
            1 ... 1,
            2 ... 2,
            3 ... 3,
            4 ... 4,
            5 ... 5,
            6 ... 6,
            7 ... 7,
            8 ... 8,
            9 ... 9,
            10 ... 10
        ])
        XCTAssertEqual((0 ..< 11).split(every:  2), [
            0 ... 1,
            2 ... 3,
            4 ... 5,
            6 ... 7,
            8 ... 9,
            10 ... 10
        ])
        XCTAssertEqual((0 ..< 11).split(every:  3), [0 ... 2, 3 ... 5, 6 ... 8, 9 ... 10])
        XCTAssertEqual((0 ..< 11).split(every:  4), [0 ... 3, 4 ... 7, 8 ... 10])
        XCTAssertEqual((0 ..< 11).split(every:  5), [0 ... 4, 5 ... 9, 10 ... 10])
        XCTAssertEqual((0 ..< 11).split(every: 10), [0 ... 9, 10 ... 10])
        XCTAssertEqual((0 ..< 11).split(every: 11), [0 ... 10])
        XCTAssertEqual((0 ..< 11).split(every: 12), [0 ... 10])
    }
    
    func testAbsoluteBounds() {
        func bounds<R: RangeExpression>(of r: R) -> (min: R.Bound?, max: R.Bound?) where R.Bound: Strideable {
            r.getAbsoluteBounds()
        }
        
        // ClosedRange
        XCTAssertEqual(bounds(of:  0 ... 0).min, 0)
        XCTAssertEqual(bounds(of:  0 ... 0).max, 0)
        XCTAssertEqual(bounds(of:  0 ... 1).min, 0)
        XCTAssertEqual(bounds(of:  0 ... 1).max, 1)
        XCTAssertEqual(bounds(of: -1 ... 1).min, -1)
        XCTAssertEqual(bounds(of: -1 ... 1).max, 1)
        
        // Range
        XCTAssertEqual(bounds(of:  0 ..< 0).min, nil)
        XCTAssertEqual(bounds(of:  0 ..< 0).max, nil)
        XCTAssertEqual(bounds(of: -1 ..< 0).min, -1)
        XCTAssertEqual(bounds(of: -1 ..< 0).max, -1)
        XCTAssertEqual(bounds(of: -1 ..< 1).min, -1)
        XCTAssertEqual(bounds(of: -1 ..< 1).max, 0)
        
        // PartialRangeFrom
        XCTAssertEqual(bounds(of:    0...).min, 0)
        XCTAssertEqual(bounds(of:    0...).max, nil)
        XCTAssertEqual(bounds(of: (-1)...).min, -1)
        XCTAssertEqual(bounds(of: (-1)...).max, nil)
        XCTAssertEqual(bounds(of:    1...).min, 1)
        XCTAssertEqual(bounds(of:    1...).max, nil)
        
        
        // PartialRangeUpTo
        XCTAssertEqual(bounds(of:   ..<0).min, nil)
        XCTAssertEqual(bounds(of:   ..<0).max, -1)
        XCTAssertEqual(bounds(of: ..<(-1)).min, nil)
        XCTAssertEqual(bounds(of: ..<(-1)).max, -2)
        XCTAssertEqual(bounds(of:   ..<1).min, nil)
        XCTAssertEqual(bounds(of:   ..<1).max, 0)
        XCTAssertEqual(bounds(of:   ..<2).min, nil)
        XCTAssertEqual(bounds(of:   ..<2).max, 1)
        
        // PartialRangeThrough
        XCTAssertEqual(bounds(of:   ...0).min, nil)
        XCTAssertEqual(bounds(of:   ...0).max, 0)
        XCTAssertEqual(bounds(of: ...(-1)).min, nil)
        XCTAssertEqual(bounds(of: ...(-1)).max, -1)
        XCTAssertEqual(bounds(of:   ...1).min, nil)
        XCTAssertEqual(bounds(of:   ...1).max, 1)
    }
    
    func testBinaryIntegerRepeatEach() {
        // basic functionality
        
        var count = 0
        5.repeatEach { count += 1 }
        XCTAssertEqual(count, 5)
        
        // edge cases
        
        count = 0
        (-1).repeatEach { count += 1 }
        XCTAssertEqual(count, 0)                // only iterates on values > 0
    }
    
    func testClosedRangeRepeatEach() {
        var count = 0
        (1 ... 5).repeatEach { count += 1 }
        XCTAssertEqual(count, 5)
        
        // edge cases
        
        count = 0
        (1 ... 1).repeatEach { count += 1 }       // single member range
        XCTAssertEqual(count, 1)
        
        count = 0
        ((-5) ... (-1)).repeatEach { count += 1 } // doesn't matter if bounds are negative
        XCTAssertEqual(count, 5)
    }
    
    func testRangeRepeatEach() {
        var count = 0
        (1 ..< 5).repeatEach { count += 1 }
        XCTAssertEqual(count, 4)
        
        // edge cases
        
        count = 0
        (1 ..< 1).repeatEach { count += 1 }       // no-member range
        XCTAssertEqual(count, 0)
        
        count = 0
        ((-5) ..< (-1)).repeatEach { count += 1 } // doesn't matter if bounds are negative
        XCTAssertEqual(count, 4)
    }
}

#endif
