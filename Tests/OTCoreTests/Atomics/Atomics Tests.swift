//
//  Atomics Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
@testable import OTCore

class Extensions_Swift_Atomics_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testAtomic() {
        
        // baseline read/write functionality test on a variety of types
        
        class Bar {
            var nonAtomicInt: Int = 100
        }
        
        class Foo {
            @Atomic var bool: Bool = true
            @Atomic var int: Int = 5
            @Atomic var string: String = "a string"
            @Atomic var dict: [String: Int] = ["Key" : 1]
            @Atomic var array: [String] = ["A", "B", "C"]
            @Atomic var barClass = Bar()
        }
        
        let foo = Foo()
        
        // read value
        
        XCTAssertEqual(foo.bool, true)
        XCTAssertEqual(foo.int, 5)
        XCTAssertEqual(foo.string, "a string")
        XCTAssertEqual(foo.dict, ["Key" : 1])
        XCTAssertEqual(foo.array, ["A", "B", "C"])
        XCTAssertEqual(foo.barClass.nonAtomicInt, 100)
        
        // replace value
        
        foo.bool = false
        XCTAssertEqual(foo.bool, false)
        
        foo.int = 10
        XCTAssertEqual(foo.int, 10)
        
        foo.string = "a new string"
        XCTAssertEqual(foo.string, "a new string")
        
        foo.dict = ["KeyA" : 10, "KeyB" : 20]
        XCTAssertEqual(foo.dict, ["KeyA" : 10, "KeyB" : 20])
        
        foo.array = ["1", "2"]
        XCTAssertEqual(foo.array, ["1", "2"])
        
        foo.barClass.nonAtomicInt = 50
        XCTAssertEqual(foo.barClass.nonAtomicInt, 50)
        
        // mutate value (collections)
        
        foo.dict["KeyB"] = 30
        XCTAssertEqual(foo.dict, ["KeyA" : 10, "KeyB" : 30])
        
        foo.array[1] = "3"
        XCTAssertEqual(foo.array, ["1", "3"])
        
    }
    
    func testAtomic_BruteForce_ConcurrentMutations() {
        
        class Foo {
            @Atomic var dict: [String: Int] = [:]
            @Atomic var array: [String] = []
        }
        
        let foo = Foo()
        
        let g = DispatchGroup()
        
        let iterations = 10_000
        
        // append operations
        
        for index in 0..<iterations {
            g.enter()
            DispatchQueue.global().async {
                foo.dict["\(index)"] = index
                foo.array.append("\(index)")
                g.leave()
            }
        }
        
        g.wait()
        
        XCTAssertEqual(foo.dict.count, iterations)
        for index in 0..<iterations {
            XCTAssertEqual(foo.dict["\(index)"], index)
        }
        
        XCTAssertEqual(foo.array.count, iterations)
        
        // remove operations
        
        for index in 0..<iterations {
            g.enter()
            DispatchQueue.global().async {
                foo.dict["\(index)"] = nil
                foo.array.remove(at: 0)
                g.leave()
            }
        }
        
        g.wait()
        
        XCTAssertEqual(foo.dict.count, 0)
        XCTAssertEqual(foo.array.count, 0)
        
    }
    
    /// Write sequential values while reading random values.
    /// This test is more useful with Thread Sanitizer on.
    func testAtomic_BruteForce_ConcurrentWriteRandomReads() {
        
        class Foo {
            @Atomic var dict: [String: Int] = [:]
            @Atomic var array: [String] = []
        }
        
        let readQueue = DispatchQueue(label: "com.orchetect.OTCore.AtomicTest",
                                      qos: .default,
                                      attributes: [],
                                      autoreleaseFrequency: .inherit,
                                      target: nil)
        
        let foo = Foo()
        
        let timer = readQueue.schedule(after: DispatchQueue.SchedulerTimeType(.now()),
                                       interval: .microseconds(1),
                                       tolerance: .zero,
                                       options: nil) {
            // dict read
            if foo.dict.count > 0 {
                let dictIndex = Int.random(in: 0..<foo.dict.count)
                _ = foo.dict["\(dictIndex)"]
            }
            // array read
            if foo.array.count > 0 {
                let arrayIndex = Int.random(in: 0..<foo.array.count)
                _ = foo.array[arrayIndex]
            }
        }
        
        let g = DispatchGroup()
        
        let iterations = 100_000
        
        // append operations
        
        for index in 0..<iterations {
            g.enter()
            DispatchQueue.global().async {
                foo.dict["\(index)"] = index
                foo.array.append("\(index)")
                g.leave()
            }
        }
        
        g.wait()
        
        timer.cancel()
        
    }
    
    /// Write and read sequential values concurrently.
    /// This test is more useful with Thread Sanitizer on.
    func testAtomic_BruteForce_ConcurrentWriteAndRead() {
        
        class Foo {
            @Atomic var dict: [String: Int] = [:]
            @Atomic var array: [String] = []
        }
        
        let foo = Foo()
        foo.dict["key"] = 1
        foo.array.append("1")
        
        let writeGroup = DispatchGroup()
        let readGroup = DispatchGroup()
        
        let iterations = 100_000
        
        DispatchQueue.global().async {
            for index in 0..<iterations {
                writeGroup.enter()
                DispatchQueue.global().async {
                    foo.dict["key"] = index
                    foo.array[0] = "\(index)"
                }
            }
        }
        
        DispatchQueue.global().async {
            for _ in 0..<iterations {
                writeGroup.enter()
                DispatchQueue.global().async {
                    _ = foo.dict["key"]
                    if foo.array.count > 0 { _ = foo.array[0] }
                }
            }
        }
        
        writeGroup.wait()
        readGroup.wait()
        
    }
    
}

#endif
