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
    // MARK: - FilePath & URL Interop
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func filePath_asURL() async throws {
        #expect(FilePath("/").asURL().path(percentEncoded: false) == "/")
        
        #expect(FilePath("/Users").asURL().path(percentEncoded: false) == "/Users")
        #expect(FilePath("/Users/").asURL().path(percentEncoded: false) == "/Users")
        
        #expect(FilePath("/Users/user/text.txt").asURL().path(percentEncoded: false) == "/Users/user/text.txt")
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test
    func url_asFilePath() async throws {
        #expect(try URL(fileURLWithPath: "/").asFilePath().string == "/")
        
        #expect(try URL(fileURLWithPath: "/Users").asFilePath().string == "/Users")
        #expect(try URL(fileURLWithPath: "/Users/").asFilePath().string == "/Users")
        
        #expect(try URL(fileURLWithPath: "/Users/user/text.txt").asFilePath().string == "/Users/user/text.txt")
        
        #expect(try URL(string: "file:///")?.asFilePath().string == "/")
        #expect(try URL(string: "file:///Users/user/text.txt")?.asFilePath().string == "/Users/user/text.txt")
        
        // edge cases - non-file URLs
        #expect(throws: (any Error).self) { _ = try URL(string: "https://www.domain.com")?.asFilePath() }
        #expect(throws: (any Error).self) { _ = try URL(string: "https://www.domain.com/")?.asFilePath() }
        #expect(throws: (any Error).self) { _ = try URL(string: "https://www.domain.com/Users")?.asFilePath() }
        #expect(throws: (any Error).self) { _ = try URL(string: "https://www.domain.com/Users/")?.asFilePath() }
        #expect(throws: (any Error).self) { _ = try URL(string: "https://www.domain.com/Users/user/text.txt")?.asFilePath() }
    }
    
    // MARK: - URL Manipulation
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test
    func mutatingLastPathComponent() async {
        #expect(
            FilePath("/temp1/temp2/some file.txt")
                .mutatingLastPathComponent { "a" + $0.string + ".pdf" }
                .string
            == "/temp1/temp2/asome file.txt.pdf"
        )
        
        #expect(
            FilePath("/temp1/temp2/some file.txt")
                .mutatingLastPathComponent { _ in "new file name" }
                .string
            == "/temp1/temp2/new file name"
        )
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test
    func mutatingLastPathComponentExcludingExtension() async {
        #expect(
            FilePath("/temp1/temp2/some file.txt")
                .mutatingLastPathComponentExcludingExtension { "a" + $0 + "b" }
                .string
            == "/temp1/temp2/asome fileb.txt"
        )
        
        #expect(
            FilePath("/temp1/temp2/some file.txt")
                .mutatingLastPathComponentExcludingExtension { _ in "new file name" }
                .string
            == "/temp1/temp2/new file name.txt"
        )
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test
    func appendingToLastPathComponentBeforeExtension() async {
        #expect(
            FilePath("/temp1/temp2/some file.txt")
                .appendingToLastPathComponentBeforeExtension("-2")
                .string
            == "/temp1/temp2/some file-2.txt"
        )
    }
    
    // MARK: - File / Folder Metadata
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test
    func fileExists() async {
        // guaranteed to exist
        let folder = FilePath(NSHomeDirectory())
        
        #expect(folder.fileExists)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test
    func isDirectory() async {
        // guaranteed to exist
        let folder = FilePath(NSHomeDirectory())
        
        #expect(folder.isDirectory)
    }
    
    #if os(macOS)
    @available(macOS 12.0, *)
    @Test
    func canonicalize() async throws {
        // write temp file including a mix of uppercase and lowercase letters
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString)-TeSt123AbC.txt")
        try "\(Date())".write(to: fileURL, atomically: true, encoding: .utf8)
        #expect(FileManager.default.fileExists(atPath: fileURL.path))
        
        let originalcase = try #require(FilePath(fileURL))
        let lowercased = FilePath(originalcase.string.lowercased())
        #expect(originalcase != lowercased) // sanity check
        var reformed = lowercased
        try reformed.canonicalize()
        
        // adjust original path for comparison. path canonicalization adds `/private` to temporary
        // directory path.
        let prefixString = "/var/"
        let originalFileString = originalcase.string
        let originalFileStringRange = originalFileString.startIndex
            ..< originalFileString.index(originalFileString.startIndex, offsetBy: prefixString.count)
        let prefixedOriginalFileString = originalFileString
            .replacingOccurrences(
                of: prefixString,
                with: "/private/var/",
                range: originalFileStringRange
            )
        
        #expect(prefixedOriginalFileString == reformed.string)
        
        // cleanup
        try? FileManager.default.removeItem(at: fileURL)
    }
    #endif
    
    #if os(macOS)
    @available(macOS 12.0, *)
    @Test
    func canonicalized() async throws {
        // write temp file including a mix of uppercase and lowercase letters
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString)-TeSt123AbC.txt")
        try "\(Date())".write(to: fileURL, atomically: true, encoding: .utf8)
        #expect(FileManager.default.fileExists(atPath: fileURL.path))
        
        let originalcase = try #require(FilePath(fileURL))
        let lowercased = FilePath(originalcase.string.lowercased())
        #expect(originalcase != lowercased) // sanity check
        let reformed = try lowercased.canonicalized()
        
        // adjust original path for comparison. path canonicalization adds `/private` to temporary
        // directory path.
        let prefixString = "/var/"
        let originalFileString = originalcase.string
        let originalFileStringRange = originalFileString.startIndex
        ..< originalFileString.index(originalFileString.startIndex, offsetBy: prefixString.count)
        let prefixedOriginalFileString = originalFileString
            .replacingOccurrences(
                of: prefixString,
                with: "/private/var/",
                range: originalFileStringRange
            )
        
        #expect(prefixedOriginalFileString == reformed.string)
        
        // cleanup
        try? FileManager.default.removeItem(at: fileURL)
    }
    #endif
    
    #if os(macOS)
    @Test
    func isEqualFileNode() async throws {
        // write temp file including a mix of uppercase and lowercase letters
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(UUID().uuidString)-TeSt123AbC.txt")
        try "\(Date())".write(to: fileURL, atomically: true, encoding: .utf8)
        #expect(FileManager.default.fileExists(atPath: fileURL.path))
        
        let originalcase = try #require(FilePath(fileURL))
        let lowercased = FilePath(originalcase.string.lowercased())
        #expect(originalcase.string != lowercased.string) // sanity check
        
        #expect(try originalcase.isEqualFileNode(as: lowercased))
        
        // cleanup
        try? FileManager.default.removeItem(at: fileURL)
    }
    #endif
    
    // MARK: - File Operations
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func trashOrDelete() async throws {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        
        // ensure path does not exist
        try #require(!FileManager.default.fileExists(atPath: url.path))
        
        print("Source path:", url.path)
        
        // create source folder
        
        print("Creating source directory...")
        
        try FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        // operation
        
        let path = try #require(FilePath(url))
        let trashedPath = try path.trashOrDelete()
        
        // result test
        
        #if os(macOS) || targetEnvironment(macCatalyst)
        #expect(trashedPath != nil)
        #elseif os(iOS)
        #expect(trashedPath == nil)
        #elseif os(tvOS)
        #expect(trashedPath == nil)
        #elseif os(watchOS)
        #expect(trashedPath == nil)
        #elseif os(visionOS)
        #expect(trashedPath == nil)
        #endif
        
        // clean up
        
        try? FileManager.default.removeItem(at: url)
        if let trashedPath { try? FileManager.default.removeItem(at: trashedPath.asURL()) }
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func uniqued() async throws {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let folderURL = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        let folderPath = try folderURL.asFilePath()
        
        // create source folder
        
        print("Creating temporary directory...")
        
        try FileManager.default.createDirectory(
            at: folderURL,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        let file1Path = folderPath.appending("Test.txt")
        let file1URL = file1Path.asURL(directoryHint: .notDirectory)
        
        // file does not exist on disk, so no uniquing is needed; path is returned as-is
        #expect(file1Path.uniqued() == file1Path)
        
        // create file on disk
        try "Test string".write(to: file1URL, atomically: false, encoding: .utf8)
        
        // unique base file
        let file2Path = file1Path.uniqued()
        let file2URL = file2Path.asURL(directoryHint: .notDirectory)
        #expect(file2Path == folderPath.appending("Test 2.txt"))
        
        // create file on disk
        try "Test string".write(to: file2URL, atomically: false, encoding: .utf8)
        
        // unique base file
        let file3 = file1Path.uniqued()
        #expect(file3 == folderPath.appending("Test 3.txt"))
        
        // cleanup
        try? FileManager.default.removeItem(at: folderURL)
    }
    
    // MARK: - Finder Aliases
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func isFinderAlias() async throws {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectoryCompat
        
        // determine temporary paths
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url1 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        let path1 = try #require(FilePath(url1))
        
        // ensure path does not exist
        try #require(!FileManager.default.fileExists(atPath: path1.string))
        
        print("Source path:", path1.string)
        
        let url2 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName + " alias")
        let path2 = try #require(FilePath(url2))
        
        // ensure path does not exist
        try #require(!FileManager.default.fileExists(atPath: path2.string))
        
        print("Destination path:", path2.string)
        
        // ensure paths aren't equal
        try #require(path1 != path2)
        
        // neither exist, so this will fail
        
        #expect(!path1.isFinderAlias)
        #expect(!path2.isFinderAlias)
        
        // create source folder
        
        print("Creating source directory...")
        
        try FileManager.default.createDirectory(
            at: url1,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        // create temporary alias
        
        print("Forming alias...")
        
        try path1.createFinderAlias(at: path2)
        
        // test
        
        #expect(!path1.isFinderAlias)
        #expect(path2.isFinderAlias)
        
        // clean up
        
        try? FileManager.default.removeItem(at: url1)
        try? FileManager.default.removeItem(at: url2)
    }
    
    // MARK: - SymLinks
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func symlink() async throws {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectoryCompat
        
        // determine temporary paths
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url1 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        let path1 = try #require(FilePath(url1))
        
        // ensure path does not exist
        try #require(!FileManager.default.fileExists(atPath: path1.string))
        
        print("Source path:", path1.string)
        
        let url2 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName + "-alias")
        let path2 = try #require(FilePath(url2))
        
        // ensure path does not exist
        try #require(!FileManager.default.fileExists(atPath: path2.string))
        
        // ensure paths aren't equal
        try #require(path1 != path2)
        
        print("Destination path:", path2.string)
        
        // neither exist, so this will fail
        
        #expect(throws: (any Error).self) { _ = try path1.isSymLink }
        #expect(throws: (any Error).self) { _ = try path2.isSymLink }
        
        // create source folder
        
        print("Creating source directory...")
        
        try FileManager.default.createDirectory(
            at: url1,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        // create temporary symlink
        
        print("Forming symlink...")
        
        try path1.createSymLink(at: path2)
        
        // test
        
        #expect(try !path1.isSymLink)
        #expect(try path2.isSymLink)
        #expect(try !path1.isSymLink(of: path2))
        #expect(try path2.isSymLink(of: path1))
        
        // clean up
        
        try? FileManager.default.removeItem(at: url1)
        try? FileManager.default.removeItem(at: url2)
    }
    
    // MARK: - Static
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func currentDirectory() async throws {
        #expect(FilePath.currentDirectory().string == URL.currentDirectory().path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test
    func homeDirectory() async throws {
        #expect(FilePath.homeDirectory.string == URL.homeDirectory.path)
    }
    
    @available(macOS 13.0, /* iOS 16.0, tvOS 16.0, watchOS 9.0, */ *)
    @available(macCatalyst, unavailable) // username lookup not available
    @available(iOS, unavailable) // username lookup not available
    @available(tvOS, unavailable) // username lookup not available
    @available(watchOS, unavailable) // username lookup not available
    @Test
    func homeDirectory_forUser() async throws {
        let username = Globals.System.userName
        #expect(FilePath.homeDirectory(forUser: username)?.string == URL.homeDirectory(forUser: username)?.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func temporaryDirectory() async throws {
        #expect(FilePath.temporaryDirectory.string == URL.temporaryDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func cachesDirectory() async throws {
        #expect(FilePath.cachesDirectory.string == URL.cachesDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func applicationDirectory() async throws {
        #expect(FilePath.applicationDirectory.string == URL.applicationDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func libraryDirectory() throws {
        #expect(FilePath.libraryDirectory.string == URL.libraryDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func userDirectory() async throws {
        #expect(FilePath.userDirectory.string == URL.userDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func documentsDirectory() async throws {
        #expect(FilePath.documentsDirectory.string == URL.documentsDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func desktopDirectory() async throws {
        #expect(FilePath.desktopDirectory.string == URL.desktopDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func applicationSupportDirectory() async throws {
        #expect(FilePath.applicationSupportDirectory.string == URL.applicationSupportDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func downloadsDirectory() async throws {
        #expect(FilePath.downloadsDirectory.string == URL.downloadsDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func moviesDirectory() async throws {
        #expect(FilePath.moviesDirectory.string == URL.moviesDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func musicDirectory() async throws {
        #expect(FilePath.musicDirectory.string == URL.musicDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func picturesDirectory() async throws {
        #expect(FilePath.picturesDirectory.string == URL.picturesDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test func sharedPublicDirectory() async throws {
        #expect(FilePath.sharedPublicDirectory.string == URL.sharedPublicDirectory.path)
    }
    
    @available(macOS 13.0, iOS 16.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @Test(
        .enabled("There seems to be a bug where calling `URL.trashDirectory` on an iOS Simulator causes a EXC_BAD_INSTRUCTION crash.") {
            (try? FileManager.default.url(for: .trashDirectory, in: .userDomainMask, appropriateFor: nil, create: false)) != nil
        }
    )
    func trashDirectory() async throws {
        #expect(FilePath.trashDirectory.string == URL.trashDirectory.path)
    }
}

#endif
