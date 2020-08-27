import {join} from "path"
import response from "./response"
import "source-map-support/register"

handler = (event, context, callback) ->
  {request, config} = event.Records[0].cf

  console.log
    requestID: config.requestId
    uri: request.uri
    accept: request.headers["accept"]?[0]?.value
    acceptEncoding: request.headers["accept-encoding"]?[0]?.value

  try
    if (request.uri.match /^\/(content|media)\//)?
      switch request.headers["accept-encoding"]?[0]?.value
        when "br"
          request.uri = join "/brotli", request.uri
        when "gzip"
          request.uri = join "/gzip", request.uri
        else
          request.uri = join "/identity", request.uri
      callback null, request
    else
      callback null, await response request
  catch e
    # Fallback to just processing the request normally.
    console.error e
    request.uri = join "/identity", request.uri
    callback null, request

export {handler}
