import Registry from "@dashkite/helium"
import "./pages"
import {respond} from "../../helpers"

application = (match, context) ->
  {request} = context
  router = Registry.get "router"
  # will redirect to / on its own
  # TODO we shouldn't need this but ...
  if /^\/content/.test request.uri
    throw new Error "Application handler was invoked
      with content URL: #{request.uri}"
  await router.dispatch url: request.uri
  # neon server places results in global $
  html = $.html()
  respond context,
    status: "200"
    content:
      body: html
      type: "text/html"

export {application}
