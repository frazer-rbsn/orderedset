@testable import OrderedSet
import XCTest

final class InitialisationTests: XCTestCase {

	func testInitArray() {
		let array = Array([1, 2, 3])
		let set = OrderedSet(array)
		XCTAssertEqual(set.count, 3)
		XCTAssertEqual(set.array, array)
		XCTAssert(set.sanityCheck())
	}

	func testInitArrayRetainFirstOccurrences() {
		let array = Array([1, 2, 3, 4, 5, 4, 2])
		let set = OrderedSet(array)
		XCTAssertEqual(set.count, 5)
		XCTAssertEqual(set.array, [1, 2, 3, 4, 5])
		XCTAssert(set.sanityCheck())
	}

	func testInitArrayRetainLastOccurrences() {
		let array = Array([1, 2, 3, 4, 5, 4, 2])
		let set = OrderedSet(array, retainLastOccurences: true)
		XCTAssertEqual(set.count, 5)
		XCTAssertEqual(set.array, [1, 3, 5, 4, 2])
		XCTAssert(set.sanityCheck())
	}

	func testInitArrayOneElement() {
		let array = Array([1])
		let set = OrderedSet(array)
		XCTAssertEqual(set.count, 1)
		XCTAssertEqual(set.index(of: 1), 0)
		XCTAssert(set.sanityCheck())
	}

	func testInitEmptyArray() {
		let array = [Int]()
		let set = OrderedSet(array)
		XCTAssertEqual(set.count, 0)
		XCTAssert(set.sanityCheck())
	}

	func testInitArrayLiteral() {
		let set = OrderedSet(arrayLiteral: 1, 2, 3)
		XCTAssertEqual(set.count, 3)
		XCTAssert(set.sanityCheck())
	}

	func testInitIntRange() {
		let set = OrderedSet(1 ..< 5)
		XCTAssertEqual(set.count, 4)
		XCTAssert(set.sanityCheck())
	}

	func testInitSetSortedBy() {
		let arr = [1, 2, 3, 3, 4, 5]
		let set = Set(arr)
		let oSet = OrderedSet(set, sortedBy: { $0 > $1 })
		XCTAssertEqual(oSet, OrderedSet([5, 4, 3, 2, 1]))
		XCTAssert(oSet.sanityCheck())
	}

	func testInitSetSortedComparable() {
		let arr = [4, 1, 2, 6, 3]
		let set = Set(arr)
		let oSet = OrderedSet(set)
		XCTAssertEqual(oSet, OrderedSet([1, 2, 3, 4, 6]))
		XCTAssert(oSet.sanityCheck())
	}

	func testInitEmpty() {
		let set = OrderedSet<Int>()
		XCTAssertEqual(set.count, 0)
		XCTAssert(set.sanityCheck())
	}

	func testSendable() async {
		struct SomethingSendable: Sendable, Hashable {
			let someValue: Int
		}

		func thisFunctionNeedsASendableType(_: Sendable) {
			print("Yes, this is sendable")
		}

		let array = (0...5).map { SomethingSendable(someValue: $0) }
		let x = OrderedSet(array)
		// Using a function to check conformance at compile time as `Sendable` is a marker protocol
		thisFunctionNeedsASendableType(x)
	}
}
