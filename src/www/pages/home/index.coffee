import {wrap, flow} from "@pandastrike/garden"
import * as n from "@dashkite/neon"
import {router} from "../helpers"
import head from "./head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import template from "./view.pug"

router.add "/",
  name: "home"
  flow [
    n.render "head", head
    n.render "header", header
    n.render "footer", footer
    n.view "main", template
    n.show
  ]
