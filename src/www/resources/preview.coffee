import {flow, curry, tee} from "@pandastrike/garden"
import * as m from "@dashkite/mercury"
import Vault from "-sky-vault"

vault = Vault["link-preview-production-rapid"]

get = curry (name, object) -> object[name]

Preview =
  get: ({url}) ->
    cache = undefined
    json = do flow [
      m.use m.Fetch.client mode: "cors"
      m.template "https://www.dashkite.com/preview{?url}"
      m.parameters {url}
      m.accept "application/json"
      m.method "get"
      m.request
      tee (context) ->
        cache = control: context.response.headers["cache-control"]
      m.json
      get "json"
    ]
    {json, cache}

export default Preview
