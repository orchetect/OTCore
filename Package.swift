// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OTCore",
    
    // certain features of the library are marked @available only on newer versions of OSes,
    // but a platforms spec here determines what base platforms
    // the library is currently supported on
    platforms: [
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
            swiftSettings: [
                .define(
                    "DEBUG",
                    .when(
                        platforms: [.iOS, .macOS, .tvOS, .watchOS],
                        configuration: .debug
                    )
                )
            ]
        ),
        
        .testTarget(
            name: "OTCoreTests",
            dependencies: ["OTCore", "XCTestUtils"]
        )
    ]
)

func addShouldTestFlag() {
    package.targets.filter { $0.isTest }.forEach { target in
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings?.append(.define("shouldTestCurrentPlatform"))
    }
}

// Xcode 12.5.1 (Swift 5.4.2) introduced watchOS testing
#if swift(>=5.4.2)
addShouldTestFlag()
#elseif !os(watchOS)
addShouldTestFlag()
#endif
