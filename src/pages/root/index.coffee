import * as Fn from "@dashkite/joy/function"
import Registry from "@dashkite/helium"
import * as Ne from "@dashkite/neon"
import head from "#templates/head"
import main from "./main"

do ->

  router = await Registry.get "router"

  router.add "/",
    name: "root",
    Fn.flow [
      Ne.render "head", head
      Ne.view "main", main
      Ne.show
    ]
