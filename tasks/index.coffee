import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import sky from "@dashkite/sky-presets"

preset t
sky t

mode = process.env.mode ? "development"

t.define "deploy", [ "build", "sky:s3:deploy" ], ->
  t.run "sky:edge:publish"

t.define "publish", [ "build" ], ->
  t.run "sky:s3:publish"

t.define "undeploy", ->
  if mode != "production"
    t.run "sky:s3:undeploy"
    t.run "sky:edge:delete"