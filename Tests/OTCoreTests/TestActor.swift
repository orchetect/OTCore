//
//  TestActor.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Dedicated actor for concurrency-related unit tests.
@globalActor actor TestActor {
    static let shared = TestActor()
}
