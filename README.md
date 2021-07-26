# OTCore

<p>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/Swift%205.3-compatible-orange.svg?style=flat"
	 alt="Swift 5.3 compatible" /></a>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/platform-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20-green.svg?style=flat"
	 alt="Platform - macOS | iOS | tvOS | watchOS" /></a>
<a href="https://github.com/orchetect/OTCore/blob/main/LICENSE">
<img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat"
	 alt="License: MIT" /></a>

Multi-platform Swift shared code module with useful extension methods on standard library types.

The library has full unit test coverage and is actively used in production.

## Installation: Swift Package Manager (SPM)

#### Dependency within an Application

1. Add the package to your Xcode project using Swift Package Manager
   - Select File → Swift Packages → Add Package Dependency
   - Add package using  `https://github.com/orchetect/OTCore` as the URL.
2. Import the module in your *.swift files where needed.
   ```swift
   import OTCore
   ```

#### Dependency within a Swift Package

1. In your Package.swift file:

   ```swift
   dependencies: [
       .package(url: "https://github.com/orchetect/OTCore", from: "1.1.9")
   ],
   ```
   
2. `@_implementationOnly` prevents the methods and properties in `OTCore` from being exported to the consumer of your SPM package.

   ```swift
   @_implementationOnly import OTCore
   ```
   

## Documentation

Most methods are implemented as category methods so they are generally discoverable.

All methods have inline help explaining their purpose and basic usage examples.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/OTCore/blob/master/LICENSE) for details.

## Contributions

Bug fixes and improvements are welcome. Please open an issue to discuss prior to submitting PRs.
