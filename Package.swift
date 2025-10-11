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
            ],
            swiftSettings: isRunningOnGitHubActions()
                ? [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
                : []
        )
    ]
)

// MARK: - CI Pipeline

#if canImport(Foundation)
import Foundation
#elseif canImport(CoreFoundation)
import CoreFoundation
#endif

func getEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
}

extension StringProtocol {
    var isTrueEnvValue: Bool {
        let value = trimmingCharacters(in: .whitespacesAndNewlines)
        
        return value == "true"
            || value == "TRUE"
            || value == "1"
            || value == "yes"
            || value == "YES"
    }
}

func isRunningOnGitHubActions() -> Bool {
#if canImport(Foundation) || canImport(CoreFoundation)
    guard let value = getEnvironmentVar("GITHUB_ACTIONS")?
        .trimmingCharacters(in: .whitespacesAndNewlines)
    else { return false }
    
    return value.isTrueEnvValue
#else
    return false
#endif
}
