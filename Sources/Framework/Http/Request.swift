import Foundation
import HTTP

extension HTTPRequest {
    
    private var queryParams : [String:String]? { return parseQueryParams() }
    private var bodyParams : [String:String]? { return parseBodyParams() }

    public func getQueryParams() -> [String:String]? { return queryParams }
    public func getParsedBody() -> [String:String]? { return bodyParams }
    
    private func parseQueryParams() -> [String:String]? {
        guard let queryString = url.query else { return nil }
        return getDictionaryFromQuerySrtring(string: queryString)
    }
    
    private func parseBodyParams() -> [String:String]? {
        guard let contentType = contentType else { return nil }
        var dictionaryResult: [String:String] = [:]
        switch contentType {
        case .json:
            if let data = body.data {
                if let res = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String] {
                    dictionaryResult = res
                }
            }
        case .urlEncodedForm:
            dictionaryResult = getDictionaryFromQuerySrtring(string: body.description)
        default:
            print("Unsupported type")
            return nil
        }
        return dictionaryResult
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
}
