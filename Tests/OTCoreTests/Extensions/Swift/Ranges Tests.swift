//
//  Ranges Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Extensions_Swift_Ranges_Tests {
    @Test
    func isContained_InRange() {
        // int
        
        #expect(0.isContained(in: 1 ... 4) == false)
        #expect(1.isContained(in: 1 ... 4) == true)
        #expect(2.isContained(in: 1 ... 4) == true)
        #expect(4.isContained(in: 1 ... 4) == true)
        #expect(5.isContained(in: 1 ... 4) == false)
        
        #expect(0.isContained(in: 1 ..< 4) == false)
        #expect(1.isContained(in: 1 ..< 4) == true)
        #expect(2.isContained(in: 1 ..< 4) == true)
        #expect(4.isContained(in: 1 ..< 4) == false)
        #expect(5.isContained(in: 1 ..< 4) == false)
        
        #expect(0.isContained(in: 1...) == false)
        #expect(1.isContained(in: 1...) == true)
        #expect(2.isContained(in: 1...) == true)
        
        #expect(0.isContained(in: ...2) == true)
        #expect(1.isContained(in: ...2) == true)
        #expect(2.isContained(in: ...2) == true)
        #expect(3.isContained(in: ...2) == false)
        
        #expect(0.isContained(in: ..<2) == true)
        #expect(1.isContained(in: ..<2) == true)
        #expect(2.isContained(in: ..<2) == false)
        #expect(3.isContained(in: ..<2) == false)
        
        // floating point
        
        #expect(0.0.isContained(in: 1.0 ... 4.0) == false)
        #expect(1.0.isContained(in: 1.0 ... 4.0) == true)
        #expect(2.0.isContained(in: 1.0 ... 4.0) == true)
        #expect(4.0.isContained(in: 1.0 ... 4.0) == true)
        #expect(5.0.isContained(in: 1.0 ... 4.0) == false)
        
        #expect(0.0.isContained(in: 1.0 ..< 4.0) == false)
        #expect(1.0.isContained(in: 1.0 ..< 4.0) == true)
        #expect(2.0.isContained(in: 1.0 ..< 4.0) == true)
        #expect(4.0.isContained(in: 1.0 ..< 4.0) == false)
        #expect(5.0.isContained(in: 1.0 ..< 4.0) == false)
        
        #expect(0.0.isContained(in: 1.0...) == false)
        #expect(1.0.isContained(in: 1.0...) == true)
        #expect(2.0.isContained(in: 1.0...) == true)
        
        #expect(0.0.isContained(in: ...2.0) == true)
        #expect(1.0.isContained(in: ...2.0) == true)
        #expect(2.0.isContained(in: ...2.0) == true)
        #expect(3.0.isContained(in: ...2.0) == false)
        
        #expect(0.0.isContained(in: ..<2.0) == true)
        #expect(1.0.isContained(in: ..<2.0) == true)
        #expect(2.0.isContained(in: ..<2.0) == false)
        #expect(3.0.isContained(in: ..<2.0) == false)
        
        // other Comparable, such as String:
        
        #expect("c".isContained(in: "a" ... "d") == true)
        #expect("e".isContained(in: "a" ... "d") == false)
    }
    
    @Test
    func closedRange_contains_ClosedRange() {
        #expect((1 ... 10).contains(1 ...  1))
        #expect((1 ... 10).contains(3 ... 7))
        #expect((1 ... 10).contains(1 ... 10))
        #expect((1 ... 10).contains(10 ... 10))
        
        #expect(!(1 ... 10).contains(0 ...  0))
        #expect(!(1 ... 10).contains(0 ...  1))
        #expect(!(1 ... 10).contains(0 ...  2))
        #expect(!(1 ... 10).contains(0 ... 10))
        #expect(!(1 ... 10).contains(9 ... 11))
        #expect(!(1 ... 10).contains(10 ... 11))
        #expect(!(1 ... 10).contains(11 ... 11))
        
        #expect(!(1 ... 10).contains(-1 ...  1))
    }
    
    @Test
    func closedRange_contains_Range() {
        #expect(!(1 ... 10).contains(1 ..<  1)) // empty, but in range
        #expect((1 ... 10).contains(1 ..< 10)) // 1...9
        #expect((1 ... 10).contains(3 ..< 8)) // 3...7
        #expect((1 ... 10).contains(1 ..< 11)) // 1...10
        #expect(!(1 ... 10).contains(10 ..< 10)) // empty
        #expect((1 ... 10).contains(10 ..< 11)) // 10...10

        #expect(!(1 ... 10).contains(0 ..<  0)) // empty, out of range
        #expect(!(1 ... 10).contains(0 ..<  1)) // 0...0, out of range
        #expect(!(1 ... 10).contains(0 ..<  2)) // 0...1, lowerBound out of range
        #expect(!(1 ... 10).contains(0 ..< 10)) // 0...9, lowerBound out of range
        #expect((1 ... 10).contains(9 ..< 11)) // 9...10
        #expect((1 ... 10).contains(10 ..< 11)) // 10...10
        #expect(!(1 ... 10).contains(11 ..< 11)) // empty, out of range

        #expect(!(1 ... 10).contains(-1 ..< 1))
    }
    
    @Test
    func range_contains_ClosedRange() {
        #expect((1 ..< 10).contains(1 ... 1))
        #expect((1 ..< 10).contains(3 ... 7))
        #expect((1 ..< 10).contains(1 ... 9))
        #expect(!(1 ..< 10).contains(1 ... 10))
        #expect(!(1 ..< 10).contains(10 ... 10))
        
        #expect(!(1 ..< 10).contains(0 ... 0))
        #expect(!(1 ..< 10).contains(0 ... 1))
        #expect(!(1 ..< 10).contains(0 ... 2))
        #expect(!(1 ..< 10).contains(0 ... 9))
        #expect(!(1 ..< 10).contains(0 ... 10))
        #expect(!(1 ..< 10).contains(9 ... 11))
        #expect(!(1 ..< 10).contains(10 ... 11))
        #expect(!(1 ..< 10).contains(11 ... 11))
        
        #expect(!(1 ..< 10).contains(-1 ... 1))
    }
    
    @Test
    func range_contains_Range() {
        #expect(!(1 ..< 10).contains(1 ..< 1)) // empty
        #expect((1 ..< 10).contains(3 ..< 8)) // 3...7
        #expect((1 ..< 10).contains(1 ..< 10)) // identical
        #expect(!(1 ..< 10).contains(1 ..< 11)) // 1...10
        #expect(!(1 ..< 10).contains(10 ..< 10)) // empty
        #expect(!(1 ..< 10).contains(10 ..< 11)) // 10...10

        #expect(!(1 ..< 10).contains(0 ..< 0)) // empty, out of range
        #expect(!(1 ..< 10).contains(0 ..< 1)) // 0...0, out of range
        #expect(!(1 ..< 10).contains(0 ..< 2)) // 0...1, lowerBound out of range
        #expect(!(1 ..< 10).contains(0 ..< 10)) // 0...9, lowerBound out of range
        #expect(!(1 ..< 10).contains(9 ..< 11)) // 9...10
        #expect(!(1 ..< 10).contains(10 ..< 11)) // 10...10, out of range
        #expect(!(1 ..< 10).contains(11 ..< 12)) // 11...11, out of range
        #expect(!(1 ..< 10).contains(11 ..< 11)) // empty, out of range

        #expect(!(1 ..< 10).contains(-1 ..< 1))
        
        // edge cases
        
        #expect((Int.min ..< Int.max).contains(1 ..< 10))
        #expect(!(Int.max ..< Int.max).contains(1 ..< 10))
        #expect((Int.min ..< Int.max).contains(Int.min ..< Int.max))
        #expect(!(Int.max ..< Int.max).contains(Int.min ..< Int.max))
    }
    
    @Test
    func partialRangeFrom_contains_ClosedRange() {
        #expect(((-1)...).contains(1 ... 10))
        #expect((0...).contains(1 ... 10))
        #expect((1...).contains(1 ... 10))
        #expect(!(2...).contains(1 ... 10))
        #expect(!(9...).contains(1 ... 10))
        #expect(!(10...).contains(1 ... 10))
        #expect(!(11...).contains(1 ... 10))
        
        // edge cases
        
        #expect((Int.min...).contains(1 ... 10))
        #expect(!(Int.max...).contains(1 ... 10))
        #expect((Int.min...).contains(Int.min ... Int.max))
        #expect(!(Int.max...).contains(Int.min ... Int.max))
    }
    
    @Test
    func partialRangeFrom_contains_Range() {
        #expect(((-1)...).contains(1 ..< 10)) // 1...9
        #expect((0...).contains(1 ..< 10)) // 1...9
        #expect((1...).contains(1 ..< 10)) // 1...9
        #expect(!(2...).contains(1 ..< 10)) // 1...9
        #expect(!(9...).contains(1 ..< 10)) // 1...9
        #expect(!(10...).contains(1 ..< 10)) // 1...9
        #expect(!(11...).contains(1 ..< 10)) // 1...9
        
        // edge cases
        
        #expect((Int.min...).contains(1 ..< 10))
        #expect(!(Int.max...).contains(1 ..< 10))
        #expect((Int.min...).contains(Int.min ..< Int.max))
        #expect(!(Int.max...).contains(Int.min ..< Int.max))
    }
    
    @Test
    func partialRangeFrom_contains_PartialRangeFrom() {
        #expect(!(1...).contains((-1)...))
        #expect(!(1...).contains(0...))
        #expect((1...).contains(1...))
        #expect((1...).contains(2...))
        
        // edge cases
        
        #expect((Int.min...).contains(1...))
        #expect(!(Int.max...).contains(1...))
        #expect((Int.min...).contains(Int.min...))
        #expect(!(Int.max...).contains(Int.min...))
        #expect((Int.max...).contains(Int.max...))
    }
    
    @Test
    func partialRangeThrough_contains_ClosedRange() {
        #expect((...(-1)).contains(-10 ... -1))
        #expect(!(...(-1)).contains(1 ... 10))
        #expect(!(...0).contains(1 ... 10))
        #expect(!(...1).contains(1 ... 10))
        #expect(!(...2).contains(1 ... 10))
        #expect(!(...9).contains(1 ... 10))
        #expect((...10).contains(1 ... 10))
        #expect((...11).contains(1 ... 10))
        
        // edge cases
        
        #expect(!(...Int.min).contains(1 ... 10))
        #expect((...Int.max).contains(1 ... 10))
        #expect((...Int.min).contains(Int.min ... Int.min))
        #expect(!(...Int.min).contains(Int.min ... Int.max))
        #expect((...Int.max).contains(Int.min ... Int.max))
    }
    
    @Test
    func partialRangeThrough_contains_Range() {
        #expect((...(-1)).contains(-10 ..< 0)) // -10 ... -1
        #expect(!(...(-1)).contains(1 ..< 10)) // 1...9
        #expect(!(...0).contains(1 ..< 10)) // 1...9
        #expect(!(...1).contains(1 ..< 10)) // 1...9
        #expect(!(...2).contains(1 ..< 10)) // 1...9
        #expect((...9).contains(1 ..< 10)) // 1...9
        #expect((...10).contains(1 ..< 10)) // 1...9
        #expect((...11).contains(1 ..< 10)) // 1...9
        
        // edge cases
        
        #expect(!(...Int.min).contains(1 ..< 10))
        #expect((...Int.max).contains(1 ..< 10))
        #expect(!(...Int.min).contains(Int.min ..< Int.min))
        #expect(!(...Int.min).contains(Int.min ..< Int.max))
        #expect((...Int.max).contains(Int.max ..< Int.max))
        #expect((...Int.max).contains(Int.min ..< Int.max))
    }

    @Test
    func partialRangeThrough_contains_PartialRangeThrough() {
        #expect(!(...(-1)).contains(...1))
        #expect(!(...0).contains(...1))
        #expect((...1).contains(...1))
        #expect((...2).contains(...1))
        
        // edge cases
        
        #expect(!(...Int.min).contains(...1))
        #expect((...Int.max).contains(...1))
        #expect((...Int.min).contains(...Int.min))
        #expect(!(...Int.min).contains(...Int.max))
        #expect((...Int.max).contains(...Int.min))
        #expect((...Int.max).contains(...Int.max))
    }

    @Test
    func partialRangeThrough_contains_PartialRangeUpTo() {
        #expect(!(...(-1)).contains(..<1))
        #expect(!(...0).contains(..<1))
        #expect(!(...1).contains(..<1))
        #expect((...2).contains(..<1))
        
        // edge cases
        
        #expect(!(...Int.min).contains(..<1))
        #expect((...Int.max).contains(..<1))
        #expect(!(...Int.min).contains(..<Int.min))
        #expect(!(...Int.min).contains(..<Int.max))
        #expect((...Int.max).contains(..<Int.min))
        #expect(!(...Int.max).contains(..<Int.max))
    }
    
    @Test
    func partialRangeUpTo_contains_ClosedRange() {
        #expect((..<(-1)).contains(-10 ... -2))
        #expect(!(..<(-1)).contains(-10 ... -1))
        #expect(!(..<(-1)).contains(1 ... 10))
        #expect(!(..<0).contains(1 ... 10))
        #expect(!(..<1).contains(1 ... 10))
        #expect(!(..<2).contains(1 ... 10))
        #expect(!(..<9).contains(1 ... 10))
        #expect(!(..<10).contains(1 ... 10))
        #expect((..<11).contains(1 ... 10))
        
        // edge cases
        
        #expect(!(..<Int.min).contains(1 ... 10))
        #expect((..<Int.max).contains(1 ... 10))
        #expect(!(..<Int.min).contains(Int.min ... Int.min))
        #expect(!(..<Int.min).contains(Int.min ... Int.max))
        #expect(!(..<Int.max).contains(Int.min ... Int.max))
    }
    
    @Test
    func partialRangeUpTo_contains_Range() {
        #expect((..<(-1)).contains(-10 ..< -1)) // -10 ... -2
        #expect(!(..<(-1)).contains(-10 ..< 0))  // -10 ... -1
        #expect(!(..<(-1)).contains(1 ..< 10)) // 1...9
        #expect(!(..<0).contains(1 ..< 10)) // 1...9
        #expect(!(..<1).contains(1 ..< 10)) // 1...9
        #expect(!(..<2).contains(1 ..< 10)) // 1...9
        #expect(!(..<9).contains(1 ..< 10)) // 1...9
        #expect((..<10).contains(1 ..< 10)) // 1...9
        #expect((..<11).contains(1 ..< 10)) // 1...9
        
        // edge cases
        
        #expect(!(..<Int.min).contains(1 ..< 10))
        #expect((..<Int.max).contains(1 ..< 10))
        #expect((..<Int.min).contains(Int.min ..< Int.min))
        #expect(!(..<Int.min).contains(Int.min ..< Int.max))
        #expect((..<Int.max).contains(Int.max ..< Int.max))
        #expect((..<Int.max).contains(Int.min ..< Int.max))
    }
    
    @Test
    func partialRangeUpTo_contains_PartialRangeThrough() {
        #expect(!(..<(-1)).contains(...1))
        #expect(!(..<0).contains(...1))
        #expect(!(..<1).contains(...1))
        #expect((..<2).contains(...1))
        
        // edge cases
        
        #expect(!(..<Int.min).contains(...1))
        #expect((..<Int.max).contains(...1))
        #expect(!(..<Int.min).contains(...Int.min))
        #expect(!(..<Int.min).contains(...Int.max))
        #expect((..<Int.max).contains(...Int.min))
        #expect(!(..<Int.max).contains(...Int.max))
    }
    
    @Test
    func partialRangeUpTo_contains_PartialRangeUpTo() {
        #expect(!(..<(-1)).contains(..<1))
        #expect(!(..<0).contains(..<1))
        #expect((..<1).contains(..<1))
        #expect((..<2).contains(..<1))
        
        // edge cases
        
        #expect(!(..<Int.min).contains(..<1))
        #expect((..<Int.max).contains(..<1))
        #expect((..<Int.min).contains(..<Int.min))
        #expect(!(..<Int.min).contains(..<Int.max))
        #expect((..<Int.max).contains(..<Int.min))
        #expect((..<Int.max).contains(..<Int.max))
    }
    
    @Test
    func number_ClampedTo_Ranges() {
        // .clamped(ClosedRange)
        
        #expect(5.clamped(to: 7 ... 10) == 7)
        #expect(8.clamped(to: 7 ... 10) == 8)
        #expect(20.clamped(to: 7 ... 10) == 10)
        
        #expect(5.0.clamped(to: 7.0 ... 10.0) == 7.0)
        #expect(8.0.clamped(to: 7.0 ... 10.0) == 8.0)
        #expect(20.0.clamped(to: 7.0 ... 10.0) == 10.0)
        
        #expect("a".clamped(to: "b" ... "h") == "b")
        #expect("c".clamped(to: "b" ... "h") == "c")
        #expect("k".clamped(to: "b" ... "h") == "h")
        
        // .clamped(Range)
        
        #expect(5.clamped(to: 7 ..< 10) == 7)
        #expect(8.clamped(to: 7 ..< 10) == 8)
        #expect(20.clamped(to: 7 ..< 10) == 9)
        
        // .clamped(PartialRangeFrom)
        
        #expect(5.clamped(to: 300...) == 300)
        #expect(400.clamped(to: 300...) == 400)
        
        #expect(5.0.clamped(to: 300.00...) == 300.0)
        #expect(400.0.clamped(to: 300.00...) == 400.0)
        
        #expect("a".clamped(to: "b"...) == "b")
        #expect("g".clamped(to: "b"...) == "g")
        
        // .clamped(PartialRangeThrough)
        
        #expect(200.clamped(to: ...300) == 200)
        #expect(400.clamped(to: ...300) == 300)
        
        #expect(200.0.clamped(to: ...300.0) == 200.0)
        #expect(400.0.clamped(to: ...300.0) == 300.0)
        
        #expect("a".clamped(to: ..."h") == "a")
        #expect("k".clamped(to: ..."h") == "h")
        
        // .clamped(PartialRangeUpTo)
        
        #expect(200.clamped(to: ..<300) == 200)
        #expect(400.clamped(to: ..<300) == 299)
    }
    
    @Test
    func firstExcluding_ClosedRange() {
        // .first(excluding:) Generic Tests
        #expect((0 ... 10).first(excluding: [2, 5]) == 0)
        #expect((0 ... 10).first(excluding: [0, 2, 5]) == 1)
        
        #expect((0 ... 10).first(excluding: 0 ... 0) == 1)
        #expect((0 ... 10).first(excluding: 2 ... 5) == 0)
        #expect((0 ... 10).first(excluding: 0 ... 5) == 6)
        
        #expect((0 ... 10).first(excluding: 2 ..< 5) == 0)
        #expect((0 ... 10).first(excluding: 0 ..< 5) == 5)
        
        #expect((0 ... 10).first(excluding: 2...) == 0)
        #expect((0 ... 10).first(excluding: 0...) == nil)
        
        #expect((0 ... 10).first(excluding: ...0) == 1)
        #expect((0 ... 10).first(excluding: ...10) == nil)
        
        #expect((0 ... 10).first(excluding: ..<0) == 0)
        #expect((0 ... 10).first(excluding: ..<10) == 10)
        #expect((0 ... 10).first(excluding: ..<11) == nil)
        
        // .first(excluding: [])
        #expect((1 ... 10).first(excluding: []) == 1)
        #expect((1 ... 10).first(excluding: [-1]) == 1)
        #expect((1 ... 10).first(excluding: [1]) == 2)
        #expect((1 ... 10).first(excluding: [5, 1, 2]) == 3)
        #expect((1 ... 10).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]) == 10)
        #expect((1 ... 10).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]) == 10)
        #expect((1 ... 10).first(excluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]) == nil)
        
        // first(presortedExcluding: [])
        #expect((1 ... 10).first(presortedExcluding: []) == 1)
        #expect((1 ... 10).first(presortedExcluding: [-1]) == 1)
        #expect((1 ... 10).first(presortedExcluding: [1]) == 2)
        #expect((1 ... 10).first(presortedExcluding: [1, 2]) == 3)
        #expect((1 ... 10).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9]) == 10)
        #expect((1 ... 10).first(presortedExcluding: [-1, 1, 2, 3, 4, 5, 6, 7, 8, 9]) == 10)
        #expect((1 ... 10).first(presortedExcluding: [1, 2, 3, 4, 6, 7, 9, 8, 10]) == 5)
        #expect((1 ... 10).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) == nil)
        
        // .first(sortingAndExcluding: [])
        #expect((1 ... 10).first(sortingAndExcluding: []) == 1)
        #expect((1 ... 10).first(sortingAndExcluding: [-1]) == 1)
        #expect((1 ... 10).first(sortingAndExcluding: [1]) == 2)
        #expect((1 ... 10).first(sortingAndExcluding: [2]) == 1)
        #expect((1 ... 10).first(sortingAndExcluding: [5, 1, 2]) == 3)
        #expect((1 ... 10).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]) == 10)
        #expect((1 ... 10).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]) == 10)
        #expect((1 ... 10).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]) == nil)
        #expect((1 ... 200).first(sortingAndExcluding: Array(-10 ... 150)) == 151)
        #expect((1 ... 1000).first(sortingAndExcluding: Array(-10 ... 999)) == 1000)
        #expect((1 ... 1000).first(sortingAndExcluding: Array(-10 ... 1100)) == nil)
        #expect((10 ... 20).first(sortingAndExcluding: [15, 11, 10, 12, 14, 13, 19, 17, 18, 16, 9, 8, 7]) == 20)
        
        // .first(excluding: ClosedRange)
        #expect((1 ... 10000).first(excluding: 10000 ... 12000) == 1)
        #expect((1 ... 10000).first(excluding: (-12000) ... (-10000)) == 1)
        
        #expect((1 ... 10000).first(excluding: -1 ... (-1)) == 1)
        #expect((1 ... 10000).first(excluding: -1 ... 0) == 1)
        #expect((1 ... 10000).first(excluding: -1 ... 1) == 2)
        #expect((1 ... 10000).first(excluding: -1 ... 2) == 3)
        #expect((1 ... 10000).first(excluding: -1 ... 3) == 4)
        
        #expect((1 ... 10000).first(excluding:  0 ... 0) == 1)
        #expect((1 ... 10000).first(excluding:  0 ... 1) == 2)
        #expect((1 ... 10000).first(excluding:  0 ... 2) == 3)
        #expect((1 ... 10000).first(excluding:  0 ... 3) == 4)
        
        #expect((1 ... 10000).first(excluding:  1 ... 1) == 2)
        #expect((1 ... 10000).first(excluding:  1 ... 2) == 3)
        #expect((1 ... 10000).first(excluding:  1 ... 3) == 4)
        
        #expect((1 ... 10000).first(excluding:  2 ... 2) == 1)
        #expect((1 ... 10000).first(excluding:  2 ... 3) == 1)
        
        #expect((1 ... 10000).first(excluding:  3 ... 3) == 1)
        
        #expect((1 ... 10000).first(excluding:  1 ... 9999) == 10000)
        #expect((1 ... 10000).first(excluding:  1 ... 10000) == nil)
        #expect((1 ... 10000).first(excluding:  2 ... 9999) == 1)
        
        // .first(excluding: Range)
        #expect((1 ... 10000).first(excluding: 10000 ..< 12000) == 1)
        #expect((1 ... 10000).first(excluding: (-12000) ..< (-10000)) == 1)
        
        #expect((1 ... 10000).first(excluding: -1 ..< (-1)) == 1)
        #expect((1 ... 10000).first(excluding: -1 ..< 0) == 1)
        #expect((1 ... 10000).first(excluding: -1 ..< 1) == 1)
        #expect((1 ... 10000).first(excluding: -1 ..< 2) == 2)
        #expect((1 ... 10000).first(excluding: -1 ..< 3) == 3)
        
        #expect((1 ... 10000).first(excluding:  0 ..< 0) == 1)
        #expect((1 ... 10000).first(excluding:  0 ..< 1) == 1)
        #expect((1 ... 10000).first(excluding:  0 ..< 2) == 2)
        #expect((1 ... 10000).first(excluding:  0 ..< 3) == 3)
        
        #expect((1 ... 10000).first(excluding:  1 ..< 1) == 1)
        #expect((1 ... 10000).first(excluding:  1 ..< 2) == 2)
        #expect((1 ... 10000).first(excluding:  1 ..< 3) == 3)
        
        #expect((1 ... 10000).first(excluding:  2 ..< 2) == 1)
        #expect((1 ... 10000).first(excluding:  2 ..< 3) == 1)
        
        #expect((1 ... 10000).first(excluding:  3 ..< 3) == 1)
        
        #expect((1 ... 10000).first(excluding:  1 ..< 9999) == 9999)
        #expect((1 ... 10000).first(excluding:  1 ..< 10000) == 10000)
        #expect((1 ... 10000).first(excluding:  1 ..< 10001) == nil)
        #expect((1 ... 10000).first(excluding:  2 ..< 9999) == 1)
        
        // .first(excluding: PartialRangeFrom)
        #expect((1 ... 10000).first(excluding:  9999...) == 1)
        #expect((1 ... 10000).first(excluding: 10000...) == 1)
        #expect((1 ... 10000).first(excluding: 10001...) == 1)
        #expect((1 ... 10000).first(excluding: (-1)...) == nil)
        #expect((1 ... 10000).first(excluding: 0...) == nil)
        #expect((1 ... 10000).first(excluding: 1...) == nil)
        #expect((1 ... 10000).first(excluding: 2...) == 1)
        
        // .first(excluding: PartialRangeThrough)
        #expect((1 ... 10000).first(excluding: ...9998) == 9999)
        #expect((1 ... 10000).first(excluding: ...9999) == 10000)
        #expect((1 ... 10000).first(excluding: ...10000) == nil)
        #expect((1 ... 10000).first(excluding: ...10001) == nil)
        #expect((1 ... 10000).first(excluding: ...(-1)) == 1)
        #expect((1 ... 10000).first(excluding: ...0) == 1)
        #expect((1 ... 10000).first(excluding: ...1) == 2)
        #expect((1 ... 10000).first(excluding: ...2) == 3)
        
        // .first(excluding: PartialRangeUpTo)
        #expect((1 ... 10000).first(excluding: ..<9999) == 9999)
        #expect((1 ... 10000).first(excluding: ..<10000) == 10000)
        #expect((1 ... 10000).first(excluding: ..<10001) == nil)
        #expect((1 ... 10000).first(excluding: ..<(-1)) == 1)
        #expect((1 ... 10000).first(excluding: ..<0) == 1)
        #expect((1 ... 10000).first(excluding: ..<1) == 1)
        #expect((1 ... 10000).first(excluding: ..<2) == 2)
        
        // these integers result in overflow on armv7/i386 (32-bit arch)
        #if !(arch(arm) || arch(arm64_32) || arch(i386))
        // very large ranges
        #expect((1 ... 10_000_000_000).first(excluding: [1]) == 2)
        #endif
        
        // zero element ranges
        #expect((0 ... 0).first(excluding: 0 ... 5) == nil)
    }
    
    @Test
    func firstExcluding_Range() {
        // .first(excluding:) Generic Tests
        
        #expect((0 ..< 10).first(excluding: [2, 5]) == 0)
        #expect((0 ..< 10).first(excluding: [0, 2, 5]) == 1)
        
        #expect((0 ..< 10).first(excluding: 0 ... 0) == 1)
        #expect((0 ..< 10).first(excluding: 2 ... 5) == 0)
        #expect((0 ..< 10).first(excluding: 0 ... 5) == 6)
        
        #expect((0 ..< 10).first(excluding: 2 ..< 5) == 0)
        #expect((0 ..< 10).first(excluding: 0 ..< 5) == 5)
        
        #expect((0 ..< 10).first(excluding: 2...) == 0)
        #expect((0 ..< 10).first(excluding: 0...) == nil)
        
        #expect((0 ..< 10).first(excluding: ...0) == 1)
        #expect((0 ..< 10).first(excluding: ...10) == nil)
        
        #expect((0 ..< 10).first(excluding: ..<0) == 0)
        #expect((0 ..< 10).first(excluding: ..<9) == 9)
        #expect((0 ..< 10).first(excluding: ..<10) == nil)
        
        // .first(excluding: [])
        #expect((1 ..< 10).first(excluding: []) == 1)
        #expect((1 ..< 10).first(excluding: [-1]) == 1)
        #expect((1 ..< 10).first(excluding: [1]) == 2)
        #expect((1 ..< 10).first(excluding: [5, 1, 2]) == 3)
        #expect((1 ..< 11).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]) == 10)
        #expect((1 ..< 11).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]) == 10)
        #expect((1 ..< 11).first(excluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]) == nil)
        
        // first(presortedExcluding: [])
        #expect((1 ..< 11).first(presortedExcluding: []) == 1)
        #expect((1 ..< 11).first(presortedExcluding: [-1]) == 1)
        #expect((1 ..< 11).first(presortedExcluding: [1]) == 2)
        #expect((1 ..< 11).first(presortedExcluding: [1, 2]) == 3)
        #expect((1 ..< 11).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9]) == 10)
        #expect((1 ..< 11).first(presortedExcluding: [-1, 1, 2, 3, 4, 5, 6, 7, 8, 9]) == 10)
        #expect((1 ..< 11).first(presortedExcluding: [1, 2, 3, 4, 6, 7, 9, 8, 10]) == 5)
        #expect((1 ..< 11).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) == nil)
        
        // .first(sortingAndExcluding: [])
        #expect((1 ..< 10).first(sortingAndExcluding: []) == 1)
        #expect((1 ..< 10).first(sortingAndExcluding: [-1]) == 1)
        #expect((1 ..< 10).first(sortingAndExcluding: [1]) == 2)
        #expect((1 ..< 10).first(sortingAndExcluding: [5, 1, 2]) == 3)
        #expect((1 ..< 11).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]) == 10)
        #expect((1 ..< 11).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]) == 10)
        #expect((1 ..< 11).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]) == nil)
        #expect((1 ..< 200).first(sortingAndExcluding: Array(-10 ... 150)) == 151)
        #expect((1 ..< 1001).first(sortingAndExcluding: Array(-10 ... 999)) == 1000)
        #expect((1 ..< 1000).first(sortingAndExcluding: Array(-10 ... 1100)) == nil)
        #expect((10 ..< 21).first(sortingAndExcluding: [15, 11, 10, 12, 14, 13, 19, 17, 18, 16, 9, 8, 7]) == 20)
        
        // .first(excluding: ClosedRange)
        #expect((1 ..< 10000).first(excluding: 9999 ... 12000) == 1)
        #expect((1 ..< 10000).first(excluding: (-12000) ... (-10000)) == 1)
        
        #expect((1 ..< 10000).first(excluding: -1 ... (-1)) == 1)
        #expect((1 ..< 10000).first(excluding: -1 ... 0) == 1)
        #expect((1 ..< 10000).first(excluding: -1 ... 1) == 2)
        #expect((1 ..< 10000).first(excluding: -1 ... 2) == 3)
        #expect((1 ..< 10000).first(excluding: -1 ... 3) == 4)
        
        #expect((1 ..< 10000).first(excluding:  0 ... 0) == 1)
        #expect((1 ..< 10000).first(excluding:  0 ... 1) == 2)
        #expect((1 ..< 10000).first(excluding:  0 ... 2) == 3)
        #expect((1 ..< 10000).first(excluding:  0 ... 3) == 4)
        
        #expect((1 ..< 10000).first(excluding:  1 ... 1) == 2)
        #expect((1 ..< 10000).first(excluding:  1 ... 2) == 3)
        #expect((1 ..< 10000).first(excluding:  1 ... 3) == 4)
        
        #expect((1 ..< 10000).first(excluding:  2 ... 2) == 1)
        #expect((1 ..< 10000).first(excluding:  2 ... 3) == 1)
        
        #expect((1 ..< 10000).first(excluding:  3 ... 3) == 1)
        
        #expect((1 ..< 10000).first(excluding:  1 ... 9998) == 9999)
        #expect((1 ..< 10000).first(excluding:  1 ... 9999) == nil)
        #expect((1 ..< 10000).first(excluding:  2 ... 9999) == 1)
        
        // .first(excluding: Range)
        #expect((1 ..< 10000).first(excluding: 9999 ..< 12000) == 1)
        #expect((1 ..< 10000).first(excluding: (-12000) ..< (-10000)) == 1)
        
        #expect((1 ..< 10000).first(excluding: -1 ..< (-1)) == 1)
        #expect((1 ..< 10000).first(excluding: -1 ..< 0) == 1)
        #expect((1 ..< 10000).first(excluding: -1 ..< 1) == 1)
        #expect((1 ..< 10000).first(excluding: -1 ..< 2) == 2)
        #expect((1 ..< 10000).first(excluding: -1 ..< 3) == 3)
        
        #expect((1 ..< 10000).first(excluding:  0 ..< 0) == 1)
        #expect((1 ..< 10000).first(excluding:  0 ..< 1) == 1)
        #expect((1 ..< 10000).first(excluding:  0 ..< 2) == 2)
        #expect((1 ..< 10000).first(excluding:  0 ..< 3) == 3)
        
        #expect((1 ..< 10000).first(excluding:  1 ..< 1) == 1)
        #expect((1 ..< 10000).first(excluding:  1 ..< 2) == 2)
        #expect((1 ..< 10000).first(excluding:  1 ..< 3) == 3)
        
        #expect((1 ..< 10000).first(excluding:  2 ..< 2) == 1)
        #expect((1 ..< 10000).first(excluding:  2 ..< 3) == 1)
        
        #expect((1 ..< 10000).first(excluding:  3 ..< 3) == 1)
        
        #expect((1 ..< 10000).first(excluding:  1 ..< 9998) == 9998)
        #expect((1 ..< 10000).first(excluding:  1 ..< 9999) == 9999)
        #expect((1 ..< 10000).first(excluding:  1 ..< 10000) == nil)
        #expect((1 ..< 10000).first(excluding:  2 ..< 9999) == 1)
        
        // .first(excluding: PartialRangeFrom)
        #expect((1 ..< 10000).first(excluding:  9998...) == 1)
        #expect((1 ..< 10000).first(excluding:  9999...) == 1)
        #expect((1 ..< 10000).first(excluding: 10000...) == 1)
        #expect((1 ..< 10000).first(excluding:  (-1)...) == nil)
        #expect((1 ..< 10000).first(excluding:     0...) == nil)
        #expect((1 ..< 10000).first(excluding:     1...) == nil)
        #expect((1 ..< 10000).first(excluding:     2...) == 1)
        
        // .first(excluding: PartialRangeThrough)
        #expect((1 ..< 10000).first(excluding: ...9997) == 9998)
        #expect((1 ..< 10000).first(excluding: ...9998) == 9999)
        #expect((1 ..< 10000).first(excluding: ...9999) == nil)
        #expect((1 ..< 10000).first(excluding: ...10000) == nil)
        #expect((1 ..< 10000).first(excluding: ...(-1)) == 1)
        #expect((1 ..< 10000).first(excluding: ...0) == 1)
        #expect((1 ..< 10000).first(excluding: ...1) == 2)
        #expect((1 ..< 10000).first(excluding: ...2) == 3)
        
        // .first(excluding: PartialRangeUpTo)
        #expect((1 ..< 10000).first(excluding: ..<9998) == 9998)
        #expect((1 ..< 10000).first(excluding: ..<9999) == 9999)
        #expect((1 ..< 10000).first(excluding: ..<10000) == nil)
        #expect((1 ..< 10000).first(excluding: ..<10001) == nil)
        #expect((1 ..< 10000).first(excluding: ..<(-1)) == 1)
        #expect((1 ..< 10000).first(excluding: ..<0) == 1)
        #expect((1 ..< 10000).first(excluding: ..<1) == 1)
        #expect((1 ..< 10000).first(excluding: ..<2) == 2)
        
        // these integers result in overflow on armv7/i386 (32-bit arch)
        #if !(arch(arm) || arch(arm64_32) || arch(i386))
        // very large ranges
        #expect((1 ..< 10_000_000_000).first(excluding: [1]) == 2)
        #endif
        
        // zero element ranges
        #expect((0 ..< 0).first(excluding: 0 ... 5) == nil)
    }
    
    @Test
    func firstExcluding_PartialRangeFrom() {
        // .first(excluding: [])
        #expect((1...).first(excluding: []) == 1)
        #expect((1...).first(excluding: [-1]) == 1)
        #expect((1...).first(excluding: [1]) == 2)
        #expect((1...).first(excluding: [5, 1, 2]) == 3)
        #expect((1...).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]) == 10)
        #expect((1...).first(excluding: [5, 1, 2, 4, 3, 9, 7, 8, 6, -1]) == 10)
        #expect((1...).first(excluding: [5, 2, 4, 3, 9, 10, 7, 8, 6]) == 1)
        
        // first(presortedExcluding: [])
        #expect((1...).first(presortedExcluding: []) == 1)
        #expect((1...).first(presortedExcluding: [-1]) == 1)
        #expect((1...).first(presortedExcluding: [1]) == 2)
        #expect((1...).first(presortedExcluding: [1, 2]) == 3)
        #expect((1...).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9]) == 10)
        #expect((1...).first(presortedExcluding: [-1, 1, 2, 3, 4, 5, 6, 7, 8, 9]) == 10)
        #expect((1...).first(presortedExcluding: [1, 2, 3, 4, 6, 7, 9, 8, 10]) == 5)
        #expect((1...).first(presortedExcluding: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) == 11)
        
        // .first(sortingAndExcluding: [])
        #expect((1...).first(sortingAndExcluding: []) == 1)
        #expect((1...).first(sortingAndExcluding: [-1]) == 1)
        #expect((1...).first(sortingAndExcluding: [1]) == 2)
        #expect((1...).first(sortingAndExcluding: [5, 1, 2]) == 3)
        #expect((1...).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 8, 6]) == 10)
        #expect((1...).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 7, 6, -1]) == 8)
        #expect((1...).first(sortingAndExcluding: [5, 1, 2, 4, 3, 9, 10, 7, 8, 6]) == 11)
        #expect((1...).first(sortingAndExcluding: Array(-10 ... 150)) == 151)
        #expect((1...).first(sortingAndExcluding: Array(-10 ... 999)) == 1000)
        #expect((10...).first(sortingAndExcluding: [15, 11, 10, 12, 14, 13, 16, 9, 8, 7]) == 17)
        
        // .first(excluding: ClosedRange)
        #expect((1...).first(excluding: -3 ... (-1)) == 1)
        #expect((1...).first(excluding: -3 ... 0) == 1)
        #expect((1...).first(excluding: -3 ... 1) == 2)
        #expect((1...).first(excluding:  1 ... 1) == 2)
        #expect((1...).first(excluding:  1 ... 1000) == 1001)
        #expect((1...).first(excluding:  2 ... 1000) == 1)
        
        // .first(excluding: Range)
        #expect((1...).first(excluding: -3 ..< (-1)) == 1)
        #expect((1...).first(excluding: -3 ..< 0) == 1)
        #expect((1...).first(excluding: -3 ..< 1) == 1)
        #expect((1...).first(excluding: -3 ..< 2) == 2)
        #expect((1...).first(excluding:  1 ..< 1) == 1)
        #expect((1...).first(excluding:  1 ..< 2) == 2)
        #expect((1...).first(excluding:  1 ..< 1000) == 1000)
        #expect((1...).first(excluding:  2 ..< 1000) == 1)
        
        // .first(excluding: PartialRangeFrom)
        #expect((1...).first(excluding: 100...) == 1)
        #expect((1...).first(excluding: (-1)...) == nil)
        #expect((1...).first(excluding: 0...) == nil)
        #expect((1...).first(excluding: 1...) == nil)
        #expect((1...).first(excluding: 2...) == 1)
        #expect((1...).first(excluding: 3...) == 1)
        
        // .first(excluding: PartialRangeThrough)
        #expect((1...).first(excluding: ...100) == 101)
        #expect((1...).first(excluding: ...(-1)) == 1)
        #expect((1...).first(excluding: ...0) == 1)
        #expect((1...).first(excluding: ...1) == 2)
        #expect((1...).first(excluding: ...2) == 3)
        #expect((1...).first(excluding: ...3) == 4)
        
        // .first(excluding: PartialRangeUpTo)
        #expect((1...).first(excluding: ..<100) == 100)
        #expect((1...).first(excluding: ..<(-1)) == 1)
        #expect((1...).first(excluding: ..<0) == 1)
        #expect((1...).first(excluding: ..<1) == 1)
        #expect((1...).first(excluding: ..<2) == 2)
        #expect((1...).first(excluding: ..<3) == 3)
    }
    
    @Test
    func closedRange_SplitEvery() {
        #expect((0 ... 10).split(every: -1) == [0 ... 10])
        #expect((0 ... 10).split(every: 0) == [0 ... 10])
        #expect(
            (0 ... 10).split(every: 1)
                == [0 ... 0, 1 ... 1, 2 ... 2, 3 ... 3, 4 ... 4, 5 ... 5, 6 ... 6, 7 ... 7, 8 ... 8, 9 ... 9, 10 ... 10]
        )
        #expect((0 ... 10).split(every: 2) == [0 ... 1, 2 ... 3, 4 ... 5, 6 ... 7, 8 ... 9, 10 ... 10])
        #expect((0 ... 10).split(every: 3) == [0 ... 2, 3 ... 5, 6 ... 8, 9 ... 10])
        #expect((0 ... 10).split(every: 4) == [0 ... 3, 4 ... 7, 8 ... 10])
        #expect((0 ... 10).split(every: 5) == [0 ... 4, 5 ... 9, 10 ... 10])
        #expect((0 ... 10).split(every: 10) == [0 ... 9, 10 ... 10])
        #expect((0 ... 10).split(every: 11) == [0 ... 10])
        #expect((0 ... 10).split(every: 12) == [0 ... 10])
    }
    
    @Test
    func range_SplitEvery() {
        #expect((0 ..< 11).split(every: -1) == [0 ... 10])
        #expect((0 ..< 11).split(every:  0) == [0 ... 10])
        #expect(
            (0 ..< 11).split(every:  1)
                == [0 ... 0, 1 ... 1, 2 ... 2, 3 ... 3, 4 ... 4, 5 ... 5, 6 ... 6, 7 ... 7, 8 ... 8, 9 ... 9, 10 ... 10]
        )
        #expect((0 ..< 11).split(every:  2) == [0 ... 1, 2 ... 3, 4 ... 5, 6 ... 7, 8 ... 9, 10 ... 10])
        #expect((0 ..< 11).split(every:  3) == [0 ... 2, 3 ... 5, 6 ... 8, 9 ... 10])
        #expect((0 ..< 11).split(every:  4) == [0 ... 3, 4 ... 7, 8 ... 10])
        #expect((0 ..< 11).split(every:  5) == [0 ... 4, 5 ... 9, 10 ... 10])
        #expect((0 ..< 11).split(every: 10) == [0 ... 9, 10 ... 10])
        #expect((0 ..< 11).split(every: 11) == [0 ... 10])
        #expect((0 ..< 11).split(every: 12) == [0 ... 10])
    }
    
    @Test
    func absoluteBounds() {
        func bounds<R: RangeExpression>(of r: R) -> (min: R.Bound?, max: R.Bound?) where R.Bound: Strideable {
            r.getAbsoluteBounds()
        }
        
        // ClosedRange
        #expect(bounds(of:  0 ... 0).min == 0)
        #expect(bounds(of:  0 ... 0).max == 0)
        #expect(bounds(of:  0 ... 1).min == 0)
        #expect(bounds(of:  0 ... 1).max == 1)
        #expect(bounds(of: -1 ... 1).min == -1)
        #expect(bounds(of: -1 ... 1).max == 1)
        
        // Range
        #expect(bounds(of:  0 ..< 0).min == nil)
        #expect(bounds(of:  0 ..< 0).max == nil)
        #expect(bounds(of: -1 ..< 0).min == -1)
        #expect(bounds(of: -1 ..< 0).max == -1)
        #expect(bounds(of: -1 ..< 1).min == -1)
        #expect(bounds(of: -1 ..< 1).max == 0)
        
        // PartialRangeFrom
        #expect(bounds(of:    0...).min == 0)
        #expect(bounds(of:    0...).max == nil)
        #expect(bounds(of: (-1)...).min == -1)
        #expect(bounds(of: (-1)...).max == nil)
        #expect(bounds(of:    1...).min == 1)
        #expect(bounds(of:    1...).max == nil)
        
        // PartialRangeUpTo
        #expect(bounds(of:   ..<0).min == nil)
        #expect(bounds(of:   ..<0).max == -1)
        #expect(bounds(of: ..<(-1)).min == nil)
        #expect(bounds(of: ..<(-1)).max == -2)
        #expect(bounds(of:   ..<1).min == nil)
        #expect(bounds(of:   ..<1).max == 0)
        #expect(bounds(of:   ..<2).min == nil)
        #expect(bounds(of:   ..<2).max == 1)
        
        // PartialRangeThrough
        #expect(bounds(of:   ...0).min == nil)
        #expect(bounds(of:   ...0).max == 0)
        #expect(bounds(of: ...(-1)).min == nil)
        #expect(bounds(of: ...(-1)).max == -1)
        #expect(bounds(of:   ...1).min == nil)
        #expect(bounds(of:   ...1).max == 1)
    }
    
    @Test
    func binaryIntegerRepeatEach() {
        // basic functionality
        
        var count = 0
        5.repeatEach { count += 1 }
        #expect(count == 5)
        
        // edge cases
        
        count = 0
        (-1).repeatEach { count += 1 }
        #expect(count == 0)                // only iterates on values > 0
    }
    
    @Test
    func closedRangeRepeatEach() {
        var count = 0
        (1 ... 5).repeatEach { count += 1 }
        #expect(count == 5)
        
        // edge cases
        
        count = 0
        (1 ... 1).repeatEach { count += 1 }       // single member range
        #expect(count == 1)
        
        count = 0
        ((-5) ... (-1)).repeatEach { count += 1 } // doesn't matter if bounds are negative
        #expect(count == 5)
    }
    
    @Test
    func rangeRepeatEach() {
        var count = 0
        (1 ..< 5).repeatEach { count += 1 }
        #expect(count == 4)
        
        // edge cases
        
        count = 0
        (1 ..< 1).repeatEach { count += 1 }       // no-member range
        #expect(count == 0)
        
        count = 0
        ((-5) ..< (-1)).repeatEach { count += 1 } // doesn't matter if bounds are negative
        #expect(count == 4)
    }
}
