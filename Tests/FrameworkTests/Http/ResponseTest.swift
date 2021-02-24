import XCTest
@testable import HTTP
@testable import Framework

class ResponseTest: XCTestCase {
    
    func testEmpty() {
        let status = HTTPResponseStatus(
            statusCode: 200,
            reasonPhrase: "OK"
        )
        let body = "Hello Body"
        let response = HTTPResponse(
            status: status,
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
}
