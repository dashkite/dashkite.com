import {gzip} from "./utils"
import Registry from "@dashkite/helium"
import "./pages"

render = (request) ->
  router = Registry.get "router"
  await router.dispatch url: request.uri
  $.html()

respond = (request) ->
  isCompressed = (request.headers["accept-encoding"][0].value == "gzip")

  body = await render request

  status: "200",
  statusDescription: "200 OK"
  body: if isCompressed then await gzip body else body
  bodyEncoding: if isCompressed then "base64" else "text"
  headers:
    "access-control-allow-origin": [
      key: "Access-Control-Allow-Origin"
      value: "*"
    ]
    "content-type": [
        key: "Content-Type",
        value: "text/html"
    ]
    "content-encoding": [
        key: "Content-Encoding",
        value: if isCompressed then "gzip" else "identity"
    ]
    "vary": [
      key: "Vary"
      value: "Accept-Encoding"
    ]


export default respond
