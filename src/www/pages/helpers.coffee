import Registry from "@dashkite/helium"
import Router from "@dashkite/oxygen"

adapt = (f) ->
  do ({handler} = []) ->
    (context) ->
      handler ?= f Registry.get "neon"
      handler context

router = Router.create()
Registry.set {router}

export {adapt, router}
