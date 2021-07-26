// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "OTCore",
    
    products: [
        // OTCore main library
        .library(
            name: "OTCore",
            type: .static,
            targets: ["OTCore"]),
        
        // OTCore-Testing production code import
        .library(
            name: "OTCore-Testing",
            type: .static,
            targets: ["OTCoreTesting"]),
        
        // OTCore-Testing XCTest unit test target import
        .library(
            name: "OTCore-Testing-XCTest",
            type: .static,
            targets: ["OTCoreTestingXCTest"])
    ],
    
    dependencies: [
        .package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1"),
    ],
    
    targets: [
        // MODULE: OTCore
        .target(
            name: "OTCore",
            dependencies: []),
        
        // TESTS: OTCore
        .testTarget(
            name: "OTCoreTests",
            dependencies: ["OTCore", "SegmentedProgress"]),
        
        // MODULE: OTCoreTesting
        .target(
            name: "OTCoreTesting",
            dependencies: []
        ),
        
        // MODULE: OTCoreTestingXCTest
        .target(
            name: "OTCoreTestingXCTest",
            dependencies: ["OTCoreTesting"]
        ),
        
        // TESTS: OTCoreTestingXCTest
        .testTarget(
            name: "OTCoreTestingXCTestTests",
            dependencies: ["OTCore", "OTCoreTestingXCTest"]
        )
        
    ]
    
)
