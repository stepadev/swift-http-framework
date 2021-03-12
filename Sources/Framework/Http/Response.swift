import Foundation
import HTTP

extension HTTPResponse {
    
    public func getBody() -> String {
        return self.body.description
    }
    
    func getStatusCode() -> Int {
        return Int(self.status.code)
    }
    
    func getReasonPhrase() -> String {
        return self.status.reasonPhrase
    }
    
    public func withHeader(_ header: [String:String]) -> HTTPResponse {
        var response = self
        response.headers.add(name: header.first?.key ?? "", value: header.first?.value ?? "")
        return response
    }
    
    public func getHeaders() -> [String:String] {
        var headers: [String:String] = [:]
        for header in self.headers {
            headers[String(header.name)] = String(header.value)
        }
        return headers
    }
    
    func withBody(_ body: HTTPBody) -> HTTPResponse {
        var response = self
        response.body = body
        return response
    }
    
    func withStatus(code: Int, reasonPhrase: String = "") -> HTTPResponse {
        var response = self
        response.status = HTTPResponseStatus(statusCode: code, reasonPhrase: reasonPhrase)
        return response
    }
    
    func hasHeader(_ header: [String:String]) -> Bool {
        let headers = getHeaders()
        for search in headers {
            if search.key == header.first?.key && search.value == header.first?.value {
                return true
            }
        }
        return false
    }
    
    func getHeader(_ header: [String:String]) -> [String:String] {
        if (!self.hasHeader(header)) {
            return [:]
        }
        return header
    }

}
