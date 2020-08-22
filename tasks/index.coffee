# TODO this break the coffee compilation for some reason?
# import "source-map-support/register"
import "coffeescript/register"

import "./www"
import "./edge"

import {define} from "@dashkite/genie"

define "test", [ "www:test", "edge:test" ]
