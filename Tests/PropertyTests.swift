@testable import OrderedSet
import XCTest

final class PropertyTests: XCTestCase {

	func testCount() {
		let array = [1, 2, 3, 3, 4, 5]
		let set = OrderedSet(array)
		XCTAssertEqual(set.count, 5)
		XCTAssert(set.sanityCheck())
	}

	func testIsEmpty() {
		let set = OrderedSet<Int>()
		XCTAssert(set.isEmpty)
	}

	func testArray() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		XCTAssertEqual(set.array, array)
	}

	func testContiguousArray() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		let ca = ContiguousArray(array)
		XCTAssertEqual(set.contiguousArray, ca)
	}

	func testUnorderedSet() {
		let array = [1, 2, 3, 4, 5]
		let set = OrderedSet(array)
		let uSet = Set(array)
		XCTAssertEqual(set.unorderedSet, uSet)
	}
}
