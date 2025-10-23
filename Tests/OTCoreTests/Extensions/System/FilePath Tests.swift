//
//  FilePath Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import Testing
import System

/// Some basic tests for System framework's `FilePath` type and its interop with `URL`.
@Suite struct FilePath_Tests {
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @Test
    func filePath_Equatable_Tests() async throws {
        #expect(FilePath("/") == FilePath("/"))
        
        // one side missing trailing slash
        #expect(FilePath("/Users/user/") == FilePath("/Users/user"))
        
        // does not do implicit path expansion
        #expect(FilePath("/Users/user/") != FilePath("~/user/"))
        
        // case-sensitive
        #expect(FilePath("/Users/user/") != FilePath("/Users/User/"))
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func filePathAndURL_Equatable_Tests() async throws {
        #expect(URL(filePath: FilePath("/")) == URL(filePath: "/"))
        #expect(FilePath("/") == FilePath(URL(filePath: "/")))
        
        // identical, with or without trailing slash
        #expect(FilePath("/Users/user/") == FilePath(URL(filePath: "/Users/user/")))
        #expect(FilePath("/Users/user") == FilePath(URL(filePath: "/Users/user")))
        
        // one side missing trailing slash
        #expect(FilePath("/Users/user/") == FilePath(URL(filePath: "/Users/user")))
        #expect(FilePath("/Users/user") == FilePath(URL(filePath: "/Users/user/")))
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func url_Equatable_Tests() async throws {
        // case-sensitive
        #expect(URL(filePath: "/Users/user/") != URL(filePath: "/Users/User/"))
        
        // identical, with or without trailing slash
        #expect(URL(filePath: "/Users/user/") == URL(filePath: "/Users/user/"))
        #expect(URL(filePath: "/Users/user") == URL(filePath: "/Users/user"))
        
        // one side missing trailing slash
        #expect(URL(filePath: "/Users/user/") != URL(filePath: "/Users/user")) // doesn't know they are both directories without a hint
        #expect(URL(filePath: "/Users/user") != URL(filePath: "/Users/user/")) // doesn't know they are both directories without a hint
        #expect(URL(filePath: "/Users/user/") == URL(filePath: "/Users/user", directoryHint: .isDirectory))
        #expect(URL(filePath: "/Users/user", directoryHint: .isDirectory) == URL(filePath: "/Users/user/"))
    }
}

#endif
