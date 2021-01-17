//
//  URL and AppKit.swift
//  OTCore
//
//  Created by Steffan Andrews on 2019-10-03.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if os(macOS)

import AppKit

// MARK: - Images

extension URL {
	
	/// **OTCore:**
	/// Returns the icon that represents the given file, folder, application, etc.
	/// Returns nil if URL is not a file URL or if file does not exist.
	/// Thread-safe.
	public var icon: NSImage? {
		
		guard isFileURL else { return nil }
		guard fileExists else { return nil }
		
		return NSWorkspace.shared.icon(forFile: self.path)
		
	}
	
}

#endif
