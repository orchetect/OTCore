//
//  Concurrency.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Task Group

/// **OTCore:**
/// Wrapper for `withTaskGroup` that performs a task for each element of a sequence, outputting a
/// new sequence maintaining element ordering.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@inlinable @_disfavoredOverload
public func withOrderedTaskGroup<Base: Sequence, ResultElement>(
    sequence: Base,
    priority: TaskPriority? = nil,
    isolation: isolated (any Actor)? = #isolation,
    elementTask: @Sendable @escaping @isolated(any) (_ element: Base.Element) async -> ResultElement
) async -> [ResultElement] where Base.Element: Sendable, ResultElement: Sendable {
    await withTaskGroup(of: (Int, ResultElement).self, isolation: isolation) { group in
        for (number, element) in sequence.enumerated() {
            group.addTask(priority: priority) {
                await (number, elementTask(element))
            }
        }
        
        var dict = [Int: ResultElement](minimumCapacity: sequence.underestimatedCount)
        
        for await (index, item) in group {
            dict[index] = item
        }
        
        return dict
            .sorted(by: { $0.key < $1.key })
            .map(\.value)
    }
}
