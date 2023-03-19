import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import sky from "@dashkite/sky-presets"

preset t
sky t

# turn this on to build while watching
autobuild = false
t.define "autobuild", -> autobuild = true
t.after "watch", "autobuild"
t.define "autopublish", ->
  t.run "sky:s3:publish:dashkite.com" if autobuild
t.after "build", "autopublish"
t.define "publish", [ "build" ], ->
  t.run "sky:s3:publish:dashkite.com"