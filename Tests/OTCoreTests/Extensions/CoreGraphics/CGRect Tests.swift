//
//  CGRect Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreGraphics)

import CoreGraphics
@testable import OTCore
import Testing

@Suite struct Extensions_CoreGraphics_CGRect_Tests {
    @Test
    func center() {
        let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
        
        let center = rect.center
        
        #expect(center.x == 7)
        #expect(center.y == 13)
    }
    
    @Test
    func hrow() {
        let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
        
        let newRect = rect.grow(by: 1.5)
        
        #expect(newRect.origin.x == 0.5)
        #expect(newRect.origin.y == 1.5)
        #expect(newRect.width == 13.0)
        #expect(newRect.height == 23.0)
    }
    
    @Test
    func shrink() {
        let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
        
        let newRect = rect.shrink(by: 1.5)
        
        #expect(newRect.origin.x == 3.5)
        #expect(newRect.origin.y == 4.5)
        #expect(newRect.width == 7.0)
        #expect(newRect.height == 17.0)
    }
    
    @Test
    func scale() {
        do {
            let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
            
            let newRect = rect.scale(factor: 1)
            
            #expect(newRect.origin.x == 2.0)
            #expect(newRect.origin.y == 3.0)
            #expect(newRect.width == 10.0)
            #expect(newRect.height == 20.0)
        }
        do {
            let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
            
            let newRect = rect.scale(factor: 1.5)
            
            #expect(newRect.origin.x == 2.0 - 2.5)
            #expect(newRect.origin.y == 3.0 - 5.0)
            #expect(newRect.width == 15.0)
            #expect(newRect.height == 30.0)
        }
        do {
            let rect = CGRect(x: 2, y: 3, width: 10, height: 20)
            
            let newRect = rect.scale(factor: 0.5)
            
            #expect(newRect.origin.x == 2.0 + 2.5)
            #expect(newRect.origin.y == 3.0 + 5.0)
            #expect(newRect.width == 5.0)
            #expect(newRect.height == 10.0)
        }
    }
}

#endif
