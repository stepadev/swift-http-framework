//  swift-http-framework
//  Created by Anton Stepanov on 01.02.2021.

import HTTP

//var res = HTTPResponse(body: "Hello")

struct EchoResponder: HTTPServerResponder {
    func respond(to req: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        
        print("-------Start--------")
        
        func parseQueryParams(_ req: HTTPRequest) -> [String:String] {
            var paramsDictionary = [String:String]()
            guard let queryParams = req.url.query else { return paramsDictionary }
            let params = queryParams.split(separator: "&")
            for param in params {
                let item = param.split(separator: "=")
                if item.count == 2 { paramsDictionary[String(item[0])] = String(item[1]) }
                else { paramsDictionary[String(item[0])] = "" }
            }
            return paramsDictionary
        }

        print(parseQueryParams(req))
        
        let name = parseQueryParams(req)["name"] ?? "Guest"
        let res = HTTPResponse(body: "Hello, \(name)!")
        
        return worker.eventLoop.newSucceededFuture(result: res)
    }
}

let hostname = "localhost"
let port = 8000
print("Server starting on http://\(hostname):\(port)")
let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
defer { try! group.syncShutdownGracefully() }

let server = try HTTPServer.start(hostname: hostname, port: port, responder: EchoResponder(), on: group).wait()
try server.onClose.wait()



