import Foundation
import HTTP

public struct Request {
    
    private var queryStringParams = [String:String]()
    private let httpRequest: HTTPRequest
    
    public init(httpRequest: HTTPRequest) {
        self.httpRequest = httpRequest
        self.queryStringParams = parseQueryParams()
    }
    
    public func getQueryParams() -> [String:String] { return self.queryStringParams }
    
    private mutating func parseQueryParams() -> [String:String] {
        guard let queryParams = self.httpRequest.url.query else { return self.queryStringParams }
        let params = queryParams.split(separator: "&")
        for param in params {
            let item = param.split(separator: "=")
            if item.count == 2 { self.queryStringParams[String(item[0])] = String(item[1]) }
            else { self.queryStringParams[String(item[0])] = "" }
        }
        return queryStringParams
    }
    
}
