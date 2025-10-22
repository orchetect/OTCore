//
//  FilePath and URL Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation) && canImport(System)

import Foundation
import OTCore
import Testing
import System

@Suite struct Extensions_FilePathAndURL_Tests {
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func filePath_asURL() async {
        #expect(FilePath("/").asURL().path(percentEncoded: false) == "/")
        
        #expect(FilePath("/Users").asURL().path(percentEncoded: false) == "/Users")
        #expect(FilePath("/Users/").asURL().path(percentEncoded: false) == "/Users")
        
        #expect(FilePath("/Users/user/text.txt").asURL().path(percentEncoded: false) == "/Users/user/text.txt")
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test
    func url_asFilePath() async {
        #expect(URL(fileURLWithPath: "/").asFilePath?.string == "/")
        
        #expect(URL(fileURLWithPath: "/Users").asFilePath?.string == "/Users")
        #expect(URL(fileURLWithPath: "/Users/").asFilePath?.string == "/Users")
        
        #expect(URL(fileURLWithPath: "/Users/user/text.txt").asFilePath?.string == "/Users/user/text.txt")
        
        #expect(URL(string: "file:///")?.asFilePath?.string == "/")
        #expect(URL(string: "file:///Users/user/text.txt")?.asFilePath?.string == "/Users/user/text.txt")
        
        // edge cases - non-file URLs
        #expect(URL(string: "https://www.domain.com")?.asFilePath == nil)
        #expect(URL(string: "https://www.domain.com/")?.asFilePath == nil)
        #expect(URL(string: "https://www.domain.com/Users")?.asFilePath == nil)
        #expect(URL(string: "https://www.domain.com/Users/")?.asFilePath == nil)
        #expect(URL(string: "https://www.domain.com/Users/user/text.txt")?.asFilePath == nil)
    }
}

#endif
