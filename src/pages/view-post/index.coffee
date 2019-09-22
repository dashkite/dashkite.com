import {route} from "../../router"

route "/posts/{name}",
  name: "view-post"
  (name) -> console.log "view post": name
