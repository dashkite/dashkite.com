import {flow, curry, tee, rtee} from "@pandastrike/garden"
import * as m from "@dashkite/mercury"
import Vault from "-sky-vault"

vault = Vault["link-preview-production-rapid"]

get = curry (name, object) -> object[name]

# TODO this belongs in Mercury instead of the current version
headers = curry rtee (object, context) ->
  Object.assign (context.headers ?= {}), object

Preview =
  get: ({url}) ->
    cache = undefined
    data = await do flow [
      m.use m.Fetch.client mode: "cors"
      m.template "https://links-api.dashkite.com/preview{?url}"
      m.parameters {url}
      m.accept "application/json"
      headers [ vault.header ]: vault.value
      m.method "get"
      m.request
      m.expect.status [ 200 ]
      m.expect.media "application/json"
      tee (context) ->
        cache = control: context.response.headers["cache-control"]
      m.json
      get "json"
    ]
    {data, cache}

export {Preview}
