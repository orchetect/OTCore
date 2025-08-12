//
//  ZeroIndexedCollection Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Abstractions_ZeroIndexedCollection_Tests {
    @Test
    func zeroIndexedCollection() {
        let arr = ["A", "B", "C"]
        let filtered = arr.lazy.filter { $0 != "A" }
        
        let coll = ZeroIndexedCollection(filtered)
        
        #expect(!coll.isEmpty)
        #expect(coll.count == 2)
        #expect(coll[0] == "B")
        #expect(coll[1] == "C")
    }
    
    @Test
    func zeroIndexedMutableCollection() {
        var coll = ZeroIndexedMutableCollection(["A", "B", "C"][1...])
        
        #expect(!coll.isEmpty)
        #expect(coll.count == 2)
        
        #expect(coll.first == "B")
        #expect(coll[0] == "B")
        #expect(coll[1] == "C")
        
        // mutate
        
        coll[0] = "X"
        #expect(coll[0] == "X")
        #expect(coll[1] == "C")
        
        coll[1] = "Y"
        #expect(coll[0] == "X")
        #expect(coll[1] == "Y")
        
        coll.swapAt(0, 1)
        #expect(coll[0] == "Y")
        #expect(coll[1] == "X")
        
        #expect(coll.first == "Y")
        #expect(coll.firstIndex(of: "X") == 1)
    }
    
    @Test
    func zeroIndexedRangeReplaceableCollection() {
        var coll = ZeroIndexedRangeReplaceableCollection(["A", "B", "C", "D", "E"][1...])
        
        #expect(!coll.isEmpty)
        #expect(coll.count == 4)
        
        #expect(coll.first == "B")
        #expect(coll[0] == "B")
        #expect(coll[1] == "C")
        #expect(coll[2] == "D")
        #expect(coll[3] == "E")
        
        // mutate
        
        coll.replaceSubrange(1 ..< 3, with: ["X", "Y"])
        #expect(coll.count == 4)
        #expect(coll[0] == "B")
        #expect(coll[1] == "X")
        #expect(coll[2] == "Y")
        #expect(coll[3] == "E")
        
        coll.replaceSubrange(1 ..< 3, with: ["J", "K", "L"])
        #expect(coll.count == 5)
        #expect(coll[0] == "B")
        #expect(coll[1] == "J")
        #expect(coll[2] == "K")
        #expect(coll[3] == "L")
        #expect(coll[4] == "E")
    }
}
