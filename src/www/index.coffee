import "construct-style-sheets-polyfill"
import Registry from "@dashkite/helium"
import * as q from "@dashkite/quark"
import {navigate} from "@dashkite/navigate"

import "./pages"
# import "./components"

import {ready} from "./helpers"
import css from "./styles/document.styl"

navigate document

sheets = q.sheets document
sheets.set "main", css
Registry.set {sheets}

ready ->
  router = Registry.get "router"
  try
    router.dispatch url: window.location.href
  catch error
    console.warn error
    router.browse name: "home"
