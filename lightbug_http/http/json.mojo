from emberjson import (
    parse,
    deserialize,
    try_deserialize,
    JSON,
    JsonSerializable,
    JsonDeserializable,
)
from lightbug_http.http.request import HTTPRequest
from lightbug_http.http.response import Json


fn json_decode(req: HTTPRequest) raises -> JSON:
    """Parse the request body as untyped JSON.

    Args:
        req: The HTTP request to extract JSON from.

    Returns:
        A parsed JSON value.

    Raises:
        An error if the body is not valid JSON.
    """
    return parse(req.get_body())


fn json_decode[T: Movable & ImplicitlyDestructible](req: HTTPRequest) raises -> T:
    """Deserialize the request body into a typed struct.

    Parameters:
        T: Any struct conforming to Movable & ImplicitlyDestructible. Types with
           fields that have non-trivial destructors must also conform to Defaultable.

    Args:
        req: The HTTP request to deserialize JSON from.

    Returns:
        The deserialized value.

    Raises:
        An error if the body is not valid JSON or doesn't match the expected schema.
    """
    return deserialize[T](String(req.get_body()))
