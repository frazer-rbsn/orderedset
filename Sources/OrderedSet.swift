/// A static, ordered collection of unique objects.
/// Available under the MIT License. https://mit-license.org
/// - author: Frazer Robinson
@frozen public struct OrderedSet<E: Hashable> {

	// MARK: - Typealiases

	public typealias Element = E
	public typealias Index = Int

	@usableFromInline typealias HashValue = Int
	@usableFromInline typealias HashIndexDict = [HashValue: Index]

	// MARK: - Internal Storage

	private let _array: ContiguousArray<Element>
	private let _set: Set<Element>
	private let _hashIndexDict: HashIndexDict

	// MARK: - Public Stored Properties

	/// Returns the number of elements in this ordered set.
	public let count: Int

	/// Returns `true` if this ordered set is empty.
	public let isEmpty: Bool

	// MARK: - Public Initialisers

	/// Creates an ordered set with the contents of `sequence`.
	/// - parameter retainLastOccurences: If set to `true`, if an element occurs more than once in `sequence`, only the last instance
	///   will be included. Default value is `false`.
	public init<S>(_ sequence: S, retainLastOccurences: Bool = false) where Element == S.Element, S: Sequence {
		if retainLastOccurences {
			self.init(retainingLastOccurrencesIn: sequence)
		} else {
			self.init(retainingFirstOccurrencesIn: sequence)
		}
	}

	/// Creates an ordered set with the contents of `set`, ordered by the given predicate.
	public init(_ set: Set<Element>, sortedBy areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
		let sortedArray = try set.sorted(by: areInIncreasingOrder)
		self.init(array: ContiguousArray(sortedArray),
		          set: set,
		          hashIndexDict: Self.hashIndexDict(from: sortedArray))
	}

	/// Creates an ordered set with the contents of `set`, sorted according to the member type's conformance to `Comparable`.
	public init(_ set: Set<Element>) where Element: Comparable {
		let sortedArray = set.sorted()
		self.init(array: ContiguousArray(sortedArray),
		          set: set,
		          hashIndexDict: Self.hashIndexDict(from: sortedArray))
	}

	/// Creates an empty ordered set.
	public init() {
		self.init(array: [],
		          set: [],
		          hashIndexDict: [:])
	}

	// MARK: - Private Initialisers

	private init<S>(retainingFirstOccurrencesIn sequence: S) where Element == S.Element, S: Sequence {
		var array = ContiguousArray<Element>()
		var set = Set<Element>()
		var indexDict = HashIndexDict()
		for element in sequence {
			let inserted = set.insert(element).inserted
			guard inserted else { continue }

			array.append(element)
			indexDict[element.hashValue] = array.endIndex - 1
		}
		self.init(array: array,
		          set: set,
		          hashIndexDict: indexDict)
	}

	private init<S>(retainingLastOccurrencesIn sequence: S) where Element == S.Element, S: Sequence {
		var array = ContiguousArray<Element>()
		var set = Set<Element>()
		for element in sequence {
			let inserted = set.insert(element).inserted
			if !inserted {
				let index = array.lastIndex(of: element)!
				array.remove(at: index)
			}
			array.append(element)
		}
		self.init(array: array,
		          set: set)
	}

	private init(array: ContiguousArray<Element>, set: Set<Element>) {
		self.init(array: array,
		          set: set,
		          hashIndexDict: Self.hashIndexDict(from: array))
	}

	private init(array: [Element], set: Set<Element>) {
		self.init(array: ContiguousArray(array),
		          set: set,
		          hashIndexDict: Self.hashIndexDict(from: array))
	}

	private init(array: ContiguousArray<Element>, set: Set<Element>, hashIndexDict: HashIndexDict) {
		self._array = array
		self._set = set
		self._hashIndexDict = hashIndexDict
		self.count = array.count
		self.isEmpty = array.isEmpty
	}

	private static func hashIndexDict<S>(from sequence: S) -> HashIndexDict where Element == S.Element, S: Sequence {
		var indexDict = HashIndexDict()
		for (index, element) in sequence.enumerated() {
			indexDict[element.hashValue] = index
		}
		return indexDict
	}

	// MARK: - Computed Properties

	/// Returns the contents of this ordered set as an array.
	public var array: [Element] { Array(_array) }

	/// Returns the contents of this ordered set as a `ContiguousArray`.
	/// - complexity: O(1)
	public var contiguousArray: ContiguousArray<Element> { _array }

	/// Returns the contents of this ordered set as an unordered set.
	/// - complexity: O(1)
	public var unorderedSet: Set<Element> { _set }

	// MARK: - Metadata Functions

	/// Returns `true` if this ordered set contains `element`.
	/// - complexity: O(1)
	public func contains(_ element: Element) -> Bool {
		_set.contains(element)
	}

	/// Returns `true` if this ordered set contains any element in `elements`.
	/// - complexity: O(n) where n is the length of `elements`.
	public func contains(anyOf elements: Element...) -> Bool {
		for e in elements {
			if _set.contains(e) {
				return true
			}
		}
		return false
	}

	/// Returns the index of `element`, or `nil` if it is not a member of this ordered set.
	/// - complexity: O(1)
	public func index(of element: Element) -> Index? {
		_hashIndexDict[element.hashValue]
	}

	// Overrides method from `Collection`
	/// Returns the index of `element`, or `nil` if it is not a member of this ordered set.
	/// - complexity: O(1)
	/// - note: All members of `OrderedSet` are unique. Please use `index(of:)` instead.
	@inlinable public func firstIndex(of element: Element) -> Index? {
		index(of: element)
	}

	// Overrides method from `Collection`
	/// Returns the index of `element`, or `nil` if it is not a member of this ordered set.
	/// - complexity: O(1)
	/// - note: All members of `OrderedSet` are unique. Please use `index(of:)` instead.
	@inlinable public func lastIndex(of element: Element) -> Index? {
		index(of: element)
	}

	/// Returns `true` if this ordered set is a subset of `otherSet`.
	public func isSubset(of otherSet: Set<Element>) -> Bool {
		_set.isSubset(of: otherSet)
	}

	/// Returns `true` if this ordered set is a subset of `otherSet`.
	public func isSubset(of otherSet: Self) -> Bool {
		_set.isSubset(of: otherSet)
	}

	/// Returns `true` if this ordered set is a superset of `otherSet`.
	public func isSuperset(of otherSet: Set<Element>) -> Bool {
		_set.isSuperset(of: otherSet)
	}

	/// Returns `true` if this ordered set is a superset of `otherSet`.
	public func isSuperset(of otherSet: Self) -> Bool {
		_set.isSuperset(of: otherSet)
	}

	/// Returns `true` if this ordered set has elements in common with `otherSet`.
	public func intersects(with otherSet: Set<Element>) -> Bool {
		!_set.isDisjoint(with: otherSet)
	}

	/// Returns `true` if this ordered set has elements in common with `otherSet`.
	public func intersects(with otherSet: Self) -> Bool {
		!_set.isDisjoint(with: otherSet)
	}

	/// Returns `true` if this ordered set has no elements in common with `otherSet`.
	public func isDisjoint(with otherSet: Set<Element>) -> Bool {
		_set.isDisjoint(with: otherSet)
	}

	/// Returns `true` if this ordered set has no elements in common with `otherSet`.
	public func isDisjoint(with otherSet: Self) -> Bool {
		_set.isDisjoint(with: otherSet)
	}

	// MARK: - Creation Functions

	// MARK: Adding Elements

	/// Returns a new ordered set with `element` inserted at the end.
	/// This function returns an equivalent ordered set if `element` is
	/// already a member.
	public func appending(_ element: Element) -> Self {
		var set = _set
		let inserted = set.insert(element).inserted
		guard inserted else { return self }

		var dict = _hashIndexDict
		dict[element.hashValue] = endIndex
		var array = _array
		array.append(element)
		return Self(array: array, set: set, hashIndexDict: dict)
	}

	/// Returns a new ordered set with `element` inserted at `index`.
	/// This function returns an equivalent ordered set if `element` is
	/// already a member.
	public func inserting(_ element: Element, at index: Index) -> Self {
		var set = _set
		let inserted = set.insert(element).inserted
		guard inserted else { return self }

		var array = _array
		array.insert(element, at: index)
		return Self(array: array, set: set)
	}

	/// Returns a new ordered set with the contents of `otherSet` appended
	/// to the end of this set, retaining the order of both ordered sets,
	/// removing any duplicate elements in place.
	@inlinable public func union(with otherSet: Self) -> Self {
		self + otherSet
	}

	// MARK: Removing Elements

	/// Returns a new ordered set with the first element removed.
	/// The collection must not be empty.
	public func removingFirst() -> Self {
		var arr = _array
		let e = arr.removeFirst()
		var set = _set
		set.remove(e)
		return Self(array: arr, set: set)
	}

	/// Returns a new ordered set with the last element removed.
	/// The collection must not be empty.
	public func removingLast() -> Self {
		var arr = _array
		let e = arr.removeLast()
		var set = _set
		set.remove(e)
		return Self(array: arr, set: set)
	}

	/// Returns a new ordered set with the element at the specified position removed.
	/// - parameter position: The index of the member to remove.
	///   `position` must be a valid index of the ordered set.
	public func removing(at position: Index) -> Self {
		var arr = _array
		let e = arr.remove(at: position)
		var set = _set
		set.remove(e)
		return Self(array: arr, set: set)
	}

	/// Returns a new ordered set with the member element removed.
	/// This function returns an equivalent ordered set if `element` is not a
	/// member.
	/// - parameter element: The member to remove.
	public func removing(element: Element) -> Self {
		guard let index = self.index(of: element) else { return self }

		return removing(at: index)
	}

	/// Returns a new ordered set with the elements filtered by the given predicate.
	/// - parameter shouldBeRemoved: A closure that takes an element of the
	///   sequence as its argument and returns a Boolean value indicating
	///   whether the element should be removed from the collection.
	public func removingAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows -> Self {
		var arr = _array
		try arr.removeAll(where: shouldBeRemoved)
		return Self(arr)
	}

	/// Returns a new ordered set with the elements filtered by the given predicate.
	/// - parameter retainOrder: The returned ordered set retains the relative order of the elements. Defaults to `true`.
	///   If retaining the order is not necessary, passing in `false` may yield a performance benefit.
	public func filter(_ isIncluded: (Element) throws -> Bool, retainOrder: Bool = true) rethrows -> Self {
		if retainOrder {
			return try Self(_array.filter(isIncluded))
		} else {
			return try Self(_set.filter(isIncluded))
		}
	}

	/// Returns a new ordered set containing the elements of this ordered set that do not occur in the given sequence.
	/// Retains the relative order of the elements in this ordered set.
	public func subtracting<S>(_ sequence: S) -> Self where Element == S.Element, S: Sequence {
		Self(_array.filter { !sequence.contains($0) })
	}

	/// Returns a new ordered set containing the elements of this ordered set that do not occur in the given set.
	/// - parameter retainOrder: The returned ordered set retains the relative order of the elements. Defaults to `true`.
	///   If retaining the order is not necessary, passing in `false` may yield a performance benefit.
	public func subtracting(_ set: Set<Element>, retainOrder: Bool = true) -> Self {
		if retainOrder {
			return Self(_array.filter { !set.contains($0) })
		} else {
			return Self(_set.subtracting(set))
		}
	}

	/// Returns a new ordered set containing the elements of this ordered set that also occur in the given sequence.
	/// Retains the relative order of the elements in this ordered set.
	public func intersection<S>(_ sequence: S) -> Self where Element == S.Element, S: Sequence {
		Self(_array.filter { sequence.contains($0) })
	}

	/// Returns a new ordered set containing the elements of this ordered set that also occur in the given set.
	/// - parameter retainOrder: The returned ordered set retains the relative order of the elements. Defaults to `true`.
	///   If retaining the order is not necessary, passing in `false` may yield a performance benefit.
	public func intersection(_ set: Set<Element>, retainOrder: Bool = true) -> Self {
		if retainOrder {
			return Self(_array.filter { set.contains($0) })
		} else {
			return Self(_set.intersection(set))
		}
	}

	// MARK: Reordering Elements

	/// Returns a new ordered set with the elements sorted by the given predicate.
	/// - parameter areInIncreasingOrder: A predicate that returns `true` if its
	///   first argument should be ordered before its second argument;
	///   otherwise, `false`. If `areInIncreasingOrder` throws an error during
	///   the sort, the elements may be in a different order, but none will be
	///   lost.
	/// - note: Documentation based on `Swift.Sequence.sorted(by:)`
	public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Self {
		try Self(array: _array.sorted(by: areInIncreasingOrder), set: _set)
	}

	/// Returns a new ordered set with the elements at indices `i` and `j` swapped.
	/// Both parameters must be valid indices of the collection that are not equal to `endIndex`.
	public func swappingAt(_ i: Index, _ j: Index) -> Self {
		var array = _array
		var dict = _hashIndexDict
		let elementAtI = array[i]
		let elementAtJ = array[j]
		array.swapAt(i, j)
		dict[elementAtI.hashValue] = j
		dict[elementAtJ.hashValue] = i
		return Self(array: array, set: _set, hashIndexDict: dict)
	}

	/// Returns a new ordered set with the order of the elements shuffled.
	///
	/// For example, you can shuffle the numbers between `0` and `9` by calling
	/// the `shuffled()` method on that range:
	///
	///     let numbers = OrderedSet(0...9)
	///     let shuffledNumbers = numbers.shuffled()
	///     // shuffledNumbers == OrderedSet([1, 7, 6, 2, 8, 9, 4, 3, 5, 0])
	///
	/// This method is equivalent to calling `shuffled(using:)`, passing in the
	/// system's default random generator.
	/// - note: Documentation based on `Swift.Sequence.shuffled(using:_)`
	public func shuffled() -> Self {
		Self(array: _set.shuffled(), set: _set)
	}

	/// Returns a new ordered set, with the order of the elements shuffled using the given generator
	/// as a source for randomness.
	///
	/// You use this method to randomize the elements of a sequence when you are
	/// using a custom random number generator. For example, you can shuffle the
	/// numbers between `0` and `9` by calling the `shuffled(using:)` method on
	/// that range:
	///
	///     let numbers = OrderedSet(0...9)
	///     let shuffledNumbers = numbers.shuffled(using: &myGenerator)
	///     // shuffledNumbers == OrderedSet([8, 9, 4, 3, 2, 6, 7, 0, 5, 1])
	///
	/// - parameter generator: The random number generator to use when shuffling
	///   the sequence.
	/// - note: The algorithm used to shuffle a sequence may change in a future
	///   version of Swift. If you're passing a generator that results in the
	///   same shuffled order each time you run your program, that sequence may
	///   change when your program is compiled using a different version of
	///   Swift.
	/// - note: Documentation based on `Swift.Sequence.shuffled(using:_)`
	public func shuffled(using generator: inout some RandomNumberGenerator) -> Self {
		Self(array: _set.shuffled(using: &generator), set: _set)
	}

	// MARK: Transforming Elements

	/// Returns a new ordered set with the results of mapping the given closure over the ordered set's elements.
	/// - parameter transform: A mapping closure. `transform` accepts an
	///   element of this ordered set as its parameter and returns a transformed
	///   value of the same or of a different type.
	/// - parameter retainOrder: The returned ordered set retains the relative order of the elements. Defaults to `true`.
	///   If retaining the order is not necessary, passing in `false` may yield a performance benefit.
	/// - note: To return a new ordered set instead of an array, the given closure must return a type that conforms to `Hashable`.
	/// - note: Documentation based on `Swift.Collection.map(_:)`
	public func map<T>(_ transform: (Element) throws -> T, retainOrder: Bool = true) rethrows -> OrderedSet<T> where T: Hashable {
		if retainOrder {
			return try OrderedSet<T>(_array.map(transform))
		} else {
			return try OrderedSet<T>(_set.map(transform))
		}
	}

	/// Returns a new ordered set with the non-nil results of mapping the given closure over the ordered set's elements.
	/// - parameter transform: A mapping closure. `transform` accepts an
	///   element of this ordered set as its parameter and returns a transformed
	///   value of the same or of a different type.
	/// - parameter retainOrder: The returned ordered set retains the relative order of the elements. Defaults to `true`.
	///   If retaining the order is not necessary, passing in `false` may yield a performance benefit.
	/// - note: To return a new ordered set instead of an array, the given closure must return a type that conforms to `Hashable`.
	/// - note: Documentation based on `Swift.Collection.compactMap(_:)`
	public func compactMap<T>(_ transform: (Element) throws -> T?, retainOrder: Bool = true) rethrows -> OrderedSet<T> where T: Hashable {
		if retainOrder {
			return try OrderedSet<T>(_array.compactMap(transform))
		} else {
			return try OrderedSet<T>(_set.compactMap(transform))
		}
	}

	// MARK: - Subscripts

	/// Returns the element at `index`, or `nil` if this index is out of bounds.
	public subscript(safe index: Index) -> Element? {
		guard indices.contains(index) else { return nil }

		return _array[index]
	}

	// MARK: - Internal Functions

	func sanityCheck() -> Bool {
		_array.count == _set.count
			&& _set.count == _hashIndexDict.count
			&& endIndex == _array.count
			&& _hashIndexDict.count == Set(_hashIndexDict.values).count // Check for duplicate indices
			&& _set == Set(_array) // Check set and array match
	}
}

// MARK: - Extensions

public extension OrderedSet {

	static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs._array + rhs._array)
	}

	static func + <S>(lhs: Self, rhs: S) -> Self where Element == S.Element, S: Sequence {
		Self(lhs._array + rhs)
	}
}

extension OrderedSet: ExpressibleByArrayLiteral {

	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}

extension OrderedSet: RandomAccessCollection {

	public var startIndex: Index { 0 }

	public var endIndex: Index { _array.endIndex }

	public subscript(index: Index) -> Element { _array[index] }
}

extension OrderedSet: Hashable {}

extension OrderedSet: Equatable {

	public static func == <F>(lhs: OrderedSet<F>, rhs: OrderedSet<F>) -> Bool {
		lhs._array == rhs._array
	}
}

extension OrderedSet: Codable where Element: Codable {

	public init(from decoder: Decoder) throws {
		let c = try decoder.singleValueContainer()
		let array = try c.decode(ContiguousArray<Element>.self)
		let set = Set(array)
		guard set.count == array.endIndex else {
			throw Error.nonUniqueElements
		}

		self.init(array: array, set: set)
	}

	public func encode(to encoder: Encoder) throws {
		var c = encoder.singleValueContainer()
		try c.encode(_array)
	}
}

extension OrderedSet {
	enum Error: LocalizedError {
		case nonUniqueElements

		var errorDescription: String? {
			switch self {
				case .nonUniqueElements:
					return "Attempted to decode an array into an OrderedSet, but found non-unique elements in the collection."
			}
		}
	}
}

extension OrderedSet: CustomStringConvertible {

	public var description: String {
		array.description
	}

	public var debugDescription: String {
		"OrderedSet (\(count) elements): " + description
	}
}

extension OrderedSet: Sendable where Element: Sendable {}

#if canImport(Foundation)
	import Foundation

	public extension OrderedSet {

		/// Returns a new ordered set with the elements at the specified offsets removed.
		/// `offsets` must not contain any invalid indices.
		func removing(atOffsets offsets: IndexSet) -> Self {
			let indicesToRemove = Array(offsets)
			var newArr = [Element]()
			for index in _array.indices where !indicesToRemove.contains(index) {
				newArr.append(_array[index])
			}
			return Self(newArr)
		}
	}
#endif

// #if canImport(SwiftUI)
// import SwiftUI
//
// extension OrderedSet {
//
//  /// Returns a new ordered set with the elements at the specified offsets moved.
//  /// Calls the `move(fromOffsets:_, toOffset:_)` function which is defined in the `SwiftUI` framework, and is undocumented.
//  /// Both parameters must not contain any invalid indices.
//  public func moving(fromOffsets source: IndexSet, toOffset destination: Int) -> Self {
//    var arr = _array
//    arr.move(fromOffsets: source, toOffset: destination)
//    return Self(arr)
//  }
// }
// #endif
