import Feed from "resources/feed"
import {respond} from "../helpers"

# install global fetch
import fetch from "node-fetch"
global.fetch = fetch

feed = (match, context) ->
  {format, tag} = match.bindings
  try
    respond context,
      status: "200"
      content:
        body: await Feed.get {format, tag}
        type: "text/xml"
  catch error
    console.warn error
    respond context, status: "404"

export {feed}
