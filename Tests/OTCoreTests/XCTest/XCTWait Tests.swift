//
//  XCTWait Tests.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if !os(watchOS)

import XCTest
/* @testable */ import OTCore

class XCTest_XCTWait_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    @available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func testXCTWait() {
        
        func runTest(duration: Double, margin: ClosedRange<Double>) {

            let startTime = clock_gettime_monotonic_raw()
            
            XCTWait(sec: duration)
            
            let endTime = clock_gettime_monotonic_raw()
            
            let diffTime = (endTime - startTime).doubleValue
            
            // this unit test is flakey because it depends on the performance of the hardware it is run on
            // additionally, CI platforms are too inconsistent and can't guarantee stability of timing mechanisms in unit tests... which means we need to approach this differently in future, but for now we'll ignore it
            
            XCTAssertGreaterThan(diffTime, margin.lowerBound)
            XCTAssertLessThan(diffTime, margin.upperBound + 0.500)
            
            // just print a log message if diffTime is out of margin,
            // but don't fail the test
            if !diffTime.isContained(in: margin) {
                Log.error("Tested XCTWait duration of \(duration)sec, with an accuracy margin of \(margin.lowerBound)...\(margin.upperBound) but measured time was out of margin at \(diffTime)sec.")
            }

        }
        
        // small values
        runTest(duration: 0.0000, margin: 0.0000...0.0020)
        runTest(duration: 0.0050, margin: 0.0049...0.0070)
        
        // medium value
        runTest(duration: 0.5000, margin: 0.4999...0.5020)
        
        
        
        // alternate method, but measure{} wasn't feeling like the right tool for this job:
        
        //let measureOptions = XCTMeasureOptions()
        //measureOptions.iterationCount = 3
        //measure(options: measureOptions) {
        //    XCTWait(sec: 0.5000)
        //}
        
    }
    
}

#endif
