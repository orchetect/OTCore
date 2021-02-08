//
//  Transformable.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-02-07.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

// MARK: - Transformable Protocol

/// A protocol that adds the `.transform{} -> Self` and `.transformed{} -> T` methods to a type that does not otherwise already have those methods exposed on it.
///
/// Since in the Swift language it is not possible to extend `Any` or `AnyObject`, this approach is a compromise. `.transform` and `.transformed` have been implemented on `Equatable` so any type that conforms to `Equatable` will get these methods for free. For types that do not conform to `Equatable` or cannot conform to it, the `Transformable` protocol has been provided to add these methods.
///
/// It is useful to note that all `NSObject`-based classes intrinsically conform to `Equatable`. As well, all Swift `Optional`s are bound by `Equatable` so even if the wrapped type has no exposure to .`transform`/`.transformed`, these two functions will be exposed on a wrapped `Optional` containing that type.
///
/// For Example:
///
/// # On a type you control:
///
///     // gets .transform and .transformed for free
///     // (do NOT also add Transformable to Equatable types)
///     struct MyStruct: Equatable { }
///
/// # or:
///
///     // add Transformable,
///     // if adding Equatable conformance is not possible or desirable
///     struct MyStruct: Transformable { }
///
/// # On a struct you do not control:
///
///     // add Transformable if type is not already Equatable
///     struct OtherStruct { }
///     extension OtherStruct: Transformable { }
///
/// # On a class you do not control:
///
///     // Transformable conformance is NOT supported in this case,
///     // Due to restrictions of the Swift compiler.
///     class OtherClass { }
///     extension OtherClass: Transformable { } // 🛑 compile error
///
///     // There are a few exceptions:
///
///     // #1: If the class is marked "final"
///     final class OtherClass { }
///     extension OtherClass: Transformable { }
///
///     // Or:
///
///     // #2: If you can conform it to Equatable:
///     // this will bring .transform and .transformed with it
///     // without needing to conform to Transformable
///     class OtherClass { }
///     extension OtherClass: Equatable { }
///
/// - warning: Do not add this protocol to types that already conform to `Equatable`.
/// When conforming a class to `Transformable`, it must be a `final class`.
public protocol Transformable {
	
	func transformed<T>(_ transform: (Self) throws -> T) rethrows -> T
	
	mutating func transform(_ mutation: (inout Self) throws -> Void) rethrows -> Self
	
}


// MARK: Transformable impl.

extension Transformable {
	
	/// **OTCore:**
	/// Returns a new value transformed by a closure.
	/// (Functional convenience method)
	///
	/// Example 1 - simple operation:
	///
	///     123.transformed { $0 * 2 } // 246
	///
	/// Example 2 - different resulting type:
	///
	///     123.transformed { "\($0)" } // "123"
	///
	/// Example 3 - complex transform block
	///
	///     123.transformed { (source) -> Bool in
	///         let calc = Double(source) * 2 / 14.9
	///         let rounded = round(calc)
	///         return rounded > 18
	///     }
	///
	/// Example 4 - chainable:
	///
	///     123.transformed { $0 * 2 / 12.47 }
	///         .rounded()
	///         .transformed { "Rounded value: \($0)" }
	///     // "Rounded value: 20.0"
	///
	/// - note: When `self` is an implicitly-unwrapped Optional, you need to either force-unwrap it before you can use `.transformed` or use the alternative `.transformedOptional` method.
	///
	/// Example:
	///
	///     let int: Int! = 123
	///     int!.transformed { $0 * 2 } // 246
	///     int.transformedOptional { $0! * 2 } // 246
	///
	@inlinable public
	func transformed<T>(_ transform: (Self) throws -> T) rethrows -> T {
		
		try transform(self)
		
	}
	
	/// **OTCore:**
	/// Mutate a value in place and also return it in order to continue chaining methods.
	/// (Functional convenience method)
	@inlinable @discardableResult public
	mutating func transform(_ mutation: (inout Self) throws -> Void) rethrows -> Self {
		
		try mutation(&self)
		
		return self
		
	}
	
}


// MARK: Transformable class-only impl.
// required to allow chaining multiple `.transform{}` blocks

extension Transformable where Self : AnyObject {
	
	/// **OTCore:**
	/// Mutate a value in place and also return it in order to continue chaining methods.
	/// (Functional convenience method)
	@inlinable @discardableResult public
	func transform(_ mutation: (Self) throws -> Void) rethrows -> Self {
		
		try mutation(self)
		
		return self
		
	}
	
}


// MARK: - Optional impl.

extension Optional: Transformable {
	
	/// **OTCore:**
	/// Returns the result of transforming a wrapped Optional using a closure.
	/// (Functional convenience method)
	@inlinable public
	func transformedOptional<T>(_ transform: (Self) throws -> T) rethrows -> T {
		
		try transform(self)
		
	}
	
	/// **OTCore:**
	/// Mutate a wrapped Optional in place and also return it in order to continue chaining methods.
	/// (Functional convenience method)
	@inlinable @discardableResult public
	mutating func transformOptional(_ mutation: (inout Self) throws -> Void) rethrows -> Self {
		
		try mutation(&self)
		
		return self
		
	}
	
}


// MARK: Equatable class-only impl.
// required to allow chaining multiple `.transform{}` blocks

extension Optional where Wrapped : AnyObject {
	
	/// **OTCore:**
	/// Mutate a value in place and also return it in order to continue chaining methods.
	/// (Functional convenience method)
	@inlinable @discardableResult public
	func transform(_ mutation: (Self) throws -> Void) rethrows -> Self {
		
		try mutation(self)
		
		return self
		
	}
	
}


// MARK: - Equatable impl.

extension Equatable {
	
	/// **OTCore:**
	/// Returns a new value transformed by a closure.
	/// (Functional convenience method)
	///
	/// Example 1 - simple operation:
	///
	///     123.transformed { $0 * 2 } // 246
	///
	/// Example 2 - different resulting type:
	///
	///     123.transformed { "\($0)" } // "123"
	///
	/// Example 3 - complex transform block
	///
	///     123.transformed { (source) -> Bool in
	///         let calc = Double(source) * 2 / 14.9
	///         let rounded = round(calc)
	///         return rounded > 18
	///     }
	///
	/// Example 4 - chainable:
	///
	///     123.transformed { $0 * 2 / 12.47 }
	///         .rounded()
	///         .transformed { "Rounded value: \($0)" }
	///     // "Rounded value: 20.0"
	///
	/// - note: When `self` is an implicitly-unwrapped Optional, you need to either force-unwrap it before you can use `.transformed` or use the alternative `.transformedOptional` method.
	///
	/// Example:
	///
	///     let int: Int! = 123
	///     int!.transformed { $0 * 2 } // 246
	///     int.transformedOptional { $0! * 2 } // 246
	///
	@inlinable public
	func transformed<T>(_ transform: (Self) throws -> T) rethrows -> T {
		
		try transform(self)
		
	}
	
	/// **OTCore:**
	/// Mutate a value in place and also return it in order to continue chaining methods.
	/// (Functional convenience method)
	@inlinable @discardableResult public
	mutating func transform(_ mutation: (inout Self) throws -> Void) rethrows -> Self {
		
		try mutation(&self)
		
		return self
		
	}
	
}


// MARK: Equatable class-only impl.
// required to allow chaining multiple `.transform{}` blocks

extension Equatable where Self : AnyObject {
	
	/// **OTCore:**
	/// Mutate a value in place and also return it in order to continue chaining methods.
	/// (Functional convenience method)
	@inlinable @discardableResult public
	func transform(_ mutation: (Self) throws -> Void) rethrows -> Self {
		
		try mutation(self)
		
		return self
		
	}
	
}
