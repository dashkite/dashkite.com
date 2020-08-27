# TODO this break the coffee compilation for some reason?
# import "source-map-support/register"
import "coffeescript/register"

import "./www"
import "./edge"

import {define} from "@dashkite/genie"

define "test", [ "www:test", "edge:test" ]
define "build", [ "www:production:build", "edge:production:build" ]
define "build:staging", [ "www:staging:build", "edge:staging:build" ]
