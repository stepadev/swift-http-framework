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
}
