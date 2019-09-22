import {flow} from "panda-garden"
import {route} from "../../router"
import {page, view, activate} from "../combinators"
import render from "./index.pug"

route "/posts/{name}",
  name: "view post"
  flow [
    page
    view render
    activate [ "kite-view-post" ]
    (context) -> console.log {context}
  ]
