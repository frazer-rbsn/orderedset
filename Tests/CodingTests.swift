import XCTest
@testable import OrderedSet

final class CodingTests: XCTestCase {
	
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
	
	func testDecodeEmpty() throws {
		let json = """
	{
		"members": []
	}
	"""
		let jsonData = json.data(using: .utf8)!
		let decoder = JSONDecoder()
		let house = try decoder.decode(House.self, from: jsonData)
		XCTAssertEqual(house.members, [])
	}
	
	func testDecodeNonUniqueThrows() throws {
		let json = """
	{
		"members": [
			"Jim",
			"Carol",
			"Joan",
			"Felix",
			"Jim"
		]
	}
	"""
		let jsonData = json.data(using: .utf8)!
		let decoder = JSONDecoder()
		XCTAssertThrowsError(try decoder.decode(House.self, from: jsonData))
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
	
	func testEncodeEmpty() throws {
		let house = House(members: OrderedSet<String>([]))
		let encoder = JSONEncoder()
		let jsonData = try encoder.encode(house)
		let json = String(data: jsonData, encoding: .utf8)!
		let specJson = """
	{
		"members": [
		]
	}
	"""
		let jsonRemovingWhitespace = json.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
		let specJsonRemovingWhitespace = specJson.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
		XCTAssertEqual(jsonRemovingWhitespace,specJsonRemovingWhitespace)
	}
}
