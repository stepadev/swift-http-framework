//  swift-http-framework
//  Created by Anton Stepanov on 01.02.2021.

import HTTP
import Framework

struct EchoResponder: HTTPServerResponder {
    func respond(to request: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        
        print("-------Start--------")
        
        let name = request.getQueryParams()?["name"] ?? "Guest"
        
        print("request:", request)
        print("query params:", request.getQueryParams() as Any)
        print("body params:", request.getParsedBody() as Any)
    
        print("=====")
        
        let request2 = request.withQueryParams(["Kquery1":"Vquery1", "Kquery2":"Vquery2"])
        print("request2:", request2)
        print("query params:", request2.getQueryParams() as Any)
        print("body params:", request2.getParsedBody() as Any)
        
        print("=====")
        
        let request3 = request2.withParsedBody(["Kbody1":"Vbody1", "Kbody2":"Vbody2"], request2.method)
        print("request3:", request3)
        print("query params:", request3.getQueryParams() as Any)
        print("body params:", request3.getParsedBody() as Any)
        
        print("=====")
        
        let request4 = request
            .withQueryParams(["Kquery1":"Vquery1", "Kquery2":"Vquery2"])
            .withParsedBody(["Kbody1":"Vbody1", "Kbody2":"Vbody2"])
        print("request4:", request4)
        print("query params:", request4.getQueryParams() as Any)
        print("body params:", request4.getParsedBody() as Any)
        
        print("=====")
        
        let request5 = request4
            .withQueryParams(["":""])
            .withParsedBody(["":""])
        print("request5:", request5)
        print("query params:", request5.getQueryParams() as Any)
        print("body params:", request5.getParsedBody() as Any)
        
        var res = HTTPResponse(body: "Hello, \(name)!")
        res.headers.add(name: "X-Developer", value: "StepA")
        
        
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



