import {flow, curry, tee} from "@pandastrike/garden"
import * as m from "@dashkite/mercury"

get = curry (name, object) -> object[name]

Preview =
  get: flow [
    m.use m.Fetch.client mode: "cors"
    m.template "https://www.dashkite.com/preview{?url}"
    m.from [
      m.data [ "url" ]
      m.parameters
    ]
    m.accept "application/json"
    m.method "get"
    m.request
    m.json
    get "json"
  ]

export default Preview
