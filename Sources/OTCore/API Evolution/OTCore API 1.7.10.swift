//
//  OTCore API 1.7.10.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension URL {
    @available(*, deprecated, renamed: "isDirectory")
    @_disfavoredOverload
    public var isFolder: Bool? {
        isDirectory
    }
}

#endif
