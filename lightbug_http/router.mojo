"""Route matching helpers — inline pattern dispatch.

Usage:

    struct MyService(HTTPService):
        def func(mut self, req: HTTPRequest) raises -> HTTPResponse:
            if route_match(req, "GET", "/"):
                return OK("Hello!")

            var params = route_match(req, "GET", "/greet/:name")
            if params:
                return OK("Hello, " + params.value()["name"] + "!")

            return NotFound(req.uri.path)

`route_match(req, method, pattern)` returns `Optional[Dict[String,String]]` —
`None` if no match, `Some(params)` on match with extracted path parameters.
Path segments prefixed with `:` are named parameters.
"""

from lightbug_http.http import HTTPRequest, HTTPResponse, NotFound


def _split(path: String) -> List[String]:
    var segs = List[String]()
    if path == "/":
        return segs^
    var start = 1
    for i in range(start, path.byte_length()):
        if path[byte=i] == "/"[0]:
            var seg = String(path[byte=start:i])
            if seg.byte_length() > 0:
                segs.append(seg)
            start = i + 1
    if start < path.byte_length():
        segs.append(String(path[byte=start:path.byte_length()]))
    return segs^


def route_match(req: HTTPRequest, method: String, pattern: String) -> Optional[Dict[String, String]]:
    """Match a request against a method and route pattern.

    Returns Some(params) on match, or None.
    Path segments starting with `:` become named parameters.
    A `*` segment captures the remainder of the path.
    """
    if req.method != method:
        return Optional[Dict[String, String]](None)

    var pat_segs = _split(pattern)
    var path_segs = _split(req.uri.path)

    if len(pat_segs) != len(path_segs):
        return Optional[Dict[String, String]](None)

    var params = Dict[String, String]()
    for i in range(len(pat_segs)):
        var pseg = pat_segs[i]
        var rseg = path_segs[i]
        if pseg.startswith(":"):
            params[String(pseg[byte=1:pseg.byte_length()])] = rseg.copy()
        elif pseg == "*":
            var rest = rseg.copy()
            for j in range(i + 1, len(path_segs)):
                rest += "/" + path_segs[j].copy()
            params["*"] = rest^
            return Optional[Dict[String, String]](params^)
        elif pseg != rseg:
            return Optional[Dict[String, String]](None)

    return Optional[Dict[String, String]](params^)
