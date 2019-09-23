import "./pages"
import "./components"
import {dispatch} from "./router"
import {ready} from "./helpers"

ready ->
  dispatch window.location.href
