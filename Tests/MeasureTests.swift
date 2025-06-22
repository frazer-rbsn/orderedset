@testable import OrderedSet
import XCTest

final class MeasureTests: XCTestCase {

	static let smallMeasureCount = 10
	static let largeMeasureCount = 100_000
	nonisolated(unsafe) static var smallMeasureSet: OrderedSet<Int>!
	nonisolated(unsafe) static var largeMeasureSet: OrderedSet<Int>!

	nonisolated(unsafe) static var smallArray = [Int]()
	nonisolated(unsafe) static var largeArray = [Int]()

	override class func setUp() {
		for n in 1...smallMeasureCount {
			smallArray.append(n)
		}
		for n in 1...largeMeasureCount {
			largeArray.append(n)
		}
		smallMeasureSet = OrderedSet(smallArray)
		largeMeasureSet = OrderedSet(largeArray)
	}

	func testMeasureInitLargeArray() {
		measure {
			_ = OrderedSet(Self.largeArray)
		}
	}

	func testMeasureInitLargeArrayJson() throws {
		let data = try JSONEncoder().encode(Self.largeArray)
		measure {
			_ = try! JSONDecoder().decode([Int].self, from: data)
		}
	}

	func testMeasureContainsSmall() {
		measure {
			_ = Self.smallMeasureSet.contains(9)
		}
	}

	func testMeasureContainsLarge() {
		measure {
			_ = Self.largeMeasureSet.contains(99999)
		}
	}

	func testMeasureIndexOfSmall() {
		measure {
			_ = Self.smallMeasureSet.index(of: 9)
		}
	}

	func testMeasureIndexOfLarge() {
		measure {
			_ = Self.largeMeasureSet.index(of: 99999)
		}
	}

	func testMeasureCompactMapSmall() {
		measure {
			let _: OrderedSet<Int> = Self.smallMeasureSet.compactMap {
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
			let _: OrderedSet<Int> = Self.largeMeasureSet.compactMap {
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
			let _: OrderedSet<Int> = Self.smallMeasureSet.compactMap({
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
			let _: OrderedSet<Int> = Self.largeMeasureSet.compactMap({
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
			_ = Self.smallMeasureSet.appending(999_999)
		}
	}

	func testMeasureAppendingLarge() {
		measure {
			_ = Self.largeMeasureSet.appending(999_999)
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

	func testMeasureRemovingFirstSmall() {
		measure {
			_ = Self.smallMeasureSet.removingFirst()
		}
	}

	func testMeasureRemovingFirstLarge() {
		measure {
			_ = Self.largeMeasureSet.removingFirst()
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
