import XCTest
@testable import HTTP
@testable import Framework

class ResponseTest: XCTestCase {
    
    func testEmpty() {
        let body = "Hello"
        let response = HTTPResponse(
            body: HTTPBody(string: body)
        )
        XCTAssertEqual(body, response.getBody())
        XCTAssertEqual(200, response.getStatusCode())
        XCTAssertEqual("OK", response.getReasonPhrase())
    }
    
    func test404() {
        let status = HTTPResponseStatus(
            statusCode: 404,
            reasonPhrase: "Not Found"
        )
        let body = "Empty"
        let response = HTTPResponse(
            status: status,
            body: HTTPBody(string: body)
        )
        XCTAssertEqual(body, response.getBody())
        XCTAssertEqual(404, response.getStatusCode())
        XCTAssertEqual("Not Found", response.getReasonPhrase())
    }
    
    func testHeaders() {
        let response = HTTPResponse()
            .withHeader(["X-Header-1":"value1"])
            .withHeader(["X-Header-2":"value2"])
        XCTAssertEqual(["content-length":"0", "X-Header-1":"value1", "X-Header-2":"value2"], response.getHeaders())
    }
    
}
