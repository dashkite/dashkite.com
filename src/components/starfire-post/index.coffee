import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import template from "./index.pug"

import marked from "marked"

_loadMarkdown = require.context "raw-loader!../../content", true, /\.md$/
_loadYAML = require.context "!json-loader!yaml-loader!../../content", true, /\.yaml$/

load = (path) ->
  data = _loadYAML "./#{path}.yaml"
  console.log {data}
  data.html = marked (_loadMarkdown "./#{path}.md").default
  data

class extends Gadget

  mixin @, [

    tag "starfire-post"

    bebop, shadow #, navigate, queryable

    render ({value}) -> template value

    events
      activate: local (event) ->
        @value = load @dom.dataset.name
  ]
