import XCTest
@testable import HTTP
@testable import Framework

class RequestTest: XCTestCase {
  
    func testEmpty() {
        let httpReq = HTTPRequest()
        let request = Request(httpRequest: httpReq)
        XCTAssertEqual([:], request.getQueryParams())
    }
    
    func testQueryParams() {
        let httpReq = HTTPRequest(url: "/?name=John&age=23")
        let data = ["name":"John", "age":"23"]
        let request = Request(httpRequest: httpReq)
        XCTAssertEqual(data, request.getQueryParams())
    }
    
    func testParsedBodyJsonEncoded() {
        let httpReq = HTTPRequest(method: .POST, url: "/", headers: ["Content-Type": "application/json"], body: HTTPBody(string: "{\"name\":\"James\"}"))
        let data = ["name":"James"]
        let request = Request(httpRequest: httpReq)
        XCTAssertEqual([:], request.getQueryParams())
        XCTAssertEqual(data, request.getParsedBody())
    }
    
    func testParsedBodyFormEncoded() {
        let httpReq = HTTPRequest(method: .POST, url: "/", headers: ["Content-Type": "application/x-www-form-urlencoded"], body: HTTPBody(string: "name=James"))
        let data = ["name":"James"]
        let request = Request(httpRequest: httpReq)
        XCTAssertEqual([:], request.getQueryParams())
        XCTAssertEqual(data, request.getParsedBody())
    }
    
}
