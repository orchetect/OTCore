//
//  UserDefaults.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-12.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

import Foundation

extension UserDefaults {
	
	// custom optional methods for core data types that don't intrinsically support optionals yet
	
	/// OTCore:
	/// Convenience method to wrap the built-in `.integer(forKey:)` method in an optional returning nil if the key doesn't exist.
	public func integerOptional(forKey: String) -> Int? {
		
		guard self.object(forKey: forKey) != nil else { return nil }
		return self.integer(forKey: forKey)
		
	}
	
	/// OTCore:
	/// Convenience method to wrap the built-in `.double(forKey:)` method in an optional returning nil if the key doesn't exist.
	public func doubleOptional(forKey: String) -> Double? {
		
		guard self.object(forKey: forKey) != nil else { return nil }
		return self.double(forKey: forKey)
		
	}
	
	/// OTCore:
	/// Convenience method to wrap the built-in `.float(forKey:)` method in an optional returning nil if the key doesn't exist.
	public func floatOptional(forKey: String) -> Float? {
		
		guard self.object(forKey: forKey) != nil else { return nil }
		return self.float(forKey: forKey)
		
	}
	
	/// OTCore:
	/// Convenience method to wrap the built-in `.bool(forKey:)` method in an optional returning nil if the key doesn't exist.
	public func boolOptional(forKey: String) -> Bool? {
		
		guard self.object(forKey: forKey) != nil else { return nil }
		return self.bool(forKey: forKey)
		
	}
	
}
