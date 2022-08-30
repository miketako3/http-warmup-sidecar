# http-warmup-sidecar

## What is this?

When we use JVM application on Kubernetes, we must warm up our application before real request sent.

This sidecar image perform following things:

- send health check requests until main container stand up per second
- send warm up requests
- create `/http-warmup/warmup-completed` file

## Parameters

all parameters are required.

| number | parameter                    | example          | if empty string  |
|--------|------------------------------|------------------|------------------|
| `$1`   | url for health check         | `localhost:3000` | `localhost:8080` |
| `$2`   | http method for health check | `POST`           | `GET`            |
| `$3`   | http header for health check | `Cookie: foobar` |                  |
| `$4`   | http body for health check   | `{"foo": "bar"}` |                  |
| `$5`   | url for warmup               | `localhost:3000` | `localhost:8080` |
| `$6`   | http method for warmup       | `POST`           | `GET`            |
| `$7`   | http header for warmup       | `Cookie: foobar` |                  |
| `$8`   | http body for warmup         | `{"foo": "bar"}` |                  |
| `$9`   | count of requests for warmup | `1000`           | `10`             |

## Example

```shell
 docker container run -t http-warmup:latest localhost:3000 "" "" "" localhost:3000 "" "" "" 10
```
