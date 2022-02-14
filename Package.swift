// swift-tools-version:5.3

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
        .package(url: "https://github.com/orchetect/OTAtomics", from: "1.0.0"),
        
        // testing-only dependency
        .package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1")
    ],
    
    targets: [
        .target(
            name: "OTCore",
            dependencies: ["OTAtomics"]),
        
        .testTarget(
            name: "OTCoreTests",
            dependencies: ["OTCore", "OTAtomics", "SegmentedProgress"])
    ]
    
)

func addShouldTestFlag() {
    var swiftSettings = package.targets
        .first(where: { $0.name == "OTCoreTests" })?
        .swiftSettings ?? []
    
    swiftSettings.append(.define("shouldTestCurrentPlatform"))
    
    package.targets
        .first(where: { $0.name == "OTCoreTests" })?
        .swiftSettings = swiftSettings
}

// Swift version in Xcode 12.5.1 which introduced watchOS testing
#if os(watchOS) && swift(>=5.4.2)
    addShouldTestFlag()
#elseif os(watchOS)
    // don't add flag
#else
    addShouldTestFlag()
#endif
