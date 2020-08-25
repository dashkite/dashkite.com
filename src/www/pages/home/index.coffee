import {wrap, flow} from "@pandastrike/garden"
import {adapt, router} from "../helpers"
import head from "./head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import view from "./view.pug"

router.add "/",
  name: "home"
  adapt (n) ->
    flow [
      n.render "head", head
      n.render "header", header
      n.render "footer", footer
      n.view "main", view
      n.show
    ]
