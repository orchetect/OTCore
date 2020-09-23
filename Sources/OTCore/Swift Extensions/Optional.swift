//
//  Optional.swift
//  OTCore
//
//  Created by Steffan Andrews on 2018-09-29.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation

/// OTCore:
/// Protocol describing an optional, so `.optional` is available on all Optionals. Used to enable extensions on types such as `Type<T>?`.
public protocol OptionalType {
	
	associatedtype Wrapped
	
	/// OTCore:
	/// Return an object as an optional.
	var optional: Wrapped? { get }
	
}

extension Optional: OptionalType {
	
	/// OTCore:
	/// Semantic workaround to make `.optional` available on all Optionals. Used to enable extensions on types such as `Type<T>?`.
	public var optional: Wrapped? {
		return self
	}
	
}

extension Optional {
	
	/// OTCore:
	/// Nil-coalescing ?? operator employed as a function
	public func ifNil(_ defaultValue: Wrapped) -> Wrapped {
		return self ?? defaultValue
	}
	
}
