//
//  DispatchGroup Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
@testable import OTCore
import Testing
import TestingExtensions

@Suite(.serialized) struct Extensions_Foundation_DispatchGroup_Tests {
    actor Expectation {
        var isFulfilled = false
        private func _fulfill() { isFulfilled = true }
        nonisolated func fulfill() { Task { await _fulfill() } }
    }
    
    @Test
    func sync() async {
        let exp = Expectation()
        
        DispatchGroup.sync { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                exp.fulfill()
                g.leave()
            }
        }
        
        await wait(expect: { await exp.isFulfilled }, timeout: 1.0)
    }
    
    @Test
    func syncOnQueue() async {
        let exp = Expectation()
        
        DispatchGroup.sync(asyncOn: .global()) { g in
            sleep(0.1)
            
            exp.fulfill()
            g.leave()
        }
        
        await wait(expect: { await exp.isFulfilled }, timeout: 1.0)
    }
    
    @Test
    func syncTimeout_timedOut() async {
        let exp = Expectation()
        
        let result = DispatchGroup.sync(timeout: .milliseconds(100)) { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                exp.fulfill()
                g.leave()
            }
        }
        
        await withKnownIssue {
            await wait(expect: { await exp.isFulfilled }, timeout: 0.5)
        }
        #expect(await !exp.isFulfilled)
        #expect(result == .timedOut)
    }
    
    @Test
    func syncTimeout_success() async {
        let exp = Expectation()
        
        let result = DispatchGroup.sync(timeout: .seconds(1)) { g in
            DispatchQueue.global().async() {
                exp.fulfill()
                g.leave()
            }
        }
        
        await wait(expect: { await exp.isFulfilled }, timeout: 0.5)
        #expect(result == .success)
    }
    
    @Test
    func syncOnQueueTimeout_timedOut() async {
        let exp = Expectation()
        
        let result = DispatchGroup.sync(asyncOn: .global(), timeout: .milliseconds(100)) { g in
            sleep(1) // 1 second
            exp.fulfill()
            g.leave()
        }
        
        await withKnownIssue {
            await wait(expect: { await exp.isFulfilled }, timeout: 0.5)
        }
        #expect(await !exp.isFulfilled)
        #expect(result == .timedOut)
    }
    
    @Test
    func syncOnQueueTimeout_success() async {
        let exp = Expectation()
        
        let result = DispatchGroup.sync(
            asyncOn: .global(),
            timeout: .seconds(1)
        ) { g in
            exp.fulfill()
            g.leave()
        }
        
        await wait(expect: { await exp.isFulfilled }, timeout: 0.5)
        #expect(result == .success)
    }
    
    @Test
    func syncReturnValue() {
        let returnValue = DispatchGroup.sync { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                g.leave(withValue: 1)
            }
        }
        
        #expect(returnValue == 1)
    }
    
    @Test
    func syncReturnValueOnQueue() {
        let returnValue: Int = DispatchGroup.sync(asyncOn: .global()) { g in
            sleep(0.1)
            g.leave(withValue: 1)
        }
        
        #expect(returnValue == 1)
    }
    
    @Test
    func syncReturnValueTimeout_timedOut() {
        let result = DispatchGroup.sync(timeout: .milliseconds(100)) { g in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                g.leave(withValue: 1)
            }
        }
        
        switch result {
        case .success:
            #fail()
        case .timedOut:
            // correct
            break
        }
    }
    
    @Test
    func syncReturnValueTimeout_success() {
        let result = DispatchGroup.sync(timeout: .milliseconds(500)) { g in
            DispatchQueue.global().async() {
                g.leave(withValue: 1)
            }
        }
        
        switch result {
        case let .success(value):
            // correct
            #expect(value == 1)
        case .timedOut:
            #fail()
        }
    }
    
    @Test
    func syncReturnValueOnQueueTimeout_timedOut() {
        let result: DispatchSyncTimeoutResult<Int> =
            DispatchGroup.sync(
                asyncOn: .global(),
                timeout: .milliseconds(100)
            ) { g in
                sleep(1) // 1 second
                g.leave(withValue: 1)
            }
        
        switch result {
        case .success:
            #fail()
        case .timedOut:
            // correct
            break
        }
    }
    
    @Test
    func syncReturnValueOnQueueTimeout_success() {
        let result: DispatchSyncTimeoutResult<Int> =
            DispatchGroup.sync(
                asyncOn: .global(),
                timeout: .seconds(1)
            ) { g in
                g.leave(withValue: 1)
            }
        
        switch result {
        case let .success(value):
            // correct
            #expect(value == 1)
        case .timedOut:
            #fail()
        }
    }
    
    @Test
    func nesting() {
        var val = 0
        
        var to1: DispatchTimeoutResult?
        var to2: DispatchTimeoutResult?
        
        to1 = DispatchGroup.sync(timeout: .seconds(1)) { g in
            to2 = DispatchGroup.sync(timeout: .milliseconds(500)) { g in
                val = 1
                g.leave()
            }
            g.leave()
        }
        
        #expect(to1 == .success)
        #expect(to2 == .success)
        #expect(val == 1)
    }
}

#endif
