import {Gadget, mixin, tag, bebop, shadow,
  render, properties, ready, events, local} from "panda-play"

import {load} from "../../content"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "raven-banner"

    bebop, shadow, describe, navigate

    resource -> @value = load @dom.dataset.path

    render smart template

    events
      # video:
      #   canplaythrough: -> console.log "video ready!"
    
      render: local do (_initialized = false) ->
        ->
          if !_initialized
            if (video = @root.querySelector "video")?
              _initialized = true
              video.addEventListener "canplaythrough",
                =>
                  image = @root.querySelector "img"
                  image.classList.remove "active"
                  video.classList.add "active"

  ]
