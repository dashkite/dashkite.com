import {wrap, tee, flow} from "@pandastrike/garden"
import * as n from "@dashkite/neon"
import Content from "resources/content"
import {router} from "../helpers"
import head from "./head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import notFound from "templates/404.pug"
import products from "./products.pug"
import code from "./open-source.pug"
import contact from "./contact.pug"

templates = {products, "open-source": code, contact}

router.add "{/path*}",
  name: "basic"
  flow [
    n.resource ({bindings}) ->
      bindings.path = bindings.path.join "/"
      Content.get bindings.path
    tee (context) ->
      Object.assign context.bindings, context.resource
    n.render "head", head
    n.render "header", header
    n.render "footer", footer
    n.view "main", (bindings) ->
      if (template = templates[bindings.path])?
        template bindings
    n.show
  ]
