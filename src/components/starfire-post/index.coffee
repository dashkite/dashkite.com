import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import template from "./index.pug"

_load = require.context "html-loader!markdown-loader!../../content", true, /\.md$/
load = (path) -> (_load "./#{path}.md")

class extends Gadget

  mixin @, [

    tag "starfire-post"

    bebop, shadow #, navigate, queryable

    render ({value}) -> template value

    events
      activate: local (event) ->
        @value = html: load @dom.dataset.name
  ]
