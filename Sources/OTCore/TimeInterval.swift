//
//  TimeInterval.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-09.
//  Copyright © 2020 Steffan Andrews. All rights reserved.

import Foundation

extension TimeInterval {
	
	/// OTCore:
	/// Convenience constructor from `timespec`
	public init(_ time: timespec) {
		
		self = time.doubleValue
		
	}
	
}
