# JSON Service

A simple JSON API example using `lightbug_http`. The server accepts a POST request with a JSON body and returns a JSON response.

To run the server:

```bash
pixi run server
```

Then send a request:

```bash
curl -X POST http://localhost:8080/greet \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice"}'
# {"message":"Hello, Alice!"}
```
