import {Router} from "panda-router"
import TemplateParser from "url-template"

router = new Router()
handlers = {}

route = (template, data, handler) ->
  router.add {template, data}
  handlers[data.name] = handler
  router

match = (url) -> router.match url

dispatch = (url) ->
  if /^[^\/]/.test url
    {pathname, search} = new URL url
    url = pathname + search
  console.log url
  {data, bindings} = match url
  handlers[data.name] bindings

link = ({name, parameters}) ->
  for route in router.routes
    if route.data.name == name
      return TemplateParser
        .parse route.template
        .expand parameters ? {}

  console.warn "link: no page matching '#{name}'"

push = ({name, parameters, state}) ->
  window.history.pushState state, "", link {name, parameters}

replace = ({name, parameters, state}) ->
  window.history.replaceState state, "", link {name, parameters}

browse = ({url, name, parameters, state}) ->
  if !url?
    await push {name, parameters, state}
  else
    try
      history.pushState {}, "", url
    catch error
      console.warn error
      # For non-local URLs, open the link in a new tab.
      window.open url

export {router, route, match, dispatch, link, push, replace, browse}
