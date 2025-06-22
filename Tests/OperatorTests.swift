import XCTest
@testable import OrderedSet

final class OperatorTests: XCTestCase {
	
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
		XCTAssert(cSet.sanityCheck())
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
}
