import "./pages"
import "./components"
import {dispatch} from "./router"
import {navigate} from "./navigate"
import {ready} from "./helpers"

ready ->
  navigate document
  dispatch window.location.href
