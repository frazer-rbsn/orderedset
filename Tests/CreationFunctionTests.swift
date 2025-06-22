import XCTest
@testable import OrderedSet

final class CreationFunctionTests: XCTestCase {
	
	// MARK: - Adding Elements
	
	func testAppending() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.appending(6)
		XCTAssertEqual(newSet, OrderedSet([1,2,3,4,5,6]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testInsertingAt() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.inserting(9, at: 3)
		XCTAssertEqual(newSet, OrderedSet([1,2,3,9,4,5]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testUnion() {
		let arr1 = [1,2,3]
		let arr2 = [3,4,5]
		let set1 = OrderedSet(arr1)
		let set2 = OrderedSet(arr2)
		let newSet = set1.union(with: set2)
		XCTAssertEqual(newSet, OrderedSet([1,2,3,4,5]))
		XCTAssert(newSet.sanityCheck())
	}
	
	
	// MARK: -  Removing Elements
	
	func testRemovingFirst() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.removingFirst()
		XCTAssertEqual(newSet, OrderedSet([2,3,4,5]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingLast() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.removingLast()
		XCTAssertEqual(newSet, OrderedSet([1,2,3,4]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingAtPosition() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.removing(at: 2)
		XCTAssertEqual(newSet, OrderedSet([1,2,4,5]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingAtOffsetsStart() {
		let array = [1,2,3,4,5,6,7,8,9,10]
		let set = OrderedSet(array)
		let indexSet = IndexSet(integersIn: 0...5)
		let newSet = set.removing(atOffsets: indexSet)
		XCTAssertEqual(newSet, OrderedSet([7,8,9,10]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingAtOffsetsMiddle() {
		let array = [1,2,3,4,5,6,7,8,9,10]
		let set = OrderedSet(array)
		let indexSet = IndexSet(integersIn: 3...7)
		let newSet = set.removing(atOffsets: indexSet)
		XCTAssertEqual(newSet, OrderedSet([1,2,3,9,10]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingAtOffsetsEnd() {
		let array = [1,2,3,4,5,6,7,8,9,10]
		let set = OrderedSet(array)
		let indexSet = IndexSet(integersIn: 5...9)
		let newSet = set.removing(atOffsets: indexSet)
		XCTAssertEqual(newSet, OrderedSet([1,2,3,4,5]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingAtOffsetsInterspersed() {
		let array = [1,2,3,4,5,6,7,8,9,10]
		let set = OrderedSet(array)
		let indexSet = IndexSet([0,9,3,1,6])
		let newSet = set.removing(atOffsets: indexSet)
		XCTAssertEqual(newSet, OrderedSet([3,5,6,8,9]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingElement() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.removing(element: 3)
		XCTAssertEqual(newSet, OrderedSet([1,2,4,5]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testRemovingAllWhere() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.removingAll { $0.isMultiple(of: 2) }
		XCTAssertEqual(newSet, OrderedSet([1,3,5]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testFilter() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.filter { $0 % 2 == 0 }
		XCTAssertEqual(newSet, OrderedSet([2,4]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testSubtractingArray() {
		let arr1 = [1,2,3]
		let arr2 = [3,4,5]
		let set1 = OrderedSet(arr1)
		let set2 = OrderedSet(arr2)
		let newSet = set1.subtracting(set2)
		XCTAssertEqual(newSet, OrderedSet([1,2]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testSubtractingSet() {
		let set = Set([3,4,5])
		let oSet = OrderedSet([1,2,3])
		let newSet = oSet.subtracting(set)
		XCTAssertEqual(newSet, OrderedSet([1,2]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testIntersection() {
		let set = OrderedSet([3,4,5])
		let oSet = OrderedSet([1,2,3,4])
		let newSet = oSet.intersection(set)
		XCTAssertEqual(newSet, OrderedSet([3,4]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testIntersectionSet() {
		let set = Set([3,4,5])
		let oSet = OrderedSet([1,2,3,4])
		let newSet = oSet.intersection(set)
		XCTAssertEqual(newSet, OrderedSet([3,4]))
		XCTAssert(newSet.sanityCheck())
	}
	
	
	// MARK: - Reordering Elements
	
	func testSorted() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.sorted { $0 > $1 }
		XCTAssertEqual(newSet, OrderedSet([5,4,3,2,1]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testSwappingAt() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.swappingAt(1, 4)
		XCTAssertEqual(newSet, OrderedSet([1,5,3,4,2]))
		XCTAssertEqual(newSet.index(of: 5), 1)
		XCTAssert(newSet.sanityCheck())
	}
	
	//  func testMoving() {
	//    let array = [1,2,3,4,5]
	//    let set = OrderedSet(array)
	//    let newSet = set.moving(fromOffsets: IndexSet([0]), toOffset: 3)
	//    XCTAssertEqual(newSet, OrderedSet([2,3,1,4,5]))
	//    XCTAssert(newSet.sanityCheck())
	//  }
	
	// MARK: Transforming Elements
	
	func testMap() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet = set.map { $0 * 2 }
		XCTAssertEqual(newSet, OrderedSet([2,4,6,8,10]))
		XCTAssert(newSet.sanityCheck())
	}
	
	func testCompactMap() {
		let array = [1,2,3,4,5]
		let set = OrderedSet(array)
		let newSet: OrderedSet<Int> = set.compactMap {
			if $0.isMultiple(of: 2) {
				return nil
			} else {
				return $0
			}
		}
		XCTAssertEqual(newSet, OrderedSet([1,3,5]))
		XCTAssert(newSet.sanityCheck())
	}
}
