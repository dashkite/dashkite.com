import {curry, pipe, tee, rtee} from "@pandastrike/garden"

_root = curry rtee (selector, context) ->
  context.root = $ selector

_page = tee (context) ->
  {data, root} = context
  context.page = $ ".page[name='#{data.name}']", root
  if context.page.get().length == 0
    root.append "<div class='page' name='#{data.name}'>"
    context.page = $ ".page[name='#{data.name}']", root

_view = curry rtee (template, context) ->
  {bindings, path, page} = context
  context.initializing = false
  context.view = $ "[data-path='#{path}']", page
  if context.view.get().length == 0
    context.initializing = true
    page.append "<div class='view' data-path='#{path}'>"
    context.view = $ "[data-path='#{path}']", page
  # context.view.append template bindings

resource = curry rtee (getter, context) ->
  context.resource = await getter context

properties = curry rtee (dictionary, context) ->
  Promise.all do ->
    for key, getter of dictionary
      do (key, getter) ->
        context.bindings[key] = await getter context

view = (selector, template) ->
  pipe [
    _root selector
    _page
    _view template
  ]

render = curry rtee (selector, template, {bindings}) ->
  ($ selector).html template bindings

show = tee (context) ->
  $ ".active", context.root
    .removeClass "active"
  context.page.addClass "active"
  context.view.addClass "active"

# activate/deactivate are no-ops
activate = curry rtee (handler, context) ->
deactivate = curry rtee (handler, context) ->

export {resource, properties, view, activate, deactivate, render, show}
