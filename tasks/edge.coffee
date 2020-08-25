import Path from "path"

import {tee, pipe} from "@pandastrike/garden"
import * as b from "@dashkite/brick"
import {define, run} from "@dashkite/genie"

import * as h from "./helpers"
import {bundle as www} from "./www"

import * as w from "@dashkite/zenpack"

source = Path.resolve "src", "edge"
build = Path.resolve "build", "edge"

bundle = pipe [
  www
  w.target "node"
  w.node global: true
  w.entry
    "origin-request": Path.resolve source, "origin-request", "index.coffee"
    "viewer-request": Path.resolve source, "viewer-request", "index.coffee"
  w.path build
  tee (context) -> console.log "resolve", context.resolve
]

define "edge:clean", -> h.clean build

define "edge:development:bundle", pipe [
  bundle
  w.mode "development"
  w.sourcemaps
  w.run
]

define "edge:staging:bundle", pipe [
  bundle
  w.mode "development"
  w.sourcemaps
  w.run
]

define "edge:production:bundle", pipe [
  bundle
  w.mode "production"
  w.run
]

define "edge:development:build", [
  "edge:clean"
  "edge:development:bundle&"
]

define "edge:staging:build", [
  "edge:clean"
  "edge:development:bundle&"
]

define "edge:production:build", [
  "edge:clean"
  "edge:production:bundle&"
]

define "edge:build", "edge:development:build"

define "edge:watch", ->
  b.watch source, -> run "edge:development:build"
  b.watch "./node_modules", h.debounce 1000, -> run "edge:development:build"

define "edge:test", "edge:development:build", ->
  b.node "build/test/edge/index.js", [ "--enable-source.maps" ]
