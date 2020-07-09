import "coffeescript/register"

import Path from "path"

import pug from "jstransformer-pug"
import stylus from "jstransformer-stylus"

import {define, run, glob, read, write,
  extension, copy, transform, watch} from "panda-9000"

import {rmr} from "panda-quill"
import {go, map, wait, tee, reject} from "panda-river"

import {markdown, bundle, serve, sprites} from "./helpers"

import {processVideo} from "./media"

source = "./src"
target = "./build"

define "default", [ "build", "watch&", "serve&" ]

define "watch", watch (Path.resolve source), -> run "build"

# define "build", [ "clean", "html&", "css&", "js&", "images&" ]
define "build", [ "clean", "html&", "css&", "images&" ]

define "sprites", -> sprites source, target

define "clean", -> rmr "build"

define "html", ->
  go [
    glob [ "**/*.pug",  "!**/-*/**", "!**/-*" ], source
    wait map read
    map transform pug, filters: {markdown}
    map extension ".html"
    map write target
  ]

define "css", ->

  go [
    glob [ "**/*.styl",  "!**/-*/**", "!**/-*" ], source
    wait map read
    map transform stylus, {}
    map extension ".css"
    map write target
  ]

define "js", -> bundle "./src/index.coffee", "./build"

define "images", ->
  go [
    glob "**/*.{jpg,png,webp,svg,ico,mp4,webm}", source
    map copy target
  ]

define "serve",
  serve target,
    files: extensions: [ "html" ]
    logger: "tiny"
    rewrite: verbose: true
    port: 8000

define "video", ->
  {input, name, time} = process.env
  processVideo input, name, time
