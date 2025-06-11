# OTCore

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2FOTCore%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/OTCore) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2FOTCore%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/OTCore) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OTCore/blob/main/LICENSE)

Multi-platform Swift shared code module with useful extension methods on standard library types.

The library has full unit test coverage and is actively used in production.

## Installation: Swift Package Manager (SPM)

### Dependency within an Application

1. Add the package to your Xcode project using Swift Package Manager using `https://github.com/orchetect/OTCore` as the URL.

2. Import the module files where needed. It's recommended to use the `internal` access level if used in a package so that it is not exported to the user of your package.

   ```swift
   internal import OTCore
   ```

### Dependency within a Swift Package

In your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/orchetect/OTCore", from: "1.7.4")
]
```

## Documentation

Most methods are implemented as category methods so they are generally discoverable.

All methods are documented with inline help explaining their purpose and basic usage examples.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/OTCore/blob/master/LICENSE) for details.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/OTCore/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/OTCore/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/OTCore/discussions) first prior to new submitting PRs for features or modifications is encouraged.
