//
//  String Sanitize Path Component Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OTCore
import Testing

@Suite
struct Abstractions_StringSanitizePathComponent_Tests {
    // @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @Test(arguments: [nil, .hfsPlus, .apfs] as [FileSystemFormat?])
    func sanitizingFilename(fileSystem: FileSystemFormat?) {
        let fs: [FileSystemFormat]? = fileSystem != nil ? [fileSystem!] : nil
        
        // path component string
        #expect("".sanitizingPathComponent(for: fs, replacement: "-") == "")
        #expect("Test/File.txt".sanitizingPathComponent(for: fs, replacement: "-") == "Test-File.txt")
        #expect("Test//File.txt".sanitizingPathComponent(for: fs, replacement: "-") == "Test--File.txt")
        #expect("TestFile\0.txt".sanitizingPathComponent(for: fs, replacement: "-") == "TestFile-.txt")
        #expect("Test/File\0.txt".sanitizingPathComponent(for: fs, replacement: "-") == "Test-File-.txt")
        #expect("Test:File.txt".sanitizingPathComponent(for: fs, replacement: "-") == "Test-File.txt")
        
        // url last path component
        #expect(
            URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("")
                .sanitizingLastPathComponent(for: fs, replacement: "-")
                .path
            == "/Folder"
        )
        #expect(
            URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("Test/File.txt") // URL interprets `/` as a path delimiter
                .sanitizingLastPathComponent(for: fs, replacement: "-")
                .path
            == "/Folder/Test/File.txt"
        )
        
        do {
            let url = URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("Test//File.txt") // URL interprets `//` as a single path delimiter
            #expect(url.pathComponents == ["/", "Folder", "Test", "File.txt"])
            #expect(url.lastPathComponent == "File.txt")
            let sanitizedURL = url.sanitizingLastPathComponent(for: fs, replacement: "-")
            #expect(sanitizedURL.pathComponents == ["/", "Folder", "Test", "File.txt"])
            #expect(sanitizedURL.lastPathComponent == "File.txt")
            if URL.preservesSequentialSeparators {
                #expect(sanitizedURL.path == "/Folder/Test//File.txt")
            } else {
                #expect(sanitizedURL.path == "/Folder/Test/File.txt")
            }
        }
        
        do {
            let url = URL(fileURLWithPath: "/Folder/Test//File.txt") // URL interprets `//` as a single path delimiter
            #expect(url.pathComponents == ["/", "Folder", "Test", "File.txt"])
            #expect(url.lastPathComponent == "File.txt")
            let sanitizedURL = url.sanitizingLastPathComponent(for: fs, replacement: "-")
            #expect(sanitizedURL.pathComponents == ["/", "Folder", "Test", "File.txt"])
            #expect(sanitizedURL.lastPathComponent == "File.txt")
            if URL.preservesSequentialSeparators {
                #expect(sanitizedURL.path == "/Folder/Test//File.txt")
            } else {
                #expect(sanitizedURL.path == "/Folder/Test/File.txt")
            }
        }
        
        // Note: appending a null character to URL will cause a crash
        // #expect(
        //     URL(fileURLWithPath: "/Folder")
        //         .appendingPathComponent("TestFile\0.txt")
        //         .sanitizingLastPathComponent(for: fs, replacement: "-")
        //         .path
        //     == "/Folder/TestFile-.txt"
        // )
        // #expect(
        //     URL(fileURLWithPath: "/Folder")
        //         .appendingPathComponent("Test/File\0.txt")
        //         .sanitizingLastPathComponent(for: fs, replacement: "-")
        //         .path
        //     == "/Folder/Test-File-.txt"
        // )
        
        #expect(
            URL(fileURLWithPath: "/Folder")
                .appendingPathComponent("Test:File.txt")
                .sanitizingLastPathComponent(for: fs, replacement: "-")
                .path
            == "/Folder/Test-File.txt"
        )
    }
}

extension URL {
    // URL has slightly different sequential path separator behavior depending on platform and
    // version
    fileprivate static let preservesSequentialSeparators: Bool = {
        #if os(macOS)
        true
        #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 26, tvOS 26, watchOS 26, visionOS 26, *) {
            false
        } else {
            true
        }
        #endif
    }()
}
