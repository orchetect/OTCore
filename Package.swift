// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "OTCore",
	
    products: [
        .library(
            name: "OTCore",
            targets: ["OTCore"]),
		
		.library(
			name: "OTCoreTesting",
			targets: ["OTCoreTesting", "OTCoreTestingXCTest"])
    ],
	
    dependencies: [
		.package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1"),
	],
	
    targets: [
		// main
		.target(
			name: "OTCore",
			dependencies: []),
		
		// main tests
		.testTarget(
			name: "OTCoreTests",
			dependencies: ["OTCore", "SegmentedProgress"]),
		
		// Testing module
		.target(
			name: "OTCoreTesting",
			dependencies: []),
		
		// Testing XCTest module
		.target(
			name: "OTCoreTestingXCTest",
			dependencies: ["OTCoreTesting"]),
		
		// Testing tests
		.testTarget(
			name: "OTCoreTestingXCTestTests",
			dependencies: ["OTCore", "OTCoreTesting", "OTCoreTestingXCTest"])
	]
	
)
