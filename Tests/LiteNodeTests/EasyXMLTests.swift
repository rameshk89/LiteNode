import XCTest
@testable import LiteNode

final class LiteNodeTests: XCTestCase {

    func testSimpleExample() {
        XCTAssertEqual(try HTML("<message>Welcome</message>wenfv").description, "<message>Welcome</message>")
    }

    func testElementsCount() {
        let string = "<a><b>Tove</b><c>Jani</c><b>Reminder</b><d>Don't forget me this weekend!</d></a>"
        do {
            let xml = try HTML(string)
            XCTAssertEqual(xml.elementsCount, 5)
        } catch {
            XCTAssertThrowsError("Error occurred")
        }
    }

    func testSearchElements() {
        let string = "<a><b>Tove</b><c>Jani</c><b>Reminder</b><d>Hello</d></a>"
        do {
            let xml = try HTML(string)
            XCTAssertEqual(xml.searchElements("b").count, 2)
        } catch {
            XCTAssertThrowsError("Error occurred")
        }
    }

    static var allTests = [
        ("testExample", testSimpleExample),
        ("textElementsCount", testElementsCount),
        ("textElementsCount", testSearchElements),
    ]
}
