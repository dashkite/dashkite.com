import {curry, tee, flow} from "@pandastrike/garden"
import * as m from "@dashkite/mercury"
import * as h from "helpers"

Markup =

  get: (path) ->
    do flow [
      m.use m.Fetch.client mode: "cors"
      m.from [
        -> window.location.origin
        m.base
      ]
      m.path "/content#{path}/content.html"
      m.accept "text/html"
      m.method "get"
      m.request
      m.text
      h.get "text"
  ]

export default Markup
