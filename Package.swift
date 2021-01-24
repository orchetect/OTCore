// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "OTCore",
	
    products: [
		// production modules
        .library(
            name: "OTCore",
			type: .static,
            targets: ["OTCore"]),
		
		.library(
			name: "OTCore-Testing",
			type: .static,
			targets: ["OTCoreTesting"]),
		
		.library(
			name: "OTCore-Testing-XCTest",
			type: .static,
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
		
		.target(
			name: "OTCoreTesting",
			dependencies: []//,
//			cSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC", to: "YES")],
//			cxxSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC", to: "YES")],
//			swiftSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC=YES")]
		),
		
		.target(
			name: "OTCoreTestingXCTest",
			dependencies: ["OTCoreTesting"]//,
//			cSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC", to: "YES")],
//			cxxSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC", to: "YES")],
//			swiftSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC=YES")]
		),
		
//		cSettings: <#T##[CSetting]?#>, cxxSettings: <#T##[CXXSetting]?#>, swiftSettings: <#T##[SwiftSetting]?#>, linkerSettings: <#T##[LinkerSetting]?#>)
		
		.testTarget(
			name: "OTCoreTestingXCTestTests",
			dependencies: ["OTCore", "OTCoreTestingXCTest"]//,
//			cSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC", to: "YES")],
//			cxxSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC", to: "YES")],
//			swiftSettings: [.define("DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC=YES")]
		)
		
	]
	
)
