import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import sky from "@dashkite/sky-presets"

preset t
sky t

# turn this on to build while watching
t.after "build", "sky:s3:publish:dashkite.com"
