console.log "loading application"
import Registry from "@dashkite/helium"
import Router from "@dashkite/oxygen"
import { navigate } from "@dashkite/navigate"
import { $ } from "#helpers"
import "./pages"

# Install hook to allow us to avoid removing dynamically added importmap
# TODO should this be in Neon? or should Neon provide a more flexible solution?
#      or does it belong elsewhere (we have a similar hook in Carbon...)
import { innerHTML, use } from "diffhtml"
use syncTreeHook: (oldTree, newTree) ->
  if oldTree.attributes?.skip? then return false

router = Router.create()
router.install()
Registry.set {router}

import configuration from "./configuration"
window.mode ?= "development"

$.ready ->
  
  # TODO do this as part of the tag injection?
  $.set "skip", "true", $ "script[type='importmap']"

  # handle navigation events
  do ->
    for await event from navigate document
      router.browse event

  # make sure our routes have loaded
  # before we dispatch based on initial URL
  queueMicrotask ->
    router.dispatch url: window.location.href
