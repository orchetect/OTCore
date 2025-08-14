//
//  URL Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing
import TestingExtensions

@Suite struct Extensions_Foundation_URL_Tests {
    @Test
    func hasPrefixURL() {
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/"))
        )
        
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/"))
        )
        
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/"))
        )
        
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/file.txt"))
        )
        
        // different path
        
        #expect(
            !URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/wrong/"))
        )
        
        // different schemes (ie: file:// vs. https://)
        
        #expect(
            !URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(string: "https://temp1/temp2/file.txt")!)
        )
        
        #expect(
            !URL(string: "https://temp1/temp2/file.txt")!
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/file.txt"))
        )
        
        #expect(
            !URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(string: "https://somehost/temp1/temp2/file.txt")!)
        )
        
        #expect(
            !URL(string: "https://somehost/temp1/temp2/file.txt")!
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/file.txt"))
        )
    }
    
    @Test
    func hasPathComponentsPrefix() {
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/").pathComponents)
        )
        
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/temp1/").pathComponents)
        )
        
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/temp1/temp2/").pathComponents)
        )
        
        #expect(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(
                    prefix: URL(fileURLWithPath: "/temp1/temp2/file.txt")
                        .pathComponents
                )
        )
        
        // different path
        #expect(
            !URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/wrong/").pathComponents)
        )
        
        // different path
        #expect(
            !URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(
                    prefix: URL(fileURLWithPath: "/temp1/temp2/otherfile.txt")
                        .pathComponents
                )
        )
        
        // temp1 is hostname in https here, not part of path
        #expect(
            !URL(string: "file:///temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "https://temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // temp1 is hostname in https here, not part of path
        #expect(
            !URL(string: "https://temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "file:///temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // different hosts, same paths
        #expect(
            URL(string: "https://somehost1.com/temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "https://somehost2.com/temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // different hosts with authentication and port numbers, same paths
        #expect(
            URL(string: "https://user:pass@somehost1.com:8080/temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "https://somehost2.com/temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // different schemes (ie: file:// vs. https://)
        #expect(
            URL(string: "https://somehost.com/temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "file:///temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
    }
    
    @Test
    func pathComponentsRemovingBase() {
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp1/temp2/file.txt")!)
                == []
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp1/temp2/")!)
                == ["file.txt"]
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp1/")!)
                == ["temp2", "file.txt"]
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///")!)
                == ["temp1", "temp2", "file.txt"]
        )
        
        // url does not begin with base url
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp2/")!)
                == nil
        )
        
        // different schemes (ie: file:// vs. https://)
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "https://somehost.com/temp1/temp2/file.txt")!)
                == nil
        )
        
        // different schemes (ie: file:// vs. https://)
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "https://somehost.com/temp1/temp2/")!)
                == nil
        )
    }
    
    @Test
    func pathComponentsRemovingPrefix() {
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///temp1/temp2/file.txt")!.pathComponents)
                == []
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///temp1/temp2/")!.pathComponents)
                == ["file.txt"]
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///temp1/")!.pathComponents)
                == ["temp2", "file.txt"]
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///")!.pathComponents)
                == ["temp1", "temp2", "file.txt"]
        )
        
        // url does not begin with base url
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///temp2/")!.pathComponents)
                == nil
        )
        
        // different schemes (ie: file:// vs. https://)
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "https://somehost.com/temp1/temp2/")!.pathComponents)
                == ["file.txt"]
        )
        
        // different hosts, same paths
        #expect(
            URL(string: "https://somehost1.com/temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "https://somehost2.com/temp1/temp2/")!.pathComponents)
                == ["file.txt"]
        )
        
        // different hosts with authentication and port numbers, same paths
        #expect(
            URL(string: "https://user:pass@somehost1.com:8080/temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "https://somehost2.com/temp1/temp2/")!.pathComponents)
                == ["file.txt"]
        )
        
        // different schemes (ie: file:// vs. https://)
        #expect(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "https://somehost.com/temp1/temp2/file.txt")!.pathComponents)
                == []
        )
    }
    
    @Test
    func relativeToBaseURL() {
        // ensure absolute URL remains unchanged
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .relative(to: URL(string: "file:///temp1/")!)
                .absoluteString
                == "file:///temp1/temp2/some%20file.txt"
        )
        
        // test baseURL
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .relative(to: URL(string: "file:///temp1/")!)
                .baseURL?.absoluteString
                == "file:///temp1/"
        )
        
        // test relative path
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .relative(to: URL(string: "file:///temp1/")!)
                .relativeString
                == "temp2/some%20file.txt"
        )
    }
    
    @Test
    func mutatingLastPathComponent() {
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponent { "a" + $0 + ".pdf" }
                .absoluteString
                == "file:///temp1/temp2/asome%20file.txt.pdf"
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponent { _ in "new file name" }
                .absoluteString
                == "file:///temp1/temp2/new%20file%20name"
        )
    }
    
    @Test
    func mutatingLastPathComponentExcludingExtension() {
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponentExcludingExtension { "a" + $0 + "b" }
                .absoluteString
                == "file:///temp1/temp2/asome%20fileb.txt"
        )
        
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponentExcludingExtension { _ in "new file name" }
                .absoluteString
                == "file:///temp1/temp2/new%20file%20name.txt"
        )
    }
    
    @Test
    func appendingToLastPathComponentBeforeExtension() {
        #expect(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .appendingToLastPathComponentBeforeExtension("-2")
                .absoluteString
                == "file:///temp1/temp2/some%20file-2.txt"
        )
    }
    
    @Test
    func fileExists() {
        // guaranteed to exist
        let folder = URL(fileURLWithPath: NSHomeDirectory())
        
        #expect(folder.fileExists)
    }
    
    @Test
    func isFolder() {
        // guaranteed to exist
        let folder = URL(fileURLWithPath: NSHomeDirectory())
        
        #expect(folder.isFolder!)
    }
    
    #if os(macOS)
    @Test
    func canonicalizeFileURL() throws {
        // write temp file including a mix of uppercase and lowercase letters
        let file = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString)-TeSt123AbC.txt")
        try "\(Date())".write(to: file, atomically: true, encoding: .utf8)
        #expect(file.fileExists)
        
        let lowercased = try #require(URL(string: file.absoluteString.lowercased()))
        #expect(file.absoluteString != lowercased.absoluteString)
        var reformed = lowercased
        try reformed.canonicalizeFileURL()
        
        // adjust original URL for comparison. path canonicalization adds `/private` to temporary
        // directory path.
        let prefixString = "file:///var/"
        let originalFileString = file.absoluteString
        let originalFileStringRange = originalFileString.startIndex
            ..< originalFileString.index(originalFileString.startIndex, offsetBy: prefixString.count)
        let prefixedOriginalFileString = originalFileString
            .replacingOccurrences(
                of: prefixString,
                with: "file:///private/var/",
                range: originalFileStringRange
            )
        
        #expect(prefixedOriginalFileString == reformed.absoluteString)
    }
    #endif
    
    #if os(macOS)
    @Test
    func canonicalizingFileURL() throws {
        // write temp file including a mix of uppercase and lowercase letters
        let file = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(UUID().uuidString)-TeSt123AbC.txt")
        try "\(Date())".write(to: file, atomically: true, encoding: .utf8)
        #expect(file.fileExists)
        
        let lowercased = try #require(URL(string: file.absoluteString.lowercased()))
        #expect(file.absoluteString != lowercased.absoluteString)
        let reformed = try lowercased.canonicalizingFileURL()
        
        // adjust original URL for comparison. path canonicalization adds `/private` to temporary
        // directory path.
        let prefixString = "file:///var/"
        let originalFileString = file.absoluteString
        let originalFileStringRange = originalFileString.startIndex
            ..< originalFileString.index(originalFileString.startIndex, offsetBy: prefixString.count)
        let prefixedOriginalFileString = originalFileString
            .replacingOccurrences(
                of: prefixString,
                with: "file:///private/var/",
                range: originalFileStringRange
            )
        
        #expect(prefixedOriginalFileString == reformed.absoluteString)
    }
    #endif
    
    #if os(macOS)
    @Test
    func isEqualFileNode() throws {
        // write temp file including a mix of uppercase and lowercase letters
        let file = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(UUID().uuidString)-TeSt123AbC.txt")
        try "\(Date())".write(to: file, atomically: true, encoding: .utf8)
        #expect(file.fileExists)
        
        let lowercased = try #require(URL(string: file.absoluteString.lowercased()))
        #expect(file.absoluteString != lowercased.absoluteString)
        
        #expect(try file.isEqualFileNode(as: lowercased))
    }
    #endif
    
    @Test
    func trashOrDelete() throws {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        
        // ensure path does not exist
        try #require(!url.fileExists)
        
        print("Source URL:", url)
        
        // create source folder
        
        print("Creating source directory...")
        
        try FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        // operation
        
        let result = try url.trashOrDelete()
        
        // result test
        
        #if os(macOS) || targetEnvironment(macCatalyst)
        #expect(result != nil)
        #elseif os(iOS)
        #expect(result == nil)
        #elseif os(tvOS)
        #expect(result == nil)
        #elseif os(watchOS)
        #expect(result == nil)
        #endif
        
        // clean up
        
        // no clean up necessary
        // test moves any temp files/folders it creates to the trash or deletes them
    }
    
    @Test
    func isFinderAlias() throws {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url1 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        
        // ensure path does not exist
        try #require(!url1.fileExists)
        
        print("Source URL:", url1)
        
        let url2 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName + " alias")
        
        // ensure path does not exist
        try #require(!url2.fileExists)
        
        print("Destination URL:", url2)
        
        // ensure paths aren't equal
        try #require(url1 != url2)
        
        // neither exist, so this will fail
        
        #expect(!url1.isFinderAlias)
        #expect(!url2.isFinderAlias)
        
        // create source folder
        
        print("Creating source directory...")
        
        try FileManager.default.createDirectory(
            at: url1,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        // create temporary alias
        
        print("Forming alias...")
        
        try url1.createFinderAlias(at: url2)
        
        // test
        
        #expect(!url1.isFinderAlias)
        #expect(url2.isFinderAlias)
        
        // clean up
        
        // .trashItem not available on all platforms
        
        print("Cleaning up source directory...")
        #expect(throws: Never.self) { try url1.trashOrDelete() }
        
        print("Cleaning up destination alias...")
        #expect(throws: Never.self) { try url2.trashOrDelete() }
    }
    
    @Test
    func symlink() throws {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url1 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        
        // ensure path does not exist
        try #require(!url1.fileExists)
        
        print("Source URL:     ", url1)
        
        let url2 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName + "-alias")
        
        // ensure path does not exist
        try #require(!url2.fileExists)
        
        // ensure paths aren't equal
        try #require(url1 != url2)
        
        print("Destination URL:", url2)
        
        // neither exist, so this will fail
        
        #expect(url1.isSymLink == nil)
        #expect(url2.isSymLink == nil)
        
        // create source folder
        
        print("Creating source directory...")
        
        try FileManager.default.createDirectory(
            at: url1,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        // create temporary symlink
        
        print("Forming symlink...")
        
        try url1.createSymLink(at: url2)
        
        // test
        
        try #expect(!#require(url1.isSymLink as Bool?))
        try #expect(#require(url2.isSymLink as Bool?))
        try #expect(!#require(url1.isSymLinkOf(file: url2) as Bool?))
        try #expect(#require(url2.isSymLinkOf(file: url1) as Bool?))
        
        // clean up
        
        print("Cleaning up source directory...")
        #expect(throws: Never.self) { try url1.trashOrDelete() }
        
        print("Cleaning up destination symlink...")
        #expect(throws: Never.self) { try url2.trashOrDelete() }
    }
    
    @Test
    func folders() {
        #if os(macOS)
        
        // FileManager
        
        _ = FileManager.default.homeDirectoryForCurrentUserCompat
        _ = FileManager.default.temporaryDirectoryCompat
        
        #endif
    }
}

#endif
