import {wrap, tee, flow} from "@pandastrike/garden"
import Content from "types/content"
import {adapt, router} from "../helpers"
import head from "./head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import view from "./view.pug"

path = tee ({bindings}) -> bindings.path = bindings.path.join "/"
merge = tee (context) -> Object.assign context.bindings, context.resource

router.add "{/path*}",
  name: "basic"
  adapt (n) ->
    flow [
      path
      n.resource Content.load
      merge
      n.render "head", head
      n.render "header", header
      n.render "footer", footer
      n.view "main", view
      n.show
    ]
