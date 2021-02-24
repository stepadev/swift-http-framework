import Foundation
import HTTP

extension HTTPRequest {
    
    public func getQueryParams() -> [String:String]? {
        guard let queryString = url.query else { return nil }
        return getDictionaryFromQuerySrtring(string: queryString)
    }
    
    public func withQueryParams(
        _ params: [String:String],
        _ method: HTTPMethod = .GET) -> HTTPRequest {
        
        guard params.count != 0 else { return self }
        
        // if isset body params
        var json: Data?
        if let bodyParams = getParsedBody() {
            json = try? JSONEncoder().encode(bodyParams)
        }

        // parse params and create string
        var urlQuery = ""
        for param in params {
            if !param.key.isEmpty {
                urlQuery += "\(param.key)=\(param.value)&"
            }
        }
                
        // create copy of request with query string
        return cloneHTTPRequest(urlQuery, json, method)
    }
    
    public func getParsedBody() -> [String:String]? {
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
            print("Unsupported type:", contentType)
            return nil
        }
        return dictionaryResult
    }
    
    public func withParsedBody(
        _ params: [String:String],
        _ method: HTTPMethod = .GET) -> HTTPRequest {
        
        guard params.count != 0 else { return self }
        
        // if isset query params
        var urlQuery = ""
        if let queryParams = getQueryParams() {
            for param in queryParams {
                if !param.key.isEmpty {
                    urlQuery += "\(param.key)=\(param.value)&"
                }
            }
        }
        
        // create json encode data with given params
        var json: Data?
        if params.count > 0 && params.first?.key != "" {
            json = try? JSONEncoder().encode(params)
        }

        // create copy of request with body data
        return cloneHTTPRequest(urlQuery, json, method)
    }
    
    private func cloneHTTPRequest(
        _ queryString: String,
        _ bodyParams: Data?,
        _ method: HTTPMethod) -> HTTPRequest {
        
        var request = self
    
        // All internal copy of HTTPRequest's with body params will create with Content-Type: application/json
        // For all copy of HTTPRequest's without body params header "Content-Type" will be removed
        if request.headers.firstValue(name: .contentType) == nil && bodyParams != nil {
            request.headers.add(name: "Content-Type", value: "application/json")
        } else if request.headers.firstValue(name: .contentType) != nil && bodyParams == nil {
            request.headers.remove(name: .contentType)
        } else if request.headers.firstValue(name: .contentType) != nil && bodyParams != nil {
            if request.headers.firstValue(name: .contentType) != "application/json" {
                request.headers.replaceOrAdd(name: "Content-Type", value: "application/json")
            }
        }
        
        request.method = method
        request.url = URL(string: (queryString.isEmpty) ? "/" : "/?\(queryString.dropLast())")!
        request.version = HTTPVersion(major: request.version.major, minor: request.version.minor)
        request.headers = request.headers
        request.body = ((bodyParams) != nil) ? HTTPBody(data: bodyParams!) : HTTPBody()
        
        return request
    }
    
    private func getDictionaryFromQuerySrtring(string: String) -> [String:String] {
        var dictionaryResult: [String:String] = [:]
        let params = string.split(separator: "&")
        for param in params {
            let item = param.split(separator: "=")
            if item.count == 2 { dictionaryResult[String(item[0])] = String(item[1]) }
            else if !item.isEmpty { dictionaryResult[String(item[0])] = "" }
        }
        return dictionaryResult
    }
}
