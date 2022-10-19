//
//  URL Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OTCore

class Extensions_Foundation_URL_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testHasPrefixURL() {
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/"))
        )
        
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/"))
        )
        
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/"))
        )
        
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/file.txt"))
        )
        
        // different path
        
        XCTAssertFalse(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(fileURLWithPath: "/wrong/"))
        )
        
        // different schemes (ie: file:// vs. https://)
        
        XCTAssertFalse(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(string: "https://temp1/temp2/file.txt")!)
        )
        
        XCTAssertFalse(
            URL(string: "https://temp1/temp2/file.txt")!
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/file.txt"))
        )
        
        XCTAssertFalse(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPrefix(url: URL(string: "https://somehost/temp1/temp2/file.txt")!)
        )
        
        XCTAssertFalse(
            URL(string: "https://somehost/temp1/temp2/file.txt")!
                .hasPrefix(url: URL(fileURLWithPath: "/temp1/temp2/file.txt"))
        )
    }
    
    func testHasPathComponentsPrefix() {
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/").pathComponents)
        )
        
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/temp1/").pathComponents)
        )
        
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/temp1/temp2/").pathComponents)
        )
        
        XCTAssertTrue(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(
                    prefix: URL(fileURLWithPath: "/temp1/temp2/file.txt")
                        .pathComponents
                )
        )
        
        // different path
        XCTAssertFalse(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(prefix: URL(fileURLWithPath: "/wrong/").pathComponents)
        )
        
        // different path
        XCTAssertFalse(
            URL(fileURLWithPath: "/temp1/temp2/file.txt")
                .hasPathComponents(
                    prefix: URL(fileURLWithPath: "/temp1/temp2/otherfile.txt")
                        .pathComponents
                )
        )
        
        // temp1 is hostname in https here, not part of path
        XCTAssertFalse(
            URL(string: "file:///temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "https://temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // temp1 is hostname in https here, not part of path
        XCTAssertFalse(
            URL(string: "https://temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "file:///temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // different hosts, same paths
        XCTAssertTrue(
            URL(string: "https://somehost1.com/temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "https://somehost2.com/temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // different hosts with authentication and port numbers, same paths
        XCTAssertTrue(
            URL(string: "https://user:pass@somehost1.com:8080/temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "https://somehost2.com/temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
        
        // different schemes (ie: file:// vs. https://)
        XCTAssertTrue(
            URL(string: "https://somehost.com/temp1/temp2/file.txt")!
                .hasPathComponents(
                    prefix: URL(string: "file:///temp1/temp2/file.txt")!
                        .pathComponents
                )
        )
    }
    
    func testOathComponentsRemovingBase() {
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp1/temp2/file.txt")!),
            []
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp1/temp2/")!),
            ["file.txt"]
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp1/")!),
            ["temp2", "file.txt"]
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///")!),
            ["temp1", "temp2", "file.txt"]
        )
        
        // url does not begin with base url
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "file:///temp2/")!),
            nil
        )
        
        // different schemes (ie: file:// vs. https://)
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(
                    removingBase: URL(string: "https://somehost.com/temp1/temp2/file.txt")!
                ),
            nil
        )
        
        // different schemes (ie: file:// vs. https://)
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingBase: URL(string: "https://somehost.com/temp1/temp2/")!),
            nil
        )
    }
    
    func testPathComponentsRemovingPrefix() {
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(
                    removingPrefix: URL(string: "file:///temp1/temp2/file.txt")!
                        .pathComponents
                ),
            []
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(
                    removingPrefix: URL(string: "file:///temp1/temp2/")!
                        .pathComponents
                ),
            ["file.txt"]
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///temp1/")!.pathComponents),
            ["temp2", "file.txt"]
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///")!.pathComponents),
            ["temp1", "temp2", "file.txt"]
        )
        
        // url does not begin with base url
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(removingPrefix: URL(string: "file:///temp2/")!.pathComponents),
            nil
        )
        
        // different schemes (ie: file:// vs. https://)
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(
                    removingPrefix: URL(string: "https://somehost.com/temp1/temp2/")!
                        .pathComponents
                ),
            ["file.txt"]
        )
        
        // different hosts, same paths
        XCTAssertEqual(
            URL(string: "https://somehost1.com/temp1/temp2/file.txt")!
                .pathComponents(
                    removingPrefix: URL(string: "https://somehost2.com/temp1/temp2/")!
                        .pathComponents
                ),
            ["file.txt"]
        )
        
        // different hosts with authentication and port numbers, same paths
        XCTAssertEqual(
            URL(string: "https://user:pass@somehost1.com:8080/temp1/temp2/file.txt")!
                .pathComponents(
                    removingPrefix: URL(string: "https://somehost2.com/temp1/temp2/")!
                        .pathComponents
                ),
            ["file.txt"]
        )
        
        // different schemes (ie: file:// vs. https://)
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/file.txt")!
                .pathComponents(
                    removingPrefix: URL(string: "https://somehost.com/temp1/temp2/file.txt")!
                        .pathComponents
                ),
            []
        )
    }
    
    func testRelativeToBaseURL() {
        // ensure absolute URL remains unchanged
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .relative(to: URL(string: "file:///temp1/")!)
                .absoluteString,
            "file:///temp1/temp2/some%20file.txt"
        )
        
        // test baseURL
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .relative(to: URL(string: "file:///temp1/")!)
                .baseURL?.absoluteString,
            "file:///temp1/"
        )
        
        // test relative path
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .relative(to: URL(string: "file:///temp1/")!)
                .relativeString,
            "temp2/some%20file.txt"
        )
    }
    
    func testMutatingLastPathComponent() {
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponent { "a" + $0 + ".pdf" }
                .absoluteString,
            "file:///temp1/temp2/asome%20file.txt.pdf"
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponent { _ in "new file name" }
                .absoluteString,
            "file:///temp1/temp2/new%20file%20name"
        )
    }
    
    func testMutatingLastPathComponentExcludingExtension() {
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponentExcludingExtension { "a" + $0 + "b" }
                .absoluteString,
            "file:///temp1/temp2/asome%20fileb.txt"
        )
        
        XCTAssertEqual(
            URL(string: "file:///temp1/temp2/some%20file.txt")!
                .mutatingLastPathComponentExcludingExtension { _ in "new file name" }
                .absoluteString,
            "file:///temp1/temp2/new%20file%20name.txt"
        )
    }
    
    func testFileExists() {
        // guaranteed to exist
        let folder = URL(fileURLWithPath: NSHomeDirectory())
        
        XCTAssertTrue(folder.fileExists)
    }
    
    func testIsFolder() {
        // guaranteed to exist
        let folder = URL(fileURLWithPath: NSHomeDirectory())
        
        XCTAssertTrue(folder.isFolder!)
    }
    
    func testTrashOrDelete() {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        
        // ensure path does not exist
        guard !url.fileExists else {
            XCTFail("\(url) exists unexpectedly. Can't continue test.")
            return
        }
        
        print("Source URL:     ", url)
        
        // create source folder
        
        print("Creating source directory...")
        
        guard (try? FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: false,
            attributes: nil
        )) != nil else {
            XCTFail("Failed to create source folder \"\(url)\". Can't continue test.")
            return
        }
        
        // operation
        
        var result: URL?
        
        do {
            result = try url.trashOrDelete()
        } catch {
            XCTFail("URL.trashOrDelete() threw an exception: \(error)")
        }
        
        // result test
        
        #if os(macOS) || targetEnvironment(macCatalyst)
        XCTAssertNotNil(result)
        #elseif os(iOS)
        XCTAssertNil(result)
        #elseif os(tvOS)
        XCTAssertNil(result)
        #elseif os(watchOS)
        // watchOS can't run XCTest unit tests, but we'll put the expected result here any way:
        XCTAssertNil(result)
        #endif
        
        // clean up
        
        // no clean up necessary
        // test moves any temp files/folders it creates to the trash or deletes them
    }
    
    func testIsFinderAlias() {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url1 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        
        // ensure path does not exist
        guard !url1.fileExists else {
            XCTFail("\(url1) exists unexpectedly. Can't continue test.")
            return
        }
        
        print("Source URL:     ", url1)
        
        let url2 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName + " alias")
        
        // ensure path does not exist
        guard !url2.fileExists else {
            XCTFail("\(url2) exists unexpectedly. Can't continue test.")
            return
        }
        
        print("Destination URL:", url2)
        
        // ensure paths aren't equal
        guard url1 != url2 else {
            XCTFail("Random URLs generated are equal. Can't continue test.")
            return
        }
        
        // neither exist, so this will fail
        
        XCTAssertFalse(url1.isFinderAlias)
        XCTAssertFalse(url2.isFinderAlias)
        
        // create source folder
        
        print("Creating source directory...")
        
        guard (try? FileManager.default.createDirectory(
            at: url1,
            withIntermediateDirectories: false,
            attributes: nil
        )) != nil else {
            XCTFail("Failed to create source folder \"\(url1)\". Can't continue test.")
            return
        }
        
        // create temporary alias
        
        print("Forming alias...")
        
        guard (try? url1.createFinderAlias(at: url2)) != nil else {
            XCTFail(
                "Failed to create temporary alias \"\(url2)\" on disk from source \"\(url1)\". Can't continue with test."
            )
            return
        }
        
        // test
        
        XCTAssertFalse(url1.isFinderAlias)
        XCTAssertTrue(url2.isFinderAlias)
        
        // clean up
        
        // .trashItem not available on all platforms
        
        print("Cleaning up source directory...")
        XCTAssertNoThrow(try url1.trashOrDelete())
        
        print("Cleaning up destination alias...")
        XCTAssertNoThrow(try url2.trashOrDelete())
    }
    
    func testSymlink() {
        // boilerplate
        
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        
        // determine temporary URLs
        
        let randomFolderName = "temp-\(UUID().uuidString)"
        
        let url1 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName)
        
        // ensure path does not exist
        guard !url1.fileExists else {
            XCTFail("\(url1) exists unexpectedly. Can't continue test.")
            return
        }
        
        print("Source URL:     ", url1)
        
        let url2 = temporaryDirectoryURL
            .appendingPathComponent(randomFolderName + "-alias")
        
        // ensure path does not exist
        guard !url2.fileExists else {
            XCTFail("\(url2) exists unexpectedly. Can't continue test.")
            return
        }
        
        // ensure paths aren't equal
        guard url1 != url2 else {
            XCTFail("Random URLs generated are equal. Can't continue test.")
            return
        }
        
        print("Destination URL:", url2)
        
        // neither exist, so this will fail
        
        XCTAssertNil(url1.isSymLink)
        XCTAssertNil(url2.isSymLink)
        
        // create source folder
        
        print("Creating source directory...")
        
        guard (try? FileManager.default.createDirectory(
            at: url1,
            withIntermediateDirectories: false,
            attributes: nil
        )) != nil else {
            XCTFail("Failed to create source folder \"\(url1)\". Can't continue test.")
            return
        }
        
        // create temporary symlink
        
        print("Forming symlink...")
        
        if (try? url1.createSymLink(at: url2)) == nil {
            XCTFail(
                "Failed to create symlink, or symlink already exists. Can't continue with test."
            )
            return
        }
        
        // test
        
        if let checkSymlink = url1.isSymLink {
            XCTAssertFalse(checkSymlink)
        } else {
            XCTFail("isSymLink should not be nil here")
            return
        }
        
        if let checkSymlink = url2.isSymLink {
            XCTAssertTrue(checkSymlink)
        } else {
            XCTFail("isSymLink should not be nil here")
            return
        }
        
        if let checkSymlink = url1.isSymLinkOf(file: url2) {
            XCTAssertFalse(checkSymlink)
        } else {
            XCTFail("isSymLink should not be nil here")
            return
        }
        
        if let checkSymlink = url2.isSymLinkOf(file: url1) {
            XCTAssertTrue(checkSymlink)
        } else {
            XCTFail("isSymLink should not be nil here")
            return
        }
        
        // clean up
        
        print("Cleaning up source directory...")
        XCTAssertNoThrow(try url1.trashOrDelete())
        
        print("Cleaning up destination symlink...")
        XCTAssertNoThrow(try url2.trashOrDelete())
    }
    
    func testFolders() {
        #if os(macOS)
        
        // FileManager
        
        _ = FileManager.homeDirectoryForCurrentUserCompat
        _ = FileManager.temporaryDirectoryCompat
        
        #endif
    }
}

#endif
