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
}
