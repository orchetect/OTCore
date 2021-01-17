//
//  Pasteboard.swift
//  OTCore
//
//  Created by Steffan Andrews on 2020-07-30.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if os(macOS)

import AppKit

extension NSPasteboard.PasteboardType {
	
	/// **OTCore:**
	/// Can use in place of `.fileURL` when building for platforms earlier than macOS 10.13.
	public static var fileURLBackCompat: Self {
		
		if #available(macOS 10.13, *) {
			return .fileURL
			
		} else {
			// Fallback on earlier versions
			return .init(kUTTypeFileURL as String)
			
		}
		
	}
	
}

#endif
