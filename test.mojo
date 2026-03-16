from lightbug_http.http.json import Json, json_decode
from lightbug_http.http.response import HTTPResponse
from emberjson import deserialize

@fieldwise_init
struct Message(Movable, Defaultable):
    var message: String

    fn __init__(out self):
        self.message = ""

fn main() raises:
    # Test serialization via Json wrapper
    var msg = Message("Hello, World!")
    var res = HTTPResponse(Json(msg))
    print("status:", res.status_code)
    print("body:", String(res.get_body()))

    # Test deserialization
    var parsed = deserialize[Message]('{"message": "from JSON"}')
    print("deserialized:", parsed.message)