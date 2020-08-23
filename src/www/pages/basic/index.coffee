import {wrap, flow} from "@pandastrike/garden"
import * as n from "@dashkite/neon"
import {router} from "../helpers"
import head from "./head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import products from "./products.pug"

templates = {products}

router.add "{/path*}",
  name: "basic"
  flow [
    n.render "head", head
    n.render "header", header
    n.render "footer", footer
    n.view "main", (bindings) ->
      {path: [key]} = bindings
      templates[key] bindings
    n.show
  ]
