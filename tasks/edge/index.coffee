import "coffeescript/register"

import Path from "path"
import {define, run} from "@dashkite/genie"
import * as b from "@dashkite/brick"
import {read, write, rmr} from "panda-quill"
import {shell, webpack} from "./helpers"

source = Path.resolve "src", "edge"
build = Path.resolve "build", "edge"

define "edge:build:development", [ "edge:clean", "edge:js:development"]

define "edge:build:staging", [ "edge:clean", "edge:js:staging"]

define "edge:build:production", [ "edge:clean", "edge:js:production"]

define "edge:build", "edge:build:development"

define "edge:clean", -> await rmr build

define "edge:js:development", ->
  webpack
    mode: "development"
    devtool: "inline-source-map"

define "edge:js:staging", ->
  webpack
    mode: "production"
    devtool: "none"
    optimization:
      nodeEnv: "staging"

define "edge:js:production", ->
  webpack
    mode: "production"
    devtool: "none"

define "edge:test:build", ->
  await rmr "build/test"
  webpack
    mode: "development"
    devtool: "inline-source-map"
    entry:
      "index": Path.resolve "test/edge/index.coffee"
    output:
      path: Path.resolve "build/test/edge"
      filename: "[name].js"

define "edge:test", "edge:test:build", ->
  b.node "build/test/edge/index.js", [ "--enable-source.maps" ]
