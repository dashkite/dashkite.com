media = (match, context) ->
  {request, callback} = context
  switch request.headers["accept-encoding"]?[0]?.value
    when "br"
      request.uri = join "/brotli", request.uri
    when "gzip"
      request.uri = join "/gzip", request.uri
    else
      request.uri = join "/identity", request.uri
  try
    next()
  catch error
    console.warn error
    request.uri = join "/identity", request.uri
    callback null, request



export {media}
