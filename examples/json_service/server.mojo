from lightbug_http import OK, NotFound, HTTPRequest, HTTPResponse, HTTPService, Server
from lightbug_http.http.json import Json, json_decode


@fieldwise_init
struct GreetRequest(Movable, Defaultable):
    var name: String

    fn __init__(out self):
        self.name = ""


@fieldwise_init
struct GreetResponse(Movable, Defaultable):
    var message: String

    fn __init__(out self):
        self.message = ""


@fieldwise_init
struct JsonService(HTTPService):
    fn func(mut self, req: HTTPRequest) raises -> HTTPResponse:
        if req.uri.path == "/greet":
            var body = json_decode[GreetRequest](req)
            var response = GreetResponse(String("Hello, ", body.name, "!"))
            return OK(Json(response))
        return NotFound(req.uri.path)


fn main() raises:
    var server = Server()
    var handler = JsonService()
    server.listen_and_serve("localhost:8080", handler)
