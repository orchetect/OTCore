// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "OTCore",
	
    products: [
        .library(
            name: "OTCore",
            targets: ["OTCore"]),
    ],
	
    dependencies: [
		.package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1"),
	],
	
    targets: [
		.target(
			name: "OTCore",
			dependencies: []),
		
		.testTarget(
			name: "OTCoreTests",
			dependencies: ["OTCore", "SegmentedProgress"]),
		
	]
	
)
