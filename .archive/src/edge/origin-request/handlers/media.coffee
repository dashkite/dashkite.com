import Path from "path"

media = (match, context) ->
  {request, callback} = context
  switch request.headers["accept-encoding"]?[0]?.value
    when "br"
      request.uri = Path.join "/brotli", request.uri
    when "gzip"
      request.uri = Path.join "/gzip", request.uri
    else
      request.uri = Path.join "/identity", request.uri
  try
    callback null, request
  catch error
    console.warn error
    request.uri = Path.join "/identity", request.uri
    callback null, request

export {media}
