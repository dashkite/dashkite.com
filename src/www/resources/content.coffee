import {curry, tee, flow} from "@pandastrike/garden"
import * as m from "@dashkite/mercury"

Content =

  get: (path) ->
    do flow [
      m.use m.Fetch.client mode: "cors"
      m.base window.location.origin
      m.path "/content/#{path}.json"
      m.accept "application/json"
      m.method "get"
      m.request
      m.json
      (context) -> context.json
  ]

export default Content
