import XCTest
@testable import tivok_api

final class tivok_apiTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(tivok_api().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
