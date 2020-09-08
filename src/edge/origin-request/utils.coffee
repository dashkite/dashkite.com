import zlib from "zlib"

gzip = (string) ->
  new Promise (resolve, reject) ->
    zlib.gzip (Buffer.from string, "utf8"), level: 1, (error, result) ->
      if error
        reject error
      else
        resolve result.toString "base64"

export {gzip}
