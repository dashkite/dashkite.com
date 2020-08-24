import {curry, tee, flow} from "@pandastrike/garden"
import * as m from "@dashkite/mercury"
import * as h from "helpers"

Descriptor =

  get: (path) ->
    do flow [
      m.use m.Fetch.client mode: "cors"
      m.base window.location.origin
      m.path "/content#{path}/description.json"
      m.accept "application/json"
      m.method "get"
      m.request
      m.json
      h.get "json"
  ]

export default Descriptor
