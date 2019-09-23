import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {load} from "../../content"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "starfire-post"

    bebop, shadow #, navigate, queryable

    render ({value}) -> template value

    events
      activate: local (event) ->
        @value = load @dom.dataset.name
  ]
