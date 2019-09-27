import {curry} from "panda-garden"
import hash from "hash-sum"
import {$} from "panda-play"

page = (context) ->
  context.bindings.hash ?= hash context.bindings
  context.bindings.meta = context.data
  context

view = curry (template, context) ->
  # TODO hide/show page
  context.dom = document.querySelector ".page[name='#{context.data.name}']"
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
    do ->
      el = await $ selector, context.view
      el.dispatch "activate" if el?
  context

show = (context) ->
  active = document.querySelector ".page.active"
  active?.classList.remove "selected"
  context.dom.classList.add "active"
  context

export {page, view, activate, show}
