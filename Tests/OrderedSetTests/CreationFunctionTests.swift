import XCTest
@testable import OrderedSet

final class CreationFunctionTests: XCTestCase {

  func testAppending() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let newSet = set.appending(6)
    XCTAssertEqual(newSet, OrderedSet([1,2,3,4,5,6]))
    XCTAssert(set.sanityCheck())
  }

  func testInsertingAt() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let newSet = set.inserting(9, at: 3)
    XCTAssertEqual(newSet, OrderedSet([1,2,3,9,4,5]))
    XCTAssert(set.sanityCheck())
  }

  func testUnion() {
    let arr1 = [1,2,3]
    let arr2 = [3,4,5]
    let set1 = OrderedSet(arr1)
    let set2 = OrderedSet(arr2)
    let set = set1.union(with: set2)
    XCTAssertEqual(set, OrderedSet([1,2,3,4,5]))
    XCTAssert(set.sanityCheck())
  }

  func testSubtractingArray() {
    let arr1 = [1,2,3]
    let arr2 = [3,4,5]
    let set1 = OrderedSet(arr1)
    let set2 = OrderedSet(arr2)
    let set = set1.subtracting(set2)
    XCTAssertEqual(set, OrderedSet([1,2]))
    XCTAssert(set.sanityCheck())
  }

  func testSubtractingSet() {
    let set = Set([3,4,5])
    let oSet = OrderedSet([1,2,3])
    let subtracting = oSet.subtracting(set)
    XCTAssertEqual(subtracting, OrderedSet([1,2]))
    XCTAssert(subtracting.sanityCheck())
  }

  func testSorted() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let sort = set.sorted { $0 > $1 }
    XCTAssertEqual(sort, OrderedSet([5,4,3,2,1]))
    XCTAssert(set.sanityCheck())
  }

  func testFilter() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let even = set.filter { $0 % 2 == 0 }
    XCTAssertEqual(even, OrderedSet([2,4]))
    XCTAssert(set.sanityCheck())
  }

  func testMap() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let mapped = set.map { $0 * 2 }
    XCTAssertEqual(mapped, OrderedSet([2,4,6,8,10]))
    XCTAssert(set.sanityCheck())
  }

  func testCompactMap() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let mapped: OrderedSet<Int> = set.compactMap {
      if $0.isMultiple(of: 2) {
        return nil
      } else {
        return $0
      }
    }
    XCTAssertEqual(mapped, OrderedSet([1,3,5]))
    XCTAssert(set.sanityCheck())
  }

  func testSwappingAt() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let swapped = set.swappingAt(1, 4)
    XCTAssertEqual(swapped, OrderedSet([1,5,3,4,2]))
    XCTAssertEqual(swapped.index(of: 5), 1)
    XCTAssert(set.sanityCheck())
  }

  func testRemovingFirst() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let removing = set.removingFirst()
    XCTAssertEqual(removing, OrderedSet([2,3,4,5]))
    XCTAssert(set.sanityCheck())
  }

  func testRemovingLast() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let removing = set.removingLast()
    XCTAssertEqual(removing, OrderedSet([1,2,3,4]))
    XCTAssert(set.sanityCheck())
  }

  func testRemovingAtPosition() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let removing = set.removing(at: 2)
    XCTAssertEqual(removing, OrderedSet([1,2,4,5]))
    XCTAssert(set.sanityCheck())
  }

  func testRemovingAll() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let removing = set.removingAll { $0.isMultiple(of: 2) }
    XCTAssertEqual(removing, OrderedSet([1,3,5]))
    XCTAssert(set.sanityCheck())
  }

  func testAllSatisfy() {
    let array = [2,4,6,8]
    let set = OrderedSet(array)
    XCTAssert(set.allSatisfy { $0.isMultiple(of: 2) })
  }
}
