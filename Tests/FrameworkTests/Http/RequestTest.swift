import XCTest
@testable import HTTP
@testable import Framework

class RequestTest: XCTestCase {
    
    func testEmpty() {
        let request = HTTPRequest()
        
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
        
        let request3 = HTTPRequest().withQueryParams(["name":"John", "age":"23"])
        let request4 = HTTPRequest().withQueryParams(["name":"", "age":""])
        
        
        let request5 = HTTPRequest(
            method: .POST,
            url: "/",
            headers: ["Content-Type": "application/json"],
            body: HTTPBody(string: "{\"name\":\"James\"}")
        ).withQueryParams(["name":"John", "age":"23"])
        
        let data1 = ["name":"John", "age":"23"]
        let data2 = ["name":"", "age":""]
        let data3 = ["name":"James"]
        
        XCTAssertEqual(data1, request1.getQueryParams())
        XCTAssertNil(request1.getParsedBody())
        XCTAssertEqual(data2, request2.getQueryParams())
        XCTAssertNil(request2.getParsedBody())
        
        XCTAssertEqual(data1, request3.getQueryParams())
        XCTAssertEqual(data2, request4.getQueryParams())
        XCTAssertEqual(data1, request5.getQueryParams())
        XCTAssertNil(request3.getParsedBody())
        XCTAssertNil(request4.getParsedBody())
        XCTAssertEqual(data3, request5.getParsedBody())
        
    }
    
    func testParsedBodyJsonEncoded() {
        let request = HTTPRequest(
            method: .POST,
            url: "/",
            headers: ["Content-Type": "application/json"],
            body: HTTPBody(string: "{\"name\":\"James\"}")
        )
        
        let request2 = HTTPRequest().withParsedBody(["name":"James"])
        
        let request3 = HTTPRequest()
            .withQueryParams(["name":"James"])
            .withParsedBody(["age":"23"])
        
        
        let request4 = HTTPRequest(
            headers: ["Content-Type": "application/json"],
            body: HTTPBody(string: "{\"name\":\"James\"}")
        )
            .withQueryParams(["":""])
            .withParsedBody(["":""])
        
        let data = ["name":"James"]
        let data2 = ["age":"23"]
        XCTAssertNil(request.getQueryParams())
        XCTAssertEqual(data, request.getParsedBody())
        
        XCTAssertEqual(data, request2.getParsedBody())
        XCTAssertEqual(data, request3.getQueryParams())
        XCTAssertEqual(data2, request3.getParsedBody())
        XCTAssertNil(request4.getQueryParams())
        XCTAssertNil(request4.getParsedBody())
        
    }
    
    func testParsedBodyFormEncoded() {
        let request = HTTPRequest(
            method: .POST,
            url: "/",
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            body: HTTPBody(string: "name=James")
        )
        
        let request2 = HTTPRequest(
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        )
            .withParsedBody(["name":"James"])
        
        let data = ["name":"James"]
        
        XCTAssertNil(request.getQueryParams())
        XCTAssertEqual(data, request.getParsedBody())
        XCTAssertEqual(data, request2.getParsedBody())
        
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
