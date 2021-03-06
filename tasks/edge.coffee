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
  tee (context) -> context.resolve.mainFields = [ "main:coffee", "main" ]
  aws.run awsConfig
 ]

define "edge:staging:bundle", pipe [
  bundle
  w.mode "development"
  w.nodeEnv "staging"
  w.sourcemaps
  tee (context) -> context.resolve.mainFields = [ "main:coffee", "main" ]
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

# TODO make it possible to run against dev or staging?
# right now there's no difference between dev and staging build
# except that dev doesn't work due to the configuration being local

define "edge:staging:test", ->
  require "../test/edge"
