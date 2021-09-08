import * as F from "@dashkite/joy/function"
import * as G from "@dashkite/joy/generic"
import * as O from "@dashkite/joy/object"
import * as T from "@dashkite/joy/type"

isRoot = (el) -> el.querySelector?

$ = G.generic
  name: "$"
  description: "JQuery-style DOM helpers"
  default: F.identity

G.generic $, T.isString, isRoot, (selector, root) ->
  $ root.querySelector selector

G.generic $, T.isString, (selector) -> $ selector, document

O.assign $,
  ready: (f) ->
    if document.readyState != "loading"
      queueMicrotask f
    else
      document.addEventListener "DOMContentLoaded", f
  set: F.curry (key, value, el) -> el.setAttribute key, value

export { $ }
