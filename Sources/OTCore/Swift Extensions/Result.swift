//
//  Result.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-05-26.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

public typealias AnyResult = Result<Any, Error>

extension Result {
	
	/// OTCore:
	/// If `.success` case, returns associated value unwrapped.
	public var successValue: Success? {
		guard case .success(let value) = self else { return nil }
		return value
	}
	
	/// OTCore:
	/// If `.failure` case, returns associated value unwrapped.
	public var failureValue: Failure? {
		guard case .failure(let value) = self else { return nil }
		return value
	}
	
	/// OTCore:
	/// Returns `true` if `.success(_)` case.
	/// Returns `false` if .`failure(_)` case.
	public var isSuccess: Bool {
		if case .success(_) = self { return true }
		return false
	}
	
}
