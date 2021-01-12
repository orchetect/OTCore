//
//  Operators.swift
//  OTCore
//
//  Created by Steffan Andrews on 2018-12-07.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - Modulo FloatingPoint

infix operator %: MultiplicationPrecedence

/// OTCore:
/// Operator performing `.truncatingRemainder(dividingBy:)`
public func % <T: FloatingPoint>(lhs: T, rhs: T) -> T {
	return lhs.truncatingRemainder(dividingBy: rhs)
}



// MARK: - Modulo CGFloat

// % is built-in for CGFloat:
// _ = (43.0 as CGFloat) % 10.0


// MARK: - Modulo Decimal
		
// .truncatingRemainder(dividingBy:) and fmod() are not usable with Decimal

//_ = (43.0 as Decimal) % (10.0 as Decimal)					// doesn't work
//_ = (43.0 as NSDecimalNumber) % (10.0 as NSDecimalNumber)	// doesn't work
