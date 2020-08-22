import "construct-style-sheets-polyfill"
import Registry from "@dashkite/helium"
import {ready} from "./helpers"
import "./pages"
# import "./components"
import {navigate} from "@dashkite/navigate"
# import css from "./css"

navigate document
# sheets.set "main", css

ready ->
  router = Registry.get "router"
  try
    router.dispatch url: window.location.href
  catch error
    console.warn error
    # browse "home", {}
