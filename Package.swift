// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "OTCore",
    platforms: [
        // The minimum platform versions here set the baseline requirements for the library, however
        // individual features of the library may be marked as `@available` only on newer versions.
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "OTCore",
            type: .static,
            targets: ["OTCore"]
        )
    ],
    dependencies: [
        // Testing-only dependencies
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.3"),
        .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.2.3")
    ],
    targets: [
        .target(
            name: "OTCore",
            dependencies: [],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .testTarget(
            name: "OTCoreTests",
            dependencies: [
                "OTCore", 
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "TestingExtensions", package: "swift-testing-extensions")
            ]
        )
    ]
)
