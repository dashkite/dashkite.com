import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import sky from "@dashkite/sky-presets"
import * as Time from "@dashkite/joy/time"

preset t
sky t

t.define "publish", [ "build" ], ->
  # Give the FS operations a sec
  await Time.sleep 1000
  t.run "sky:graphene:items:publish:www-development.dashkite.com"
  t.run "sky:bucket:publish:www-development.dashkite.com"

