import {curry} from "panda-garden"

page = (context) -> context

view = curry (template, context) ->
  context.html = template context.bindings
  context.dom = document.querySelector "[name='#{context.data.name}']"
  context.dom.innerHTML = context.html
  context

activate = curry (selectors, context) -> context

export {page, view, activate}
