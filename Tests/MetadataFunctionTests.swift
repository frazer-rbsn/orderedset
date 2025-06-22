@testable import OrderedSet
import XCTest

final class MetadataFunctionTests: XCTestCase {

	func testContains() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		XCTAssert(set.contains(5))
		XCTAssertFalse(set.contains(6))
	}

	func testContainsAnyOf() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		XCTAssert(set.contains(anyOf: 7, 5))
		XCTAssertFalse(set.contains(anyOf: 7, 8))
	}

	func testIndexOf() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		XCTAssertEqual(set.index(of: 1), 0)
		XCTAssertEqual(set.index(of: 5), 4)
		XCTAssertNil(set.index(of: 6))
	}

	func testFirst() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		XCTAssertEqual(set.first, 1)
	}

	func testLast() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		XCTAssertEqual(set.last, 5)
	}

	func testIsSubsetOf() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		let subset = OrderedSet([2, 3, 5])
		let notSubset = OrderedSet([1, 3, 7])
		XCTAssert(subset.isSubset(of: set))
		XCTAssertFalse(notSubset.isSubset(of: set))
	}

	func testIsSubsetOfUnorderedSet() {
		let array = [1, 2, 3, 4, 5]
		let uSet = Set(array)
		let subset = OrderedSet([2, 3, 5])
		let notSubset = OrderedSet([1, 3, 7])
		XCTAssert(subset.isSubset(of: uSet))
		XCTAssertFalse(notSubset.isSubset(of: uSet))
	}

	func testIsSupersetOf() {
		let array = [1, 2, 4]
		let set = OrderedSet(array)
		let superset = OrderedSet([1, 2, 3, 4, 5])
		let notSuperset = OrderedSet([1, 4, 5])
		XCTAssert(superset.isSuperset(of: set))
		XCTAssertFalse(notSuperset.isSuperset(of: set))
	}

	func testIsSupersetOfUnorderedSet() {
		let array = [1, 2, 4]
		let uSet = Set(array)
		let superset = OrderedSet([1, 2, 3, 4, 5])
		let notSuperset = OrderedSet([1, 4, 5])
		XCTAssert(superset.isSuperset(of: uSet))
		XCTAssertFalse(notSuperset.isSuperset(of: uSet))
	}

	func testIntersectsWith() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		let array2 = [5, 6, 7, 8]
		let set2 = OrderedSet(array2)
		let array3 = [6, 7, 8, 9]
		let set3 = OrderedSet(array3)
		XCTAssert(set.intersects(with: set2))
		XCTAssertFalse(set.intersects(with: set3))
	}

	func testIntersectsWithUnorderedSet() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		let array2 = [5, 6, 7, 8]
		let set2 = Set(array2)
		let array3 = [6, 7, 8, 9]
		let set3 = Set(array3)
		XCTAssert(set.intersects(with: set2))
		XCTAssertFalse(set.intersects(with: set3))
	}

	func testIsDisjointWith() {
		let array = [6, 7, 8]
		let set = OrderedSet(array)
		let uSet = Set([1, 2, 3, 4, 5])
		XCTAssert(set.isDisjoint(with: uSet))
	}

	func testIsDisjointWithOrderedSet() {
		let array = [6, 7, 8]
		let set = OrderedSet(array)
		let set2 = OrderedSet([1, 2, 3, 4, 5])
		XCTAssert(set.isDisjoint(with: set2))
	}
}
