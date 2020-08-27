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

router.add "{/path*}",
  name: "basic"
  adapt (n) ->
    flow [
      path
      n.view "main", loading
      attempt [
        # Try to load the content
        flow [
          n.resource Content.load
          merge
          n.view "main", view
          n.show
        ]
        # If we fail, show Not Found page
        flow [
          tee (context) ->
            context.bindings =
              title: "Not Found"
              description: "I'm sorry, but we can't find that page."
          n.view "main", notFound
        ]
      ]
      n.render "head", head
      n.render "header", header
      n.render "footer", footer
      n.show
    ]
