import Registry from "@dashkite/helium"
import "./pages"
import {respond} from "../../helpers"

application = (match, context) ->
  router = Registry.get "router"
  # will redirect to / on its own
  await router.dispatch url: request.uri
  # neon server places results in global $
  html = $.html()
  respond context,
    status: "200"
    content:
      body: html
      type: "text/html"

export {application}
