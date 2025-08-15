//
//  NSEvent Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import AppKit
@testable import OTCore
import Testing

@Suite struct Extensions_AppKit_NSEvent_Tests {
    @MainActor @Test
    func locationInView() throws {
        let view = NSView(frame: NSRect())
        let subview = NSView(frame: NSRect())
        view.addSubview(subview)
        
        var window: NSWindow? = NSWindow()
        window!.contentView = view
        window!.setFrame(.init(x: 0, y: 0, width: 800, height: 800), display: true)
        
        subview.setFrameOrigin(.init(x: 100, y: 100))
        subview.setFrameSize(.init(width: 400, height: 400))
        
        // create a mock `mouseDown(with event: NSEvent)` event
        let mockEvent = try #require(NSEvent.mouseEvent(
            with: .leftMouseDown,
            location: .init(x: 300, y: 300), // location in window's coord system
            modifierFlags: [],
            timestamp: ProcessInfo.processInfo.systemUptime,
            windowNumber: 0,
            context: nil,
            eventNumber: 0,
            clickCount: 1,
            pressure: 1.0
        ))
        
        // check native property for expected value
        #expect(
            mockEvent.locationInWindow
                == .init(x: 300, y: 300)
        )
        
        // check native method
        #expect(
            subview.convert(mockEvent.locationInWindow, from: nil)
                == .init(x: 200, y: 200)
        )
        
        // test OTCore method
        #expect(
            mockEvent.location(in: subview)
                == .init(x: 200, y: 200)
        )
        
        // dispose of window, keeping view in memory
        window?.contentView = nil
        window = nil
        #expect(view.window == nil)
        
        // check native method
        #expect(
            subview.convert(mockEvent.locationInWindow, from: nil)
                == .init(x: 200, y: 200)
        )
        
        // test OTCore method
        #expect(
            mockEvent.location(in: subview)
                == .init(x: 200, y: 200)
        )
    }
}

#endif
