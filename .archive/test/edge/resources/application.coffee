import * as g from "@pandastrike/garden"
import * as m from "@dashkite/mercury"

get = g.curry (name, object) -> object[name]

Application =

  get: (path) ->
    do g.flow [
      m.use m.Fetch.client {mode: "cors"}
      m.url "https://staging-www.dashkite.com#{path}"
      m.method "get"
      m.accept "text/html"
      m.request
      m.expect.status [ 200 ]
      m.expect.media "text/html"
      m.text
      get "text"
    ]

export {Application}
