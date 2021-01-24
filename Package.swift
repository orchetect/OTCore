// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "OTCore",
	
    products: [
		// production modules
        .library(
            name: "OTCore",
            targets: ["OTCore"]),
		
		// production testing module
		.library(
			name: "OTCore-Testing",
			type: .dynamic,
			targets: ["OTCoreTesting"]),
		
		// XCTest module
		.library(
			name: "OTCore-Testing-XCTest",
			type: .dynamic,
			targets: ["OTCoreTestingXCTest"])
    ],
	
    dependencies: [
		.package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1"),
	],
	
    targets: [
		// production
		.target(
			name: "OTCore",
			dependencies: []),
		
		// production tests
		.testTarget(
			name: "OTCoreTests",
			dependencies: ["OTCore", "SegmentedProgress"]),
		
		// production testing module
		.target(
			name: "OTCoreTesting",
			dependencies: []),
		
		// XCTest module
		.target(
			name: "OTCoreTestingXCTest",
			dependencies: ["OTCoreTesting"]),
		
		// XCTest module tests
		.testTarget(
			name: "OTCoreTestingXCTestTests",
			dependencies: ["OTCore", "OTCoreTestingXCTest"])
	]
	
)
