import {flow, curry, tee} from "@pandastrike/garden"
import * as m from "@dashkite/mercury"

get = curry (name, object) -> object[name]

Preview =
  get: ({url}) ->
    do flow [
      m.use m.Fetch.client mode: "cors"
      m.template "https://staging-www.dashkite.com/preview{?url}"
      m.parameters {url}
      m.accept "application/json"
      m.method "get"
      m.request
      m.expect.status [ 200 ]
      m.expect.media "application/json"
      m.request
      m.json
      get "json"
    ]

export {Preview}
