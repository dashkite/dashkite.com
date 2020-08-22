import Path from "path"
import FS from "fs/promises"
import puppeteer from "puppeteer"
import express from "express"
import Pug from "pug"
import Coffee from "coffeescript"
import markdown from "marked"
import svgstore from "svgstore"
import SVGO from "svgo"
import cheerio from "cheerio"
import {wrap, pipe, flow} from "@pandastrike/garden"
import {tee, wait} from "panda-river"
import {rmr, mkdirp} from "panda-quill"
import * as b from "@dashkite/brick"
import * as k from "@dashkite/katana"
import * as w from "@dashkite/zenpack"

sleep = (ms) ->
  new Promise (resolve) ->
    setTimeout resolve, ms

clean = (build) ->
  await rmr build
  await mkdirp "0777", build

# base webpack bundle
bundle = (source, build) ->
  pipe [
    w.config source, build
    w.mainField "main:coffee"
    w.extension ".coffee"
    w.rule
      test: /.coffee$/
      loader: "coffee-loader"
    w.rule
      test: /.pug$/
      loader: "pug-loader"
      options:
        basedir: source
        filters: {markdown}
    w.rule
      test: /.yaml$/
      type: "json"
      loader: "yaml-loader"
    w.alias
      configuration: "#{source}/configuration.coffee"
      helpers: "#{source}/helpers/index.coffee"
      resources: "#{source}/resources/"
      profiles: "#{source}/profiles/"
      authenticators: "#{source}/authenticators/index.coffee"
      templates: "#{source}/templates/"
      themes: "#{source}/themes/index.coffee"
  ]

coffee = (source, build) ->
  do b.start [
    b.glob [ "**/*.coffee" ], source
    b.read
    b.tr ({path}, code) ->
      Coffee.compile code,
        bare: true
        inlineMap: true
        filename: path
        transpile:
          presets: [[
            "@babel/preset-env"
            targets: node: "current"
          ]]
    b.extension ".js"
    b.write build
  ]

pug = (source, build) ->
  do b.start [
    b.glob [ "**/*.pug", "!**/{templates,components,pages}/**/*.pug" ], source
    b.read
    b.tr ({path}, code) ->
      Pug.render code,
        filename: path
        basedir: source
        filters: {markdown}
    b.extension ".html"
    b.write build
  ]

images = (source, build) ->
  do b.start [
    b.glob [ "images/**/*", "!images/-svg" ], source
    b.copy build
  ]

sprites = (source, build) ->
  store = svgstore()
  svgo = new SVGO multipass: true
  await do b.start [
    b.glob [ "images/-svg/**/*.svg" ], source
    b.read
    b.tr ({path, name}, svg) ->
      # $ = cheerio.load svg
      # id = ((($ "[id]").attr "id").toLowerCase().replace /[\W_]+/g, " ")
      {data} = await svgo.optimize svg, {path}
      store.add name, data
  ]
  svg = store.toString()
  path = Path.join source, "images", "sprites.svg"
  # svg = await svgo.optimize svg, {path}
  # {data} = svg
  # FS.writeFile path, data
  FS.writeFile path, svg

browser = -> puppeteer.launch()

debounce = do (last = undefined) ->
  (ms, f) ->
    ms = BigInt 1e6 * ms
    (ax...) ->
      current = process.hrtime.bigint()
      if !last? || (current - last > ms)
        last = current
        f ax...

export { clean, bundle, coffee, pug, images, browser, debounce, sprites }
