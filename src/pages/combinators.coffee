import {curry} from "panda-garden"
import hash from "hash-sum"

page = (context) ->
  context.bindings.hash ?= hash context.bindings
  context

view = curry (template, context) ->
  context.dom = document.querySelector "[name='#{context.data.name}']"
  context.view =  context.dom.querySelector "[data-hash='#{context.bindings.hash}']"
  if !context.view?
    context.html = template context.bindings
    context.dom.insertAdjacentHTML  "beforeend", context.html
    context.view =  context.dom.querySelector "[data-hash='#{context.bindings.hash}']"

  context

activate = curry (selectors, context) ->
  # TODO if unitialized, add event handlers?
  event = new Event "activate"
  for selector in selectors
    el = context.view.querySelector selector
    if el?
      el.dispatchEvent event
  context

export {page, view, activate}
