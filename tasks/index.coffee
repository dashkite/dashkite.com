import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import sky from "@dashkite/sky-presets"
import FS from "node:fs/promises"
import Path from "node:path"
import { build } from "@dashkite/sites-fs"
import { render } from "@dashkite/sites-render"
import * as Fn from "@dashkite/joy/function"

preset t
sky t

mode = process.env.mode ? "development"

write = ( build ) ->
  ( html ) ->
    await FS.mkdir build, recursive: true
    FS.writeFile ( Path.join build, "index.html" ), html

t.define "build", [ "clean" ], Fn.flow [
  build "src"
  render "home"
  write "build" 
]

t.define "deploy", [ "build", "sky:s3:deploy" ], ->
  t.run "sky:edge:publish"

t.define "publish", [ "build" ], ->
  t.run "sky:s3:publish"

t.define "undeploy", ->
  if mode != "production"
    t.run "sky:s3:undeploy"
    t.run "sky:edge:delete"
