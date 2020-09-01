import Path from "path"

import {pipe} from "@pandastrike/garden"
import * as b from "@dashkite/brick"
import {define, run} from "@dashkite/genie"

import * as h from "./helpers"

import * as w from "@dashkite/zenpack"

import test from "../test/www"

source = Path.resolve "src", "www"
build = Path.resolve "build", "www"

define "www:clean", -> h.clean build
define "www:pug", -> h.pug source, build
define "www:markdown", -> h.markdown source, build
define "www:yaml", -> h.yaml source, build
define "www:media", -> h.images source, build
define "www:assets", [ "www:pug&", "www:markdown&", "www:yaml&", "www:media&" ]

bundle = h.bundle source, build

define "www:development:bundle", pipe [
  bundle
  w.mode "development"
  w.sourcemaps
  w.run
]

define "www:staging:bundle", pipe [
  bundle
  w.mode "development"
  w.nodeEnv "staging"
  w.sourcemaps
  w.run
]

define "www:production:bundle", pipe [
  bundle
  w.mode "production"
  w.run
]

define "www:development:build", [
  "www:clean"
  "www:development:bundle&"
  "www:assets&"
]

define "www:staging:build", [
  "www:clean"
  "www:staging:bundle&"
  "www:assets&"
]

define "www:production:build", [
  "www:clean"
  "www:production:bundle&"
  "www:assets&"
]

define "www:build", "www:development:build"

define "www:watch", ->
  b.watch source, -> run "www:development:build"
  b.watch "./node_modules", h.debounce 1000, -> run "www:development:build"

define "www:server", [ "www:development:build&", "www:watch&" ], ->
  {port} = (b.server build, port: 8080, fallback: "index.html").address()
  console.log "server running on port #{port}"

define "www:test", "www:development:build", ->

  test await Promise.all [
    b.server build, fallback: "index.html"
    h.browser()
  ]

define "www:sprites", -> h.sprites source, build

export {bundle}
