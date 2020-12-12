//
//  Timespec.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-12-11.
//  Copyright © 2020 Steffan Andrews. All rights reserved.

import Foundation

// CLOCK_MONOTONIC clock that increments monotonically, tracking the time since an arbitrary point, and will continue to increment while the system is asleep.
//
// CLOCK_MONOTONIC_RAW clock that increments monotonically, tracking the time since an arbitrary point like CLOCK_MONOTONIC. However, this clock is unaffected by frequency or time adjustments. It should not be compared to other system time sources.
//
// CLOCK_MONOTONIC_RAW_APPROX like CLOCK_MONOTONIC_RAW, but reads a value cached by the system at context switch. This can be read faster, but at a loss of accuracy as it may return values that are milliseconds old.
//
// CLOCK_UPTIME_RAW clock that increments monotonically, in the same manner as CLOCK_MONOTONIC_RAW, but that does not increment while the system is asleep. The returned value is identical to the result of mach_absolute_time() after the appropriate mach_timebase conversion is applied.

/// Returns high-precision system uptime
///
/// This is preferable to using `mach_absolute_time()` since `mach_absolute_time()` is macOS-only.
///
/// - returns: `timespec(tv_sec: Int, tv_nsec: Int)` where `tv_sec` is seconds and `tc_nsec` is nanoseconds
@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
public func clock_gettime_monotonic_raw() -> timespec {

	var uptime = timespec()
	
	if 0 != clock_gettime(CLOCK_MONOTONIC_RAW, &uptime) {
		fatalError("Could not execute clock_gettime, errno: \(errno)")
	}

	return uptime
	
}


// MARK: - Timespec operators and comparison

public func + (lhs: timespec, rhs: timespec) -> timespec {
	
	let nsRaw = rhs.tv_nsec + lhs.tv_nsec
	
	let ns = nsRaw % 1_000_000_000
	
	let s = lhs.tv_sec + rhs.tv_sec + (nsRaw / 1_000_000_000)
	
	return timespec(tv_sec: s, tv_nsec: ns)
	
}

public func - (lhs: timespec, rhs: timespec) -> timespec {
	
	let nsRaw = lhs.tv_nsec - rhs.tv_nsec
	
	if nsRaw >= 0 {
		let ns = nsRaw % 1_000_000_000
		
		let s = lhs.tv_sec - rhs.tv_sec + (nsRaw / 1_000_000_000)
		
		return timespec(tv_sec: s, tv_nsec: ns)
		
	} else {
		// rollunder
		
		let ns = -nsRaw % 1_000_000_000

		let s = lhs.tv_sec - rhs.tv_sec - 1 - (-nsRaw / 1_000_000_000)
		
		return timespec(tv_sec: s, tv_nsec: ns)
		
	}
	
}

extension timespec: Equatable {
	
	static public func == (lhs: Self, rhs: Self) -> Bool {
		
		return lhs.tv_sec == rhs.tv_sec &&
			lhs.tv_nsec == rhs.tv_nsec
		
	}
	
}

extension timespec: Comparable {

	public static func < (lhs: timespec, rhs: timespec) -> Bool {
		if lhs.tv_sec < rhs.tv_sec { return true }
		if lhs.tv_sec > rhs.tv_sec { return false }
		
		// seconds equate; now test nanoseconds
		
		if lhs.tv_nsec < rhs.tv_nsec { return true }
		
		return false
		
	}

}
