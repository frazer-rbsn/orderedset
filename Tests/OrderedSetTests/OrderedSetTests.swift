import XCTest
@testable import OrderedSet

final class OrderedSetTests: XCTestCase {

  static let smallMeasureCount = 10
  static let largeMeasureCount = 100_000
  static var smallMeasureSet: OrderedSet<Int>!
  static var largeMeasureSet: OrderedSet<Int>!

  override class func setUp() {
    var smallArray = [Int]()
    var largeArray = [Int]()
    for n in 1...smallMeasureCount {
      smallArray.append(n)
    }
    for n in 1...largeMeasureCount {
      largeArray.append(n)
    }
    smallMeasureSet = OrderedSet(smallArray)
    largeMeasureSet = OrderedSet(largeArray)
  }


  // MARK: - Initialisation Tests

  func testInitArray() {
    let array = Array([1,2,3])
    let set = OrderedSet(array)
    XCTAssertEqual(set.count, 3)
    XCTAssertEqual(set.array, array)
    XCTAssert(set.sanityCheck())
  }

  func testInitArrayRetainFirstOccurrences() {
    let array = Array([1,2,3,4,5,4,2])
    let set = OrderedSet(array)
    XCTAssertEqual(set.count, 5)
    XCTAssertEqual(set.array, [1,2,3,4,5])
    XCTAssert(set.sanityCheck())
  }

  func testInitArrayRetainLastOccurrences() {
    let array = Array([1,2,3,4,5,4,2])
    let set = OrderedSet(retainingLastOccurrencesIn: array)
    XCTAssertEqual(set.count, 5)
    XCTAssertEqual(set.array, [1,3,5,4,2])
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
    let set = OrderedSet(1..<5)
    XCTAssertEqual(set.count, 4)
    XCTAssert(set.sanityCheck())
  }

  func testInitSetSortedBy() {
    let arr = [1,2,3,3,4,5]
    let set = Set(arr)
    let oSet = OrderedSet(set, sortedBy: { $0 > $1 })
    XCTAssertEqual(oSet, OrderedSet([5,4,3,2,1]))
    XCTAssert(oSet.sanityCheck())
  }

  func testInitSetSortedComparable() {
    let arr = [4,1,2,6,3]
    let set = Set(arr)
    let oSet = OrderedSet(set)
    XCTAssertEqual(oSet, OrderedSet([1,2,3,4,6]))
    XCTAssert(oSet.sanityCheck())
  }

  func testInitEmpty() {
    let set = OrderedSet<Int>()
    XCTAssertEqual(set.count, 0)
    XCTAssert(set.sanityCheck())
  }


  // MARK: - Computed Property Tests

  func testCount() {
    let array = [1,2,3,3,4,5]
    let set = OrderedSet(array)
    XCTAssertEqual(set.count, 5)
    XCTAssert(set.sanityCheck())
  }

  func testIsEmpty() {
    let set = OrderedSet<Int>()
    XCTAssert(set.isEmpty)
  }

  func testArray() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    XCTAssertEqual(set.array, array)
  }

  func testContiguousArray() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let ca = ContiguousArray(array)
    XCTAssertEqual(set.contiguousArray, ca)
  }

  func testUnorderedSet() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let uSet = Set(array)
    XCTAssertEqual(set.unorderedSet, uSet)
  }


  // MARK: - Metadata Function Tests

  func testContains() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    XCTAssert(set.contains(5))
    XCTAssertFalse(set.contains(6))
  }

  func testIndexOf() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    XCTAssertEqual(set.index(of: 1), 0)
    XCTAssertEqual(set.index(of: 5), 4)
    XCTAssertNil(set.index(of: 6))
  }

  func testFirst() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    XCTAssertEqual(set.first, 1)
  }

  func testLast() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    XCTAssertEqual(set.last, 5)
  }

  func testIsSubsetOf() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let subset = OrderedSet([2,3,5])
    let notSubset = OrderedSet([1,3,7])
    XCTAssert(subset.isSubset(of: set))
    XCTAssertFalse(notSubset.isSubset(of: set))
  }

  func testIsSubsetOfUnorderedSet() {
    let array = [1,2,3,4,5]
    let uSet = Set(array)
    let subset = OrderedSet([2,3,5])
    let notSubset = OrderedSet([1,3,7])
    XCTAssert(subset.isSubset(of: uSet))
    XCTAssertFalse(notSubset.isSubset(of: uSet))
  }

  func testIsSupersetOf() {
    let array = [1,2,4]
    let set = OrderedSet(array)
    let superset = OrderedSet([1,2,3,4,5])
    let notSuperset = OrderedSet([1,4,5])
    XCTAssert(superset.isSuperset(of: set))
    XCTAssertFalse(notSuperset.isSuperset(of: set))
  }

  func testIsSupersetOfUnorderedSet() {
    let array = [1,2,4]
    let uSet = Set(array)
    let superset = OrderedSet([1,2,3,4,5])
    let notSuperset = OrderedSet([1,4,5])
    XCTAssert(superset.isSuperset(of: uSet))
    XCTAssertFalse(notSuperset.isSuperset(of: uSet))
  }

  func testIntersectsWith() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let array2 = [5,6,7,8]
    let set2 = OrderedSet(array2)
    let array3 = [6,7,8,9]
    let set3 = OrderedSet(array3)
    XCTAssert(set.intersects(with: set2))
    XCTAssertFalse(set.intersects(with: set3))
  }

  func testIntersectsWithUnorderedSet() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let array2 = [5,6,7,8]
    let set2 = Set(array2)
    let array3 = [6,7,8,9]
    let set3 = Set(array3)
    XCTAssert(set.intersects(with: set2))
    XCTAssertFalse(set.intersects(with: set3))
  }

  func testIsDisjointWith() {
    let array = [6,7,8]
    let set = OrderedSet(array)
    let uSet = Set([1,2,3,4,5])
    XCTAssert(set.isDisjoint(with: uSet))
  }

  func testIsDisjointWithOrderedSet() {
    let array = [6,7,8]
    let set = OrderedSet(array)
    let set2 = OrderedSet([1,2,3,4,5])
    XCTAssert(set.isDisjoint(with: set2))
  }


  // MARK: - Creation Functions Tests

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


  // MARK: - Operator Tests

  func testConcatenate() {
    let arr1 = [1,2,3]
    let arr2 = [4,5,6]
    let arr3 = [7,8,9]
    let set1 = OrderedSet(arr1)
    let set2 = OrderedSet(arr2)
    let set3 = OrderedSet(arr3)
    let conCat = set1 + set2 + set3
    let conCatArr = arr1 + arr2 + arr3
    XCTAssertEqual(conCat.array, conCatArr)
    XCTAssert(conCat.sanityCheck())
  }

  func testConcatenateUniqued() {
    let arr1 = [1,2,3]
    let arr2 = [3,4,5]
    let arr3 = [5,6,7]
    let set1 = OrderedSet(arr1)
    let set2 = OrderedSet(arr2)
    let set3 = OrderedSet(arr3)
    let set = set1 + set2 + set3
    XCTAssertEqual(set, OrderedSet([1,2,3,4,5,6,7]))
    XCTAssert(set.sanityCheck())
  }

  func testConcatenateArray() {
    let arr = [3,4,5]
    let set = OrderedSet([1,2,3])
    let cSet = set + arr
    XCTAssertEqual(cSet, OrderedSet([1,2,3,4,5]))
    XCTAssert(set.sanityCheck())
  }

  func testEqual() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let set2 = OrderedSet(array)
    XCTAssertEqual(set, set2)
    XCTAssert(set == set2)
    XCTAssertFalse(set != set2)
  }

  func testUnequalOrder() {
    let array = [1,2,3,4,5]
    let array2 = [1,3,2,4,5]
    let set = OrderedSet(array)
    let set2 = OrderedSet(array2)
    XCTAssertNotEqual(set, set2)
    XCTAssert(set != set2)
  }


  // MARK: - Coding Tests

  struct House: Codable {
    let members: OrderedSet<String>
  }

  func testDecode() throws {
    let json = """
    {
      "members": [
        "Jim",
        "Carol",
        "Joan",
        "Felix"
      ]
    }
    """
    let jsonData = json.data(using: .utf8)!
    let decoder = JSONDecoder()
    let house = try decoder.decode(House.self, from: jsonData)
    XCTAssertEqual(house.members, ["Jim","Carol","Joan","Felix"])
  }

  func testEncode() throws {
    let house = House(members: OrderedSet<String>(["Jim","Carol","Joan","Felix"]))
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(house)
    let json = String(data: jsonData, encoding: .utf8)!
    let specJson = """
    {
      "members": [
        "Jim",
        "Carol",
        "Joan",
        "Felix"
      ]
    }
    """
    let jsonRemovingWhitespace = json.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    let specJsonRemovingWhitespace = specJson.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    XCTAssertEqual(jsonRemovingWhitespace,specJsonRemovingWhitespace)
  }


  // MARK: - Misc Tests

  func testRandomElement() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    let r = set.randomElement()
    XCTAssertNotNil(r)
  }

  func testPrint() {
    let array = [1,2,3,4,5]
    let set = OrderedSet(array)
    print(set)
    print(set.debugDescription)
  }

  func testEnumerate() {
    let array = [0,1,2,3,4]
    let set = OrderedSet(array)
    for (n,e) in set.enumerated() {
      XCTAssertEqual(n,e)
    }
  }

  func testSafeSubscript() {
    let array = [0,1,2,3,4]
    let set = OrderedSet(array)
    XCTAssertNil(set[safe:6])
    XCTAssertEqual(set[safe:2], 2)
  }


  // MARK: - Performance Tests

  func testMeasureContainsSmall() {
    measure {
      _ = Self.smallMeasureSet.contains(99999)
    }
  }

  func testMeasureContainsLarge() {
    measure {
      _ = Self.largeMeasureSet.contains(99999)
    }
  }

  func testMeasureIndexOfSmall() {
    measure {
      _ = Self.smallMeasureSet.index(of: 99999)
    }
  }

  func testMeasureIndexOfLarge() {
    measure {
      _ = Self.largeMeasureSet.index(of: 99999)
    }
  }

  func testMeasureCountSmall() {
    measure {
      _ = Self.smallMeasureSet.count
    }
  }

  func testMeasureCountLarge() {
    measure {
      _ = Self.largeMeasureSet.count
    }
  }

  func testMeasureCompactMapSmall() {
    measure {
      let _ : OrderedSet<Int> = Self.smallMeasureSet.compactMap {
        if $0.isMultiple(of: 10) {
          return nil
        } else {
          return $0
        }
      }
    }
  }

  func testMeasureCompactMapLarge() {
    measure {
      let _ : OrderedSet<Int> = Self.largeMeasureSet.compactMap {
        if $0.isMultiple(of: 10) {
          return nil
        } else {
          return $0
        }
      }
    }
  }

  func testMeasureCompactMapNoRetainOrderSmall() {
    measure {
      let _ : OrderedSet<Int> = Self.smallMeasureSet.compactMap({
        if $0.isMultiple(of: 10) {
          return nil
        } else {
          return $0
        }
      }, retainOrder: false)
    }
  }

  func testMeasureCompactMapNoRetainOrderLarge() {
    measure {
      let _ : OrderedSet<Int> = Self.largeMeasureSet.compactMap({
        if $0.isMultiple(of: 10) {
          return nil
        } else {
          return $0
        }
      }, retainOrder: false)
    }
  }

  func testMeasureAppendingSmall() {
    measure {
      _ = Self.smallMeasureSet.appending(999999)
    }
  }

  func testMeasureAppendingLarge() {
    measure {
      _ = Self.largeMeasureSet.appending(999999)
    }
  }

  func testMeasureRemovingSmall() {
    measure {
      _ = Self.smallMeasureSet.removing(at: 6)
    }
  }

  func testMeasureRemovingLarge() {
    measure {
      _ = Self.largeMeasureSet.removing(at: 6666)
    }
  }

  func testMeasureShuffledSmall() {
    measure {
      _ = Self.smallMeasureSet.shuffled()
    }
  }

  func testMeasureShuffledLarge() {
    measure {
      _ = Self.largeMeasureSet.shuffled()
    }
  }

  func testMeasureSwappingAtSmall() {
    measure {
      _ = Self.smallMeasureSet.swappingAt(2, 9)
    }
  }

  func testMeasureSwappingAtLarge() {
    measure {
      _ = Self.largeMeasureSet.swappingAt(2000, 9000)
    }
  }
}
