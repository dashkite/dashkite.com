import Path from "path"
import FS from "fs/promises"
import {promise} from "panda-parchment"
import {read} from "panda-quill"

import * as b from "@dashkite/brick"
import svgstore from "svgstore"
import SVGO from "svgo"

import marked from "marked"
import webpack from "webpack"

import http from "http"
import connect from "connect"
import logger from "morgan"
import finish from "finalhandler"
import rewrite from "connect-history-api-fallback"
import files from "serve-static"
import {green, red} from "colors/safe"

markdown = (text) ->
  marked text,
    gfm: true
    headerIds: true
    mangle: true
    smartLists: true
    smartypants: true

bundle = (entry, target) ->

  promise (resolve, reject) ->

    callback = (error, result) ->
      console.error result.toString colors: true
      if error? || result.hasErrors()
        reject error ? result.errors
      else
        resolve result

    config =
      entry: entry
      mode: "development"
      devtool: "inline-source-map"
      output:
        path: Path.resolve target
        filename: "index.js"
        devtoolModuleFilenameTemplate: (info, args...) ->
          {namespace, resourcePath} = info
          "webpack://#{namespace}/#{resourcePath}"
      module:
        rules: [

          test: /\.pug$/
          use: [
            loader: "pug-loader"
            options: filters: {markdown}

          ]
        ,
          test: /\.coffee$/
          use: [ 'coffee-loader' ]
        ,
          test: /\.js$/
          use: [ "source-map-loader" ]
          enforce: "pre"
        ,
          test: /\.yaml$/
          use: [ "json-loader", "yaml-loader" ]
        ,
          test: /\.md$/
          use: [ "html-loader", "markdown-loader" ]
        ]
      resolve:
        modules: [ Path.resolve "node_modules" ]
        extensions: [ ".js", ".json", ".coffee" ]
      plugins: []

    webpack config, callback

serve = (path, options) ->

  ->
    {port} = options
    handler = connect()

    if options.logger?
      handler.use logger options.logger

    # 1. try to find the file based on the URL
    handler.use files path, options.files

    # 2. rewrite the URL and try again
    if options.rewrite?
      handler.use rewrite options.rewrite
    handler.use files path, options.files

    # 3. give up and error out
    handler.use finish

    http.createServer handler
    .listen port, ->
      console.log green "p9k: server listening on port #{port}"

sprites = (source, build) ->
  store = svgstore()
  svgo = new SVGO multipass: true
  await do b.start [
    b.glob [ "media/-sprites/**/*.svg" ], source
    b.read
    b.tr ({path, name}, svg) ->
      # $ = cheerio.load svg
      # id = ((($ "[id]").attr "id").toLowerCase().replace /[\W_]+/g, " ")
      {data} = await svgo.optimize svg, {path}
      store.add name, data
  ]
  svg = store.toString()
  path = Path.join source, "media", "sprites.svg"
  # svg = await svgo.optimize svg, {path}
  # {data} = svg
  # FS.writeFile path, data
  FS.writeFile path, svg

export {markdown, bundle, serve, sprites}
