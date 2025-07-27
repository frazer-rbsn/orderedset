@testable import OrderedSet
import XCTest

final class MeasureTests: XCTestCase {

	// MARK: - Data generators

	static let smallMeasureCount = 10
	static let largeMeasureCount = 1_000_000

	private func makeSmallArray() -> [Int] {
		return Array(1...Self.smallMeasureCount)
	}

	private func makeLargeArray() -> [Int] {
		return Array(1...Self.largeMeasureCount)
	}

	private func makeSmallOrderedSet() -> OrderedSet<Int> {
		return OrderedSet(makeSmallArray())
	}

	private func makeLargeOrderedSet() -> OrderedSet<Int> {
		return OrderedSet(makeLargeArray())
	}

	// MARK: - Tests

	func testMeasureInitLargeArray() {
		let largeArray = makeLargeArray()
		measure {
			_ = OrderedSet(largeArray)
		}
	}

	func testMeasureInitLargeArrayJson() throws {
		let largeArray = makeLargeArray()
		let data = try JSONEncoder().encode(largeArray)
		measure {
			_ = try! JSONDecoder().decode([Int].self, from: data)
		}
	}

	func testMeasureContainsSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			_ = smallOrderedSet.contains(9)
		}
	}

	func testMeasureContainsLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			_ = largeOrderedSet.contains(99999)
		}
	}

	func testMeasureIndexOfSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			_ = smallOrderedSet.index(of: 9)
		}
	}

	func testMeasureIndexOfLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			_ = largeOrderedSet.index(of: 99999)
		}
	}

	func testMeasureCompactMapSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			let _: OrderedSet<Int> = smallOrderedSet.compactMap {
				if $0.isMultiple(of: 10) {
					return nil
				} else {
					return $0
				}
			}
		}
	}

	func testMeasureCompactMapLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			let _: OrderedSet<Int> = largeOrderedSet.compactMap {
				if $0.isMultiple(of: 10) {
					return nil
				} else {
					return $0
				}
			}
		}
	}

	func testMeasureCompactMapNoRetainOrderSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			let _: OrderedSet<Int> = smallOrderedSet.compactMap({
				if $0.isMultiple(of: 10) {
					return nil
				} else {
					return $0
				}
			}, retainOrder: false)
		}
	}

	func testMeasureCompactMapNoRetainOrderLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			let _: OrderedSet<Int> = largeOrderedSet.compactMap({
				if $0.isMultiple(of: 10) {
					return nil
				} else {
					return $0
				}
			}, retainOrder: false)
		}
	}

	func testMeasureAppendingSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			_ = smallOrderedSet.appending(999_999)
		}
	}

	func testMeasureAppendingLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			_ = largeOrderedSet.appending(999_999)
		}
	}

	func testMeasureRemovingSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			_ = smallOrderedSet.removing(at: 6)
		}
	}

	func testMeasureRemovingLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			_ = largeOrderedSet.removing(at: 6666)
		}
	}

	func testMeasureRemovingFirstSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			_ = smallOrderedSet.removingFirst()
		}
	}

	func testMeasureRemovingFirstLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			_ = largeOrderedSet.removingFirst()
		}
	}

	func testMeasureSwappingAtSmall() {
		let smallOrderedSet = makeSmallOrderedSet()
		measure {
			_ = smallOrderedSet.swappingAt(2, 9)
		}
	}

	func testMeasureSwappingAtLarge() {
		let largeOrderedSet = makeLargeOrderedSet()
		measure {
			_ = largeOrderedSet.swappingAt(2000, 9000)
		}
	}
}
