import statuses from "statuses"
import zlib from "zlib"

gzip = (string) ->
  new Promise (resolve, reject) ->
    zlib.gzip (Buffer.from string, "utf8"), level: 1, (error, result) ->
      if error
        reject error
      else
        resolve result.toString "base64"

respond = ({request, callback}, {status, content, cache}) ->

  # prepare response
  canCompress = (request.headers["accept-encoding"][0].value == "gzip")
  status ?= "200"
  description = statuses status
  isSuccess = ("200" <= status <= "299") && (status != "204")
  body = encoding = undefined
  if isSuccess && content.body
    body = if content.body.constructor == String
      content.type ?= "text/html"
      content.body
    else
      content.type ?= "application/json"
      JSON.stringify content.body
    if canCompress
      body = await gzip body
      encoding = "gzip"
      format = "base64"
    else
      encoding = "identity"
      format = "text"

  # send it
  callback null,
    status: status
    statusDescription: description
    body: body
    bodyEncoding: format
    headers:
      "access-control-allow-origin": [
        key: "Access-Control-Allow-Origin"
        value: "*"
      ]
      "content-type": [
          key: "Content-Type",
          value: content.type
      ]
      "content-encoding": [
          key: "Content-Encoding",
          value: encoding
      ]
      "cache-control": [
          key: "Cache-Control",
          value: cache.control ? "no-store"
      ]
      "vary": [
        key: "Vary"
        value: "Accept-Encoding"
      ]

log = (event) ->
  {request, config} = event.Records[0].cf
  console.log
    requestID: config.requestId
    uri: request.uri
    querystring: request.querystring
    accept: request.headers["accept"]?[0]?.value
    acceptEncoding: request.headers["accept-encoding"]?[0]?.value

export {respond, log}
