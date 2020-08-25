import Accept from "@hapi/accept"
import {isEmpty, toJSON} from "panda-parchment"
import {lookupType, isCompressible, notAcceptable} from "./utils"
import "source-map-support/register"

handler = (event, context, callback) ->
  try
    {request, config} = event.Records[0].cf

    console.log
      requestID: config.requestId
      uri: request.uri
      accept: request.headers["accept"][0].value
      acceptEncoding: request.headers["accept-encoding"][0].value

    # Negotiate the final "Accept" Header and assign to request
    try
      header = request.headers["accept"]?[0]?.value ?  "*/*"
      allowedType = lookupType request
      acceptable = Accept.mediaType header, [ allowedType ]
      return callback null, notAcceptable allowedType if isEmpty acceptable
    catch e
      console.error e
      return callback null, notAcceptable allowedType

    console.log accept: acceptable
    request.headers["accept"] = [
      key: "Accept"
      value: acceptable
    ]


    # Negotiate the "Accept-Encoding" header and assign to request.
    # Because this is an SPA, all HTML files get <meta> tags injected,
    # so the best we can do is dynamic compression with gzip.
    try
      if allowedType == "text/html"
        allowedTypes = ["gzip", "identity"]
      else
        if isCompressible allowedType
          allowedTypes = ["br", "gzip", "identity"]
        else
          allowedTypes = ["identity"]

      header = request.headers["accept-encoding"]?[0]?.value ? "identity"
      acceptable = Accept.encoding header, allowedTypes

      return callback null, notAcceptable allowedTypes if isEmpty acceptable
    catch e
      console.log e
      return callback null, notAcceptable allowedTypes

    console.log acceptEncoding: acceptable
    request.headers["accept-encoding"] = [
      key: "Accept-Encoding"
      value: acceptable
    ]

    callback null, request

  catch e
    console.error e
    callback null, request

export {handler}
