
import XCTest
@testable import LiteNode


class LiteNodeCodableTest: XCTestCase {

    func testJsonEncoding() {

        guard let data = sample1.data(using: .utf8) else {
            return
        }
        XCTAssertNoThrow(try JSONDecoder().decode(Response.self, from: data))
    }

    func testHTMLAttributes() {
        do {
            let html = try HTML(sample2)
            let result = html.searchElements("body")
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result[0].attributes.count, 2)
        } catch {
            //error
        }
    }

    static var allTests = [
        ("testJsonParsingWithXML", testJsonEncoding),
        ("testHTMLAttributes", testHTMLAttributes),
    ]
}


struct Response: Decodable {
    struct Data: Decodable {
        let title: String
        let body: HTML
    }
    let data: Data
}


let sample1 = """
{"data":{"title":"Sample title","body":"<html><head>Welcome</head><body>This is simple body</body></html>"}}
"""

let sample2 = """
<html><head>Welcome</head><body id="1234" class="Cool">This is simple body</body></html>
"""

