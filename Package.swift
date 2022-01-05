// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "OTCore",
    
    // certain features of the library are marked @available only on newer versions of OSes,
    // but a platforms spec here determines what base platforms
    // the library is currently supported on
    platforms: [
        .macOS(.v10_12)
    ],
    
    products: [
        .library(
            name: "OTCore",
            type: .static,
            targets: ["OTCore"])
    ],
    
    dependencies: [
        // testing-only dependency
        .package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1"),
    ],
    
    targets: [
        .target(
            name: "OTCore",
            dependencies: []),
        
        .testTarget(
            name: "OTCoreTests",
            dependencies: ["OTCore", "SegmentedProgress"])
    ]
    
)
