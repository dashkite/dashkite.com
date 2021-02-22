import Preview from "resources/preview"
import {respond} from "../helpers"

preview = (match, context) ->
  {cache, data} = await Preview.get match.bindings.url
  respond context,
    cache: cache
    content: body: data

export {preview}
