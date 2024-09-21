# OTCore

[![CI Build Status](https://github.com/orchetect/OTCore/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/OTCore/actions/workflows/build.yml) [![Platforms - macOS 10.12+ | iOS 9+ | tvOS 9+ | watchOS 2+ | visionOS 1+](https://img.shields.io/badge/platforms-macOS%2010.12+%20|%20iOS%209+%20|%20tvOS%209+%20|%20watchOS%202+%20|%20visionOS%201+-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.3-6.0](https://img.shields.io/badge/Swift-5.3–6.0-orange.svg?style=flat) [![Xcode 16+](https://img.shields.io/badge/Xcode-16+-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OTCore/blob/main/LICENSE)

Multi-platform Swift shared code module with useful extension methods on standard library types.

The library has full unit test coverage and is actively used in production.

## Installation: Swift Package Manager (SPM)

### Dependency within an Application

1. Add the package to your Xcode project using Swift Package Manager

   - Select File → Swift Packages → Add Package Dependency
   - Add package using  `https://github.com/orchetect/OTCore` as the URL.

2. Import the module in your *.swift files where needed.

   ```swift
   import OTCore
   ```

### Dependency within a Swift Package

In your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/orchetect/OTCore", from: "1.5.0")
]
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
