import {tee} from "@pandastrike/garden"
import Registry from "@dashkite/helium"
import Router from "@dashkite/oxygen"

adapt = (f) ->
  do ({handler} = []) ->
    (context) ->
      handler ?= f Registry.get "neon"
      handler context

router = Router.create()
Registry.set {router}

merge = tee (context) ->
  Object.assign context.bindings, context.resource

json = tee (context) ->
  context.bindings.json =
    JSON.stringify context.bindings

export {adapt, router, merge, json}
