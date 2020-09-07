import {tee, wrap, flow} from "@pandastrike/garden"
import Content from "types/content"
import {adapt, router, merge, json} from "../helpers"
import head from "templates/head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import view from "./view.pug"
import content from "content/home/content.pug"
import description from "content/home/description.yaml"

router.add "/",
  name: "home"
  adapt (n) ->
    flow [
      n.render "head", head
      n.render "header", header
      n.render "footer", footer
      n.resource -> Content.loadFrom {content: content(), description...}
      merge
      json
      n.view "main", view
      n.show
    ]
