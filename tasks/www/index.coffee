import Path from "path"

import {pipe} from "@pandastrike/garden"
import * as b from "@dashkite/brick"
import {define, run} from "@dashkite/genie"

import { clean, bundle, coffee, pug, yaml, images, sprites,
  browser, debounce } from "./helpers"

import * as w from "@dashkite/zenpack"

import markdown from "marked"

import test from "../../test/www"

source = Path.resolve "src", "www"
build = Path.resolve "build", "www"

define "www:server", [ "www:development:build" ], ->
  {port} = (b.server build, port: 3000, fallback: "index.html").address()
  console.log "server running on port #{port}"
  b.watch source, -> run "www:development:build"
  b.watch "./node_modules", debounce 1000, -> run "www:development:build"

define "www:development:build", ->

  await clean build

  await Promise.all [
    do pipe [
      bundle source, build
      w.mode "development"
      w.sourcemaps
      w.run
    ]
    pug source, build
    yaml source, build
    images source, build
  ]

define "www:production:build", "build&", ->

  await clean build

  await Promise.all [
    do pipe [
      bundle source, build
      w.mode "production"
      w.run
    ]
    pug source, build
    yaml source, build
    images source, build
  ]

define "www:test", "www:development:build", ->

  test await Promise.all [
    b.server build, fallback: "index.html"
    browser()
  ]

define "www:sprites", -> sprites source, build
