import std.testing as testing
from std.testing import assert_equal, assert_true

from emberjson import parse, deserialize
from lightbug_http.header import HeaderKey
from lightbug_http.http import OK, HTTPResponse
from lightbug_http.http.response import Json


@fieldwise_init
struct Message(Movable, Defaultable):
    var text: String

    fn __init__(out self):
        self.text = ""


@fieldwise_init
struct Point(Movable, Defaultable):
    var x: Int
    var y: Int

    fn __init__(out self):
        self.x = 0
        self.y = 0


def test_json_response_status_and_content_type() raises:
    var res = HTTPResponse(Json(Message("hello")))
    assert_equal(res.status_code, 200)
    assert_equal(res.headers[HeaderKey.CONTENT_TYPE], "application/json")


def test_json_response_body_is_valid_json() raises:
    var res = HTTPResponse(Json(Message("hello")))
    var body = String(res.get_body())
    var parsed = parse(body)
    assert_equal(String(parsed["text"]), '"hello"')


def test_json_response_multiple_fields() raises:
    var res = HTTPResponse(Json(Point(3, 7)))
    var body = String(res.get_body())
    var parsed = parse(body)
    assert_equal(parsed["x"].int(), 3)
    assert_equal(parsed["y"].int(), 7)


def test_json_ok_string_passthrough() raises:
    # Pre-serialized JSON strings go through OK directly
    var body = '{"key": "value"}'
    var res = OK(body, "application/json")
    assert_equal(res.status_code, 200)
    assert_equal(res.headers[HeaderKey.CONTENT_TYPE], "application/json")
    assert_equal(String(res.get_body()), body)


def main() raises:
    testing.TestSuite.discover_tests[__functions_in_module()]().run()
