import {wrap, flow} from "@pandastrike/garden"
import * as n from "@dashkite/neon"
import {router} from "../helpers"
import head from "templates/head.pug"
import header from "templates/header.pug"

router.add "/",
  name: "home"
  flow [
    n.render "head", head
    n.render "header", header
    n.view "main", -> "<h1>Hello, World</h1>"
    n.show
  ]
