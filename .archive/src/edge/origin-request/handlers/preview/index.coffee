import {Preview} from "./resources"
import {respond} from "../../helpers"

preview = (match, context) ->
  {cache, data} = await Preview.get url: match.bindings.url
  console.log "Preview: ", data
  respond context,
    cache: cache
    content: body: data

export {preview}
