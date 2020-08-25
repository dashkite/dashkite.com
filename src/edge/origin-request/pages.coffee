import fetch from "node-fetch"
import {tee} from "@pandastrike/garden"
import Registry from "@dashkite/helium"
import "pages"

# global.fetch = fetch

Registry.set
  neon:
    resource: tee ->
    render: tee ->
    view: tee ->
    show: tee ->
