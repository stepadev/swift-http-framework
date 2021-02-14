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
    
}
