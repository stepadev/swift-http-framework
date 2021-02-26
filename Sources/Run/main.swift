//  swift-http-framework
//  Created by Anton Stepanov on 01.02.2021.

import HTTP
import Framework

struct EchoResponder: HTTPServerResponder {
    func respond(to request: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        
        print("-------Start--------")
        
        let name = request.getQueryParams()?["name"] ?? "Guest"
        
        let res = HTTPResponse(body: "Hello, \(name)!")
            .withHeader(["X-Developer":"StepA"])
            .withHeader(["X-Version":"0.1"])
        
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



