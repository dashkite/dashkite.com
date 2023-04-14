import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import sky from "@dashkite/sky-presets"

preset t
sky t

import FS from "node:fs/promises"
import Path from "node:path"
import { build } from "@dashkite/sites-fs"
import { render } from "@dashkite/sites-render"
import * as Fn from "@dashkite/joy/function"

write = ( build ) ->
  ( html ) ->
    FS.writeFile ( Path.join build, "index.html" ), html

t.define "build", Fn.flow [
  build "src"
  render
  write "build" 
]

