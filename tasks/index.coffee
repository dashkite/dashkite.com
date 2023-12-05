# import * as t from "@dashkite/genie"
# import FS from "node:fs/promises"
# import Path from "node:path"
# import { build } from "@dashkite/sites-fs"
# import { render } from "@dashkite/sites-render"
# import * as Fn from "@dashkite/joy/function"
# import * as M from "@dashkite/masonry"

# mode = process.env.mode ? "development"

# write = ( build ) ->
#   ( pages ) ->
#     for page in pages
#       path = Path.join build, "#{ page.key }.html"
#       await FS.mkdir ( Path.dirname path ), recursive: true
#       FS.writeFile path, page.html

# t.define "build", [ "clean" ], Fn.flow [
#   build 
#     glob: "**/*.yaml"
#     source: "src"
#   render
#   write "build" 
# ]

# t.define "deploy", [ "build", "sky:s3:deploy" ], ->
#   t.run "sky:edge:publish"

# t.define "publish", [ "build" ], ->
#   t.run "sky:s3:publish"

# t.define "undeploy", ->
#   if mode != "production"
#     t.run "sky:s3:undeploy"
#     t.run "sky:edge:delete"

# dependencies = [
#   "sites-resource"
#   "sites-fs"
#   "sites-render"
#   "sites-render-css"
#   "sites-render-html"
#   "universal-css"
#   "quark"
# ]

# t.define "watch:dependencies", Fn.pipe do ->
#   for dependency in dependencies
#     M.watch "../#{dependency}/src", M.exec "genie", [ "build" ]

# t.after "watch", "watch:dependencies"
