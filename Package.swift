// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OTCore",
    platforms: [
        // certain features of the library are marked @available only on newer versions of OSes,
        // but a platforms spec here determines what base platforms
        // the library is currently supported on
        .macOS(.v10_12), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "OTCore",
            type: .static,
            targets: ["OTCore"]
        )
    ],
    dependencies: [
        // testing-only dependency
        .package(url: "https://github.com/orchetect/XCTestUtils", from: "1.0.3")
    ],
    targets: [
        .target(
            name: "OTCore",
            dependencies: [],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .testTarget(
            name: "OTCoreTests",
            dependencies: ["OTCore", "XCTestUtils"]
        )
    ]
)
