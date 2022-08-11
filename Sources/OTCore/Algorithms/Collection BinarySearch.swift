//
//  Collection BinarySearch.swift
//  OTCore • https://github.com/orchetect/OTCore
//

// MARK: - Search algorithms

extension ArraySlice where Element: Comparable {
    /// **OTCore:**
    /// Performs a binary search algorithm.
    ///
    /// - If the value is found, a single-count range is returned with the index (ie: 4...4).
    ///
    /// - If the value is not found, a 2-count range is returned with the two neighboring indexes below and above the search value.
    ///
    /// - If the search value is not within the upper and lower bounds of the array's values, `nil` is returned.
    ///
    /// Example:
    ///
    ///     [1,2,3,4,5].binarySearch(forValue: 3)  // 2...2
    ///     [1,2,4,5,6].binarySearch(forValue: 3)  // 1...2
    ///     [1,2,3,4,5].binarySearch(forValue: 10) // nil
    ///     [].binarySearch(forValue: 10)          // nil
    ///
    /// - warning: The base array must be `.sorted()` prior to invoking this method or it will not function as intended.
    @_disfavoredOverload
    public func binarySearch(
        forValue searchElement: Element
    ) -> ClosedRange<Self.Index>? {
        guard !isEmpty else { return nil }
        guard searchElement >= first! else { return nil }
        guard searchElement <= last!  else { return nil }
        
        var searchRange = startIndex ... endIndex - 1
        
        while searchRange.count > 2 {
            let midIndex = searchRange.lowerBound + (searchRange.count / 2)
            
            let midElement = self[midIndex]
            
            if midElement == searchElement { return midIndex ... midIndex }
            
            if midElement < searchElement {
                searchRange = midIndex ... searchRange.upperBound
            } else {
                searchRange = searchRange.lowerBound ... midIndex
            }
        }
        
        if let foundIndex = self[searchRange].firstIndex(where: { $0 == searchElement }) {
            return foundIndex ... foundIndex
        } else {
            return searchRange
        }
    }
}

extension Array where Element: Comparable {
    /// **OTCore:**
    /// Performs a binary search algorithm.
    ///
    /// - If the value is found, a single-count range is returned with the index (ie: 4...4).
    ///
    /// - If the value is not found, a 2-count range is returned with the two neighboring indexes below and above the search value.
    ///
    /// - If the search value is not within the upper and lower bounds of the array's values, `nil` is returned.
    ///
    /// Example:
    ///
    ///     [1,2,3,4,5].binarySearch(forValue: 3)  // 2...2
    ///     [1,2,4,5,6].binarySearch(forValue: 3)  // 1...2
    ///     [1,2,3,4,5].binarySearch(forValue: 10) // nil
    ///     [].binarySearch(forValue: 10)          // nil
    ///
    /// - warning: The base array must be `.sorted()` prior to invoking this method or it will not function as intended.
    @_disfavoredOverload
    public func binarySearch(
        forValue searchElement: Element
    ) -> ClosedRange<Self.Index>? {
        ArraySlice(self).binarySearch(forValue: searchElement)
    }
}
