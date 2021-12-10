//
//  NSEvent Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if os(macOS)

import XCTest
@testable import OTCore
import AppKit

class Extensions_AppKit_NSEvent_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testLocationInView() {
        // not sure why, but this test doesn't run unless you start it with a print statement
        print("Starting test...")
        
        let view = NSView(frame: NSRect())
        let subview = NSView(frame: NSRect())
        view.addSubview(subview)
        
        var window: NSWindow? = NSWindow()
        window!.contentView = view
        window!.setFrame(.init(x: 0, y: 0, width: 800, height: 800), display: true)
        
        subview.setFrameOrigin(.init(x: 100, y: 100))
        subview.setFrameSize(.init(width: 400, height: 400))
        
        // create a mock `mouseDown(with event: NSEvent)` event
        guard let mockEvent = NSEvent.mouseEvent(
            with: .leftMouseDown,
            location: .init(x: 300, y: 300), // location in window's coord system
            modifierFlags: [],
            timestamp: ProcessInfo.processInfo.systemUptime,
            windowNumber: 0,
            context: nil,
            eventNumber: 0,
            clickCount: 1,
            pressure: 1.0
        ) else {
            XCTFail("Could not create NSEvent.") ; return
        }
        
        // check native property for expected value
        XCTAssertEqual(mockEvent.locationInWindow,
                        .init(x: 300, y: 300))
        
        // check native method
        XCTAssertEqual(subview.convert(mockEvent.locationInWindow, from: nil),
                        .init(x: 200, y: 200))
        
        // test OTCore method
        XCTAssertEqual(mockEvent.location(in: subview),
                        .init(x: 200, y: 200))
        
        // dispose of window, keeping view in memory
        window?.contentView = nil
        window = nil
        XCTAssertNil(view.window)
        XCTAssertNotNil(view)
        XCTAssertNotNil(subview)
        
        // check native method
        XCTAssertEqual(subview.convert(mockEvent.locationInWindow, from: nil),
                       .init(x: 200, y: 200))
        
        // test OTCore method
        XCTAssertEqual(mockEvent.location(in: subview),
                       .init(x: 200, y: 200))
        
    }
    
}

#endif
