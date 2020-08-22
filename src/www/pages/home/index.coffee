import {wrap, flow} from "@pandastrike/garden"
import * as n from "@dashkite/neon"
import {router} from "../helpers"

router.add "/",
  name: "home"
  flow [
    n.view "main", -> "<h1>Hello, World</h1>"
    n.show
  ]
