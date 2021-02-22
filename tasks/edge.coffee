import Path from "path"

import {pipe, flow, tee} from "@pandastrike/garden"
import * as b from "@dashkite/brick"
import {define, run} from "@dashkite/genie"

import * as h from "./helpers"
import {bundle as www} from "./www"

import * as w from "@dashkite/zenpack"

import * as aws from "./aws"
import awsConfig from "./aws-config"

source = Path.resolve "src", "edge"
build = Path.resolve "build", "edge"

bundle = pipe [
  www
  w.target "node"
  w.entry
    "origin-request": Path.resolve source, "origin-request", "index.coffee"
    "viewer-request": Path.resolve source, "viewer-request", "index.coffee"
  w.libraryTarget "umd"
  w.path build
]

define "edge:clean", -> h.clean build

define "edge:development:bundle", pipe [
  bundle
  w.mode "development"
  w.sourcemaps
  aws.run awsConfig
 ]

define "edge:staging:bundle", pipe [
  bundle
  w.mode "development"
  w.nodeEnv "staging"
  w.sourcemaps
  aws.run awsConfig
]

define "edge:production:bundle", pipe [
  bundle
  w.mode "production"
  aws.run awsConfig
]

define "edge:development:build", [
  "edge:clean"
  "edge:development:bundle&"
]

define "edge:staging:build", [
  "edge:clean"
  "edge:staging:bundle&"
]

define "edge:production:build", [
  "edge:clean"
  "edge:production:bundle&"
]

define "edge:build", "edge:development:build"

define "edge:watch", ->
  b.watch source, -> run "edge:development:build"
  b.watch "./node_modules", h.debounce 1000, -> run "edge:development:build"

#
# Edge Test
#

define "edge:test:clean", -> h.clean Path.resolve "build", "edge", "test"

define "edge:test:bundle", pipe [
  bundle
  w.entry test: Path.resolve "test", "edge", "index.coffee"
  w.path Path.resolve build, "test"
  w.mode "development"
  w.nodeEnv "test"
  w.sourcemaps
  w.run
]

define "edge:test:build", [
  "edge:test:clean"
  "edge:test:bundle&"
]

define "edge:test", "edge:test:build", ->
  b.node "build/edge/test/test.js", [ "--enable-source.maps" ]
