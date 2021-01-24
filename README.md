# OTCore

<p>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/Swift%205.3-compatible-orange.svg?style=flat"
	 alt="Swift 5.3 compatible" /></a>
<a href="#installation">
<img src="https://img.shields.io/badge/SPM-compatible-orange.svg?style=flat"
	 alt="Swift Package Manager (SPM) compatible" /></a>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/platform-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20-green.svg?style=flat"
	 alt="Platform - macOS | iOS | tvOS | watchOS" /></a>
<a href="#contributions">
<img src="https://img.shields.io/badge/Linux-not%20tested-black.svg?style=flat"
	 alt="Linux - not tested" /></a>
<a href="https://github.com/orchetect/OTCore/blob/main/LICENSE">
<img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat"
	 alt="License: MIT" /></a>

Foundational multi-platform shared code module with useful extensions on core Swift types.

The library has no implicit minimum OS version requirements, but where necessary, individual methods and properties have been marked `@available`  with associated OS requirements.

## Summary

The library functions as a repository of useful extensions on common Swift types.

- Efforts have been made to reduce imports as much as possible, allowing more functions to become available on more compiled platforms.
- Efforts have also been made to make methods as performant and generalized as possible.
- Code has been battle-tested in production software for 1-5 years, and updated/improved as needed periodically.
- Unit tests have been added wherever possible.

## Installation

### Swift Package Manager (SPM)

To add OTCore to your Xcode project:

1. Select File → Swift Packages → Add Package Dependency
2. Add package using  `https://github.com/orchetect/OTCore` as the URL.

## Usage

### `OTCore`

OTCore provides all the general production code, including extensions on Swift standard library types, abstractions, algorithms, and useful odds and ends.

#### In an Application

1. Add the package to your Xcode project using Swift Package Manager
   - Select File → Swift Packages → Add Package Dependency
   - Add package using  `https://github.com/orchetect/OTCore` as the URL.
2. Import the module in your *.swift files where needed.
   ```swift
   import OTCore
   ```

#### In a SPM Package as a Dependency

1. In your Package.swift file:

   ```swift
   dependencies: [
       // ... any other dependencies you may have ...
       .package(url: "https://github.com/orchetect/OTCore", from: "1.1.2")
   ],
   ```

2. In your production target, where applicable:

   ```swift
   @_implementationOnly import OTCore
   ```
   
   `@_implementationOnly` prevents the methods and properties in `OTCore` from being exported to the consumer of your SPM package.

### `OTCore-Testing` & `OTCore-Testing-XCTest`

`OTCoreTesting` and `OTCoreTestingXCTest` provides specific production code and `XCTestCase` extensions that complement each other, useful for added functionality to XCTest unit testing of your code.

#### In an Application

1. Add the package to your Xcode project using Swift Package Manager

   - Select File → Swift Packages → Add Package Dependency
   - Add package using  `https://github.com/orchetect/OTCore` as the URL.
   
2. In all of your application targets and test targets, it is necessary to add this custom build setting:

   ```
   DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC = YES
   ```

   (In Build Settings tab, click the `+` button near the top next to "Combined" / "Levels" and select "Add User-Defined Setting". Then enter `DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC` as the name, and `YES` as its value for each build target.)

   Alternatively, this build setting can be supplied in a custom `.xcconfig` file.

   This is a necessary workaround for the time being. See [this swift.org thread](https://forums.swift.org/t/adding-a-package-to-two-targets-in-one-projects-results-in-an-error/35007) for details.

3. In Xcode → Application project file

   - *Application Target* → General tab → "Frameworks, Libraries and Embedded Content"
      - Click the `+` button
      - Add the `OTCore-Testing` library
   - Repeat for for each testing target:
      - *Test Target* → Build Phases tab → Link Binary With Libraries disclosure triangle
      - Add the `OTCore-Testing-XCTest` library

4. In your application, where applicable:
   ```swift
   import OTCoreTesting
   ```

5. In your test target source files using XCTest, where applicable:
   ```swift
   import OTCoreTestingXCTest
   ```

#### In a SPM Package as a Dependency

1. In your Package.swift file:

   Because `OTCore-Testing` and `OTCore-Testing-XCTest` are modules inside `OTCore`, they must be listed as dependencies using the `.product()` argument.

   ```swift
   dependencies: [
       // ... any other dependencies you may have ...
       .package(url: "https://github.com/orchetect/OTCore", from: "1.1.2")
   ],
   
   targets: [
       .target(
           name: "YourTarget",
           dependencies: [.product(name: "OTCore-Testing", package: "OTCore")]),
       
       .testTarget(
           name: "YourTargetTests",
           dependencies: ["YourTarget",
                          .product(name: "OTCore-Testing-XCTest", package: "OTCore")])
   ]
   ```

2. In your production target, where applicable:

   ```swift
   @_implementationOnly import OTCoreTesting
   ```
   
   `@_implementationOnly` prevents the methods and properties in `OTCoreTesting` from being exported to the consumer of your SPM package.
   
3. In your XCTest case files, where applicable:

   ```swift
   import OTCoreTestingXCTest
   ```

## Documentation

Most methods are implemented as category methods so they are generally discoverable.

All methods have inline help explaining their purpose and basic usage examples.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/OTCore/blob/master/LICENSE) for details.

## Contributions

The library is largely closed-source but bug fixes or help with open issues is welcome.
