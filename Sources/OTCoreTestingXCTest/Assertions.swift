//
//  Assertions XCTest.swift
//  OTCore
//
//  Derived from https://izziswift.com/unit-test-fatalerror-in-swift/
//

#if !os(watchOS) && canImport(XCTest) 

import XCTest
@_exported import OTCoreTesting

fileprivate let noReturnFailureWaitTime = 0.1

public extension XCTestCase {
	
	/**
	Expects an `assert` to be called with a false condition.
	If `assert` not called or the assert's condition is true, the test case will fail.
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `assert`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectAssert(
		expectedMessage: String? = nil,
		file: StaticString = #file,
		line: UInt = #line,
		testCase: @escaping () -> Void
	) {
		
		expectAssertionReturnFunction(
			functionName: "assert",
			file: file,
			line: line,
			function: { (caller) -> () in
				
				Assertions.assertClosure = { condition, message, _, _ in
					caller(condition, message)
				}
				
			},
			expectedMessage: expectedMessage,
			testCase: testCase,
			cleanUp: { () -> () in
				
				Assertions.assertClosure = Assertions.swiftAssertClosure
				
			}
		)
		
	}
	
	/**
	Expects an `assertionFailure` to be called.
	If `assertionFailure` not called, the test case will fail.
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `assertionFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectAssertionFailure(
		expectedMessage: String? = nil,
		file: StaticString = #file,
		line: UInt = #line,
		testCase: @escaping () -> Void
	) {
		
		expectAssertionReturnFunction(
			functionName: "assertionFailure",
			file: file,
			line: line,
			function: { (caller) -> Void in
				
				Assertions.assertionFailureClosure = { message, _, _ in
					caller(false, message)
				}
				
			},
			expectedMessage: expectedMessage,
			testCase: testCase,
			cleanUp: { () -> () in
				
				Assertions.assertionFailureClosure = Assertions.swiftAssertionFailureClosure
				
			}
		)
		
	}
	
	/**
	Expects an `precondition` to be called with a false condition.
	If `precondition` not called or the precondition's condition is true, the test case will fail.
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `precondition`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectPrecondition(
		expectedMessage: String? = nil,
		file: StaticString = #file,
		line: UInt = #line,
		testCase: @escaping () -> Void
	) {
		
		expectAssertionReturnFunction(
			functionName: "precondition",
			file: file,
			line: line,
			function: { (caller) -> () in
				
				Assertions.preconditionClosure = { condition, message, _, _ in
					caller(condition, message)
				}
				
			},
			expectedMessage: expectedMessage,
			testCase: testCase,
			cleanUp: { () -> () in
				
				Assertions.preconditionClosure = Assertions.swiftPreconditionClosure
				
			}
		)
		
	}
	
	/**
	Expects an `preconditionFailure` to be called.
	If `preconditionFailure` not called, the test case will fail.
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `preconditionFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectPreconditionFailure(
		expectedMessage: String? = nil,
		file: StaticString = #file,
		line: UInt = #line,
		testCase: @escaping () -> Void
	) {
		
		expectAssertionNoReturnFunction(
			functionName: "preconditionFailure",
			file: file,
			line: line,
			function: { (caller) -> Void in
				
				Assertions.preconditionFailureClosure = { (message, _, _) -> Void in
					caller(message)
				}
				
			},
			expectedMessage: expectedMessage,
			testCase: testCase,
			cleanUp: { () -> () in
				
				Assertions.preconditionFailureClosure = Assertions.swiftPreconditionFailureClosure
				
			}
		)
		
	}
	
	/**
	Expects an `fatalError` to be called.
	If `fatalError` not called, the test case will fail.
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `fatalError`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	func expectFatalError(
		expectedMessage: String? = nil,
		file: StaticString = #file,
		line: UInt = #line,
		testCase: @escaping () -> Void) {
		
		expectAssertionNoReturnFunction(
			functionName: "fatalError",
			file: file,
			line: line,
			function: { (caller) -> Void in
				
				Assertions.fatalErrorClosure = { (message, _, _) -> Void in
					caller(message)
				}
				
			},
			expectedMessage: expectedMessage,
			testCase: testCase,
			cleanUp: { () -> () in
				
				Assertions.fatalErrorClosure = Assertions.swiftFatalErrorClosure
				
			}
		)
		
	}
	
	// MARK: - Private Methods
	
	func expectAssertionReturnFunction(
		functionName: String,
		file: StaticString,
		line: UInt,
		function: @escaping (_ caller: @escaping (Bool, String) -> Void) -> Void,
		expectedMessage: String? = nil,
		testCase: @escaping () -> Void,
		cleanUp: @escaping () -> Void
	) {
		
		let expect = expectation(description: functionName + "-Expectation")
		var assertion: (condition: Bool, message: String)? = nil
		
		function { (condition, message) in
			assertion = (condition, message)
			expect.fulfill()
		}
		
		// perform on the same thread since it will return
		testCase()
		waitForExpectations(timeout: 0) { _ in
			
			defer {
				// clean up
				cleanUp()
			}
			
			guard let assertion = assertion else {
				XCTFail(functionName + " is expected to be called.",
						file: file,
						line: line)
				return
			}
			
			XCTAssertFalse(assertion.condition,
						   functionName + " condition expected to be false",
						   file: file,
						   line: line)
			
			if let expectedMessage = expectedMessage {
				// assert only if not nil
				XCTAssertEqual(assertion.message,
							   expectedMessage,
							   functionName + " called with incorrect message.",
							   file: file,
							   line: line)
			}
			
		}
		
	}
	
	private func expectAssertionNoReturnFunction(
		functionName: String,
		file: StaticString,
		line: UInt,
		function: @escaping (_ caller: @escaping (String) -> Void) -> Void,
		expectedMessage: String? = nil,
		testCase: @escaping () -> Void,
		cleanUp: @escaping () -> Void
	) {
		
		let expect = expectation(description: functionName + "-Expectation")
		var assertionMessage: String? = nil
		
		function { (message) -> Void in
			assertionMessage = message
			expect.fulfill()
		}
		
		// act, perform on separate thread because a call to function runs forever
		DispatchQueue.global(qos: .userInitiated).async(execute: testCase)
		
		waitForExpectations(timeout: noReturnFailureWaitTime) { _ in
			
			defer {
				// clean up
				cleanUp()
			}
			
			guard let assertionMessage = assertionMessage else {
				XCTFail(functionName + " is expected to be called.",
						file: file,
						line: line)
				return
			}
			
			if let expectedMessage = expectedMessage {
				// assert only if not nil
				XCTAssertEqual(assertionMessage,
							   expectedMessage,
							   functionName + " called with incorrect message.",
							   file: file,
							   line: line)
			}
			
		}
		
	}
	
}

#endif
