import Path from "path"

import {pipe} from "@pandastrike/garden"
import * as b from "@dashkite/brick"
import {define, run} from "@dashkite/genie"

import * as h from "./helpers"

import * as w from "@dashkite/zenpack"

import test from "../../test/www"

source = Path.resolve "src", "www"
build = Path.resolve "build", "www"

translate = (source, build) ->
  Promise.all [
    h.pug source, build
    h.yaml source, build
    h.markdown source, build
    h.images source, build
  ]

define "www:server", [ "www:development:build" ], ->
  {port} = (b.server build, port: 3000, fallback: "index.html").address()
  console.log "server running on port #{port}"
  b.watch source, -> run "www:development:build"
  b.watch "./node_modules", h.debounce 1000, -> run "www:development:build"

define "www:development:build", ->

  await h.clean build

  await Promise.all [
    do pipe [
      h.bundle source, build
      w.mode "development"
      w.sourcemaps
      w.run
    ]
    translate source, build
  ]

define "www:production:build", "build&", ->

  await h.clean build

  await Promise.all [
    do pipe [
      h.bundle source, build
      w.mode "production"
      w.run
    ]
    translate source, build
  ]

define "www:test", "www:development:build", ->

  test await Promise.all [
    b.server build, fallback: "index.html"
    h.browser()
  ]

define "www:sprites", -> h.sprites source, build
