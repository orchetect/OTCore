//
//  TimeInterval.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-09.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if canImport(Foundation)

import Foundation

extension TimeInterval {
	
	/// **OTCore:**
	/// Convenience constructor from `timespec`
	@inlinable public init(_ time: timespec) {
		
		self = time.doubleValue
		
	}
	
}

#endif
