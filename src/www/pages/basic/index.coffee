import {wrap, tee, flow} from "@pandastrike/garden"
import {attempt} from "helpers"
import Content from "types/content"
import {adapt, router} from "../helpers"
import head from "./head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import view from "./view.pug"
import loading from "templates/loading.pug"
import notFound from "templates/not-found.pug"

path = tee ({bindings}) -> bindings.path = bindings.path.join "/"
merge = tee (context) -> Object.assign context.bindings, context.resource
json = tee (context) ->
  context.bindings = json:
    JSON.stringify context.bindings

router.add "{/path*}",
  name: "basic"
  adapt (n) ->
    flow [
      path
      n.view "main", loading
      # rare case where we want to show before loading
      n.show
      attempt [
        # Try to load the content
        flow [
          n.resource Content.load
          merge
          json
          n.view "main", view
        ]
        # If we fail, show Not Found page
        flow [
          tee (context) ->
            context.bindings =
              title: "Not Found"
              description: "We can't find anything for that URL."
          n.view "main", notFound
        ]
      ]
      n.render "head", head
      n.render "header", header
      n.render "footer", footer
    ]
