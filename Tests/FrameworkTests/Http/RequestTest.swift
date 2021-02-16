import XCTest
@testable import HTTP
@testable import Framework

class RequestTest: XCTestCase {
    
    func testEmpty() {
        let request = HTTPRequest(
            method: .GET,
            url: "/"
        )
        XCTAssertNil(request.getQueryParams())
        XCTAssertNil(request.getParsedBody())
    }
    
    func testQueryParams() {
        let request1 = HTTPRequest(
            method: .GET,
            url: "/?name=John&age=23"
        )
        let request2 = HTTPRequest(
            method: .GET,
            url: "/?name=&age="
        )
        let data1 = ["name":"John", "age":"23"]
        let data2 = ["name":"", "age":""]
        XCTAssertEqual(data1, request1.getQueryParams())
        XCTAssertNil(request1.getParsedBody())
        XCTAssertEqual(data2, request2.getQueryParams())
        XCTAssertNil(request2.getParsedBody())
    }
    
    func testParsedBodyJsonEncoded() {
        let request = HTTPRequest(
            method: .POST,
            url: "/",
            headers: ["Content-Type": "application/json"],
            body: HTTPBody(string: "{\"name\":\"James\"}")
        )
        let data = ["name":"James"]
        XCTAssertNil(request.getQueryParams())
        XCTAssertEqual(data, request.getParsedBody())
    }
    
    func testParsedBodyFormEncoded() {
        let request = HTTPRequest(
            method: .POST,
            url: "/",
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            body: HTTPBody(string: "name=James")
        )
        let data = ["name":"James"]
        XCTAssertNil(request.getQueryParams())
        XCTAssertEqual(data, request.getParsedBody())
    }
    
    func testParsedBodyUnsupportedFormat() {
        let request = HTTPRequest(
            method: .POST,
            url: "/",
            headers: ["Content-Type": "multipart/form-data"]
        )
        XCTAssertNil(request.getQueryParams())
        XCTAssertNil(request.getParsedBody())
    }
    
}
