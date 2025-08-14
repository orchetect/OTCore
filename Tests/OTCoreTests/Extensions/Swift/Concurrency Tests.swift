//
//  Concurrency Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import OTCore
import Testing

@Suite struct Extensions_Swift_Concurrency_Tests {
    @available(macOS 10.15, iOS 13.0.0, watchOS 6.0, tvOS 13.0, *)
    @Test
    func withOrderedTaskGroupClosure() async {
        let input = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        
        let output: [String] = await withOrderedTaskGroup(sequence: input) { element in
            try? await Task.sleep(nanoseconds: UInt64.random(in: 1 ... 10) * 1000)
            return element
        }
        
        #expect(input == output)
    }
    
    @available(macOS 10.15, iOS 13.0.0, watchOS 6.0, tvOS 13.0, *)
    @Test
    func withOrderedThrowingTaskGroupClosure() async throws {
        let input = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        
        let output: [String] = try await withOrderedThrowingTaskGroup(sequence: input) { element in
            try await Task.sleep(nanoseconds: UInt64.random(in: 1 ... 10) * 1000)
            return element
        }
        
        #expect(input == output)
    }
}
