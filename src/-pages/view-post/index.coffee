import {curry, tee, flow} from "panda-garden"
import {route} from "../../router"
import {page, view, activate, show} from "../combinators"
import render from "./index.pug"

route "/posts/{key}",
  name: "view post"
  flow [
    page
    view render
    activate [ "raven-post" ]
    show
  ]
