import Registry from "@dashkite/helium"
import "@dashkite/vellum"
import * as q from "@dashkite/quark"
import {navigate} from "@dashkite/navigate"
import * as n from "@dashkite/neon"
import "pages"

import {ready} from "./helpers"
import main from "./styles/document.styl"
import views from "./styles/views"

sheets = q.sheets document
Registry.set {sheets, neon: n}

navigate document

ready ->

  sheets.set "main", main
  sheets.set "views", views

  router = Registry.get "router"
  try
    router.dispatch url: window.location.href
  catch error
    console.warn error
    router.browse name: "home"
