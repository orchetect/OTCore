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
    @Test
    func filePath_asURL() async {
        #expect(FilePath("/").asURL().path(percentEncoded: false) == "/")
        
        #expect(FilePath("/Users").asURL().path(percentEncoded: false) == "/Users")
        #expect(FilePath("/Users/").asURL().path(percentEncoded: false) == "/Users")
        
        #expect(FilePath("/Users/user/text.txt").asURL().path(percentEncoded: false) == "/Users/user/text.txt")
    }
}

#endif
