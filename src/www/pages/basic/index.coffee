import {wrap, tee, flow} from "@pandastrike/garden"
import * as n from "@dashkite/neon"
import Content from "types/content"
import {router} from "../helpers"
import head from "./head.pug"
import header from "templates/header.pug"
import footer from "templates/footer.pug"
import view from "./view.pug"

path = tee ({bindings}) -> bindings.path = bindings.path.join "/"
merge = tee (context) -> Object.assign context.bindings, context.resource

router.add "{/path*}",
  name: "basic"
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
