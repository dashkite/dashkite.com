import {curry, tee, flow} from "panda-garden"
import {route} from "../../router"
import {page, view, activate, show} from "../combinators"
import render from "./index.pug"

path = curry (key, context) ->
  context.bindings[key] = context.bindings[key].join "/"

route "{/path*}",
  name: "view article"
  flow [
    page
    tee path "path"
    view render
    activate [ "raven-article" ]
    show
  ]
