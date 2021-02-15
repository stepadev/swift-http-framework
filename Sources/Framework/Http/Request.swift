import Foundation
import HTTP

public struct Request {
    
    private var queryParams = [String:String]()
    private var bodyParams = [String:String]()
    private let httpRequest: HTTPRequest
    
    public init(httpRequest: HTTPRequest) {
        self.httpRequest = httpRequest
        self.queryParams = parseQueryParams()
        self.bodyParams = parseBodyParams()
    }
    
    public func getQueryParams() -> [String:String] { return queryParams }
    public func getParsedBody() -> [String:String] { return bodyParams }
    
    private mutating func parseQueryParams() -> [String:String] {
        guard let queryString = self.httpRequest.url.query else { return queryParams }
        return getDictionaryFromQuerySrtring(string: queryString)
    }
    
    private func getDictionaryFromQuerySrtring(string: String) -> [String:String] {
        var dictionaryResult: [String:String] = [:]
        let params = string.split(separator: "&")
        for param in params {
            let item = param.split(separator: "=")
            if item.count == 2 { dictionaryResult[String(item[0])] = String(item[1]) }
            else { dictionaryResult[String(item[0])] = "" }
        }
        return dictionaryResult
    }

    private mutating func parseBodyParams() -> [String:String] {
        guard let contentType = httpRequest.contentType else { return bodyParams }
        var dictionaryResult: [String:String] = [:]
        switch contentType {
        case .json:
            if let data = httpRequest.body.data {
                if let res = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String] {
                    dictionaryResult = res
                }
            }
        case .urlEncodedForm:
            dictionaryResult = getDictionaryFromQuerySrtring(string: httpRequest.body.description)
        default:
            print("Unsupported type")
        }
        
        return dictionaryResult
    }

}
