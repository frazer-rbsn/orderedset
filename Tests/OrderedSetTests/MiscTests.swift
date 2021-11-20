import XCTest
@testable import OrderedSet

final class MiscTests: XCTestCase {

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

  func testAllSatisfy() {
    let array = [2,4,6,8]
    let set = OrderedSet(array)
    XCTAssert(set.allSatisfy { $0.isMultiple(of: 2) })
  }
}
