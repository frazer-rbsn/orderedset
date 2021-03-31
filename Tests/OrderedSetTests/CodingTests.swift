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
}
